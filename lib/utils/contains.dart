// Packages
import 'package:flutter/material.dart';

const String TITLE = "BKChatApp";

const REG_EXP = {
  "EMAIL":
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  "PASSWORD": r".{8,}",
  "TEXT_FIELD": r"^(?!\s*$).+"
};

const ROUTES = {
  "HOME": "/home",
  "LOGIN": "/login",
  "REGISTER": "/register",
};

const DEFAULT_AVATAR = {
  "USER": "https://i.pravatar.cc/1000?img=65",
  "GROUP":
      "https://e7.pngegg.com/pngimages/380/670/png-clipart-group-chat-logo-blue-area-text-symbol-metroui-apps-live-messenger-alt-2-blue-text.png",
};

const COLORS = {
  "PRIMARY_BLUE": Color.fromRGBO(0, 82, 218, 1.0),
  "LIGHT_BLUE": Color.fromRGBO(0, 136, 249, 1.0),
  "DARK_BLUE": Color.fromRGBO(30, 29, 37, 1.0),
  "DARK_BLUE_2": Color.fromRGBO(36, 35, 49, 1.0),
  "DARK_BLUE_3": Color.fromRGBO(51, 49, 68, 1.0),
};

const HINT_TEXTS = {
  "GREET_STR": "Be the first to say hi!",
  "TYPING_MESSAGE": "Typing a message",
  "NO_CHAT_FOUND": "No Chats Found.",
  "MEDIA_ATTACHMENT": "Media Attachment",
  "EMAIL": "Email",
  "PASSWORD": "Password",
  "NAME": "Name",
  "DONT_HAVE_ACCOUNT": "Don't have an account?",
  "NO_USERS_FOUND": "No Users Found.",
  "CHAT_WITH": "Chat with",
  "CREATE_GROUP_CHAT": "Create Group Chat",
};

const ERROR_TEXTS = {
  "ERROR_LOGGING_INTO_FIREBASE": "Error logging user into Firebase",
  "ERROR_REGISTERING_USER": "Error registering user.",
  "INPUT_FIELD_ERROR_MESSAGE": "Enter a valid value.",
};

const LABELS = {
  "CHATS": "Chats",
  "USERS": "Users",
};

const COLLECTIONS = {
  "USER_COLLECTION": "Users",
  "CHAT_COLLECTION": "Chats",
  "MESSAGES_COLLECTION": "messages",
};
