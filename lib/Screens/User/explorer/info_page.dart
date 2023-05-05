import 'package:an_app/Widgets/custom.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';

import 'package:an_app/model/iniversities%20model/class_option.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../model/db_management/sqflite_management/sqflite_conn.dart';
import '../../../model/iniversities model/info_model.dart';

class InfoAPage extends StatefulWidget {
  Info info;
  InfoAPage(this.info, {super.key});

  @override
  State<InfoAPage> createState() => _UnivPageState();
}

class _UnivPageState extends State<InfoAPage> {
  List<Option> optionList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 117, 177, 1),
      appBar: AppBar(
        title: Text(widget.info.titre),
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
                        height: MediaQuery.of(context).size.height * 0.42,
                        margin: const EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Container(
                              child: Card(
                                color: Colors.white,
                                elevation: 0,
                                child: Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.memory(
                                        widget.info.image,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                1.4,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: CustomText(
                                widget.info.titre,
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
                  widget.info.contenue,
                  weiht: FontWeight.bold,
                  factor: 1.5,
                  fontStyle: FontStyle.normal,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [],
              )
            ],
          ),
        ),
      ),
    );
  }
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
