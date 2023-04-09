import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sqflite with ChangeNotifier {
  List<Option> _option = [];
  List<Option> get option => _option;
  List<Option> _optionFetcher = [];
  List<Option> get optionFetcher => _optionFetcher;
  Database? _database;

  Future<Database> get database async {
    final dbDirectory = await getDatabasesPath();

    const dbName = 'faculte.db';
    final path = join(dbDirectory, dbName);

    _database = await openDatabase(path, version: 1, onCreate: _createDb);

    return _database!;
  }

  static const oTable = 'OptionTable';
  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute(
          '''CREATE TABLE $oTable(nom TEXT, logo BLOB,commentaire TEXT,fac TEXT)''');
    });
  }

  Future<List<Option>> fetchOption(String fac) async {
    print("Fetching.....");
    final db = await database;
    return db.transaction((txn) async {
      return await txn
          .query(oTable, where: 'fac=?', whereArgs: [fac]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Option> nList = List.generate(
            convert.length, (index) => Option.deString(convert[index]));
        _optionFetcher = nList;
        print("Fecthing finish");
        return _optionFetcher;
      });
    });
  }

  Future<void> addOption(Option opt) async {
    print("Sqflite.....");
    final db = await database;
    print("Database created");
    await db.transaction((txn) async {
      await txn
          .insert(oTable, opt.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace)
          .then((value) {
        print("Insertion termine");
        final file = Option(
            nom: opt.nom,
            logo: opt.logo,
            commentaire: opt.commentaire,
            fac: opt.fac);
        _option.add(file);
        print("Sauvegarder en locale");
      });
    });
  }

  //mise a jour des options
  Future<void> updateOption(String name, Option opt) async {
    final db = await database;
    try {
      await db.update(oTable, opt.toMap(),
          where: 'nom = ? and fac = ?', whereArgs: [name, opt.fac]);
      print("MAJ faite");
    } catch (e) {
      print("Erreur lors de mise jour $e");
    }
    print("MAJ faite");
  }

//Supprimer toutes les options d'une faculté
  Future<void> deleteAllOption(Universite fac) async {
    final db = await database;
    await db.delete(oTable, where: 'fac = ?', whereArgs: [fac.name]);
    print("Suppression termine");
  }

  Future<void> deleteAnOption(Option opt) async {
    final db = await database;
    await db.delete(oTable,
        where: 'fac = ? and nom = ?', whereArgs: [opt.fac, opt.nom]);
    print("Suppression termine");
    notifyListeners();
  }
}
