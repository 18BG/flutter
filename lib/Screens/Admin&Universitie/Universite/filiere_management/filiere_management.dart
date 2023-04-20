import 'dart:convert';
import 'dart:io';

import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_fetcher.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../model/db_management/mysql_management/rudOndb.dart';
import '../../../../model/db_management/sqflite_management/sqflite_conn.dart';
import '../../Admin/TextFormFieldWidget.dart';

class FiliereManage extends StatefulWidget {
  Option option;
  FiliereManage({super.key, required this.option});

  @override
  State<FiliereManage> createState() => _FiliereManageState();
}

class _FiliereManageState extends State<FiliereManage> {
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
      appBar: AppBar(
        title: Text(widget.option.nom),
        centerTitle: true,
        actions: [
          //dechargement et rechargement des options dans sqflite
          TextButton(
              onPressed: isProcessing
                  ? null
                  : () async {
                      setState(() {
                        isProcessing = true;
                      });
                      try {
                        //suppression
                        Sqflite().deleteAllFiliere(
                            widget.option.fac, widget.option.nom);
                        Filiere? filiere;
                        //recuperation depuis mysql
                        var result = await RUD().query(
                            "select nomfiliere,commentaire,logo,facName,opt from filiere where opt = :option and facName = :fname",
                            {
                              "option": widget.option.nom,
                              "fname": widget.option.fac
                            });

                        for (var row in result!.rows) {
                          String nom = row.assoc().values.toList()[0]!;

                          String comment = row.assoc().values.toList()[1]!;

                          var img = row.assoc()['logo'] as String;
                          final decoded = base64Decode(img);
                          String fname = row.assoc()['facName']!;

                          String option = row.assoc()['opt']!;

                          filiere = Filiere(
                              nomfiliere: nom,
                              commentaire: comment,
                              logo: decoded,
                              facName: fname,
                              option: option);
                          print("jusque lq ça va");
                          //on ajoute chaque option pour la fac trouvé
                          if (filiere != null) {
                            await Sqflite().addFiliere(filiere);
                            print("filiere enregistre");

                            print("Nouvelle filiere");
                            Sqflite().fetchFiliere(
                                widget.option.fac, widget.option.nom);
                          } else {
                            print("errrreeururoo");
                          }
                        }
                      } catch (e) {
                        print("Errrrooorr $e");
                      }
                      setState(() {
                        isProcessing = false;
                      });
                    },
              child: const Text("Recharger"))
        ],
      ),
      body: (isProcessing)
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : FiliereFetcher(widget.option),
      floatingActionButton: FloatingActionButton(
        onPressed: Add,
        child: const Icon(Icons.add),
      ),
    );
  }

  Add() async {
    await showDialog(
        context: context,
        builder: (context) {
          return isProcessing
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.teal,
                    backgroundColor: Colors.red,
                  ),
                )
              : AlertDialog(
                  title: const Text(
                    "Ajouter une filiere",
                    textAlign: TextAlign.center,
                  ),
                  content: Card(
                    child: SingleChildScrollView(
                      child: Form(
                        key: key,
                        child: Column(
                          children: [
                            Image.asset("assets/images/Noimage.png"),
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
                            Row(
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
                                              final encoded =
                                                  base64Encode(imBytes);
                                              if (key.currentState!
                                                  .validate()) {
                                                try {
                                                  await RUD().insertQuery(
                                                      ScaffoldMessengerState(),
                                                      "insert into filiere(nomfiliere,commentaire,logo,facName,opt) values (:nom,:commentaire,:logo,:name,:option)",
                                                      {
                                                        "nom": nom.text,
                                                        "commentaire":
                                                            commentaire.text,
                                                        "logo": encoded,
                                                        "name":
                                                            widget.option.fac,
                                                        "option":
                                                            widget.option.nom
                                                      });
                                                } catch (e) {
                                                  print(e);
                                                }
                                                try {
                                                  Filiere? filiere;
                                                  var result = await RUD().query(
                                                      "select nomfiliere,commentaire,logo,facname,opt from filiere where opt = :option and facName = :fname",
                                                      {
                                                        "option":
                                                            widget.option.nom,
                                                        "fname":
                                                            widget.option.fac
                                                      });
                                                  for (var row
                                                      in result!.rows) {
                                                    String nom = row
                                                        .assoc()
                                                        .values
                                                        .toList()[0]!;
                                                    String comment = row
                                                        .assoc()
                                                        .values
                                                        .toList()[1]!;
                                                    var img =
                                                        row.assoc()['logo']
                                                            as String;
                                                    final decoded =
                                                        base64Decode(img);
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
                                                content:
                                                    Text("Logo obligatoire"),
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
                                            style:
                                                TextStyle(color: Colors.blue)))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        });
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
