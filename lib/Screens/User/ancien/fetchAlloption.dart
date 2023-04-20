import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/iniversities model/class_filiere.dart';
import '../univ_page.dart';

class FetchAllOption extends StatefulWidget {
  final String name;
  final Filiere filiere;
  FetchAllOption(this.name, {super.key, required this.filiere});

  @override
  State<FetchAllOption> createState() => _FetchAnUnivState();
}

class _FetchAnUnivState extends State<FetchAllOption> {
  late Future _alloptList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _alloptList = _getAllOption();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _alloptList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return UnivPage(
                name: widget.name,
                filiere: widget.filiere,
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future _getAllOption() async {
    final provider = Provider.of<Sqflite>(context, listen: false);
    return await provider.fetchOption(widget.name);
  }
}
