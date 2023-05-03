// ignore_for_file: non_constant_identifier_names

import 'package:mysql_client/mysql_client.dart';

class Mysql {
  static String host = '10.0.2.2', user = 'system', pwd = "Bg7012088";
  static int port = 3306;
  Future<MySQLConnection> ConnectToDb() async {
    //print("Connection initiated ....");

    final conn = await MySQLConnection.createConnection(
        host: host,
        port: port,
        userName: user,
        password: pwd,
        databaseName: "GE");
    await conn.connect();
    print("DB connected");
    return conn;
  }

  // Future<void> closeDB() async {
  //   await ConnectToDb().then((value) => {value.close()});
  // }
}
