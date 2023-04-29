import 'package:an_app/Screens/User/explorer/explorer.dart';
import 'package:an_app/Screens/User/explorer/fetchAll_univ_for_ex.dart';
import 'package:an_app/Screens/User/first_screen.dart';
import 'package:flutter/material.dart';

class UserScreenRouter extends StatefulWidget {
  const UserScreenRouter({super.key});

  @override
  State<UserScreenRouter> createState() => _UserScreenRouterState();
}

class _UserScreenRouterState extends State<UserScreenRouter> {
  int _pageselected = 0;
  final List<Widget> _pages = [WelcomePage(), FetchAllUniv2(), Container()];
  void _onPageSelected(int i) {
    setState(() {
      _pageselected = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: _onPageSelected,
          currentIndex: _pageselected,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Bienvenue'),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: 'Explorer'),
            BottomNavigationBarItem(
                icon: Icon(Icons.help_outline), label: 'Guide')
          ]),
      body: _pages[_pageselected],
    );
  }
}
