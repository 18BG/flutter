// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:an_app/model/iniversities%20model/classe_universite.dart';

import '../model/db_management/mysql_management/rudOndb.dart';

class Fonction {
  Future<void> getUniversiti(Universite faculte) async {
    print("ppppppppppppppppppppppppp");
    var result = await RUD().query(
        "Select name , password,mail,logo from faculte where name = :name and password = :password",
        {"name": faculte.name, "password": faculte.password});
    for (var row in result!.rows) {
      print("${row.assoc()['name']} , ${row.assoc()['mail']}");
      String nam = row.assoc().values.toList()[0]!;
      String pass = row.assoc().values.toList()[1]!;
      String maile = row.assoc().values.toList()[2]!;
      var imageprofil = row.assoc()['logo'] as String;
      final decoded = base64Decode(imageprofil);
      print(decoded);

      faculte.name = nam;
      faculte.mail = maile;
      faculte.password = pass;
      faculte.logo = decoded;
    }
    print(faculte.name);
    print("finnnnnnnnnnnnnnnnnnnn");
  }
}
