import 'package:flutter/material.dart';
import 'package:instagram/controller/user_provider.dart';
import 'package:instagram/view/edit_screen/edit_details_screen.dart';
import 'package:instagram/view/explore_screen/explore_screen.dart';
import 'package:instagram/view/home_screen/home_screen.dart';
import 'package:instagram/view/profile_screen/profile_screen.dart';
import 'package:instagram/view/reels_screen/reels_screen.dart';
import 'package:instagram/view/upload_post_screen/upload_screen.dart';
import 'package:provider/provider.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    ExploreScreen(),
    UploadPostScreen(),
    EditDetailsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey.shade700,
        items: const [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.home_filled,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.search_rounded,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.add_circle_outline_rounded,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.edit,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.person_2_rounded,
            ),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
