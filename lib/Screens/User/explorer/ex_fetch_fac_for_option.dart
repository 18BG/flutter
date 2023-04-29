import 'package:an_app/Screens/User/ancien/fetchAnfield.dart';
import 'package:an_app/Screens/User/autre/universiteList.dart';
import 'package:an_app/Screens/User/explorer/ex_fetch_field_for_option.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/class_option.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/iniversities model/class_filiere.dart';
import '../univ_page.dart';

class ExFetchFacForOpt extends StatefulWidget {
  Option opt;
  ExFetchFacForOpt({super.key, required this.opt});

  @override
  State<ExFetchFacForOpt> createState() => _FetchAllUnivState();
}

class _FetchAllUnivState extends State<ExFetchFacForOpt> {
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
              return ExFetchFieldForOpt(widget.opt);
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
    return await provider.fetchFacForoptions(widget.opt.fac);
  }
}
