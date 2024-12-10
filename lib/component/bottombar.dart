import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(192, 41, 56, 85),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.summarize),
          label: 'Login',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 45),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      onTap: (index) => _handleNavigationTap(context, index),
    );
  }

  void _handleNavigationTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/login');
        break;
      case 1:
        Navigator.pushNamed(context, '/home');
        break;
      case 2:
        Navigator.pushNamed(context, '/login');
        break;
    }
  }
}
