// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

import 'mysql_conn.dart';

class RUD {
  var _queryResult;
  get queryResult => _queryResult;
  Mysql base = Mysql();
  Future<IResultSet?> query(String sql, [Map<String, dynamic>? params]) async {
    try {
      var conn = await base.ConnectToDb();
      var results = await conn.execute(sql, params);

      _queryResult = results;

      return _queryResult;
    } catch (e) {
      print("Erreur......$e");

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
    } catch (e) {
      print("Erreur nnn......$e");
    }
  }

  Future<void> updateQuery(
      ScaffoldMessengerState scaffoldMessengerState, String sql,
      [Map<String, dynamic>? params]) async {
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    try {
      var conn = await base.ConnectToDb();
      await conn.execute(sql, params);

      print("updaaaaaaaaaaaaaaaaaaaaaated");
    } catch (e) {
      print(e);
    }
  }
}
