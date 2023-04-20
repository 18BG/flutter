import 'package:an_app/Screens/User/ancien/fetchAnfield.dart';
import 'package:an_app/Screens/User/autre/universiteList.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/iniversities model/class_filiere.dart';
import '../univ_page.dart';

class FetchAllUniv extends StatefulWidget {
  FetchAllUniv({super.key});

  @override
  State<FetchAllUniv> createState() => _FetchAllUnivState();
}

class _FetchAllUnivState extends State<FetchAllUniv> {
  late Future _univList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _univList = _getAllFac();
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
              return const UnivList();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future _getAllFac() async {
    final provider = Provider.of<Sqflite>(context, listen: false);
    return await provider.fetchAllFac();
  }
}
