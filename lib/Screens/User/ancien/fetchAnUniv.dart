import 'package:an_app/Screens/User/ancien/fetchAnfield.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/iniversities model/class_filiere.dart';
import '../univ_page.dart';

class FetchAnUniv extends StatefulWidget {
  String name;
  Filiere? filiere;
  FetchAnUniv(this.name, {super.key, required this.filiere});

  @override
  State<FetchAnUniv> createState() => _FetchAnUnivState();
}

class _FetchAnUnivState extends State<FetchAnUniv> {
  late Future _univList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _univList = _getFac();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _univList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return FetchAnField(widget.name, filiere: widget.filiere!);
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future _getFac() async {
    final provider = Provider.of<Sqflite>(context, listen: false);
    return await provider.fetchAnFac(widget.name);
  }
}
