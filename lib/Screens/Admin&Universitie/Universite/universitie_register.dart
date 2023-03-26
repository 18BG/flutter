import 'package:an_app/Screens/Admin&Universitie/Universite/register_body.dart';
import 'package:an_app/Screens/main_screen/welcome.dart';
import 'package:flutter/material.dart';

class UniversitieRegister extends StatelessWidget {
  const UniversitieRegister({super.key});

  @override
  Widget build(BuildContext context) {
    bool? returnOrno;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Guide de L'etudiant"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: const UniversitieRegisterBody(),
        ),
        onWillPop: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: const Text(
                    "Attention",
                    textAlign: TextAlign.center,
                  ),
                  children: [
                    const Text(
                      "Êtes vous sûr d'abandonner ?",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              returnOrno = true;
                            },
                            child: const Text(
                              "Abandonner",
                              style: TextStyle(color: Colors.red),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              returnOrno = false;
                            },
                            child: const Text(
                              "Continuer",
                              style: TextStyle(color: Colors.blue),
                            )),
                      ],
                    )
                  ],
                );
              });
          if (returnOrno == true) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Welcome()),
            );
          }

          return returnOrno!;
        });
  }
}
