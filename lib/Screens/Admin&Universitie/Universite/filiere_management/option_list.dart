// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_management/filiere_management.dart';
import 'package:an_app/model/db_management/mysql_management/rudOndb.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import '../../Admin/TextFormFieldWidget.dart';

class OptionList extends StatefulWidget {
  const OptionList({super.key});

  @override
  State<OptionList> createState() => _OptionListState();
}

class _OptionListState extends State<OptionList> {
  final key = GlobalKey<FormState>();
  bool isDeleting = false;
  bool isLoading = false;
  String? image;
  Option? current;
  TextEditingController nom = TextEditingController(),
      comment = TextEditingController();

  String? check(String? value) {
    if (value == null) {
      return "Champ obligatoire";
    } else if (value == current!.nom) {
      return "Vous avez entrez le même nom";
    } else {
      null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Sqflite>(builder: (_, db, __) {
      var list = db.optionFetcher;
      String? check(String? value) {
        if (value == null) {
          return "Champ obligatoire";
        }
      }

      print("list long");
      print(list.length);

      return (isDeleting)
          ? const CircularProgressIndicator.adaptive()
          : ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: list.length,
              itemBuilder: (_, i) {
                current = list[i];

                return ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return FiliereManage(option: list[i]);
                    }));
                  },
                  title: Text(list[i].nom),
                  subtitle: Text(list[i].commentaire),
                  trailing: IconButton(
                      onPressed: () async {
                        print("Suppresion depuis mysql");
                        try {
                          await RUD().query(
                              "delete from Opt where name =:name and nom = :nom",
                              {"name": list[i].fac, "nom": list[i].nom});
                        } catch (e) {
                          print("reerr $e");
                        }
                        print("mysql suppression finish");
                        print("Suppresion depuis sqflite");
                        await db.deleteAnOption(list[i]).then((value) async {
                          print("sqflite suppression finish");
                          await db.fetchOption(list[i].fac);

                          setState(() {
                            list = db.optionFetcher;
                            print("list delete");
                            print(list.length);
                          });
                        });
                      },
                      icon: const Icon(Icons.delete)),
                  leading: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text(
                                    "Modifier les infos de l'option",
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Column(
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Modification du nom"),
                                                    content: Card(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Form(
                                                          key: key,
                                                          child: Column(
                                                            children: [
                                                              TextFormFields(
                                                                toChange: nom,
                                                                f: check,
                                                                hint:
                                                                    list[i].nom,
                                                                hide: false,
                                                                labelText:
                                                                    "Nom de l'option",
                                                                prefix: false,
                                                                suffix: false,
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        "Annuler",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )),
                                                                  TextButton(
                                                                      onPressed: isLoading
                                                                          ? null
                                                                          : () async {
                                                                              setState(() {
                                                                                isLoading = true;
                                                                              });

                                                                              if (key.currentState!.validate()) {
                                                                                print("l'operation commence");
                                                                                String str = list[i].nom;
                                                                                setState(() {
                                                                                  list[i].nom = nom.text;
                                                                                });

                                                                                try {
                                                                                  await db.updateOption(str, list[i]).then((value) async {
                                                                                    print("Mise a jour dans sqflite");
                                                                                    await db.fetchOption(list[i].fac);
                                                                                    setState(() {
                                                                                      list = db.optionFetcher;
                                                                                      var r = db.optionFetcher;
                                                                                    });
                                                                                  });
                                                                                } catch (e) {
                                                                                  print("Errror : $e");
                                                                                }
                                                                                print("updated into sqflite");
                                                                                print("Mise a jour dans mysql");
                                                                                try {
                                                                                  await RUD().updateQuery(ScaffoldMessengerState(), "update Opt set nom = :nom where nom = :cnom and name = :name", {
                                                                                    "nom": nom.text,
                                                                                    "cnom": str,
                                                                                    "name": list[i].fac
                                                                                  });
                                                                                } catch (e) {
                                                                                  print("Erreur..l : $e");
                                                                                }
                                                                                print("updated into mysql");
                                                                                Navigator.pop(context);
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
                                                                          : const Text("Enregistrer", style: TextStyle(color: Colors.blue)))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: const Text("Modifier le nom")),
                                      ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Modification du commentaire"),
                                                    content: Card(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Form(
                                                          key: key,
                                                          child: Column(
                                                            children: [
                                                              TextFormFields(
                                                                toChange:
                                                                    comment,
                                                                f: check,
                                                                hint: list[i]
                                                                    .commentaire,
                                                                hide: false,
                                                                labelText:
                                                                    "Saisissez le nouveau commentaire",
                                                                prefix: false,
                                                                suffix: false,
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        "Annuler",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )),
                                                                  TextButton(
                                                                      onPressed: isLoading
                                                                          ? null
                                                                          : () async {
                                                                              setState(() {
                                                                                isLoading = true;
                                                                              });

                                                                              if (key.currentState!.validate()) {
                                                                                print("l'operation commence");
                                                                                String str = list[i].nom;
                                                                                setState(() {
                                                                                  list[i].commentaire = comment.text;
                                                                                });

                                                                                try {
                                                                                  await db.updateOption(str, list[i]).then((value) async {
                                                                                    print("Mise a jour dans sqflite");
                                                                                    await db.fetchOption(list[i].fac);
                                                                                    setState(() {
                                                                                      list = db.optionFetcher;
                                                                                    });
                                                                                  });
                                                                                } catch (e) {
                                                                                  print("Errror : $e");
                                                                                }
                                                                                print("updated into sqflite");
                                                                                print("Mise a jour dans mysql");
                                                                                try {
                                                                                  await RUD().updateQuery(ScaffoldMessengerState(), "update Opt set commentaire = :commentaire where nom = :cnom and name = :name", {
                                                                                    "commentaire": comment.text,
                                                                                    "cnom": str,
                                                                                    "name": list[i].fac
                                                                                  });
                                                                                } catch (e) {
                                                                                  print("Erreur..l : $e");
                                                                                }
                                                                                print("updated into mysql");
                                                                                Navigator.pop(context);
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
                                                                          : const Text("Enregistrer", style: TextStyle(color: Colors.blue)))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: const Text(
                                              "Modifier le commentaire")),
                                      ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Modification du logo"),
                                                    content: Card(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Form(
                                                          key: key,
                                                          child: Column(
                                                            children: [
                                                              Card(
                                                                child: (image ==
                                                                        null)
                                                                    ? Image.asset(
                                                                        "assets/images/Noimage.png")
                                                                    : Image.file(
                                                                        File(
                                                                            image!)),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        getImage(
                                                                            ImageSource.camera);
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .camera_enhance)),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        getImage(
                                                                            ImageSource.gallery);
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .photo_library))
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        "Annuler",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )),
                                                                  TextButton(
                                                                      onPressed: isLoading
                                                                          ? null
                                                                          : () async {
                                                                              print("l'operation commence");
                                                                              setState(() {
                                                                                isLoading = true;
                                                                              });

                                                                              if (image != null) {
                                                                              } else {
                                                                                print("l'operation commence");
                                                                                File imageFile = File(image!);
                                                                                final imBytes = await imageFile.readAsBytes();
                                                                                final encoded = base64Encode(imBytes);
                                                                                try {
                                                                                  print("Mise a jour dans mysql");
                                                                                  await RUD().updateQuery(ScaffoldMessengerState(), "update Opt set logo=:logo where nom=:cnom and name = :name", {
                                                                                    "logo": encoded,
                                                                                    "cnom": list[i].nom,
                                                                                    "nom": list[i].fac
                                                                                  });
                                                                                } catch (e) {
                                                                                  print("Erreur..l : $e");
                                                                                }
                                                                                String str = list[i].nom;
                                                                                setState(() {
                                                                                  list[i].logo = encoded;
                                                                                });

                                                                                try {
                                                                                  await db.updateOption(str, list[i]).then((value) async {
                                                                                    print("Mise a jour dans sqflite");
                                                                                    await db.fetchOption(list[i].fac);
                                                                                    setState(() {
                                                                                      list = db.optionFetcher;
                                                                                    });
                                                                                  });
                                                                                  print("updated into mysql");
                                                                                } catch (e) {
                                                                                  print("Errror : $e");
                                                                                }
                                                                                print("updated into sqflite");

                                                                                Navigator.pop(context);
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
                                                                          : const Text("Enregistrer", style: TextStyle(color: Colors.blue)))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child:
                                              const Text("Modifier le logo")),
                                      TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Terminé"))
                                    ],
                                  ));
                            });
                      },
                      icon: const Icon(Icons.edit)),
                );
              });
    });
  }

  Future getImage(ImageSource source) async {
    print("object");
    var newImage = await ImagePicker().pickImage(source: source);
    if (newImage != null) {
      setState(() {
        image = newImage.path;
        print(image);
        print("object1");
      });
    }
  }
}




