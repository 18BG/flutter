import 'package:flutter/material.dart';

import 'apropos.dart';
import 'welcome.dart';

class FirstScreenRouter extends StatefulWidget {
  const FirstScreenRouter({super.key});

  @override
  State<FirstScreenRouter> createState() => _FirstScreenRouterState();
}

class _FirstScreenRouterState extends State<FirstScreenRouter> {
  final List<Widget> _pages = [const Welcome(), const Apropos()];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home', tooltip: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.app_shortcut),
                label: 'A propos',
                tooltip: 'A propos'),
          ]),
      body: _pages[_selectedIndex],
    );
  }
}
