import 'dart:convert';
import 'dart:io';

import 'package:an_app/Screens/Admin&Universitie/Admin/TextFormFieldWidget.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_management/option_form.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';

import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:an_app/model/iniversities%20model/info_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../model/db_management/mysql_management/rudOndb.dart';
import 'info_fetcher.dart';
import 'info_from.dart';
import 'option_fetcher.dart';

class InfoManagement extends StatefulWidget {
  Universite faculty;
  List<Info> list;

  InfoManagement({super.key, required this.faculty, required this.list});

  @override
  State<InfoManagement> createState() => _OptionManagementState();
}

class _OptionManagementState extends State<InfoManagement> {
  TextEditingController nom = TextEditingController(),
      comment = TextEditingController();
  final key = GlobalKey<FormState>();
  String? image;
  //List<Option> optionList = [];
  List<Info> infoList = [];
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
                        Sqflite().deleteAllInfo(widget.faculty);
                        Info? info;
                        var result = await RUD().query(
                            "select titre,contenue,image,fac,datedebut,datefin from info where fac = :fac",
                            {"fac": widget.faculty.name});
                        for (var row in result!.rows) {
                          String titre = row.assoc().values.toList()[0]!;
                          String contenue = row.assoc().values.toList()[1]!;
                          var img = row.assoc()['image'] as String;
                          final decoded = base64Decode(img);
                          String fac = row.assoc()['fac']!;
                          DateTime datedebut =
                              DateTime.parse(row.assoc().values.toList()[4]!);
                          DateTime datefin =
                              DateTime.parse(row.assoc().values.toList()[5]!);
                          info = Info(
                              titre: titre,
                              contenue: contenue,
                              fac: fac,
                              image: decoded,
                              datedebut: datedebut,
                              datefin: datefin);
                          if (info != null) {
                            setState(() {
                              infoList.add(info!);
                              Sqflite().addInfo(info);
                            });
                            print("Nouvelle info");
                            print(infoList);
                            print(infoList.length);
                          }
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        isProcessing = false;
                      });
                    },
              child: const Icon(Icons.refresh))
        ],
      ),
      body: isProcessing
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 6,
              ),
            )
          : InfoFetcher(widget.faculty),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => InfoForm(faculty: widget.faculty))
              .then((value) => refresh());
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

  Future<void> fetchInfo() async {
    try {
      Info? info;
      var result = await RUD().query(
          "select titre,contenue,image,fac,datedebut,datefin from info where fac = :fac",
          {"fac": widget.faculty.name});
      for (var row in result!.rows) {
        String titre = row.assoc().values.toList()[0]!;
        String contenue = row.assoc().values.toList()[1]!;
        var img = row.assoc()['image'] as String;
        final decoded = base64Decode(img);
        String fac = row.assoc()['fac']!;
        DateTime datedebut = DateTime.parse(row.assoc().values.toList()[4]!);
        DateTime datefin = DateTime.parse(row.assoc().values.toList()[5]!);
        info = Info(
            titre: titre,
            contenue: contenue,
            fac: fac,
            image: decoded,
            datedebut: datedebut,
            datefin: datefin);
      }
      if (info != null) {
        setState(() {
          infoList.add(info!);
        });
        print("Nouvelle info");
        print(infoList);
        print(infoList.length);
      }
    } catch (e) {
      print(e);
    }
  }

  void refresh() {
    isProcessing
        ? null
        : () async {
            setState(() {
              isProcessing = true;
            });
            try {
              //suppression
              Sqflite().deleteAllInfo(widget.faculty);
              Info? info;
              var result = await RUD().query(
                  "select titre,contenue,image,fac,datedebut,datefin from info where fac = :fac",
                  {"fac": widget.faculty.name});
              for (var row in result!.rows) {
                String titre = row.assoc().values.toList()[0]!;
                String contenue = row.assoc().values.toList()[1]!;
                var img = row.assoc()['image'] as String;
                final decoded = base64Decode(img);
                String fac = row.assoc()['fac']!;
                DateTime datedebut =
                    DateTime.parse(row.assoc().values.toList()[4]!);
                DateTime datefin =
                    DateTime.parse(row.assoc().values.toList()[5]!);
                info = Info(
                    titre: titre,
                    contenue: contenue,
                    fac: fac,
                    image: decoded,
                    datedebut: datedebut,
                    datefin: datefin);
                if (info != null) {
                  setState(() {
                    infoList.add(info!);
                    Sqflite().addInfo(info);
                  });
                  print("Nouvelle info");
                  print(infoList);
                  print(infoList.length);
                }
              }
            } catch (e) {
              print(e);
            }
            setState(() {
              isProcessing = false;
            });
          };
  }
}
