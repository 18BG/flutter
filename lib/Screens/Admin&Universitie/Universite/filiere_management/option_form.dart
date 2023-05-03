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

class OptionForm extends StatefulWidget {
  Universite faculty;

  OptionForm({super.key, required this.faculty});

  @override
  State<OptionForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<OptionForm> {
  final key = GlobalKey<FormState>();
  String? image;
  bool isLoading = false;
  List<SeriesFiliere> seriefiliere = [];
  List<Serie> serie = [];
  Serie? serieToEvaluate;
  String current = "";
  List<Option> optionList = [];
  TextEditingController nom = TextEditingController(),
      comment = TextEditingController();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                "Ajouter une option",
                color: Colors.blue,
                factor: 2.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: key,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 0.6,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: (image == null)
                            ? Image.asset(
                                "assets/images/Noimage.png",
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
                    const SizedBox(
                      height: 15,
                    ),
                    (isLoading)
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
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
                                            final encoded =
                                                base64Encode(imBytes);
                                            if (key.currentState!.validate()) {
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
                                                for (var row in result!.rows) {
                                                  String nom = row
                                                      .assoc()
                                                      .values
                                                      .toList()[0]!;
                                                  String comment = row
                                                      .assoc()
                                                      .values
                                                      .toList()[1]!;
                                                  var img = row.assoc()['logo']
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
            ],
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

  void _getSeries() {
    Sqflite().fetchSeries().then((value) {
      setState(() {
        serie = value;
      });
    });
  }
}
