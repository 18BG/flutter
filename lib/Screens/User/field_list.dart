import 'package:an_app/Screens/User/field_page.dart';
import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class FielAlldList extends StatefulWidget {
  const FielAlldList({super.key});

  @override
  State<FielAlldList> createState() => _FieldListState();
}

class _FieldListState extends State<FielAlldList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Sqflite>(builder: (_, db, __) {
      var fieldList = db.fetchAllfield;
      print("nb filiere");
      print(fieldList.length);
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(194, 138, 187, 1),
              Color.fromRGBO(101, 153, 145, 1),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Card(
                child: Text(
                  "Liste des filières",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Vous pouvez cliquer sur une filière pour plus d'informationts",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: NeverScrollableScrollPhysics()),
                  shrinkWrap: true,
                  itemCount: fieldList.length,
                  itemBuilder: (BuildContext context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return FieldPage(field: fieldList[i]);
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
                                      fieldList[i].logo,
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
                                  fieldList[i].nomfiliere,
                                  fontStyle: FontStyle.normal,
                                  factor: 1.5,
                                  weiht: FontWeight.bold,
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomText(
                                  fieldList[i].commentaire,
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
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return FieldPage(field: fieldList[i]);
                                      }));
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
      );
    });
  }
}
// Container(
//                       height: 80.0,
//                       child: Card(
//                         color: const Color.fromRGBO(17, 117, 140, 1),
//                         child: Center(
//                           child: ListTile(
//                             leading: Card(
//                               elevation: 0,
//                               color: const Color.fromRGBO(17, 117, 140, 1),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15)),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     color:
//                                         const Color.fromRGBO(17, 117, 140, 1),
//                                     borderRadius: BorderRadius.circular(15)),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(5),
//                                   child: Image.memory(
//                                     fieldList[i].logo,
//                                     fit: BoxFit.cover,
//                                     width: 50,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             onTap: () {
//                               Navigator.push(context, MaterialPageRoute(
//                                   builder: (BuildContext context) {
//                                 return FieldPage(field: fieldList[i]);
//                               }));
//                             },
//                             title: Text(
//                               fieldList[i].nomfiliere,
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             trailing: IconButton(
//                                 onPressed: () {},
//                                 icon: const Icon(Icons.forward)),
//                           ),
//                         ),
//                       ),
//                     );