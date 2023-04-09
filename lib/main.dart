import 'package:an_app/Screens/main_screen/welcome.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => Sqflite(),
    child: const Entrie(),
  ));
}

class Entrie extends StatelessWidget {
  const Entrie({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guide de l\'Etudiant',
      theme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.orange),
      home: const Welcome(),
    );
  }
}