// Card(
//                                     child: SingleChildScrollView(
//                                       child: Form(
//                                         key: key,
//                                         child: Column(
//                                           children: [
//                                             Image.asset(
//                                                 "assets/images/Noimage.png"),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceEvenly,
//                                               children: [
//                                                 IconButton(
//                                                     onPressed: () {
//                                                       getImage(
//                                                           ImageSource.camera);
//                                                     },
//                                                     icon: const Icon(
//                                                         Icons.camera_enhance)),
//                                                 IconButton(
//                                                     onPressed: () {
//                                                       getImage(
//                                                           ImageSource.gallery);
//                                                     },
//                                                     icon: const Icon(
//                                                         Icons.photo_library))
//                                               ],
//                                             ),
//                                             TextFormFields(
//                                               toChange: nom,
//                                               f: check,
//                                               hide: false,
//                                               labelText: "Nom de l'option",
//                                               prefix: false,
//                                               suffix: false,
//                                             ),
//                                             const SizedBox(
//                                               height: 15,
//                                             ),
//                                             TextFormFields(
//                                               toChange: comment,
//                                               f: check,
//                                               labelText: "Commentaire",
//                                               maxl: 5,
//                                               hint:
//                                                   "Donner un commentaire sur cette option comme son importance, ses débouchés et sa place dans le marché de l'emploie",
//                                               hide: false,
//                                               suffix: false,
//                                               prefix: false,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 TextButton(
//                                                     onPressed: () {
//                                                       Navigator.pop(context);
//                                                     },
//                                                     child: const Text(
//                                                       "Annuler",
//                                                       style: TextStyle(
//                                                           color: Colors.red),
//                                                     )),
//                                                 TextButton(
//                                                     onPressed: isLoading
//                                                         ? null
//                                                         : () async {
//                                                             setState(() {
//                                                               isLoading = true;
//                                                             });
//                                                             print(
//                                                                 "l'operation commence");
//                                                             if (image != null) {
//                                                               File imgFile =
//                                                                   File(image!);
//                                                               final imBytes =
//                                                                   await imgFile
//                                                                       .readAsBytes();
//                                                               final encoded =
//                                                                   base64Encode(
//                                                                       imBytes);
//                                                               if (key
//                                                                   .currentState!
//                                                                   .validate()) {

                                                              
                                                               
//                                                                 Navigator.pop(
//                                                                     context);
//                                                               }
//                                                             } else {
//                                                               ScaffoldMessenger
//                                                                       .of(
//                                                                           context)
//                                                                   .showSnackBar(
//                                                                       const SnackBar(
//                                                                 content: Text(
//                                                                     "Logo obligatoire"),
//                                                                 duration:
//                                                                     Duration(
//                                                                         seconds:
//                                                                             3),
//                                                               ));
//                                                             }
//                                                             setState(() {
//                                                               isLoading = false;
//                                                             });
//                                                           },
//                                                     child: isLoading
//                                                         ? const Center(
//                                                             child:
//                                                                 CircularProgressIndicator(
//                                                               strokeWidth: 5,
//                                                               color: Colors.red,
//                                                             ),
//                                                           )
//                                                         : const Text(
//                                                             "Enregistrer",
//                                                             style: TextStyle(
//                                                                 color: Colors
//                                                                     .blue)))
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),