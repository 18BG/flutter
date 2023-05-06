import 'dart:convert';
import 'dart:io';

import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../model/db_management/mysql_management/rudOndb.dart';
import '../../../../model/iniversities model/class_filiere.dart';
import '../../../../model/iniversities model/class_option.dart';
import '../../../../model/iniversities model/class_series_filiere.dart';
import '../../../../model/iniversities model/serie_model.dart';
import '../../Admin/TextFormFieldWidget.dart';

class FiledForm extends StatefulWidget {
  Option option;

  FiledForm({super.key, required this.option});

  @override
  State<FiledForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<FiledForm> {
  TextEditingController nom = TextEditingController(),
      option = TextEditingController(),
      commentaire = TextEditingController(),
      fac = TextEditingController();

  bool isLoading = false;
  bool isProcessing = false;
  String? image;
  String? check(String? value) {
    if (value!.isEmpty) {
      return "Champ obligatoire";
    }
  }

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Form(
            key: key,
            child: Column(
              children: [
                CustomText(
                  "Ajouter une filiere",
                  factor: 1.3,
                  fontStyle: FontStyle.normal,
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.6,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: (image == null)
                        ? Image.asset(
                            "assets/images/Noimage-1.png",
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(image!),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
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
                  toChange: nom,
                  f: check,
                  hide: false,
                  labelText: "Nom de la filière",
                  prefix: false,
                  suffix: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormFields(
                  toChange: commentaire,
                  f: check,
                  labelText: "Commentaire",
                  maxl: 5,
                  hint:
                      "Donner un commentaire sur cette filière comme son importance, ses débouchés et sa place dans le marché de l'emploie",
                  hide: false,
                  suffix: false,
                  prefix: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                (isLoading)
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 6.0,
                          color: Colors.blueGrey,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Annuler",
                                style: TextStyle(color: Colors.red),
                              )),
                          TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      print("l'operation commence");
                                      if (image != null) {
                                        File imgFile = File(image!);
                                        final imBytes =
                                            await imgFile.readAsBytes();
                                        final encoded = base64Encode(imBytes);
                                        if (key.currentState!.validate()) {
                                          try {
                                            await RUD().insertQuery(
                                                ScaffoldMessengerState(),
                                                "insert into filiere(nomfiliere,commentaire,logo,facName,opt) values (:nom,:commentaire,:logo,:name,:option)",
                                                {
                                                  "nom": nom.text,
                                                  "commentaire":
                                                      commentaire.text,
                                                  "logo": encoded,
                                                  "name": widget.option.fac,
                                                  "option": widget.option.nom
                                                });
                                          } catch (e) {
                                            print(e);
                                          }
                                          try {
                                            Filiere? filiere;
                                            var result = await RUD().query(
                                                "select nomfiliere,commentaire,logo,facname,opt from filiere where opt = :option and facName = :fname",
                                                {
                                                  "option": widget.option.nom,
                                                  "fname": widget.option.fac
                                                });
                                            for (var row in result!.rows) {
                                              String nom = row
                                                  .assoc()
                                                  .values
                                                  .toList()[0]!;
                                              String comment = row
                                                  .assoc()
                                                  .values
                                                  .toList()[1]!;
                                              var img =
                                                  row.assoc()['logo'] as String;
                                              final decoded = base64Decode(img);
                                              String fname =
                                                  row.assoc()['fname']!;
                                              String option =
                                                  row.assoc()['opt']!;
                                              filiere = Filiere(
                                                  nomfiliere: nom,
                                                  commentaire: comment,
                                                  logo: decoded,
                                                  facName: fname,
                                                  option: option);
                                            }
                                            if (option != null) {
                                              //optionList.add(option);
                                              await Sqflite()
                                                  .addFiliere(filiere!);

                                              //print(optionList);
                                            }
                                          } catch (e) {
                                            print(e);
                                          }
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Logo obligatoire"),
                                          duration: Duration(seconds: 3),
                                        ));
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 5,
                                        color: Colors.red,
                                      ),
                                    )
                                  : const Text("Enregistrer",
                                      style: TextStyle(color: Colors.blue)))
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImage(ImageSource source) async {
    var newImage = await ImagePicker().pickImage(source: source);
    if (newImage != null) {
      setState(() {
        image = newImage.path;
      });
    }
  }
}
