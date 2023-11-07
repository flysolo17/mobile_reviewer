import 'package:flutter/material.dart';
import 'package:mobile_reviewer/styles/pallete.dart';
import 'package:mobile_reviewer/views/profile/profile.dart';
import 'package:mobile_reviewer/views/student/student.nav/home/student_home.dart';
import 'package:mobile_reviewer/views/student/student.nav/scores/scores.dart';

class StudentMainPage extends StatefulWidget {
  const StudentMainPage({super.key});

  @override
  State<StudentMainPage> createState() => _StudentMainPageState();
}

class _StudentMainPageState extends State<StudentMainPage> {
  static const List<String> _titles = [
    "Home",
    "My Scores",
    "Profile",
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    StudentHomePage(),
    StudentScorePage(),
    ProfilePage(),
  ];

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
                Icons.scoreboard_sharp,
                size: 24.0,
                semanticLabel: 'Text to My Scores',
              ),
              label: 'My Scores',
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
        body: _pages[_selectedIndex]);
  }
}
