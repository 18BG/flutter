import 'package:an_app/Screens/User/ancien/fetchAlloption.dart';
import 'package:an_app/Screens/User/autre/page_univ.dart';
import 'package:an_app/Screens/User/explorer/explorer.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/iniversities model/class_filiere.dart';
import '../univ_page.dart';

class FetchAllField2 extends StatefulWidget {
  FetchAllField2({super.key});

  @override
  State<FetchAllField2> createState() => _FetchAllField2State();
}

class _FetchAllField2State extends State<FetchAllField2> {
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
              return Explorer();
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
    return await provider.fetchtAllFiliere();
  }
}
