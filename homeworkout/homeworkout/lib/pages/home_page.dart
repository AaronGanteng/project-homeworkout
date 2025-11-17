import 'package:flutter/material.dart';
import 'package:homeworkout/pages/classic_page.dart';
import 'package:homeworkout/pages/discover_page.dart';
import 'package:homeworkout/pages/placeholder_tab.dart';

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
    const PlaceholderTab(title: 'Personal'), // Halaman "Personal"
    const PlaceholderTab(title: 'Daily'), // Halaman "Daily"
    const PlaceholderTab(title: 'Me'), // Halaman "Me"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_currentBottomNavIndex],
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
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Daily',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Me'),
      ],
    );
  }
}
