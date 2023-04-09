import 'dart:convert';
import 'dart:io';
import 'package:an_app/Function/connectFonction.dart';
import 'package:an_app/Screens/Admin&Universitie/Admin/TextFormFieldWidget.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/univLoginBody.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/universitie_home.dart';

import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../model/db_management/mysql_management/rudOndb.dart';

class Profil extends StatefulWidget {
  final Universite faculte;
  const Profil({Key? key, required this.faculte}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String? newName, newMail, newPassword, newLogo;
  Map<String, Future<void>> updater = {};
  List<String> update = [
    "Modifier le nom",
    "Modifier le mail ",
    "Modifier le password ",
    "Modifier le logo "
  ];
  final key = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController(),
      nom = TextEditingController(),
      mail = TextEditingController(),
      password = TextEditingController();
  String? image;
  bool isProcessing = false;
  String? check(String? value) {
    if (value == widget.faculte.name) {
      return "Vous avez saisi le même nom";
    } else {
      return null;
    }
  }

  String? pass1Check(String? value) {
    if (value!.isNotEmpty && value != widget.faculte.password) {
      return "Le mot de passe est incorrect";
    }
    return null;
  }

  String? pass2Check(String? value) {
    if (value == widget.faculte.password) {
      return "Vous avez saisi le même mot de passe que celle en vigueur";
    }
    return null;
  }

  String? pass3Check(String? value) {
    if (value != password.text) {
      return "Les mots de passe ne correspondent pas";
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.faculte.name),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Modifications des informations"),
            Form(
                key: key,
                child: Card(
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      (image == null)
                          ? Image.memory(widget.faculte.logo)
                          : Image.file(File(image!)),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("Chosissez un nouveau logo"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                getImage(ImageSource.camera);
                              },
                              icon: const Icon(Icons.camera_alt_sharp)),
                          IconButton(
                              onPressed: () {
                                getImage(ImageSource.gallery);
                              },
                              icon: const Icon(Icons.photo_library))
                        ],
                      ),
                      TextFormFields(
                        toChange: nom,
                        hint: widget.faculte.name,
                        labelText: "Entrez le nouveau nom da la faculté",
                        hide: false,
                        prefix: false,
                        suffix: false,
                        f: check,
                      ),
                      TextFormFields(
                        toChange: mail,
                        hint: widget.faculte.mail,
                        labelText: "Entrez le nouveau mail da la faculté",
                        hide: false,
                        prefix: false,
                        suffix: false,
                        f: check,
                      ),
                      TextFormFields(
                        labelText: "Entrez l'ancien mot de passe da la faculté",
                        hide: true,
                        prefix: false,
                        suffix: true,
                        f: pass1Check,
                      ),
                      TextFormFields(
                        toChange: password,
                        labelText:
                            "Entrez le nouveau mot de passe da la faculté",
                        hide: true,
                        prefix: false,
                        suffix: true,
                        f: pass2Check,
                      ),
                      TextFormFields(
                        labelText:
                            "Confirmez le nouveau mot de passe da la faculté",
                        hide: true,
                        prefix: false,
                        suffix: true,
                        f: pass3Check,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (nom.text == "") {
                                print("rien");
                              } else {
                                print(nom.text);
                              }

                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Annuler",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                if (nom.text == "" &&
                                    mail.text == "" &&
                                    password.text == "" &&
                                    image == null) {
                                  Navigator.pop(context);
                                } else {
                                  if (key.currentState!.validate()) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const Center(
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          );
                                        });
                                    if (image != null) {
                                      File imfile = File(image!);
                                      final imbytes =
                                          await imfile.readAsBytes();
                                      final encoded = base64Encode(imbytes);
                                      try {
                                        await RUD().updateQuery(
                                            ScaffoldMessengerState(),
                                            "update faculte set logo = :logo where name = :check",
                                            {
                                              "logo": encoded,
                                              "check": widget.faculte.name
                                            });
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                    if (mail.text != "") {
                                      try {
                                        await RUD().updateQuery(
                                            ScaffoldMessengerState(),
                                            "update faculte set mail = :mail where name = :check",
                                            {
                                              "mail": mail.text,
                                              "check": widget.faculte.name
                                            });
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                    if (password.text != "") {
                                      print(password.text);
                                      try {
                                        await RUD().updateQuery(
                                            ScaffoldMessengerState(),
                                            "update faculte set password = :passwor where name = :check",
                                            {
                                              "passwor": password.text,
                                              "check": widget.faculte.name
                                            });
                                        print("MP modifier");
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                    if (nom.text != "") {
                                      try {
                                        await RUD().updateQuery(
                                            ScaffoldMessengerState(),
                                            "update faculte set name = :name where name = :check",
                                            {
                                              "name": nom.text,
                                              "check": widget.faculte.name
                                            });
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                    await getUnivers();
                                  }
                                }
                              },
                              child: const Text("Valider",
                                  style: TextStyle(color: Colors.blue)))
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future getImage(ImageSource source) async {
    var newImage = await ImagePicker().pickImage(source: source);
    setState(() {
      image = newImage!.path;
    });
  }

  Future<void> getUnivers() async {
    Universite? fac;
    String nameTocheck;
    if (nom.text != "") {
      nameTocheck = nom.text;
    } else {
      nameTocheck = widget.faculte.name;
    }

    var result = await RUD().query(
        "Select name , password,mail,logo from faculte where name = :name",
        {"name": nameTocheck});
    for (var row in result!.rows) {
      print("ooooooooooooooooooooooo");
      print("${row.assoc()['name']} , ${row.assoc()['mail']}");
      String nam = row.assoc().values.toList()[0]!;
      String pass = row.assoc().values.toList()[1]!;
      String maile = row.assoc().values.toList()[2]!;
      var imageprofil = row.assoc()['logo'] as String;
      final decoded = base64Decode(imageprofil);
      print(decoded);

      print("ppppppppppppppppppppppppp");
      fac = Universite(logo: decoded, name: nam, mail: maile, password: pass);
      print("ppppppppppppppppppppppppp");
    }

    if (fac != null) {
      print((fac.name == "") ? "rien" : fac.name);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return UniversititHomePage(
          faculty: fac!,
        );
      }));
      // ignore: use_build_context_synchronously
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (BuildContext context) {
      //   return UniversititHomePage(
      //     faculty: fac!,
      //   );
      // }));
    }

    print("finnnnnnnnnnnnnnnnnnnn");
  }
}
