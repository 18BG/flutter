import 'package:an_app/Screens/User/explorer/ex_fetch_field_for_option.dart';
import 'package:an_app/Screens/User/explorer/ex_field_page.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:an_app/model/iniversities%20model/class_option.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExFetchFacForField extends StatefulWidget {
  Filiere filiere;
  ExFetchFacForField({super.key, required this.filiere});

  @override
  State<ExFetchFacForField> createState() => _FetchAllUnivState();
}

class _FetchAllUnivState extends State<ExFetchFacForField> {
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
              return ExFieldPage(widget.filiere);
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
    return await provider.fetchFacForField(widget.filiere.facName);
  }
}
