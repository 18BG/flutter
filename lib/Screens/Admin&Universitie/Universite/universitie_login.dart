import 'package:an_app/Screens/Admin&Universitie/Universite/univLoginBody.dart';
import 'package:flutter/material.dart';

class UniversitieLogin extends StatelessWidget {
  const UniversitieLogin({super.key});

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
                              Navigator.pop(context);
                              returnOrno = true;
                            },
                            child: const Text("Annuler")),
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
            automaticallyImplyLeading: false,
            title: const Text('Guide de l\'Etudiant'),
            centerTitle: true,
          ),
          body: const UnivLoginBody(),
        ));
  }
}
