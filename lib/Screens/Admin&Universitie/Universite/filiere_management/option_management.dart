import 'dart:convert';
import 'dart:io';

import 'package:an_app/Screens/Admin&Universitie/Admin/TextFormFieldWidget.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_management/option_form.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestions des filieres"),
        automaticallyImplyLeading: Platform.isIOS,
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
          : OptionFetcher(widget.faculty),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => OptionForm(faculty: widget.faculty));
        },
        child: const Icon(Icons.add),
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
