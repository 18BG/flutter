import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_management/serie_from.dart';
import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/db_management/mysql_management/rudOndb.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:an_app/model/iniversities%20model/class_series_filiere.dart';
import 'package:an_app/model/iniversities%20model/serie_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Admin/TextFormFieldWidget.dart';

class FilierePage extends StatefulWidget {
  final Filiere filiere;
  const FilierePage({super.key, required this.filiere});

  @override
  State<FilierePage> createState() => _FieldPageState();
}

class _FieldPageState extends State<FilierePage> {
  final key = GlobalKey<FormState>();

  List<Serie> serie = [];
  TextEditingController nom = TextEditingController();

  bool isLoading = false;
  bool isProcessing = false;
  String current = "";
  Serie? serieToEvaluate;
  String? check(String? value) {
    if (value!.isEmpty) {
      return 'Champs obligatoire';
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Sqflite>(builder: (_, db, __) {
      var seriefiliere = db.serifiliereFetcher;
      print(seriefiliere.length);
      print("Et pourtant c'es venu ${seriefiliere.length}");
      return Scaffold(
        appBar: AppBar(title: Text(widget.filiere.nomfiliere)),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Center(
              child: Card(
                child: Image.memory(widget.filiere.logo),
              ),
            ),
            Text(widget.filiere.commentaire),
            const SizedBox(
              height: 20,
            ),
            Card(
              child: CustomText(
                "Liste des Bac pouvant faire ${widget.filiere.nomfiliere}",
                textAlign: TextAlign.center,
                factor: 1.5,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: (seriefiliere.isEmpty)
                  ? Center(
                      child: CustomText(
                      "Aucune série",
                      factor: 1.3,
                    ))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: seriefiliere.length,
                      itemBuilder: (BuildContext context, i) {
                        print(
                            "object du serief de i : ${seriefiliere[i].nomFiliere}");
                        return Card(
                          child: ListTile(
                              title: Text(seriefiliere[i].nomSeries),
                              leading: Text(seriefiliere[i].acronyme)),
                        );
                      }),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => SerieForm(
                      filiere: widget.filiere,
                    ));
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }

  void _getSeries() {
    Sqflite().fetchSeries().then((value) {
      setState(() {
        serie = value;
      });
    });
  }

  Add() async {
    await showDialog(
        context: context,
        builder: (context) {
          return isProcessing
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.teal,
                    backgroundColor: Colors.red,
                  ),
                )
              : AlertDialog(
                  title: const Text(
                    "Ajouter une série",
                    textAlign: TextAlign.center,
                  ),
                  content: Card(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          DropdownButton<Serie>(
                              value: serieToEvaluate,
                              items: serie
                                  .map((e) => DropdownMenuItem<Serie>(
                                      value: e, child: Text(e.nomSerie)))
                                  .toList(),
                              onChanged: (Serie? newValue) {
                                setState(() {
                                  current = newValue.toString();
                                  serieToEvaluate = newValue;
                                });
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomText((current == "")
                              ? "Pas de série choisie"
                              : "Ajouter : $current"),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Annuler",
                                    style: TextStyle(color: Colors.red),
                                  )),
                              TextButton(
                                  onPressed: isLoading
                                      ? null
                                      : () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          if (current != "") {
                                            try {
                                              await RUD().insertQuery(
                                                  ScaffoldMessengerState(),
                                                  "insert into seriesfiliere(acronyme,nomSeries,nomfiliere) values(:acronyme,:nomSeries,:nomfiliere)",
                                                  {
                                                    'nomfiliere': widget
                                                        .filiere.nomfiliere,
                                                    'nomSeries': nom.text,
                                                    'acronyme': 'GC'
                                                  });
                                              print("serifiliere...");
                                              SeriesFiliere serie =
                                                  SeriesFiliere(
                                                      acronyme: "GC",
                                                      nomSeries: nom.text,
                                                      nomFiliere: widget
                                                          .filiere.nomfiliere);
                                              await Sqflite()
                                                  .addSerieFiliere(serie);
                                            } catch (e) {
                                              print("il y'a un probleme");
                                              print(e);
                                            }
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
                                      : const Text("Enregistrer",
                                          style: TextStyle(color: Colors.blue)))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
        });
  }
}
