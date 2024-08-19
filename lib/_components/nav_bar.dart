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
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color.fromARGB(186, 0, 0, 0),
      selectedItemColor: Color.fromARGB(255, 24, 136, 234),
      unselectedItemColor: Color.fromARGB(255, 255, 255, 255),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined, size: 30,),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 30,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined, size: 30,),
          label: 'Profile',
        ),
      ],
    );
  }
}
