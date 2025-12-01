import 'package:flutter/material.dart';
import 'package:homeworkout/pages/classic_page.dart';
import 'package:homeworkout/pages/discover_page.dart';
import 'package:homeworkout/pages/personal_page.dart';
import 'package:homeworkout/pages/placeholder_tab.dart';
import 'package:homeworkout/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentBottomNavIndex = 0;

  final List<Widget> _pages = [
    const ClassicPage(), // Halaman "Classic" (yang lama)
    const DiscoverPage(), // Halaman "Discover" (yang baru)
    const PersonalPage(), // Halaman "Personal"
    const ProfilePage(), // Halaman "Me"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentBottomNavIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // Widget untuk Footer (Bottom Navigation Bar)
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: (index) {
        setState(() {
          _currentBottomNavIndex = index;
        });
      },
      // Tipe 'fixed' agar semua 5 item terlihat dan tidak bergeser
      type: BottomNavigationBarType.fixed,

      // Tema "biru putih"
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey[500],
      backgroundColor: Colors.black,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Classic',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Discover'),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_pin),
          label: 'Personal',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.calendar_today),
        //   label: 'Daily',
        // ),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Me'),
      ],
    );
  }
}
