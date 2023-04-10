// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_management/filiere_management.dart';
import 'package:an_app/model/db_management/mysql_management/rudOndb.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class FiliereList extends StatefulWidget {
  Option opt;
  FiliereList({super.key, required this.opt});

  @override
  State<FiliereList> createState() => _FiliereListState();
}

class _FiliereListState extends State<FiliereList> {
  final key = GlobalKey<FormState>();
  bool isDeleting = false;
  bool isLoading = false;
  String? image;
  Filiere? current;
  TextEditingController nom = TextEditingController(),
      comment = TextEditingController();

  String? check(String? value) {
    if (value == null) {
      return "Champ obligatoire";
    } else if (value == current!.nomfiliere) {
      return "Vous avez entrez le même nom";
    } else {
      null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Sqflite>(builder: (_, db, __) {
      var list = db.filiereFetcher;
      String? check(String? value) {
        if (value == null) {
          return "Champ obligatoire";
        }
      }

      print("list long");
      print(list.length);

      return (isDeleting)
          ? const CircularProgressIndicator.adaptive()
          : SingleChildScrollView(
              child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  //height: MediaQuery.of(context).size.width * 0.5,
                  //color: Colors.red,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.black,
                    child: Center(
                      child: Image.memory(
                        widget.opt.logo,
                        fit: BoxFit.contain,
                        width: 350,
                        height: 300,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    widget.opt.commentaire,
                    textScaleFactor: 1.3,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      current = list[i];

                      return ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return Container();
                          }));
                        },
                        title: Text(list[i].nomfiliere),
                        subtitle: Text(list[i].commentaire),
                        trailing: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.delete)),
                        leading: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.edit)),
                      );
                    })
              ],
            ));
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







// showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                   title: const Text(
//                                     "Modifier les infos de l'option",
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   content: Column(
//                                     children: [
//                                       ElevatedButton(
//                                           onPressed: () {
//                                             showDialog(
//                                                 context: context,
//                                                 builder:
//                                                     (BuildContext context) {
//                                                   return AlertDialog(
//                                                     title: const Text(
//                                                         "Modification du nom"),
//                                                     content: Card(
//                                                       child:
//                                                           SingleChildScrollView(
//                                                         child: Form(
//                                                           key: key,
//                                                           child: Column(
//                                                             children: [
//                                                               TextFormFields(
//                                                                 toChange: nom,
//                                                                 f: check,
//                                                                 hint:
//                                                                     list[i].nom,
//                                                                 hide: false,
//                                                                 labelText:
//                                                                     "Nom de l'option",
//                                                                 prefix: false,
//                                                                 suffix: false,
//                                                               ),
//                                                               const SizedBox(
//                                                                 height: 15,
//                                                               ),
//                                                               Row(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .spaceBetween,
//                                                                 children: [
//                                                                   TextButton(
//                                                                       onPressed:
//                                                                           () {
//                                                                         Navigator.pop(
//                                                                             context);
//                                                                       },
//                                                                       child:
//                                                                           const Text(
//                                                                         "Annuler",
//                                                                         style: TextStyle(
//                                                                             color:
//                                                                                 Colors.red),
//                                                                       )),
//                                                                   TextButton(
//                                                                       onPressed: isLoading
//                                                                           ? null
//                                                                           : () async {
//                                                                               setState(() {
//                                                                                 isLoading = true;
//                                                                               });

//                                                                               if (key.currentState!.validate()) {
//                                                                                 print("l'operation commence");
//                                                                                 String str = list[i].nom;
//                                                                                 setState(() {
//                                                                                   list[i].nom = nom.text;
//                                                                                 });

//                                                                                 try {
//                                                                                   await db.updateOption(str, list[i]).then((value) async {
//                                                                                     print("Mise a jour dans sqflite");
//                                                                                     await db.fetchOption(list[i].fac);
//                                                                                     setState(() {
//                                                                                       list = db.optionFetcher;
//                                                                                       var r = db.optionFetcher;
//                                                                                     });
//                                                                                   });
//                                                                                 } catch (e) {
//                                                                                   print("Errror : $e");
//                                                                                 }
//                                                                                 print("updated into sqflite");
//                                                                                 print("Mise a jour dans mysql");
//                                                                                 try {
//                                                                                   await RUD().updateQuery(ScaffoldMessengerState(), "update Opt set nom = :nom where nom = :cnom and name = :name", {
//                                                                                     "nom": nom.text,
//                                                                                     "cnom": str,
//                                                                                     "name": list[i].fac
//                                                                                   });
//                                                                                 } catch (e) {
//                                                                                   print("Erreur..l : $e");
//                                                                                 }
//                                                                                 print("updated into mysql");
//                                                                                 Navigator.pop(context);
//                                                                               }

//                                                                               setState(() {
//                                                                                 isLoading = false;
//                                                                               });
//                                                                             },
//                                                                       child: isLoading
//                                                                           ? const Center(
//                                                                               child: CircularProgressIndicator(
//                                                                                 strokeWidth: 5,
//                                                                                 color: Colors.red,
//                                                                               ),
//                                                                             )
//                                                                           : const Text("Enregistrer", style: TextStyle(color: Colors.blue)))
//                                                                 ],
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 });
//                                           },
//                                           child: const Text("Modifier le nom")),
//                                       ElevatedButton(
//                                           onPressed: () {
//                                             showDialog(
//                                                 context: context,
//                                                 builder:
//                                                     (BuildContext context) {
//                                                   return AlertDialog(
//                                                     title: const Text(
//                                                         "Modification du commentaire"),
//                                                     content: Card(
//                                                       child:
//                                                           SingleChildScrollView(
//                                                         child: Form(
//                                                           key: key,
//                                                           child: Column(
//                                                             children: [
//                                                               TextFormFields(
//                                                                 toChange:
//                                                                     comment,
//                                                                 f: check,
//                                                                 hint: list[i]
//                                                                     .commentaire,
//                                                                 hide: false,
//                                                                 labelText:
//                                                                     "Saisissez le nouveau commentaire",
//                                                                 prefix: false,
//                                                                 suffix: false,
//                                                               ),
//                                                               const SizedBox(
//                                                                 height: 15,
//                                                               ),
//                                                               Row(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .spaceBetween,
//                                                                 children: [
//                                                                   TextButton(
//                                                                       onPressed:
//                                                                           () {
//                                                                         Navigator.pop(
//                                                                             context);
//                                                                       },
//                                                                       child:
//                                                                           const Text(
//                                                                         "Annuler",
//                                                                         style: TextStyle(
//                                                                             color:
//                                                                                 Colors.red),
//                                                                       )),
//                                                                   TextButton(
//                                                                       onPressed: isLoading
//                                                                           ? null
//                                                                           : () async {
//                                                                               setState(() {
//                                                                                 isLoading = true;
//                                                                               });

