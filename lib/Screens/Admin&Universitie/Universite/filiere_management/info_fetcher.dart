import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_management/info_list.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/iniversities model/class_option.dart';
import 'option_list.dart';

class InfoFetcher extends StatefulWidget {
  Universite fac;

  InfoFetcher(
    this.fac, {
    super.key,
  });

  @override
  State<InfoFetcher> createState() => _OptionFetcherState();
}

class _OptionFetcherState extends State<InfoFetcher> {
  late Future _infoList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _infoList = _getInfoList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _infoList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const InfoList();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future _getInfoList() async {
    final provider = Provider.of<Sqflite>(context, listen: false);
    return provider.fetchInfo(widget.fac.name);
  }
}
