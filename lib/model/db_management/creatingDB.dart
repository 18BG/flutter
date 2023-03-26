import 'package:an_app/model/admin_model/class_admin.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

import '../mysql_conn.dart';

class CreateOrUseDB {
  Future<void> insertInDbForAdmin(
      Admin admin, ScaffoldMessengerState scaffoldMessengerState) async {
    var base = Mysql();
    try {
      var conn = await base.ConnectToDb();
      await conn.execute(
          "INSERT INTO administrateur (username,nom,prenom,mail,passwor) values (:username,:nom,:prenom,:mail,:passwor)",
          {
            "username": admin.username,
            "nom": admin.nom,
            "prenom": admin.prenom,
            "mail": admin.mail,
            "passwor": admin.password
          });
    } catch (e) {
      print("Erreur lors de l'insertion dans la base de données : $e");
      if (e.toString().contains("Duplicate entry")) {
        scaffoldMessengerState.showSnackBar(
          const SnackBar(
            content: Text(
                "Le nom d'utilisateur doit être unique, veuillez choisir un autre nom d'utilisateur."),
          ),
        );
      }
    }
  }

  Future<void> insertInDbForFaculty(Universite univerisite,
      ScaffoldMessengerState scaffoldMessengerState) async {
    var base = Mysql();
    try {
      var conn = await base.ConnectToDb();
      await conn.execute(
          "INSERT INTO faculte (name,mail,password,logo) values (:name,:mail,:password,:logo)",
          {
            "name": univerisite.name,
            "mail": univerisite.mail,
            "password": univerisite.password,
            "logo": univerisite.logo
          });
    } catch (e) {
      print("Erreur lors de l'insertion dans la base de données : $e");
      if (e.toString().contains("Duplicate entry")) {
        scaffoldMessengerState.showSnackBar(
          const SnackBar(
            content: Text(
                "Le nom  doit être unique, veuillez choisir un autre nom."),
          ),
        );
      }
    }
  }
}