//                                                                               if (key.currentState!.validate()) {
//                                                                                 print("l'operation commence");
//                                                                                 String str = list[i].nom;
//                                                                                 setState(() {
//                                                                                   list[i].commentaire = comment.text;
//                                                                                 });

//                                                                                 try {
//                                                                                   await db.updateOption(str, list[i]).then((value) async {
//                                                                                     print("Mise a jour dans sqflite");
//                                                                                     await db.fetchOption(list[i].fac);
//                                                                                     setState(() {
//                                                                                       list = db.optionFetcher;
//                                                                                     });
//                                                                                   });
//                                                                                 } catch (e) {
//                                                                                   print("Errror : $e");
//                                                                                 }
//                                                                                 print("updated into sqflite");
//                                                                                 print("Mise a jour dans mysql");
//                                                                                 try {
//                                                                                   await RUD().updateQuery(ScaffoldMessengerState(), "update Opt set commentaire = :commentaire where nom = :cnom and name = :name", {
//                                                                                     "commentaire": comment.text,
//                                                                                     "cnom": str,
//                                                                                     "name": list[i].fac
//                                                                                   });
//                                                                                 } catch (e) {
//                                                                                   print("Erreur..l : $e");
//                                                                                 }
//                                                                                 print("updated into mysql");
//                                                                                 Navigator.pop(context);
//                                                                               }

