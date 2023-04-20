import 'package:an_app/Screens/User/field_page.dart';
import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class UnivList extends StatefulWidget {
  const UnivList({super.key});

  @override
  State<UnivList> createState() => _FieldListState();
}

class _FieldListState extends State<UnivList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Sqflite>(builder: (_, db, __) {
      var univList = db.fetchAllUniv;
      print("nb filiere");
      print(univList.length);
      return Scaffold(
        appBar: AppBar(),
        body: Container(
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
                    itemCount: univList.length,
                    itemBuilder: (BuildContext context, i) {
                      return InkWell(
                        // onTap: () {
                        //   Navigator.push(context,
                        //       MaterialPageRoute(builder: (BuildContext context) {
                        //     return FieldPage(field: univList[i]);
                        //   }));
                        // },
                        child: Card(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width /
                                              1.6,
                                      width: MediaQuery.of(context).size.width /
                                          1.03,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(
                                          univList[i].logo,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: CustomText(
                                  univList[i].name,
                                  factor: 1.5,
                                ),
                              )
                            ],
                          ),
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
//  Row(
//            //crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//        Container(
//        decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15)),
//         margin: const EdgeInsets.only(left: 10),
//         child: Column(
//                children: [
//              const SizedBox(
//               height: 10,
//                                   ),
//   Container(
//        height: 150,
//       width: 110,
//     child: ClipRRect(
// borderRadius: BorderRadius.circular(10),
//  child: Image.memory(
//     univList[i].logo,
//         fit: BoxFit.cover,
//               ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 15,
//                             ),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(
//                                     height: 35,
//                                   ),
//                                   CustomText(
//                                     univList[i].name,
//                                     fontStyle: FontStyle.normal,
//                                     factor: 1.5,
//                                     weiht: FontWeight.bold,
//                                     textAlign: TextAlign.start,
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   CustomText(
//                                     " Contact",
//                                     textAlign: TextAlign.start,
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   CustomText(
//                                     univList[i].mail,
//                                     textAlign: TextAlign.start,
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.only(right: 15),
//                               child: Column(
//                                 children: [
//                                   const SizedBox(
//                                     height: 40,
//                                   ),
//                                   IconButton(
//                                       focusColor: Colors.red,
//                                       onPressed: () {
//                                         // Navigator.push(context, MaterialPageRoute(
//                                         //     builder: (BuildContext context) {
//                                         //   return FieldPage(field: fieldList[i]);
//                                         // }));
//                                       },
//                                       icon: const Icon(
//                                         Icons.chevron_right,
//                                         size: 60,
//                                       )),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),