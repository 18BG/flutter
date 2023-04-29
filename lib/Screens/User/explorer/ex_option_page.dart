import 'package:an_app/Screens/User/autre/fetchfieldforoption.dart';
import 'package:an_app/Screens/User/autre/field_page2.dart';
import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/db_management/sqflite_management/fetch_uni_info.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../model/db_management/sqflite_management/sqflite_conn.dart';

class ExOptionPage extends StatefulWidget {
  Option opt;
  ExOptionPage(this.opt, {super.key});

  @override
  State<ExOptionPage> createState() => _UnivPageState();
}

class _UnivPageState extends State<ExOptionPage> {
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
      var fac = db.fetchFacForOption;
      var filiere = db.FiliereForopt;
      var fili = db.filiereFetcher;

      Future.delayed(const Duration(seconds: 2));

      print(
          "la filiere recupere est de longueur dans optiopage: ${fili.length}");

      return Scaffold(
        backgroundColor: const Color.fromRGBO(17, 117, 177, 1),
        appBar: AppBar(
          title: Text(widget.opt.nom),
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
                                          widget.opt.logo,
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
                                  widget.opt.nom,
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
                    widget.opt.commentaire,
                    factor: 1.2,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: CustomText(
                    "Les universités qui fournissent des formations pour cette option ",
                    weiht: FontWeight.bold,
                    factor: 1.5,
                  ),
                ),
                (fac.isEmpty)
                    ? const Center(
                        child: Text("Aucune"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: fac.length,
                        itemBuilder: (BuildContext context, i) {
                          return ListTile(
                            title: Text(fac[i].name),
                          );
                        }),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: CustomText(
                    "Les filières que composent cette l'option ",
                    weiht: FontWeight.bold,
                    factor: 1.5,
                  ),
                ),
                (filiere.isEmpty)
                    ? Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Center(
                          child: Text("Aucune"),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filiere.length,
                        itemBuilder: (BuildContext context, i) {
                          return ListTile(
                            title: Text(filiere[i].nomfiliere),
                          );
                        }),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: NeverScrollableScrollPhysics()),
                    shrinkWrap: true,
                    itemCount: fili.length,
                    itemBuilder: (BuildContext context, i) {
                      return InkWell(
                        onTap: () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              margin: const EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 150,
                                    width: 110,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        fili[i].logo,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  CustomText(
                                    fili[i].nomfiliere,
                                    fontStyle: FontStyle.normal,
                                    factor: 1.5,
                                    weiht: FontWeight.bold,
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    fili[i].commentaire,
                                    textAlign: TextAlign.start,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 15),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  IconButton(
                                      focusColor: Colors.red,
                                      onPressed: () {
                                        // Navigator.push(context, MaterialPageRoute(
                                        //     builder: (BuildContext context) {
                                        //   return FieldPage(field: fieldList[i]);
                                        // }));
                                      },
                                      icon: const Icon(
                                        Icons.chevron_right,
                                        size: 60,
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    })
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
