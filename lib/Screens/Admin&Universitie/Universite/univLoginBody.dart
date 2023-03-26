import 'package:an_app/Screens/Admin&Universitie/Admin/TextFormFieldWidget.dart';
import 'package:an_app/model/mysql_conn.dart';
import 'package:flutter/material.dart';

class UnivLoginBody extends StatefulWidget {
  const UnivLoginBody({super.key});

  @override
  State<UnivLoginBody> createState() => _UnivLoginBodyState();
}

class _UnivLoginBodyState extends State<UnivLoginBody> {
  final key = GlobalKey<FormState>();
  TextEditingController name = TextEditingController(),
      password = TextEditingController();
  Mysql base = Mysql();
  static String? emptyCheck(String? value) {
    if (value!.isEmpty) {
      return "Tous les champs sont obligatoires";
    }
  }

  bool? returnOrno;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              //margin: ,
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: const Text(
                "Renseignez les informations de la faculté",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormFields(
                f: emptyCheck,
                toChange: name,
                labelText: "Nom de la faculté",
                suffix: false,
                prefix: false,
                hide: false,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormFields(
                f: emptyCheck,
                toChange: password,
                labelText: "Mot de passe",
                suffix: true,
                prefix: false,
                hide: true,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                  onPressed: () {}, child: const Text("Mot de passe oublié ?")),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: ElevatedButton(
                onPressed: () async {
                  if (key.currentState!.validate()) {
                    await base.ConnectToDb().then((conn) {
                      conn.execute(
                          "Select name , password from faculte where name = :name and password = :password",
                          {"name": name.text, "password": password.text});
                    });
                  }
                },
                child: const Text("Se connecter"),
              ),
            ),
            Row(
              children: [
                const Text("Vous n'avez pas de faculté enregistrée ?"),
                TextButton(
                    onPressed: () {}, child: const Text("Créer une faculté"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
