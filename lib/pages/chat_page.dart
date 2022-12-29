// Packages
import 'package:bk_chatapp/providers/authentication_provider.dart';
import 'package:bk_chatapp/utils/contains.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/custom_input_fields.dart';

// Models
import '../models/chat.dart';
import '../models/chat_message.dart';

// Providers
import '../providers/chats_page_provider.dart';
import '../providers/chat_page_provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  ChatPage({
    required this.chat,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _authenticationProvider;
  late ChatPageProvider _chatPageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messageListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messageListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
            this.widget.chat.uid,
            _authenticationProvider,
            _messageListViewController,
          ),
        )
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _chatPageProvider = _context.watch<ChatPageProvider>();
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.03,
              vertical: _deviceHeight * 0.02,
            ),
            height: _deviceHeight,
            width: _deviceWidth * 0.97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TopBar(
                  this.widget.chat.title(),
                  fontSize: 12,
                  primaryAction: IconButton(
                    onPressed: () {
                      _chatPageProvider.deleteChat();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Color.fromRGBO(0, 82, 218, 1.0),
                    ),
                  ),
                  secondaryAction: IconButton(
                    onPressed: () {
                      _chatPageProvider.goBack();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(0, 82, 218, 1.0),
                    ),
                  ),
                ),
                _messagesListView(),
                _sendMessageForm(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _messagesListView() {
    if (_chatPageProvider.messages != null) {
      if (_chatPageProvider.messages!.length != 0) {
        return Container(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
            controller: _messageListViewController,
            itemCount: _chatPageProvider.messages!.length,
            itemBuilder: (BuildContext _context, int _index) {
              ChatMessage _message = _chatPageProvider.messages![_index];
              bool _isOwnMessage =
                  _message.senderID == _authenticationProvider.user.uid;
              return Container(
                child: CustomChatListViewTitle(
                  width: _deviceWidth * 0.80,
                  deviceHeight: _deviceHeight,
                  isOwnMessage: _isOwnMessage,
                  message: _message,
                  sender: this
                      .widget
                      .chat
                      .members
                      .where((_m) => _m.uid == _message.senderID)
                      .first,
                ),
              );
            },
          ),
        );
      } else {
        return Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first to say hi!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.04,
        vertical: _deviceHeight * 0.03,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: CustomTextFormField(
        onSaved: (_value) {
          _chatPageProvider.message = _value;
        },
        regEx: REG_EXP["TEXT_FIELD"]!,
        hintText: "Typing a message",
        obscureText: false,
      ),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.04;

    return Container(
      height: _size,
      width: _size,
      child: IconButton(
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _chatPageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
        icon: Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.04;

    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 82, 218, 1.0),
        onPressed: () {
          _chatPageProvider.sendImageMessage();
        },
        child: Icon(Icons.camera_enhance),
      ),
    );
  }
}
