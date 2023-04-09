// ignore_for_file: avoid_print

import 'package:an_app/Screens/Admin&Universitie/Admin/TextFormFieldWidget.dart';
import 'package:an_app/Screens/Admin&Universitie/Admin/admin_register.dart';

import 'package:an_app/Screens/Admin&Universitie/Universite/universitie_login.dart';

import 'package:flutter/material.dart';
import '../../../model/db_management/mysql_management/mysql_conn.dart';
import '../../../model/db_management/mysql_management/rudOndb.dart';

class AdminLoginBody extends StatefulWidget {
  const AdminLoginBody({super.key});

  @override
  State<AdminLoginBody> createState() => _AdminLoginBodyState();
}

class _AdminLoginBodyState extends State<AdminLoginBody> {
  final formcle = GlobalKey<FormState>();
  var base = Mysql();
  TextEditingController username = TextEditingController(),
      passwd = TextEditingController();
  String? usernames;
  String? password;
  int? v;
  bool isLoading = false;
  bool isVerified = false;
  bool hidePassword = false;
  bool _hasLeftPage = false;
  static String? validate(String? value) {
    if (value!.isEmpty) {
      return "Veuillez rensignez un nom d'utilisateur valide";
    }
  }

  static String? passwdValidation(String? value) {
    if (value!.isEmpty) {
      return "Veuillez le mot de passe";
    }
  }

  void login() async {
    if (formcle.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final result = await RUD().query(
          'select username,count(*) as count from administrateur where username = :username and passwor = :passwor',
          {"username": username.text, "passwor": passwd.text});

      for (var r in result!.rows) {
        setState(() {
          v = int.parse(r.assoc().values.toList()[1].toString());
        });
        print("vvvvvvvvvvvvvvvvvvvvvvvvvvv ");
        print(r.assoc().values.toList());
      }

      if (v == 1) {
        // _markPageAsLeft();

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 3),
            content: Text("Connexion reussi !")));
        // ignore: use_build_context_synchronously

        username.clear();
        passwd.clear();
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return const UniversitieLogin();
        }));

        // ignore: use_build_context_synchronously
        FocusScope.of(context).unfocus();
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Nom d'utilisateur ou mot de passe incorrect")));
      }
      setState(() {
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Données invalid")));
    }
  }

  // void _markPageAsLeft() {
  //   if (!_hasLeftPage) {
  //     setState(() {
  //       _hasLeftPage = !_hasLeftPage;
  //     });
  //   }
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    username.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_hasLeftPage) {
    //   username.clear();
    // }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Connectez vous d'abord à votre compte personnel",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Form(
            key: formcle,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormFields(
                      toChange: username,
                      hide: false,
                      hint: "Username",
                      suffix: false,
                      prefix: false,
                      f: validate,
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormFields(
                    toChange: passwd,
                    hint: "Password",
                    hide: true,
                    suffix: true,
                    prefix: false,
                    f: passwdValidation,
                  ),
                ),
                Container(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(color: Colors.white),
                    )),
                ElevatedButton(
                    onPressed: isLoading ? null : login,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.blue,
                            backgroundColor: Colors.grey,
                          )
                        : isVerified
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.check, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text("Connexion réussie !"),
                                ],
                              )
                            : const Text("Se connecter")),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Vous n'avez pas de compte ?",
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const AdminRegister();
                            }));
                          },
                          child: const Text("Créer un compte ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17)))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