//                                                                               setState(() {
//                                                                                 isLoading = false;
//                                                                               });
//                                                                             },
//                                                                       child: isLoading
//                                                                           ? const Center(
//                                                                               child: CircularProgressIndicator(
//                                                                                 strokeWidth: 5,
//                                                                                 color: Colors.red,
//                                                                               ),
//                                                                             )
//                                                                           : const Text("Enregistrer", style: TextStyle(color: Colors.blue)))
//                                                                 ],
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 });
//                                           },
//                                           child: const Text(
//                                               "Modifier le commentaire")),
//                                       ElevatedButton(
//                                           onPressed: () {
//                                             showDialog(
//                                                 context: context,
//                                                 builder:
//                                                     (BuildContext context) {
//                                                   return AlertDialog(
//                                                     title: const Text(
//                                                         "Modification du logo"),
//                                                     content: Card(
//                                                       child:
//                                                           SingleChildScrollView(
//                                                         child: Form(
//                                                           key: key,
//                                                           child: Column(
//                                                             children: [
//                                                               Card(
//                                                                 child: (image ==
//                                                                         null)
//                                                                     ? Image.asset(
//                                                                         "assets/images/Noimage.png")
//                                                                     : Image.file(
//                                                                         File(
//                                                                             image!)),
//                                                               ),
//                                                               const SizedBox(
//                                                                 height: 10,
//                                                               ),
//                                                               Row(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .spaceBetween,
//                                                                 children: [
//                                                                   IconButton(
//                                                                       onPressed:
//                                                                           () {
//                                                                         getImage(
//                                                                             ImageSource.camera);
//                                                                       },
//                                                                       icon: const Icon(
//                                                                           Icons
//                                                                               .camera_enhance)),
//                                                                   IconButton(
//                                                                       onPressed:
//                                                                           () {
//                                                                         getImage(
//                                                                             ImageSource.gallery);
//                                                                       },
//                                                                       icon: const Icon(
//                                                                           Icons
//                                                                               .photo_library))
//                                                                 ],
//                                                               ),
//                                                               const SizedBox(
//                                                                 height: 15,
//                                                               ),
//                                                               Row(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .spaceBetween,
//                                                                 children: [
//                                                                   TextButton(
//                                                                       onPressed:
//                                                                           () {
//                                                                         Navigator.pop(
//                                                                             context);
//                                                                       },
//                                                                       child:
//                                                                           const Text(
//                                                                         "Annuler",
//                                                                         style: TextStyle(
//                                                                             color:
//                                                                                 Colors.red),
//                                                                       )),
//                                                                   TextButton(
//                                                                       onPressed: isLoading
//                                                                           ? null
//                                                                           : () async {
//                                                                               print("l'operation commence");
//                                                                               setState(() {
//                                                                                 isLoading = true;
//                                                                               });

//                                                                               if (image != null) {
//                                                                               } else {
//                                                                                 print("l'operation commence");
//                                                                                 File imageFile = File(image!);
//                                                                                 final imBytes = await imageFile.readAsBytes();
//                                                                                 final encoded = base64Encode(imBytes);
//                                                                                 try {
//                                                                                   print("Mise a jour dans mysql");
//                                                                                   await RUD().updateQuery(ScaffoldMessengerState(), "update Opt set logo=:logo where nom=:cnom and name = :name", {
//                                                                                     "logo": encoded,
//                                                                                     "cnom": list[i].nom,
//                                                                                     "nom": list[i].fac
//                                                                                   });
//                                                                                 } catch (e) {
//                                                                                   print("Erreur..l : $e");
//                                                                                 }
//                                                                                 String str = list[i].nom;
//                                                                                 setState(() {
//                                                                                   list[i].logo = encoded;
//                                                                                 });

//                                                                                 try {
//                                                                                   await db.updateOption(str, list[i]).then((value) async {
//                                                                                     print("Mise a jour dans sqflite");
//                                                                                     await db.fetchOption(list[i].fac);
//                                                                                     setState(() {
//                                                                                       list = db.optionFetcher;
//                                                                                     });
//                                                                                   });
//                                                                                   print("updated into mysql");
//                                                                                 } catch (e) {
//                                                                                   print("Errror : $e");
//                                                                                 }
//                                                                                 print("updated into sqflite");

//                                                                                 Navigator.pop(context);
//                                                                               }

//                                                                               setState(() {
//                                                                                 isLoading = false;
//                                                                               });
//                                                                             },
//                                                                       child: isLoading
//                                                                           ? const Center(
//                                                                               child: CircularProgressIndicator(
//                                                                                 strokeWidth: 5,
//                                                                                 color: Colors.red,
//                                                                               ),
//                                                                             )
//                                                                           : const Text("Enregistrer", style: TextStyle(color: Colors.blue)))
//                                                                 ],
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 });
//                                           },
//                                           child:
//                                               const Text("Modifier le logo")),
//                                       TextButton(
//                                           onPressed: () async {
//                                             Navigator.pop(context);
//                                           },
//                                           child: const Text("Terminé"))
//                                     ],
//                                   ));
//                             });