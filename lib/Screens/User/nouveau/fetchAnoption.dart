import 'package:an_app/Screens/User/ancien/fetchAlloption.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/iniversities model/class_filiere.dart';
import '../univ_page.dart';

class FetchAnOption extends StatefulWidget {
  final String name;
  final Filiere filiere;
  FetchAnOption(this.name, {super.key, required this.filiere});

  @override
  State<FetchAnOption> createState() => _FetchAnUnivState();
}

class _FetchAnUnivState extends State<FetchAnOption> {
  late Future _optList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _optList = _getOption();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _optList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return FetchAllOption(widget.name, filiere: widget.filiere);
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future _getOption() async {
    final provider = Provider.of<Sqflite>(context, listen: false);
    return await provider.fetchAnOption(widget.name, widget.filiere.option);
  }
}
