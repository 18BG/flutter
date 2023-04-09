import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/iniversities model/class_option.dart';
import 'option_list.dart';

class OptionFetcher extends StatefulWidget {
  Universite fac;
  List<Option> optionList;
  OptionFetcher(
    this.fac, {
    super.key,
    required this.optionList,
  });

  @override
  State<OptionFetcher> createState() => _OptionFetcherState();
}

class _OptionFetcherState extends State<OptionFetcher> {
  late Future _optionList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _optionList = _getOptList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _optionList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const OptionList();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future _getOptList() async {
    final provider = Provider.of<Sqflite>(context, listen: false);
    return provider.fetchOption(widget.fac.name);
  }
}
