import 'package:an_app/Screens/Admin&Universitie/Admin/TextFormFieldWidget.dart';

import 'package:an_app/Screens/Admin&Universitie/Universite/universitie_register.dart';

import 'package:flutter/material.dart';

import '../../../model/db_management/mysql_management/mysql_conn.dart';

class Permission extends StatefulWidget {
  const Permission({super.key});

  @override
  State<Permission> createState() => _PermissionState();
}

class _PermissionState extends State<Permission> {
  final key = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  bool hide = true;
  int index = 0;
  bool isLoading = false;
  DateTime? _lastPressedAt;
  static String? check(String? value) {
    if (value!.isEmpty) {
      return "Champs obligatoire";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) > Duration(seconds: 2)) {
          _lastPressedAt = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Appuyer à nouveau pour vous déconnecter"),
            duration: Duration(seconds: 2),
          ));
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Guide de L'etidiant"),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: const Text(
                "Verifiez que vous avez l'autorisation",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: const Text(
                    "Clé fournis par le ministre de l'education nationale",
                    textAlign: TextAlign.center,
                  ),
                ),
                Form(
                  key: key,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormFields(
                        f: check,
                        toChange: _controller,
                        labelText: "Clé verifiant votre authenticité",
                        prefix: true,
                        icon: Icons.security,
                        suffix: true,
                        hide: true),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: isLoading
                      ? const LinearProgressIndicator()
                      : IconButton(
                          icon: const Icon(
                            Icons.check,
                            semanticLabel: "Verifier",
                          ),
                          tooltip: "Verifier",
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (key.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await Mysql()
                                        .ConnectToDb()
                                        .then((conn) async {
                                      final result = await conn.execute(
                                          "select cle from superadmin where cle = :cle",
                                          {"cle": _controller.text});

                                      for (var i in result.rows) {
                                        index =
                                            i.assoc().values.toList().length;
                                        print(i.assoc().values.toList().length);
                                      }
                                      print(
                                          "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvggg");
                                      print(index);
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        if (index == 1) {
                                          _controller.clear();
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return const UniversitieRegister();
                                          }));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Verifiez votre clé")));
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      });
                                      // setState(() {
                                      //   index = 0;
                                      // });
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Saisissez une clé")));
                                  }
                                },
                        ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
