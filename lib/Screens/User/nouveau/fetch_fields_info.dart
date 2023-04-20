import 'package:an_app/Screens/User/ancien/fetchAnUniv.dart';
import 'package:an_app/Screens/User/field_page.dart';
import 'package:an_app/Screens/User/nouveau/fetch_some_fields.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class FetchSpecifiedFieldsInfo extends StatefulWidget {
  String fieldsname;

  FetchSpecifiedFieldsInfo(this.fieldsname, {super.key});

  @override
  State<FetchSpecifiedFieldsInfo> createState() => _FetchSerieFiliereState();
}

class _FetchSerieFiliereState extends State<FetchSpecifiedFieldsInfo> {
  late Future _fieldList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFieldInfo();
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

  Future _getFieldInfo() async {
    final provider = Provider.of<Sqflite>(context, listen: false);

    return provider.fetchtSpecifiedFiliere(widget.fieldsname);
  }
}
