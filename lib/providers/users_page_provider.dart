// Packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

// Providers
import '../providers/authentication_provider.dart';

// Models
import '../models/chat_user.dart';
import '../models/chat.dart';

// Pages
import '../pages/chat_page.dart';

class UserPageProvider extends ChangeNotifier {
  AuthenticationProvider _authenticationProvider;

  late DatabaseService _databaseService;
  late NavigationService _navigationService;

  List<ChatUser>? users;
  late List<ChatUser> _selectedUsers;

  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }

  UserPageProvider(this._authenticationProvider) {
    _selectedUsers = [];
    _databaseService = GetIt.instance.get<DatabaseService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      _databaseService.getUsers(name: name).then((_snapshot) {
        var _users = _snapshot.docs.map((_doc) {
          Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
          _data["uid"] = _doc.id;
          return ChatUser.fromJSON(_data);
        }).toList();
        users = _users
            .where((user) => user.uid != _authenticationProvider.user.uid)
            .toList();
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser _user) {
    if (_selectedUsers.contains(_user)) {
      _selectedUsers.remove(_user);
    } else {
      _selectedUsers.add(_user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      // Create Chat
      List<String> _memberIds =
          _selectedUsers.map((_user) => _user.uid).toList();
      _memberIds.add(_authenticationProvider.user.uid);
      bool _isGroup = _selectedUsers.length > 1;
      DocumentReference? _doc = await _databaseService.createChat({
        "is_group": _isGroup,
        "is_activity": false,
        "members": _memberIds,
      });
      // Navigate to Chat Page
      List<ChatUser> _members = [];
      for (var _uid in _memberIds) {
        DocumentSnapshot _userSnapshot = await _databaseService.getUser(_uid);
        Map<String, dynamic> _userData =
            _userSnapshot.data() as Map<String, dynamic>;
        _userData["uid"] = _userSnapshot.id;
        _members.add(ChatUser.fromJSON(_userData));
      }
      ChatPage _chatPage = ChatPage(
        chat: Chat(
          uid: _doc!.id,
          currentUserUid: _authenticationProvider.user.uid,
          members: _members,
          messages: [],
          activity: false,
          group: _isGroup,
        ),
      );
      _selectedUsers = [];
      notifyListeners();
      _navigationService.navigateToPage(_chatPage);
    } catch (e) {
      print(e);
    }
  }
}
