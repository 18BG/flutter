import 'dart:convert';
import 'dart:io';

import 'package:an_app/Screens/Admin&Universitie/Admin/TextFormFieldWidget.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/universitie_login.dart';

import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/db_management/mysql_management/rudOndb.dart';

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
  Universite myUniversitie =
      Universite(logo: "", name: "", mail: "", password: "");
  String? passwordConfirmation(String? value) {
    if (value != password.text || value != password2.text) {
      return "Les mots de passes ne sont pas conformes";
    } else if (value!.isEmpty) {
      return "Champs obligatoire";
    }
    return null;
  }

  String? emptyCheck(String? value) {
    if (value!.isEmpty) {
      return "Champs obligatoire";
    }
    return null;
  }

  void register() async {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      myUniversitie.name = nom.text;
      myUniversitie.mail = mail.text;
      myUniversitie.password = password.text;
      if (myUniversitie.logo == "") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Le logo est obligatoire"),
          duration: Duration(seconds: 3),
        ));
      } else {
        try {
          File imgFile = File(myUniversitie.logo);
          final imbyte = await imgFile.readAsBytes();
          final encoded = base64Encode(imbyte);

          await RUD().insertQuery(
              ScaffoldMessengerState(),
              "INSERT INTO faculte (name,mail,password,logo) values (:name,:mail,:password,:logo)",
              {
                "name": myUniversitie.name,
                "mail": myUniversitie.mail,
                "password": myUniversitie.password,
                "logo": encoded
              });

          print("faculte enregistrer avec succes");
          nom.clear();
          mail.clear();
          password.clear();
          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const UniversitieLogin();
          }));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Erreur le nom de faculté existe déjà")));
        }
      }
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
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          icon: const Icon(Icons.camera_enhance)),
                      IconButton(
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
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
                onPressed: register, child: const Text("Soumettre")),
          )
        ],
      ),
    );
  }

  Future getImage(ImageSource source) async {
    var newImage = await ImagePicker().pickImage(source: source);
    setState(() {
      if (newImage!.path == null) {
      } else {
        image = newImage.path;
        myUniversitie.logo = newImage.path;
      }
    });
  }
}
