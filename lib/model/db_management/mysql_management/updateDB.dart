import 'package:mysql_client/mysql_client.dart';

import 'mysql_conn.dart';

class UpdateDB {
  Future<IResultSet?> updateProfil(String sql,
      [Map<String, dynamic>? params]) async {
    var base = Mysql();
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    try {
      var conn = await base.ConnectToDb();
      var results = await conn.execute(sql, params);
      for (var i in results.rows) {
        print(i.assoc().values.toList()[0]);
      }
      return results;
    } catch (e) {
      print("Erreur......$e");
      return null;
    }
  }
}
