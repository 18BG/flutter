import 'package:an_app/Screens/main_screen/welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Entrie());
}

class Entrie extends StatelessWidget {
  const Entrie({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guide de l\'Etudiant',
      theme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.orange),
      home: Welcome(),
    );
  }
}
