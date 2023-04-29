import 'package:an_app/Screens/User/explorer/ex_fetch_fac_for_field.dart';
import 'package:an_app/Screens/User/explorer/ex_fetch_fac_for_option.dart';
import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ex_fetch_field_for_fac.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Sqflite>(builder: (_, db, __) {
      var univ = db.fetchAllUniv;
      var field = db.fetchAllfield;
      var option = db.alloption;
      print("univ ${univ.length}");
      print("option ${option.length}");
      print("filiere ${field.length}");
      return Scaffold(
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Explorer",
                      fontStyle: FontStyle.normal,
                      weiht: FontWeight.bold,
                      factor: 2.0,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomText(
                      "Qu'est ce que vous cherchez ?",
                      fontStyle: FontStyle.normal,
                      factor: 1.2,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: Stack(children: [
                  TextField(
                    decoration: InputDecoration(
                        fillColor: Colors.grey,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(5)),
                        prefixIcon: const Icon(
                          Icons.search_outlined,
                          size: 30,
                          color: Colors.black,
                        )),
                  ),
                  Positioned(
                      right: 2,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),
                        child: const Icon(
                          Icons.mic_outlined,
                          size: 25,
                        ),
                      ))
                ]),
              ),
              Container(
                height: 800,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(73, 182, 172, 1),
                      Color.fromRGBO(17, 117, 177, 1),
                    ]),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      "Université",
                      weiht: FontWeight.bold,
                      factor: 1.6,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                    ),
                    Container(
                      height: 190,
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) => InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ExFetchFieldForFac(univ[index]);
                                  }));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        height: 150,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.memory(
                                            univ[index].logo,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomText(
                                      univ[index].name,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                    )
                                  ],
                                ),
                              )),
                          separatorBuilder: ((context, index) => const SizedBox(
                                width: 10,
                              )),
                          itemCount: univ.length),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomText(
                      "Options",
                      weiht: FontWeight.bold,
                      factor: 1.6,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                    ),
                    Container(
                      height: 150,
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) => InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ExFetchFacForOpt(opt: option[index]);
                                  }));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 5, 0),
                                        height: 100,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.memory(
                                            option[index].logo,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomText(
                                      option[index].nom,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    CustomText(
                                      option[index].fac,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                    )
                                  ],
                                ),
                              )),
                          separatorBuilder: ((context, index) => const SizedBox(
                                width: 10,
                              )),
                          itemCount: option.length),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomText(
                      "Filière",
                      weiht: FontWeight.bold,
                      factor: 1.6,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                    ),
                    Container(
                      height: 150,
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) => InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ExFetchFacForField(
                                        filiere: field[index]);
                                  }));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 5, 0),
                                        height: 100,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.memory(
                                            field[index].logo,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomText(
                                      field[index].nomfiliere,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    CustomText(
                                      field[index].facName,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                    )
                                  ],
                                ),
                              )),
                          separatorBuilder: ((context, index) => const SizedBox(
                                width: 10,
                              )),
                          itemCount: field.length),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomText(
                      "Informations",
                      weiht: FontWeight.bold,
                      factor: 1.6,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                    ),
                    Container(
                      height: 140,
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      height: 100,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.memory(
                                          field[index].logo,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomText(
                                    field[index].nomfiliere,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                  )
                                ],
                              )),
                          separatorBuilder: ((context, index) => const SizedBox(
                                width: 10,
                              )),
                          itemCount: field.length),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      );
    });
  }
}
