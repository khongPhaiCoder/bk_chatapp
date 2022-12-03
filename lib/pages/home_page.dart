// Packages
import 'package:flutter/material.dart';

// Pages
import './chats_page.dart';
import './users_page.dart';

// Utils
import '../utils/contains.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  List<Widget> _pages = [
    ChatsPage(),
    UsersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (_index) {
          setState(() {
            _currentPage = _index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: LABELS["CHATS"],
            icon: const Icon(Icons.chat_bubble_sharp),
          ),
          BottomNavigationBarItem(
            label: LABELS["USERS"],
            icon: const Icon(Icons.supervised_user_circle_sharp),
          ),
        ],
      ),
    );
  }
}
