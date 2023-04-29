import 'package:an_app/Screens/User/autre/fetch_option_for_fac.dart';

import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ex_fetch_option_for_fac.dart';

class ExFetchFieldForFac extends StatefulWidget {
  Universite univ;
  ExFetchFieldForFac(this.univ, {super.key});

  @override
  State<ExFetchFieldForFac> createState() => _FetchAnUnivState();
}

class _FetchAnUnivState extends State<ExFetchFieldForFac> {
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
              return ExFetchOptionForFac(widget.univ);
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
    return await provider.fetchFiliereForUniv(widget.univ.name);
  }
}
