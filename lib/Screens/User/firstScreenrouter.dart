import 'package:an_app/Screens/User/first_screen.dart';
import 'package:flutter/material.dart';

class UserScreenRouter extends StatefulWidget {
  const UserScreenRouter({super.key});

  @override
  State<UserScreenRouter> createState() => _UserScreenRouterState();
}

class _UserScreenRouterState extends State<UserScreenRouter> {
  int _pageselected = 0;
  final List<Widget> _pages = [
    WelcomePage(),
  ];
  void _pageSelected(int i) {
    setState(() {
      _pageselected = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Bienvenue'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorer'),
        BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Guide')
      ]),
      body: _pages[_pageselected],
    );
  }
}
