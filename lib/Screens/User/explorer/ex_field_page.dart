import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';

import 'package:an_app/model/iniversities%20model/class_option.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../model/db_management/sqflite_management/sqflite_conn.dart';

class ExFieldPage extends StatefulWidget {
  Filiere filiere;
  ExFieldPage(this.filiere, {super.key});

  @override
  State<ExFieldPage> createState() => _UnivPageState();
}

class _UnivPageState extends State<ExFieldPage> {
  List<Option> optionList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getOption();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Sqflite>(builder: (_, db, __) {
      var fili = db.fetchFacForFiliere;

      Future.delayed(const Duration(seconds: 2));

      print(
          "la filiere recupere est de longueur dans optiopage: ${fili.length}");

      return Scaffold(
        backgroundColor: const Color.fromRGBO(17, 117, 177, 1),
        appBar: AppBar(
          title: Text("widget.opt.nom"),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Container(
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                          height: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Container(
                                child: Card(
                                  color: Colors.white,
                                  elevation: 20,
                                  child: Center(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.memory(
                                          widget.filiere.logo,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.4,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: CustomText(
                                  widget.filiere.nomfiliere,
                                  color: Colors.black,
                                  weiht: FontWeight.bold,
                                  factor: 1.4,
                                  fontStyle: FontStyle.normal,
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: CustomText(
                    widget.filiere.commentaire,
                    factor: 1.2,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: CustomText(
                    "Les universités qui fournissent des formations pour cette filière ",
                    weiht: FontWeight.bold,
                    factor: 1.5,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                (fili.isEmpty)
                    ? const Center(
                        child: Text("Aucune"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: fili.length,
                        itemBuilder: (BuildContext context, i) {
                          return ListTile(
                            title: Text(fili[i].name),
                          );
                        }),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
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
  // void _getOption() async {
  //   Sqflite().fetchOption(widget.univ.name).then((value) {
  //     setState(() {
  //       optionList = value;
  //     });
  //   });
  // }
}
