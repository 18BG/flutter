import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/db_management/sqflite_management/fetch_uni_info.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../model/db_management/sqflite_management/sqflite_conn.dart';

class UnivPage extends StatefulWidget {
  String name;
  Filiere filiere;
  UnivPage({super.key, required this.name, required this.filiere});

  @override
  State<UnivPage> createState() => _UnivPageState();
}

class _UnivPageState extends State<UnivPage> {
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
      var fac = db.fetchAnUniv;
      var fili = db.AnFiliereForFac;
      var opt = db.AnOption;
      var allOpt = db.optionFetcher;
      Future.delayed(const Duration(seconds: 2));
      print("la fac recupere est de longueur : ${fac.length}");
      print("la filiere recupere est de longueur : ${fili.length}");
      print("l'option recupere est de longueur : ${opt.length}");
      print("les options recupere est de longueur : ${allOpt.length}");
      return Scaffold(
        backgroundColor: const Color.fromRGBO(17, 117, 177, 1),
        appBar: AppBar(
          title: Text(fac[0].name),
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
                                  fac[0].logo,
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
                    "La filière ${widget.filiere.nomfiliere} est enseigné ici",
                    weiht: FontWeight.bold,
                    factor: 1.7,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 3),
                  child: CustomText(
                    "Commentaire faite sur la filière ${widget.filiere.nomfiliere} par ${fac[0].name}",
                    fontStyle: FontStyle.normal,
                    textAlign: TextAlign.justify,
                    factor: 1.4,
                    weiht: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CustomText(
                    fili[0].commentaire,
                    fontStyle: FontStyle.normal,
                    factor: 1.2,
                    weiht: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 3),
                  child: CustomText(
                    "L'option à laquelle appartient la filière ${fili[0].nomfiliere}",
                    fontStyle: FontStyle.normal,
                    textAlign: TextAlign.justify,
                    factor: 1.4,
                    weiht: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CustomText(
                    "La filière ${widget.filiere.nomfiliere} appartient à l'option ${opt[0].nom} .",
                    fontStyle: FontStyle.normal,
                    factor: 1.2,
                    weiht: FontWeight.w400,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: CustomText(
                    " ${opt[0].commentaire} .",
                    fontStyle: FontStyle.normal,
                    factor: 1.2,
                    weiht: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 3),
                    child: (allOpt.length >= 2)
                        ? CustomText(
                            "D'autres options",
                            fontStyle: FontStyle.normal,
                            textAlign: TextAlign.justify,
                            factor: 1.4,
                            weiht: FontWeight.w500,
                          )
                        : const Text("")),
                const SizedBox(
                  height: 5,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: allOpt.length,
                    itemBuilder: (BuildContext context, i) {
                      return (allOpt[i].nom != opt[0].nom)
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: CustomText(
                                allOpt[i].nom,
                                fontStyle: FontStyle.normal,
                                factor: 1.2,
                                color: Colors.yellow,
                                weiht: FontWeight.w400,
                                textAlign: TextAlign.justify,
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                            );
                    }),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 3),
                  child: CustomText(
                    "Pour avoir plus d'informations sur notre structure d'enseignememt, rendez-vous dans l'explorateur et cherchez ${fac[0].name}",
                    fontStyle: FontStyle.normal,
                    textAlign: TextAlign.justify,
                    factor: 1.4,
                    color: Colors.black,
                    weiht: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
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
    Sqflite().fetchOption(widget.name).then((value) {
      setState(() {
        optionList = value;
      });
    });
  }
}
