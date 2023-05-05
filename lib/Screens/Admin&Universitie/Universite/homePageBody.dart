import 'dart:convert';
import 'dart:io';

import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_management/info_management.dart';
import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_management/option_management.dart';
import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';

import '../../../model/db_management/mysql_management/rudOndb.dart';
import '../../../model/iniversities model/info_model.dart';
import 'filiere_management/info_fetcher.dart';

class HomePageBody extends StatefulWidget {
  final Universite faculte;
  const HomePageBody({super.key, required this.faculte});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  List<Info> infoList = [];
  List<Option> optlist = [];
  final Map<String, Widget> items = {
    'Présentation': const Icon(Icons.screen_share),
    'Informations': const Icon(Icons.info),
    'Options': const Icon(Icons.school),
  };
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.7,
                    child: Card(
                      color: Colors.black,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Image.memory(
                          widget.faculte.logo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                widget.faculte.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.04,
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      if (index == 0) {
                      } else if (index == 1) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return InfoManagement(
                              faculty: widget.faculte, list: infoList);
                        }));
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return OptionManagement(
                              faculty: widget.faculte, list: optlist);
                        }));
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(
                              topEnd: Radius.circular(12),
                              bottomStart: Radius.elliptical(15, 12)),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color.fromARGB(127, 0, 0, 0),
                                Color.fromARGB(255, 84, 226, 212)
                              ])),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            items.values.elementAt(index),
                            Text(items.keys.elementAt(index)),
                            Text("$index"),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        ]),
      ),
    );
  }

  Future<void> fetchInfo() async {
    try {
      Info? info;
      var result = await RUD().query(
          "select titre,contenue,image,fac,datedebut,datefin from info where fac = :fac",
          {"fac": widget.faculte.name});
      for (var row in result!.rows) {
        String titre = row.assoc().values.toList()[0]!;
        String contenue = row.assoc().values.toList()[1]!;
        var img = row.assoc()['image'] as String;
        final decoded = base64Decode(img);
        String fac = row.assoc()['fac']!;
        DateTime datedebut = DateTime.parse(row.assoc().values.toList()[4]!);
        DateTime datefin = DateTime.parse(row.assoc().values.toList()[5]!);
        info = Info(
            titre: titre,
            contenue: contenue,
            fac: fac,
            image: decoded,
            datedebut: datedebut,
            datefin: datefin);
      }
      if (info != null) {
        setState(() {
          infoList.add(info!);
        });
        print("Nouvelle info");
        print(infoList);
        print(infoList.length);
      }
    } catch (e) {
      print(e);
    }
  }
}
