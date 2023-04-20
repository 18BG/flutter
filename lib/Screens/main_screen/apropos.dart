import 'package:flutter/material.dart';

import '../../Widgets/custom.dart';
import '../../Widgets/padd.dart';
import 'welcome.dart';

class Apropos extends StatelessWidget {
  const Apropos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("A propos de Guide De l'Etudiant"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padd().padd(1),
            CustomText(
              'Version 1.0',
              factor: 2.0,
            ),
            Padd().padd(0),
            CustomText(
              "Dévéloppé par Babry Galedou",
              fontStyle: FontStyle.normal,
              factor: 1.5,
            ),
            Padd().padd(1),
            CustomText(
              "Droit d'auteur @ 2023",
              color: Colors.black,
              fontStyle: FontStyle.normal,
            )
          ],
        ),
      ),
    );
  }
}
