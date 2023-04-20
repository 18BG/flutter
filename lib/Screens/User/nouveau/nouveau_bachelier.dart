import 'package:an_app/Screens/User/nouveau/fetchseriefields.dart';
import 'package:flutter/material.dart';

import '../../../model/db_management/sqflite_management/sqflite_conn.dart';
import '../../../model/iniversities model/serie_model.dart';

class NouveauBachelier extends StatefulWidget {
  const NouveauBachelier({Key? key}) : super(key: key);

  @override
  State<NouveauBachelier> createState() => _NouveauBachelierState();
}

class _NouveauBachelierState extends State<NouveauBachelier> {
  String current = '';
  Serie? serieToEvaluate;
  List<Serie> serie = [];
  List<String> filiere = ["LGL", "LRT", "LMRI"];
  List<Map<String, dynamic>> filieres = [
    {"value": "LGL", "label": "LGL - Lettres et sciences humaines"},
    {"value": "LRT", "label": "LRT - Lettres et sciences religieuses"},
    {"value": "LMRI", "label": "LMRI - Langues, muséologie et patrimoine"}
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        title: Text("Nouveau bachelier"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Veuillez choisir une filière",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
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
                items: serie
                    .map((e) => DropdownMenuItem<Serie>(
                        value: e, child: Text(e.nomSerie)))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    serieToEvaluate = newValue;
                    current = newValue!.nomSerie;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
                (current == '')
                    ? "Pas de filière choisie"
                    : "Filière choisie : $current",
                style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return FetchSerieFiliere(serieToEvaluate!);
                }));
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Suivant"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
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
