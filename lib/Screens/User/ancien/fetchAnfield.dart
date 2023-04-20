import 'package:an_app/Screens/User/nouveau/fetchAnoption.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/iniversities model/class_filiere.dart';
import '../univ_page.dart';

class FetchAnField extends StatefulWidget {
  String name;
  Filiere filiere;
  FetchAnField(this.name, {super.key, required this.filiere});

  @override
  State<FetchAnField> createState() => _FetchAnUnivState();
}

class _FetchAnUnivState extends State<FetchAnField> {
  late Future _fieldList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fieldList = _getFiliere();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fieldList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return FetchAnOption(widget.name, filiere: widget.filiere);
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future _getFiliere() async {
    final provider = Provider.of<Sqflite>(context, listen: false);
    return await provider.fetchAnFiliereForFac(
        widget.name, widget.filiere.nomfiliere);
  }
}
