import 'package:an_app/Screens/User/nouveau/fetch_fields_info.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:an_app/model/iniversities%20model/serie_model.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../Widgets/custom.dart';
import '../field_page.dart';

class FetchSomefield extends StatefulWidget {
  Serie serie;
  FetchSomefield(this.serie, {super.key});

  @override
  State<FetchSomefield> createState() => _FieldListState();
}

class _FieldListState extends State<FetchSomefield> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Sqflite>(builder: (_, db, __) {
      var fieldList = db.filiereforSeriFetcher;
      var list = db.myResultList;
      print("nb filiere");
      print(list.length);
      return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 30),
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
                Card(
                  child: CustomText(
                    "Liste des filières possible pour ${widget.serie.nomSerie} - ${widget.serie.acronyme}",
                    weiht: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    factor: 1.5,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(
                  "Vous pouvez cliquer sur une filière pour plus d'informationts",
                  factor: 1.3,
                  weiht: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: NeverScrollableScrollPhysics()),
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, i) {
                      return InkWell(
                        onTap: () {
                          Filiere filiere = Filiere(
                              nomfiliere: list[i].nomFiliere,
                              commentaire: list[i].commentaire,
                              logo: list[i].logo,
                              facName: list[i].facName,
                              option: list[i].opt);
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return FieldPage(field: filiere);
                          }));
                        },
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
                                        list[i].logo,
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
                                    list[i].nomFiliere,
                                    fontStyle: FontStyle.normal,
                                    factor: 1.5,
                                    weiht: FontWeight.bold,
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    list[i].facName,
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
                    }),
              ],
            ),
          ),
        ),
      );
    });
  }
}


// decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color.fromRGBO(17, 117, 177, 1),
//                 Color.fromRGBO(73, 182, 172, 1),
//               ],
//             ),
//           ),
