import 'package:an_app/Screens/Admin&Universitie/Universite/profil_body.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/universitie_home.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/universitie_login.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';

class UnivProfil extends StatelessWidget {
  final Universite faculte;
  const UnivProfil({super.key, required this.faculte});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => UniversititHomePage(faculty: faculte)),
              (Route<dynamic> route) => false);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Gérer le profil"),
            centerTitle: true,
          ),
          body: Profil(faculte: faculte),
        ),
      ),
    );
  }
}
