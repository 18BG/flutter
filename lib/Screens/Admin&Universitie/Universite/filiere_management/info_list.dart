import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_management/info_page.dart';
import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InfoList extends StatefulWidget {
  const InfoList({super.key});

  @override
  State<InfoList> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<InfoList> {
  //final DateFormat dateFormat = DateFormat.yMMMMd('fr_FR');

  bool isDeleting = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<Sqflite>(builder: (_, db, __) {
      var info = db.infoFetcher;
      print("Information");
      print(info.length);
      return (isDeleting)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: info.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onLongPress: () {},
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return InfoPage(info: info[index]);
                    }));
                  },
                  isThreeLine: true,
                  leading: Container(
                      height: 80,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.memory(
                            info[index].image,
                            fit: BoxFit.cover,
                          ))),
                  trailing: IconButton(
                      onPressed: () {}, icon: Icon(Icons.chevron_right)),
                  subtitle: Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          const Text("Date debut"),
                          Text(DateFormat('MM/dd/yyyy')
                              .format(info[index].datedebut))
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Text("Date fin"),
                          Text(DateFormat('MM/dd/yyyy')
                              .format(info[index].datefin))
                        ],
                      ))
                    ],
                  ),
                  title: CustomText(
                    info[index].titre,
                    textAlign: TextAlign.start,
                    fontStyle: FontStyle.normal,
                  ),
                );
              },
            );
    });
  }
}
