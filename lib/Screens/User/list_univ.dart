import 'package:an_app/Screens/User/ancien/fetchAnUniv.dart';

import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:flutter/material.dart';

import '../../model/db_management/sqflite_management/sqflite_conn.dart';

class ListUniv extends StatefulWidget {
  Filiere filiere;
  String name;
  ListUniv({super.key, required this.name, required this.filiere});

  @override
  State<ListUniv> createState() => _ListUnivState();
}

class _ListUnivState extends State<ListUniv> {
  List<Filiere> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFac();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          centerTitle: true,
        ),
        body: (list.isEmpty)
            ? const Center(
                child: Text("No data"),
              )
            : Container(
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
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, i) {
                      return Card(
                        color: Colors.blueGrey,
                        child: ListTile(
                          title: Text(list[i].facName),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.chevron_right)),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return FetchAnUniv(
                                list[i].facName,
                                filiere: list[i],
                              );
                            }));
                          },
                        ),
                      );
                    }),
              ));
  }

  void _getFac() async {
    Sqflite().fetchFiliereForFac(widget.name).then((value) {
      setState(() {
        list = value;
      });
    });
  }
}
