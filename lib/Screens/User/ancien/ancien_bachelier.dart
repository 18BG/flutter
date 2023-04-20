import 'package:an_app/Screens/User/fetch_filiere.dart';
import 'package:flutter/material.dart';

class AncienBachelier extends StatefulWidget {
  const AncienBachelier({super.key});

  @override
  State<AncienBachelier> createState() => _AncienBachelierState();
}

class _AncienBachelierState extends State<AncienBachelier> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Guide de l'étudiant"),
        ),
        backgroundColor: const Color.fromRGBO(73, 182, 172, 1),
        body: FetchFiliere());
  }
}
