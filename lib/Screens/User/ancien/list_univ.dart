import 'package:an_app/Screens/User/field_page.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class FieldList extends StatefulWidget {
  const FieldList({super.key});

  @override
  State<FieldList> createState() => _FieldListState();
}

class _FieldListState extends State<FieldList> {
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
              Color.fromRGBO(17, 117, 177, 1),
              Color.fromRGBO(73, 182, 172, 1),
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
                    color: Colors.grey,
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
                    return Card(
                      color: const Color.fromRGBO(17, 117, 140, 1),
                      child: ListTile(
                        leading: SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.memory(fieldList[i].logo)),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return FieldPage(field: fieldList[i]);
                          }));
                        },
                        title: Text(
                          fieldList[i].nomfiliere,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.forward)),
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
