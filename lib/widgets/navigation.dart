import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_reviewer/styles/pallete.dart';
import 'package:mobile_reviewer/views/author/author.dart';
import 'package:mobile_reviewer/views/books/books.dart';
import 'package:mobile_reviewer/views/settings/settings.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  static const List<String> _titles = [
    "Books",
    "Author",
    "Settings",
  ];
  static const List<Widget> _pages = <Widget>[
    BooksPage(),
    AuthorPage(),
    SettingsPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: PrimaryColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PrimaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              size: 24.0,
              semanticLabel: 'Text to Books',
            ),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_2_outlined,
              size: 24.0,
              semanticLabel: 'Text to weight Author',
            ),
            label: 'Authors',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 24.0,
              semanticLabel: 'Text to settings',
            ),
            label: 'Settings',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
