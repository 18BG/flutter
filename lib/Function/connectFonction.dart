import 'package:an_app/model/mysql_conn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Screens/Admin&Universitie/Universite/permission.dart';

class ConnecF extends StatefulWidget {
  const ConnecF({super.key});

  @override
  State<ConnecF> createState() => _ConnecFState();
}

class _ConnecFState extends State<ConnecF> {
  final formcle = GlobalKey<FormState>();
  bool isLoading = false;
  var base = Mysql();
  TextEditingController username = TextEditingController(),
      passwd = TextEditingController();
  int v = 0;
  @override
  Widget build(BuildContext context) {
    void login() {
      if (formcle.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        base.ConnectToDb().then((value) async {
          final result = await value.execute(
              'select username,count(*) as count from administrateur where username = :username and passwor = :passwor',
              {"username": username.text, "passwor": passwd.text});

          for (var r in result.rows) {
            setState(() {
              v = int.parse(r.assoc().values.toList()[1].toString());
            });
            print("vvvvvvvvvvvvvvvvvvvvvvvvvvv ");
            print(r.assoc().values.toList());
          }
          await Future.delayed(const Duration(seconds: 1));

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
              return const Permission();
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
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Données invalid")));
      }
    }

    return Container();
  }
}
