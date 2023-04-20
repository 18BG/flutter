import 'package:an_app/Screens/main_screen/firstscree_router.dart';
import 'package:an_app/Screens/main_screen/welcome.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool dataTransferredd = prefs.getBool('dataTranferredd') ?? false;
  if (!dataTransferredd) {
    await Sqflite().database.then(
      (db) async {
        await Sqflite().getData();
        await prefs.setBool('dataTranferredd', true);
        dataTransferredd = true;
      },
    );

    runApp(ChangeNotifierProvider(
      create: (_) => Sqflite(),
      child: const Entrie(),
    ));
  } else {
    runApp(ChangeNotifierProvider(
      create: (_) => Sqflite(),
      child: const Entrie(),
    ));
  }
}

class Entrie extends StatelessWidget {
  const Entrie({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guide de l\'Etudiant',
      theme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.orange),
      home: const FirstScreenRouter(),
    );
  }
}
