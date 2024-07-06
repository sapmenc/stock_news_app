import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const Navbar({super.key, required this.pageIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: pageIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color.fromARGB(186, 0, 0, 0),
      selectedItemColor: Color.fromARGB(255, 24, 136, 234),
      unselectedItemColor: Color.fromARGB(255, 255, 255, 255),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          label: 'Profile',
        ),
      ],
    );
  }
}
