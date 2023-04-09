import 'dart:convert';
import 'dart:io';

import 'package:an_app/Screens/Admin&Universitie/Admin/TextFormFieldWidget.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';

import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../model/db_management/mysql_management/rudOndb.dart';
import 'option_fetcher.dart';

class OptionManagement extends StatefulWidget {
  Universite faculty;
  List<Option> list;

  OptionManagement({super.key, required this.faculty, required this.list});

  @override
  State<OptionManagement> createState() => _OptionManagementState();
}

class _OptionManagementState extends State<OptionManagement> {
  TextEditingController nom = TextEditingController(),
      comment = TextEditingController();
  final key = GlobalKey<FormState>();
  String? image;
  List<Option> optionList = [];
  String? check(String? value) {
    if (value!.isEmpty) {
      return "Champ obligatoire";
    }
    return null;
  }

  String? commentCheck(String? value) {
    if (value!.isEmpty) {
      return "Champ obligatoire";
    }
    return null;
  }

  bool isProcessing = false;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchOption();
    print(optionList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestions des filieres"),
        automaticallyImplyLeading: false,
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
                        Sqflite().deleteAllOption(widget.faculty);
                        Option? option;
                        //recuperation depuis mysql
                        var result = await RUD().query(
                            "select nom,commentaire,logo,name from Opt where name = :name",
                            {"name": widget.faculty.name});
                        for (var row in result!.rows) {
                          String nom = row.assoc().values.toList()[0]!;
                          String comment = row.assoc().values.toList()[1]!;
                          var img = row.assoc()['logo'] as String;
                          final decoded = base64Decode(img);
                          String name = row.assoc()['name']!;
                          option = Option(
                              nom: nom,
                              logo: decoded,
                              commentaire: comment,
                              fac: name);
                          //on ajoute chaque option pour la fac trouvé
                          if (option != null) {
                            print(option.fac);
                            setState(() {
                              Sqflite().addOption(option!);
                              print("option enregistre");
                            });
                            print("Nouvelle option");
                          }
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        isProcessing = false;
                      });
                    },
              child: const Text("Recharger"))
        ],
      ),
      body: isProcessing
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 6,
              ),
            )
          : OptionFetcher(widget.faculty, optionList: optionList),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Add();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void Add() async {
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
                    "Ajouter une option",
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
                              labelText: "Nom de l'option",
                              prefix: false,
                              suffix: false,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormFields(
                              toChange: comment,
                              f: commentCheck,
                              labelText: "Commentaire",
                              maxl: 5,
                              hint:
                                  "Donner un commentaire sur cette option comme son importance, ses débouchés et sa place dans le marché de l'emploie",
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
                                                      "insert into Opt(nom,commentaire,logo,name) values (:nom,:commentaire,:logo,:name)",
                                                      {
                                                        "nom": nom.text,
                                                        "commentaire":
                                                            comment.text,
                                                        "logo": encoded,
                                                        "name":
                                                            widget.faculty.name
                                                      });
                                                } catch (e) {
                                                  print(e);
                                                }
                                                try {
                                                  Option? option;
                                                  var result = await RUD().query(
                                                      "select nom,commentaire,logo,name from Opt where name = :name",
                                                      {
                                                        "name":
                                                            widget.faculty.name
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
                                                    String name =
                                                        row.assoc()['name']!;
                                                    option = Option(
                                                        nom: nom,
                                                        logo: decoded,
                                                        commentaire: comment,
                                                        fac: name);
                                                  }
                                                  if (option != null) {
                                                    optionList.add(option);
                                                    await Sqflite()
                                                        .addOption(option);
                                                    print("Nouvelle option");
                                                    print(optionList);
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

  Future<void> fetchOption() async {
    try {
      Option? option;
      var result = await RUD().query(
          "select nom,commentaire,logo,name from Opt where name = :name",
          {"name": widget.faculty.name});
      for (var row in result!.rows) {
        String nom = row.assoc().values.toList()[0]!;
        String comment = row.assoc().values.toList()[1]!;
        var img = row.assoc()['logo'] as String;
        final decoded = base64Decode(img);
        String name = row.assoc()['name']!;
        option =
            Option(nom: nom, logo: decoded, commentaire: comment, fac: name);
        if (option != null) {
          setState(() {
            optionList.add(option!);
          });
          print("Nouvelle option");
          print(optionList);
          print(optionList.length);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
