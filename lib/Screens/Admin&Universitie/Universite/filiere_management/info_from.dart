import 'dart:convert';
import 'dart:io';

import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:an_app/model/iniversities%20model/info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../model/db_management/mysql_management/rudOndb.dart';
import '../../../../model/iniversities model/class_filiere.dart';
import '../../../../model/iniversities model/class_option.dart';
import '../../../../model/iniversities model/class_series_filiere.dart';
import '../../../../model/iniversities model/serie_model.dart';
import '../../Admin/TextFormFieldWidget.dart';

class InfoForm extends StatefulWidget {
  Universite faculty;

  InfoForm({super.key, required this.faculty});

  @override
  State<InfoForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<InfoForm> {
  final key = GlobalKey<FormState>();
  String? image;
  bool isLoading = false;
  List<SeriesFiliere> seriefiliere = [];
  List<Serie> serie = [];
  Serie? serieToEvaluate;
  String current = "";
  List<Option> optionList = [];
  DateTime? _date;
  DateTime? _date1;
  TextEditingController titre = TextEditingController(),
      contenue = TextEditingController();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                "Partager une information",
                color: Colors.blue,
                factor: 2.0,
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: key,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.6,
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
                      toChange: titre,
                      f: check,
                      hide: false,
                      labelText: "Titre de l'information",
                      prefix: false,
                      suffix: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormFields(
                      toChange: contenue,
                      f: commentCheck,
                      labelText: "Contenue",
                      maxl: 5,
                      hide: false,
                      suffix: false,
                      prefix: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      "Date de debut",
                      fontStyle: FontStyle.normal,
                      factor: 1.2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text((_date != null)
                                ? _date.toString()
                                : "Selectionner une date")),
                        IconButton(
                            onPressed: () => picker(),
                            icon: const Icon(Icons.calendar_month))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      "Date de fin",
                      fontStyle: FontStyle.normal,
                      factor: 1.2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text((_date1 != null)
                                ? _date1.toString()
                                : "Selectionner une date")),
                        IconButton(
                            onPressed: () => picker1(),
                            icon: const Icon(Icons.calendar_month))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
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
                                                    "insert into info(titre , contenue , image ,datedebut ,datefin ,fac) values (:titre,:contenue,:image,:datedebut,:datefin,:fac)",
                                                    {
                                                      "titre": titre.text,
                                                      "contenue": contenue.text,
                                                      "image": encoded,
                                                      "datedebut":
                                                          _date.toString(),
                                                      "datefin":
                                                          _date1.toString(),
                                                      "fac": widget.faculty.name
                                                    });
                                              } catch (e) {
                                                print(e);
                                              }
                                              // try {
                                              //   Option? option;
                                              //   var result = await RUD().query(
                                              //       "select nom,commentaire,logo,name from Opt where name = :name",
                                              //       {
                                              //         "name":
                                              //             widget.faculty.name
                                              //       });
                                              //   for (var row in result!.rows) {
                                              //     String nom = row
                                              //         .assoc()
                                              //         .values
                                              //         .toList()[0]!;
                                              //     String comment = row
                                              //         .assoc()
                                              //         .values
                                              //         .toList()[1]!;
                                              //     var img = row.assoc()['logo']
                                              //         as String;
                                              //     final decoded =
                                              //         base64Decode(img);
                                              //     String name =
                                              //         row.assoc()['name']!;
                                              //     option = Option(
                                              //         nom: nom,
                                              //         logo: decoded,
                                              //         commentaire: comment,
                                              //         fac: name);
                                              //   }
                                              //   if (option != null) {
                                              //     optionList.add(option);
                                              //     await Sqflite()
                                              //         .addOption(option);
                                              //     print("Nouvelle info");
                                              //     print(optionList);
                                              //   }
                                              // } catch (e) {
                                              //   print(e);
                                              // }
                                              try {
                                                File imgFile = File(image!);
                                                final imBytes =
                                                    await imgFile.readAsBytes();
                                                List<int> imagebytes =
                                                    imgFile.readAsBytesSync();
                                                String imagebase64 =
                                                    base64Encode(imagebytes);
                                                Uint8List imageUint =
                                                    base64Decode(imagebase64)
                                                        .buffer
                                                        .asUint8List();
                                                Info inf = Info(
                                                    titre: titre.text,
                                                    contenue: contenue.text,
                                                    fac: widget.faculty.name,
                                                    image: imageUint,
                                                    datedebut: _date!,
                                                    datefin: _date1!);
                                                await Sqflite().addInfo(inf);
                                              } catch (e) {
                                                print("errorr : $e");
                                              }

                                              Navigator.pop(context);
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text("image obligatoire"),
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
                                      : const Text("Envoyer",
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

  picker() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime.now());

    if (pickerDate != null) {
      setState(() {
        _date = pickerDate;
      });
    }
  }

  picker1() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime.now().add(const Duration(days: 60)));

    if (pickerDate != null) {
      setState(() {
        _date1 = pickerDate;
      });
    }
  }
}
