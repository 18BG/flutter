import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sqflite with ChangeNotifier {
  List<Option> _option = [];
  List<Option> get option => _option;
  //getter pour les options
  List<Option> _optionFetcher = [];
  List<Option> get optionFetcher => _optionFetcher;
  //getter pour les filieres
  List<Filiere> _filiereFetcher = [];
  List<Filiere> get filiereFetcher => _filiereFetcher;
  Database? _database;

  Future<Database> get database async {
    final dbDirectory = await getDatabasesPath();

    const dbName = 'faculte.db';
    final path = join(dbDirectory, dbName);

    _database = await openDatabase(path, version: 1, onCreate: _createDb);

    return _database!;
  }

  static const oTable = 'OptionTable';
  static const fTable = 'filiere';
  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute(
          '''CREATE TABLE $oTable(nom TEXT, logo BLOB,commentaire TEXT,fac TEXT)''');
      await txn.execute(
          '''CREATE TABLE $fTable(nomfiliere TEXT ,commentaire TEXT not null,logo BLOB,facName TEXT,opt TEXT,
primary key(nomfiliere,facName,opt), foreign key(facName) references faculte(name),foreign key(opt) references Opt(nom))''');
    });
  }

//FONCTION POUR RECUPERE LES OPTIONS DE SQFLITE
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

  //FONCTION POUR RECUPERE LES FILIERES DE SQFLITE
  Future<List<Filiere>> fetchFiliere(String fac, String option) async {
    print("fetching filiere ...");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(fTable,
          where: 'facName=? and opt = ?',
          whereArgs: [fac, option]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Filiere> fList = List.generate(
            convert.length, (index) => Filiere.fromString(convert[index]));
        _filiereFetcher = fList;
        print(fList.length);
        print("Filiere fetched successfully");
        return _filiereFetcher;
      });
    });
  }

//Fonction d'ajout de d'option
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

  //FONCTIOND'AJOUT DE FILIERE DANS SQFLITE
  Future<void> addFiliere(Filiere fli) async {
    print("adding filiere...");
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .insert(fTable, fli.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace)
          .then((value) {
        print("Inserted successfully");
        final file = Filiere(
            nomfiliere: fli.nomfiliere,
            commentaire: fli.commentaire,
            logo: fli.logo,
            facName: fli.facName,
            option: fli.option);
        print("Saved in phone storagr");
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

//supprimer toutes les fileres
  Future<void> deleteAllFiliere(String fac, String opt) async {
    final mydb = await database;
    await mydb
        .delete(fTable, where: 'facName=? and opt =?', whereArgs: [fac, opt]);
    print("deleted succesfully");
  }

  Future<void> deleteAnOption(Option opt) async {
    final db = await database;
    await db.delete(oTable,
        where: 'fac = ? and nom = ?', whereArgs: [opt.fac, opt.nom]);
    print("Suppression termine");
    notifyListeners();
  }
}
