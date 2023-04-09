import 'dart:convert';
import 'dart:io';

import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_management/option_management.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/homePageBody.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/profil_body.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/universitie_login.dart';

import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/db_management/mysql_management/rudOndb.dart';
import '../../../model/iniversities model/class_option.dart';

class UniversititHomePage extends StatefulWidget {
  final Universite faculty;
  const UniversititHomePage({super.key, required this.faculty});

  @override
  State<UniversititHomePage> createState() => _UniversititHomePageState();
}

class _UniversititHomePageState extends State<UniversititHomePage> {
  List<Option> optionList = [];
  @override
  Widget build(BuildContext context) {
    bool? returnOrno;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.faculty.name),
            centerTitle: true,
            elevation: 0,
            shadowColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.faculty.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Image.memory(
                        widget.faculty.logo,
                        height: 70,
                        width: 100,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Gérer le profil'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Profil(
                          faculte: widget.faculty,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text('Gérer les filières'),
                  onTap: () async {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OptionManagement(
                            faculty: widget.faculty, list: optionList),
                      ),
                    );
                    await fetchOption();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Gérer les informations'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Scaffold(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          body: HomePageBody(faculte: widget.faculty),
        ),
        onWillPop: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Attention !",
                    textAlign: TextAlign.center,
                  ),
                  content: const Text(
                    "Êtes-vous sûr de quitter ?",
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UniversitieLogin()),
                                  (route) => false);
                              returnOrno = true;
                            },
                            child: const Text(
                              "Quitter",
                              style: TextStyle(color: Colors.red),
                            )),
                        TextButton(
                            onPressed: () {
                              returnOrno = false;
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Annuler",
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    )
                  ],
                );
              });
          return returnOrno!;
        });
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
      }
      if (option != null) {
        setState(() {
          optionList.add(option!);
        });
        print("Nouvelle option");
        print(optionList);
        print(optionList.length);
      }
    } catch (e) {
      print(e);
    }
  }
}
