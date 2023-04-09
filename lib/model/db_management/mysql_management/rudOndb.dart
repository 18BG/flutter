// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

import 'mysql_conn.dart';

class RUD with ChangeNotifier {
  var _queryResult;
  get queryResult => _queryResult;
  Mysql base = Mysql();
  Future<IResultSet?> query(String sql, [Map<String, dynamic>? params]) async {
    try {
      var conn = await base.ConnectToDb();
      var results = await conn.execute(sql, params);

      for (var i in results.rows) {
        print(i.assoc().values.toList()[0]);
      }
      _queryResult = results;
      notifyListeners();
      return _queryResult;
    } catch (e) {
      print("Erreur......$e");
      notifyListeners();
      return null;
    }
  }

  Future<void> insertQuery(
      ScaffoldMessengerState scaffoldMessengerState, String sql,
      [Map<String, dynamic>? params]) async {
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    try {
      var conn = await base.ConnectToDb();
      var results = await conn.execute(sql, params);

      print("iiiiiiiinnnnnssserted");
      notifyListeners();
    } catch (e) {
      print("Erreur......$e");
      notifyListeners();
    }
  }

  Future<void> updateQuery(
      ScaffoldMessengerState scaffoldMessengerState, String sql,
      [Map<String, dynamic>? params]) async {
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    try {
      var conn = await base.ConnectToDb();
      await conn.execute(sql, params);

      print("iiiiiiiinnnnnssserted");
      notifyListeners();
    } catch (e) {
      print("Erreur......$e");
      notifyListeners();
    }
  }
}
