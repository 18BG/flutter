import 'dart:io';

import 'package:an_app/Screens/Admin&Universitie/Universite/univLoginBody.dart';
import 'package:an_app/Screens/main_screen/welcome.dart';
import 'package:flutter/material.dart';

class UniversitieLogin extends StatefulWidget {
  const UniversitieLogin({super.key});

  @override
  State<UniversitieLogin> createState() => _UniversitieLoginState();
}

class _UniversitieLoginState extends State<UniversitieLogin> {
  @override
  Widget build(BuildContext context) {
    bool? returnOrno;
    return WillPopScope(
        onWillPop: (() async {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Vous êtes sur le point de quitter"),
                  content:
                      const Text("Êtes vous sûr de bien vouloir abandonner"),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const Welcome()),
                                  (route) => false);
                              returnOrno = false;
                            },
                            child: const Text(
                              "Quitter",
                              style: TextStyle(color: Colors.red),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              returnOrno = false;
                            },
                            child: const Text("Continuer"))
                      ],
                    )
                  ],
                );
              });
          return returnOrno!;
        }),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: Platform.isIOS,
            title: const Text('Guide de l\'Etudiant'),
            centerTitle: true,
          ),
          body: const UnivLoginBody(),
        ));
  }
}
