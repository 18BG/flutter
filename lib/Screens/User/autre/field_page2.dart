import 'package:an_app/Screens/User/list_univ.dart';
import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';

class FieldPage2 extends StatefulWidget {
  final Filiere field;
  Universite univ;
  FieldPage2({super.key, required this.field, required this.univ});

  @override
  State<FieldPage2> createState() => _FieldPageState();
}

class _FieldPageState extends State<FieldPage2> {
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: CustomText(
                widget.field.commentaire,
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: CustomText(
                "Structure d'enseignement : ${widget.univ}",
                textAlign: TextAlign.start,
                fontStyle: FontStyle.normal,
                factor: 1.3,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: CustomText(
                "Option : ${widget.field.option}",
                fontStyle: FontStyle.normal,
                factor: 1.2,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        )),
      ),
    );
  }
}
