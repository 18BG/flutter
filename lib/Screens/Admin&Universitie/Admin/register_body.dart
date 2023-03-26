import 'package:an_app/Screens/Admin&Universitie/Admin/TextFormFieldWidget.dart';
import 'package:an_app/Screens/Admin&Universitie/Admin/admin_login.dart';
import 'package:an_app/model/admin_model/class_admin.dart';
import 'package:an_app/model/db_management/creatingDB.dart';
import 'package:flutter/material.dart';

class AdminRegisterBody extends StatefulWidget {
  const AdminRegisterBody({super.key});

  @override
  State<AdminRegisterBody> createState() => _AdminRegisterBodyState();
}

class _AdminRegisterBodyState extends State<AdminRegisterBody> {
  final key = GlobalKey<FormState>();
  TextEditingController username = TextEditingController(),
      nom = TextEditingController(),
      prenom = TextEditingController(),
      mail = TextEditingController(),
      passwd = TextEditingController(),
      passwd2 = TextEditingController();
  late String password = '';
  bool isLoading = false;
  static String? emptyCheck(String? value) {
    if (value!.isEmpty) {
      return "Champ obligatoire";
    }
    return null;
  }

  String? passwordCheck(String? value) {
    if (value!.isEmpty) {
      return "Champs obligatoire";
    } else if (value != passwd.text) {
      return "Les mots de passes ne sont pas conforment";
    }
    return null;
  }

  Admin admin =
      Admin(username: '', nom: '', prenom: '', mail: '', password: '');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: key,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              child: const Text(
                "Créez un compte personnelle",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 6),
                child: TextFormFields(
                  labelText: "username",
                  toChange: username,
                  suffix: false,
                  prefix: false,
                  hide: false,
                  f: emptyCheck,
                )),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
              child: TextFormFields(
                toChange: prenom,
                labelText: "prenom",
                suffix: false,
                prefix: false,
                hide: false,
                f: emptyCheck,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
              child: TextFormFields(
                labelText: "nom",
                toChange: nom,
                suffix: false,
                prefix: false,
                hide: false,
                f: emptyCheck,
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
                child: TextFormFields(
                  f: emptyCheck,
                  toChange: mail,
                  labelText: "mail",
                  prefix: false,
                  suffix: false,
                  hide: false,
                )),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
              child: TextFormFields(
                f: passwordCheck,
                toChange: passwd,
                labelText: "password",
                prefix: false,
                suffix: false,
                hide: false,
              ),
            ),
            ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (key.currentState!.validate()) {
                          key.currentState!.save();
                          setState(() {
                            isLoading = true;
                          });
                          admin.username = username.text.toString();

                          admin.nom = nom.text.toString();
                          admin.mail = mail.text.toString();
                          admin.prenom = prenom.text.toString();
                          admin.password = passwd.text.toString();
                          if (admin.nom != "" &&
                              admin.prenom != "" &&
                              admin.password != "" &&
                              admin.username != "") {
                            try {
                              await CreateOrUseDB().insertInDbForAdmin(
                                  admin, ScaffoldMessengerState());
                              print("Compte cree avec succes");
                              Future.delayed(const Duration(seconds: 3), () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return const AdminLogin();
                                }));
                              });
                              // ignore: use_build_context_synchronously
                              FocusScope.of(context).unfocus();
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Erreur : le nom d'utilisateur existe déjà")));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Assurrez d'avoir remplis tous les champs")));
                          }
                          // setState(() {
                          //   isLoading = false;
                          // });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Ckeck your values")));
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Créer un compte"))
          ],
        ),
      ),
    );
  }
}
