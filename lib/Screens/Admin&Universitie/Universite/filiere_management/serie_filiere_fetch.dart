import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_management/filiere_page.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/iniversities model/class_filiere.dart';
import '../../../../model/iniversities model/class_option.dart';
import 'option_list.dart';

class SerieFiliereFetcher extends StatefulWidget {
  final Filiere filiere;

  SerieFiliereFetcher(
    this.filiere, {
    super.key,
  });

  @override
  State<SerieFiliereFetcher> createState() => _SerieFiliereFetcherState();
}

class _SerieFiliereFetcherState extends State<SerieFiliereFetcher> {
  late Future _serifList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _serifList = _getSerieFiliere();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _serifList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return FilierePage(filiere: widget.filiere);
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future _getSerieFiliere() async {
    final provider = Provider.of<Sqflite>(context, listen: false);
    return provider.fetchSerieFiliere(widget.filiere.nomfiliere);
  }
}
