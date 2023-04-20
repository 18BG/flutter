import 'package:an_app/Screens/User/field_list.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FetchFiliere extends StatefulWidget {
  const FetchFiliere({super.key});

  @override
  State<FetchFiliere> createState() => _FetchFiliereState();
}

class _FetchFiliereState extends State<FetchFiliere> {
  late Future _fieldList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fieldList = _getField();
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
            return const FielAlldList();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  Future _getField() async {
    final provider = Provider.of<Sqflite>(context, listen: false);
    return provider.fetchtAllFiliere();
  }
}
