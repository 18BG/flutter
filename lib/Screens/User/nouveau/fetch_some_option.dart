import 'package:an_app/Screens/User/nouveau/fetch_some_fields.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class FetchSerieFiliere extends StatefulWidget {
  String name;
  FetchSerieFiliere(this.name, {super.key});

  @override
  State<FetchSerieFiliere> createState() => _FetchSerieFiliereState();
}

class _FetchSerieFiliereState extends State<FetchSerieFiliere> {
  late Future _someOptionList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _someOptionList = _getSomeOptions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _someOptionList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Container();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  Future _getSomeOptions() async {
    final provider = Provider.of<Sqflite>(context, listen: false);

    return provider.fetchFiliereForSerie(widget.name);
  }
}
