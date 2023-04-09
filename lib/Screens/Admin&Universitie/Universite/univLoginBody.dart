import 'dart:convert';
import 'dart:io';

import 'package:an_app/Screens/Admin&Universitie/Admin/TextFormFieldWidget.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/universitie_home.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/universitie_register.dart';

import 'package:an_app/model/iniversities%20model/classe_universite.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/db_management/mysql_management/mysql_conn.dart';
import '../../../model/db_management/mysql_management/rudOndb.dart';

class UnivLoginBody extends StatefulWidget {
  const UnivLoginBody({super.key});

  @override
  State<UnivLoginBody> createState() => _UnivLoginBodyState();
}

class _UnivLoginBodyState extends State<UnivLoginBody> {
  bool isLoading = false;
  final key = GlobalKey<FormState>();
  TextEditingController name = TextEditingController(),
      password = TextEditingController();
  Mysql base = Mysql();
  static String? emptyCheck(String? value) {
    if (value!.isEmpty) {
      return "Tous les champs sont obligatoires";
    }
  }

  void log() async {
    setState(() {
      isLoading = true;
    });
    if (key.currentState!.validate()) {
      var result = await RUD().query(
          "Select name , password,mail,logo from faculte where name = :name and password = :password",
          {"name": name.text, "password": password.text});

      print("11111111111111111111111111111");
      for (var row in result!.rows) {
        print(row.assoc()['logo']);
        Universite faculte =
            Universite(logo: "", name: "", mail: "", password: "");
        print("000000000000000000000000");

        String nam = row.assoc().values.toList()[0]!;
        String pass = row.assoc().values.toList()[1]!;
        String maile = row.assoc().values.toList()[2]!;
        var imageprofil = row.assoc()['logo'] as String;
        final decoded = base64Decode(imageprofil);
        print(decoded);

        final nomIm = row.assoc().values.toList()[0]!;
        //final logo = File(nomIm)..writeAsBytesSync(imgBytes);
        //print(logo);
        if (nam == name.text && pass == password.text) {
          faculte.name = nam;
          faculte.mail = maile;
          faculte.logo = decoded;
          faculte.password = pass;
          name.clear();
          password.clear();

          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return UniversititHomePage(
              faculty: faculte,
            );
          }));
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Nom ou mot de passe incorrect")));
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  bool? returnOrno;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              //margin: ,
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: const Text(
                "Renseignez les informations de la faculté",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormFields(
                f: emptyCheck,
                toChange: name,
                labelText: "Nom de la faculté",
                suffix: false,
                prefix: false,
                hide: false,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormFields(
                f: emptyCheck,
                toChange: password,
                labelText: "Mot de passe",
                suffix: true,
                prefix: false,
                hide: true,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                  onPressed: () {}, child: const Text("Mot de passe oublié ?")),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: ElevatedButton(
                onPressed: isLoading ? null : log,
                child: isLoading
                    ? const CircularProgressIndicator(
                        strokeWidth: 2,
                      )
                    : const Text("Se connecter"),
              ),
            ),
            Row(
              children: [
                const Text("Vous n'avez pas de faculté enregistrée ?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const UniversitieRegister();
                      }));
                    },
                    child: const Text("Créer une faculté"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
