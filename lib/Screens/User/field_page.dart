import 'package:an_app/Screens/User/list_univ.dart';
import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:flutter/material.dart';

class FieldPage extends StatefulWidget {
  final Filiere field;
  const FieldPage({super.key, required this.field});

  @override
  State<FieldPage> createState() => _FieldPageState();
}

class _FieldPageState extends State<FieldPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(73, 182, 172, 1),
      appBar: AppBar(
        title: Text(widget.field.nomfiliere),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(17, 117, 177, 1),
              Color.fromRGBO(73, 182, 172, 1),
            ],
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Center(
              child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.memory(
                        widget.field.logo,
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.width / 1.1,
                        fit: BoxFit.cover,
                      ))),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              child: Text(
                widget.field.commentaire,
                style: const TextStyle(color: Colors.blueAccent, fontSize: 20),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: CustomText(
                "Cliquer sur le bouton ci_dessous pour voir les universités qui offrent des fromations pour la filière  <<${widget.field.nomfiliere}>>",
                weiht: FontWeight.bold,
                factor: 1.2,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ListUniv(
                          name: widget.field.nomfiliere, filiere: widget.field);
                    }));
                  },
                  child: const Text("Visiter les universités")),
            )
          ],
        )),
      ),
    );
  }
}
