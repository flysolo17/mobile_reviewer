import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:mobile_reviewer/styles/pallete.dart';

import 'package:mobile_reviewer/views/teacher/home/home.dart';
import 'package:mobile_reviewer/views/profile/profile.dart';
import 'package:mobile_reviewer/views/teacher/scores/scores.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  bool _isFabVisible = true;

  static const List<String> _titles = [
    "Home",
    "Scoreboard",
    "Profile",
  ];
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    ScoreboardPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleScrollNotification(ScrollNotification notification) {
    // Check if the user is scrolling down
    if (notification is ScrollUpdateNotification &&
        notification.scrollDelta! > 0) {
      // Hide the FAB when scrolling down
      setState(() {
        _isFabVisible = false;
      });
    } else if (notification is ScrollEndNotification) {
      // Show the FAB when the scrolling stops
      setState(() {
        _isFabVisible = true;
      });
    }
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
              Icons.home_max_outlined,
              size: 24.0,
              semanticLabel: 'Text to Home',
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.score_rounded,
              size: 24.0,
              semanticLabel: 'Text to weight Category',
            ),
            label: 'Scoreboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 24.0,
              semanticLabel: 'Text to Accout',
            ),
            label: 'Account',
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          _handleScrollNotification(scrollNotification);
          return false;
        },
        child: _pages[_selectedIndex],
      ),
      floatingActionButton: _selectedIndex == 0 &&
              _isFabVisible // Show FAB only on the Home page and when it's visible
          ? FloatingActionButton(
              onPressed: () {
                // Add your FAB onPressed action here
                context.push('/home/create-quiz');
              },
              backgroundColor: PrimaryColor, // Customize the FAB color
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ), // Customize the FAB icon
            )
          : null,
    );
  }
}
