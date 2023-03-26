import 'dart:io';

import 'package:an_app/Screens/Admin&Universitie/Admin/TextFormFieldWidget.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/universitie_home.dart';
import 'package:an_app/model/db_management/creatingDB.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';

class UniversitieRegisterBody extends StatefulWidget {
  const UniversitieRegisterBody({super.key});

  @override
  State<UniversitieRegisterBody> createState() =>
      _UniversitieRegisterBodyState();
}

class _UniversitieRegisterBodyState extends State<UniversitieRegisterBody> {
  final key = GlobalKey<FormState>();
  String? image;
  bool hidePassword = true;
  TextEditingController nom = TextEditingController(),
      mail = TextEditingController(),
      password = TextEditingController(),
      password2 = TextEditingController();
  Universite myUniversitie = Universite(null, name: "", mail: "", password: "");
  String? passwordConfirmation(String? value) {
    if (value != password.text || value != password2.text) {
      return "Les mots de passes ne sont pas conformes";
    } else if (value!.isEmpty) {
      return "Champs obligatoire";
    }
  }

  String? emptyCheck(String? value) {
    if (value!.isEmpty) {
      return "Champs obligatoire";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Informations de la faculté",
            textScaleFactor: 1.6,
          ),
          Form(
            key: key,
            child: Card(
              elevation: 10,
              //margin: EdgeInsets.all(49),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (image == null)
                      ? Image.asset("assets/images/noimage.png")
                      : Image.file(File(image!)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.camera_enhance)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.photo_library))
                    ],
                  ),
                  TextFormFields(
                    f: emptyCheck,
                    hint: "Nom de la faculté",
                    toChange: nom,
                    prefix: false,
                    suffix: false,
                    hide: false,
                  ),
                  TextFormFields(
                    f: emptyCheck,
                    hint: "Email de la faculté",
                    toChange: mail,
                    hide: false,
                    prefix: false,
                    suffix: false,
                  ),
                  TextFormFields(
                    f: passwordConfirmation,
                    toChange: password,
                    hint: "Mot de passe",
                    prefix: false,
                    suffix: true,
                    hide: true,
                  ),
                  TextFormFields(
                    f: passwordConfirmation,
                    toChange: password2,
                    hint: "Confirmer le mot de passe",
                    prefix: false,
                    suffix: true,
                    hide: true,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15),
            height: 50,
            child: ElevatedButton(
                onPressed: () async {
                  if (key.currentState!.validate()) {
                    key.currentState!.save();
                    myUniversitie.name = nom.text;
                    myUniversitie.mail = mail.text;
                    myUniversitie.password = password.text;

                    try {
                      await CreateOrUseDB().insertInDbForFaculty(
                          myUniversitie, ScaffoldMessengerState());
                      print("faculte enregistrer avec succes");
                      nom.clear();
                      mail.clear();
                      password.clear();
                      // ignore: use_build_context_synchronously
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const UniversitHomePage();
                      }));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("Erreur le nom de faculté existe déjà")));
                    }
                  }
                },
                child: const Text("Soumettre")),
          )
        ],
      ),
    );
  }
}
