import 'package:an_app/Screens/Admin&Universitie/Universite/filiere_list.dart';
import 'package:an_app/Screens/User/autre/option_page.dart';
import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/iniversities model/class_option.dart';

class FiliereForOptionFetcher extends StatefulWidget {
  Option option;
  final Universite univ;
  FiliereForOptionFetcher(
    this.univ,
    this.option, {
    super.key,
  });

  @override
  State<FiliereForOptionFetcher> createState() => _FiliereFetcherState();
}

class _FiliereFetcherState extends State<FiliereForOptionFetcher> {
  late Future _filiereList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filiereList = _getOfiliereList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _filiereList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return OptionPage(univ: widget.univ, opt: widget.option);
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future _getOfiliereList() async {
    final provider = Provider.of<Sqflite>(context, listen: false);
    return provider.fetchFiliere(widget.option.fac, widget.option.nom);
  }
}
