// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/authentication_provider.dart';
import '../providers/users_page_provider.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/rounded_button.dart';

// Models
import '../models/chat_user.dart';

// Utils
import '../utils/contains.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _authenticationProvider;
  late UserPageProvider _pageProvider;

  final TextEditingController _searchFieldEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserPageProvider>(
          create: (_) => UserPageProvider(_authenticationProvider),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<UserPageProvider>();

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TopBar(
                LABELS["USERS"]!,
                primaryAction: IconButton(
                  onPressed: () {
                    _authenticationProvider.logout();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: COLORS["PRIMARY_BLUE"]!,
                  ),
                ),
              ),
              CustomTextField(
                onEditingComplete: (_value) {
                  _pageProvider.getUsers(name: _value);
                  FocusScope.of(context).unfocus();
                },
                hintText: "Search...",
                obscureText: false,
                controller: _searchFieldEditingController,
                icon: Icons.search,
              ),
              _userList(),
              _createChatButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _userList() {
    List<ChatUser>? _users = _pageProvider.users;
    return Expanded(child: () {
      if (_users != null) {
        if (_users.isNotEmpty) {
          return ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext _context, int _index) {
              return CustomListViewTile(
                height: _deviceHeight * 0.10,
                title: _users[_index].name,
                subtitle: "Last active: ${_users[_index].lastDayActive()}",
                imagePath: _users[_index].imageURL,
                isActive: _users[_index].wasRecentlyActive(),
                isSelected:
                    _pageProvider.selectedUsers.contains(_users[_index]),
                onTap: () {
                  _pageProvider.updateSelectedUsers(_users[_index]);
                },
              );
            },
          );
        } else {
          return Center(
            child: Text(
              HINT_TEXTS["NO_USERS_FOUND"]!,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
      } else {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }
    }());
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _pageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name: _pageProvider.selectedUsers.length == 1
            ? "${HINT_TEXTS["CHAT_WITH"]} ${_pageProvider.selectedUsers.first.name}"
            : HINT_TEXTS["CREATE_GROUP_CHAT"]!,
        height: _deviceHeight * 0.08,
        width: _deviceWidth * 0.80,
        onPressed: () {
          _pageProvider.createChat();
        },
      ),
    );
  }
}
