import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/db_management/mysql_management/rudOndb.dart';
import '../../../../model/iniversities model/class_filiere.dart';
import '../../../../model/iniversities model/class_series_filiere.dart';
import '../../../../model/iniversities model/serie_model.dart';

class SerieForm extends StatefulWidget {
  final Filiere filiere;
  SerieForm({super.key, required this.filiere});

  @override
  State<SerieForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<SerieForm> {
  bool isLoading = false;
  List<SeriesFiliere> seriefiliere = [];
  List<Serie> serie = [];
  Serie? serieToEvaluate;
  String current = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSeries();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Sqflite>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              'Séries',
              color: Colors.blue,
              factor: 2.0,
            ),
            const SizedBox(
              height: 30,
            ),
            CustomText("Choisissez une série à ajouter pour cette filière"),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<Serie>(
                  dropdownColor: Colors.blueGrey,
                  iconEnabledColor: Colors.green,
                  iconDisabledColor: Colors.red,
                  value: serieToEvaluate,
                  items: serie
                      .map((e) => DropdownMenuItem<Serie>(
                          value: e, child: Text(e.nomSerie)))
                      .toList(),
                  onChanged: (Serie? newValue) {
                    setState(() {
                      current = newValue!.nomSerie;
                      serieToEvaluate = newValue;
                      print(serieToEvaluate!.acronyme);
                      print(serieToEvaluate!.nomSerie);
                    });
                  }),
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomText(
              (current != "") ? current : "Pas de filière choisie",
              factor: 1.4,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          if (serieToEvaluate != null) {
                            try {
                              await RUD().insertQuery(
                                  ScaffoldMessengerState(),
                                  "insert into seriesfiliere(acronyme,nomSeries,nomfiliere) values(:acronyme,:nomSeries,:nomfiliere)",
                                  {
                                    'nomfiliere': widget.filiere.nomfiliere,
                                    'nomSeries': serieToEvaluate!.nomSerie,
                                    'acronyme': serieToEvaluate!.acronyme,
                                  });
                              print("serifiliere insere depuis le form...");
                              SeriesFiliere serief = SeriesFiliere(
                                  acronyme: serieToEvaluate!.acronyme,
                                  nomSeries: serieToEvaluate!.nomSerie,
                                  nomFiliere: widget.filiere.nomfiliere);

                              provider.addSerieFiliere(serief);
                              Navigator.of(context).pop();
                            } catch (e) {
                              print("il y'a un probleme");
                              print(e);
                            }
                          } else {
                            print("Les conditions ne sont pas reunis");
                          }
                        } catch (e) {
                          print(e);
                        }

                        setState(() {
                          isLoading = false;
                        });
                      },
                icon: const Icon(Icons.add),
                label: const Text("Add an serie"))
          ],
        ),
      ),
    );
  }

  void _getSeries() {
    Sqflite().fetchSeries().then((value) {
      setState(() {
        serie = value;
      });
    });
  }
}
