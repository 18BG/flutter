import 'package:an_app/Screens/User/autre/fetchfieldforoption.dart';
import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/db_management/sqflite_management/fetch_uni_info.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../model/db_management/sqflite_management/sqflite_conn.dart';

class PageUniv extends StatefulWidget {
  final Universite univ;
  PageUniv({super.key, required this.univ});

  @override
  State<PageUniv> createState() => _UnivPageState();
}

class _UnivPageState extends State<PageUniv> {
  List<Option> optionList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOption();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Sqflite>(builder: (_, db, __) {
      var fili = db.FiliereForUniv;
      var allOpt = db.optionFetcher;
      Future.delayed(const Duration(seconds: 2));
      print("les opt recupere est de longueur : ${allOpt.length}");
      print("la filiere recupere est de longueur : ${fili.length}");

      return Scaffold(
        backgroundColor: const Color.fromRGBO(17, 117, 177, 1),
        appBar: AppBar(
          title: Text(widget.univ.name),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(73, 182, 172, 1),
                  Color.fromRGBO(17, 117, 177, 1),
                ],
              ),
            ),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.memory(
                                  widget.univ.logo,
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height:
                                      MediaQuery.of(context).size.width / 1.1,
                                  fit: BoxFit.cover,
                                )),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: CustomText(
                    "Historique plusTard",
                    weiht: FontWeight.bold,
                    factor: 1.7,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 3),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Color.fromRGBO(21, 221, 201, 1),
                        Color.fromRGBO(4, 106, 170, 1),
                      ],
                    ),
                  ),
                  child: CustomText(
                    "Options",
                    fontStyle: FontStyle.normal,
                    textAlign: TextAlign.justify,
                    factor: 1.4,
                    weiht: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: NeverScrollableScrollPhysics()),
                    shrinkWrap: true,
                    itemCount: allOpt.length,
                    itemBuilder: (BuildContext context, i) {
                      List<Filiere> filiere = [];
                      for (var r in fili) {
                        if (r.option == allOpt[i].nom) {
                          filiere.add(r);
                        }
                      }
                      return ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return FiliereForOptionFetcher(
                                  widget.univ, allOpt[i]);
                            }));
                          },
                          title: Text(allOpt[i].nom),
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return filiere.map((e) {
                                print("object");
                                print(filiere.length);
                                return PopupMenuItem<Filiere>(
                                  value: e,
                                  child: Text(e.nomfiliere),
                                );
                              }).toList();
                            },
                            child: const Icon(Icons.arrow_drop_down),
                          ));
                    }),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 3),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Color.fromRGBO(15, 22, 27, 1),
                        Color.fromRGBO(73, 182, 172, 1),
                      ],
                    ),
                  ),
                  child: CustomText(
                    "Filière",
                    fontStyle: FontStyle.normal,
                    textAlign: TextAlign.justify,
                    factor: 1.4,
                    weiht: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: NeverScrollableScrollPhysics()),
                    shrinkWrap: true,
                    itemCount: fili.length,
                    itemBuilder: (BuildContext context, i) {
                      List<Filiere> filiere = [];

                      return ListTile(
                          title: Text(fili[i].nomfiliere),
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return filiere.map((e) {
                                print("object");
                                print(filiere.length);
                                return PopupMenuItem<Filiere>(
                                  value: e,
                                  child: Text(e.nomfiliere),
                                );
                              }).toList();
                            },
                            child: const Icon(Icons.arrow_drop_down),
                          ));
                    }),
              ],
            )),
          ),
        ),
      );
    });
  }

  // void _getFac() async {
  //   Sqflite().fetchFiliereForFac(widget.name).then((value) {
  //     setState(() {
  //       list = value;
  //     });
  //   });
  // }
  void _getOption() async {
    Sqflite().fetchOption(widget.univ.name).then((value) {
      setState(() {
        optionList = value;
      });
    });
  }
}
