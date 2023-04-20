import 'package:an_app/Screens/User/nouveau/fetch_some_fields.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/serie_model.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class FetchSerieFiliere extends StatefulWidget {
  Serie serie;
  FetchSerieFiliere(this.serie, {super.key});

  @override
  State<FetchSerieFiliere> createState() => _FetchSerieFiliereState();
}

class _FetchSerieFiliereState extends State<FetchSerieFiliere> {
  late Future _fieldList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fieldList = _getSerieFieldJoined();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fieldList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return FetchSomefield(widget.serie);
          }
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  Future _getSerieFieldJoined() async {
    final provider = Provider.of<Sqflite>(context, listen: false);

    return provider.fetchFieldsfromSftableAndFtable(widget.serie.nomSerie);
  }
}
