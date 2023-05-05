import 'dart:convert';

import 'package:an_app/model/db_management/mysql_management/rudOndb.dart';
import 'package:an_app/model/iniversities%20model/class_filiere.dart';
import 'package:an_app/model/iniversities%20model/class_option.dart';
import 'package:an_app/model/iniversities%20model/class_series_filiere.dart';
import 'package:an_app/model/iniversities%20model/classe_universite.dart';
import 'package:an_app/model/iniversities%20model/info_model.dart';
import 'package:an_app/model/iniversities%20model/joinModel.dart';
import 'package:an_app/model/iniversities%20model/serie_model.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../iniversities model/story_model.dart';

class Sqflite with ChangeNotifier {
  List<Universite> _fetchAnUniv = [];
  List<Universite> get fetchAnUniv => _fetchAnUniv;
  //Ajout

  List<Option> _option = [];
  List<Option> get option => _option;
  List<Filiere> _filiere = [];
  List<Filiere> get filiere => _filiere;
  List<Universite> _universite = [];
  List<Universite> get universite => _universite;
  List<SeriesFiliere> _serfil = [];
  List<SeriesFiliere> get serfil => _serfil;
//Fetching
  List<Option> _all_option = [];
  List<Option> get alloption => _all_option;
  List<Option> _AnOption = [];
  List<Option> get AnOption => _AnOption;
//serifiliere
  List<SeriesFiliere> _filiereforSeriFetcher = [];
  List<SeriesFiliere> get filiereforSeriFetcher => _filiereforSeriFetcher;
  List<SeriesFiliere> _serifiliereFetcher = [];
  List<SeriesFiliere> get serifiliereFetcher => _serifiliereFetcher;
  //getter pour les options
  List<Option> _optionFetcher = [];
  List<Option> get optionFetcher => _optionFetcher;
  //getter pour les info
  List<Info> _infoFetcher = [];
  List<Info> get infoFetcher => _infoFetcher;
  //getter pour les info
  List<Info> _infoallFetcher = [];
  List<Info> get infoallFetcher => _infoallFetcher;
  //getter pour les filieres
  //getter FiliereForFac
  List<Filiere> _AnFiliereForFac = [];
  List<Filiere> get AnFiliereForFac => _FiliereForFac;
  List<Filiere> _FiliereForUniv = [];
  List<Filiere> get FiliereForUniv => _FiliereForUniv;
  //filiere concernant une option
  List<Filiere> _FiliereForopt = [];
  List<Filiere> get FiliereForopt => _FiliereForopt;
  //k
  List<Filiere> _FiliereForFac = [];
  List<Filiere> get FiliereForFac => _FiliereForFac;
  List<Filiere> _filiereFetcher = [];
  List<Filiere> get filiereFetcher => _filiereFetcher;
  //recuperer toutes les filieres
  List<Filiere> _fetchAllfield = [];
  List<Filiere> get fetchAllfield => _fetchAllfield;
  //recuperer les filieres specifiées
  List<Filiere> _fetchSpeciefiedfield = [];
  List<Filiere> get fetchSpeciefiedfield => _fetchSpeciefiedfield;
  //Recuperer tous les universites
  List<Universite> _fetchAllUniv = [];
  List<Universite> get fetchAllUniv => _fetchAllUniv;
  //Recuperer des univ pour une option
  List<Universite> _fetchFacForOption = [];
  List<Universite> get fetchFacForOption => _fetchFacForOption;
  //Recuperer des univ pour une filiere
  List<Universite> _fetchFacForFiliere = [];
  List<Universite> get fetchFacForFiliere => _fetchFacForFiliere;
  Database? _database;
  List<MyJoinResultModel> _myResultList = [];
  List<MyJoinResultModel> get myResultList => _myResultList;

  Future<Database> get database async {
    final dbDirectory = await getDatabasesPath();

    const dbName = 'faculte.db';
    final path = join(dbDirectory, dbName);

    _database = await openDatabase(path, version: 1, onCreate: _createDb);

    return _database!;
  }

  static const oTable = 'OptionTable';
  static const fTable = 'filiere';
  static const facTable = 'faculte';
  static const sTable = 'series';
  static const sfTable = 'seriefiliere';
  static const iTable = 'info';
  static const hTable = 'story';
  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      await txn
          .execute('''CREATE TABLE $iTable(titre TEXT,contenue TEXT,fac TEXT, 
      image BLOB,datedebut TEXT,datefin TEXT)''');
      await txn.execute(
          '''CREATE TABLE $hTable(intro TEXT, contenu TEXT,fac TEXT)''');
      await txn.execute(
          '''CREATE TABLE $oTable(nom TEXT, logo BLOB,commentaire TEXT,fac TEXT)''');
      await txn.execute(
          '''CREATE TABLE $fTable(nomfiliere TEXT ,commentaire TEXT not null,logo BLOB,facName TEXT,opt TEXT,
  primary key(nomfiliere,facName,opt), foreign key(facName) references faculte(name),foreign key(opt) references Opt(nom))''');
      await txn.execute(
          '''CREATE TABLE $facTable(name TEXT primary key,mail TEXT ,password ,logo BLOB)''');
      await txn
          .execute('''CREATE TABLE $sTable(acronyme TEXT,nomSerie TEXT)''');
      await txn.execute(
          '''CREATE TABLE $sfTable(acronyme TEXT,nomSeries varchar(50) not null,nomfiliere varchar(30) not null, primary key(nomSeries,nomfiliere)
)''');
    });
  }

  Future<List<MyJoinResultModel>> fetchFieldsfromSftableAndFtable(
      String serieName) async {
    final db = await database;
    return db.transaction((txn) async {
      return await txn
          .query('$sfTable INNER JOIN $fTable',
              columns: [
                '$sfTable.acronyme',
                '$sfTable.nomSeries',
                '$fTable.commentaire',
                '$fTable.logo',
                '$fTable.facName',
                '$fTable.opt',
                '$fTable.nomfiliere'
              ],
              where:
                  '$sfTable.nomSeries= ? and $sfTable.nomfiliere = $fTable.nomfiliere',
              whereArgs: [serieName])
          .then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<MyJoinResultModel> myResultList = [];
        for (var row in convert) {
          myResultList.add(MyJoinResultModel(
              acronyme: row['acronyme'],
              nomSeries: row['nomSeries'],
              commentaire: row['commentaire'],
              logo: row['logo'],
              facName: row['facName'],
              opt: row['opt'],
              nomFiliere: row['nomfiliere']));
        }
        _myResultList = myResultList;
        return myResultList;
      });
    });
  }

//FONCTION POUR RECUPERER LES OPTIONS DE SQFLITE
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

  //FONCTION POUR RECUPERER LES infos DE SQFLITE
  Future<List<Info>> fetchInfo(String fac) async {
    print("Fetching.....");
    final db = await database;
    return db.transaction((txn) async {
      return await txn
          .query(iTable, where: 'fac=?', whereArgs: [fac]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Info> nList = List.generate(
            convert.length, (index) => Info.fromString(convert[index]));
        _infoFetcher = nList;

        print("Fecthing finish");
        return _infoFetcher;
      });
    });
  }

  //FONCTION POUR RECUPERER tous LES infos DE SQFLITE
  Future<List<Info>> fetchallInfo() async {
    print("Fetching.....");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(iTable).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Info> nList = List.generate(
            convert.length, (index) => Info.fromString(convert[index]));
        _infoallFetcher = nList;

        print("Fecthing finish");
        return _infoallFetcher;
      });
    });
  }

  //FONCTION POUR RECUPERER une OPTION pour une faculte
  Future<List<Option>> fetchAnOption(String fac, String optName) async {
    print("Fetching.....");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(oTable,
          where: 'fac = ? and nom = ?',
          whereArgs: [fac, optName]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Option> nList = List.generate(
            convert.length, (index) => Option.deString(convert[index]));
        _AnOption = nList;

        print("Fecthing finish");
        return _AnOption;
      });
    });
  }

  //FONCTION POUR RECUPERER toutes les OPTIONS
  Future<List<Option>> fetchAllOption() async {
    print("Fetching.....");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(oTable).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Option> nList = List.generate(
            convert.length, (index) => Option.deString(convert[index]));
        _all_option = nList;

        print("Fecthing finish");
        return _all_option;
      });
    });
  }

  //Recupere les series
  Future<List<Serie>> fetchSeries() async {
    final db = await database;
    return db.transaction((txn) async {
      return txn.query(sTable).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Serie> nList = List.generate(
            convert.length, (index) => Serie.fronString(convert[index]));
        print("Serie Fteched");
        return nList;
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
        print("liste des new filiere ${fList.length}");
        print("Filiere fetched successfully");

        return _filiereFetcher;
      });
    });
  }
  //FONCTION POUR RECUPERE LES FILIERES DE SQFLITE pour des filieres donnes

  Future<List<Filiere>> fetchFiliereForField(String filiere) async {
    print("fetching filiere ...");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(fTable,
          where: 'nomfiliere=? ', whereArgs: [filiere]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Filiere> fList = List.generate(
            convert.length, (index) => Filiere.fromString(convert[index]));
        _FiliereForFac = fList;
        print("liste des new filiere ${fList.length}");
        print("Filiere fetched successfully");
        notifyListeners();
        return _FiliereForFac;
      });
    });
  }

  Future<List<Filiere>> fetchFiliereForUniv(String facName) async {
    print("fetching filiere ...");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(fTable,
          where: 'facName=? ', whereArgs: [facName]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Filiere> fList = List.generate(
            convert.length, (index) => Filiere.fromString(convert[index]));
        _FiliereForUniv = fList;
        print("liste des new filiere ${fList.length}");
        print("Filiere fetched successfully");
        notifyListeners();
        return _FiliereForUniv;
      });
    });
  }

//recuperer des filieres concernant une option
  Future<List<Filiere>> fetchFiliereForOpt(String option) async {
    print("fetching filiere ...");
    final db = await database;
    return db.transaction((txn) async {
      return await txn
          .query(fTable, where: 'opt=? ', whereArgs: [option]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Filiere> fList = List.generate(
            convert.length, (index) => Filiere.fromString(convert[index]));
        _FiliereForopt = fList;
        print("liste des new filiere ${fList.length}");
        print("Filiere fetched successfully");
        notifyListeners();
        return _FiliereForopt;
      });
    });
  }

  //recuperer une filiere ses infos pour une fac donnees
  Future<List<Filiere>> fetchAnFiliereForFac(
      String facName, String filiere) async {
    print("fetching filiere ...");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(fTable,
          where: 'facName=? and nomfiliere=? ',
          whereArgs: [facName, filiere]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Filiere> fList = List.generate(
            convert.length, (index) => Filiere.fromString(convert[index]));
        _FiliereForFac = fList;
        print("liste des new filiere ${fList.length}");
        print("Filiere fetched successfully");
        notifyListeners();
        return _AnFiliereForFac;
        ;
      });
    });
  }

  //recuperation des seriesfiliere pour une une filiere
  Future<List<SeriesFiliere>> fetchSerieFiliere(String filiere) async {
    print("fetching filiere ...");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(sfTable,
          where: 'nomfiliere=? ', whereArgs: [filiere]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<SeriesFiliere> nList = List.generate(convert.length,
            (index) => SeriesFiliere.fromString(convert[index]));
        _serifiliereFetcher = nList;

        print("liste des new serie ${nList.length}");
        print("Serifiliere fetched successfully");
        notifyListeners();
        return _serifiliereFetcher;
      });
    });
  }

  //fetch filiere for seri
  Future<List<SeriesFiliere>> fetchFiliereForSerie(String filiere) async {
    print("fetching filiere ...");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(sfTable,
          where: 'nomSeries=? ', whereArgs: [filiere]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<SeriesFiliere> nList = List.generate(convert.length,
            (index) => SeriesFiliere.fromString(convert[index]));
        _filiereforSeriFetcher = nList;

        print("liste des new serie ${nList.length}");
        print("Serifiliere fetched successfully");
        notifyListeners();
        return _filiereforSeriFetcher;
      });
    });
  }

  //recuperation de tout seriesfiliere
  Future<List<SeriesFiliere>> fetchAllSerieFiliere() async {
    print("fetching filiere ...");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(sfTable).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<SeriesFiliere> nList = List.generate(convert.length,
            (index) => SeriesFiliere.fromString(convert[index]));
        _serifiliereFetcher = nList;

        print("liste des new serie ${nList.length}");
        print("Serifiliere fetched successfully");
        notifyListeners();
        return _serifiliereFetcher;
      });
    });
  }

  //Recupere toutes les fileres
  Future<List<Filiere>> fetchtAllFiliere() async {
    print("recuperation...");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(fTable).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Filiere> fList = List.generate(
            convert.length, (index) => Filiere.fromString(convert[index]));
        _fetchAllfield = fList;
        print("liste des new filiere ${fList.length}");
        print("Filiere fetched successfully");
        notifyListeners();
        return _fetchAllfield;
      });
    });
  }

  //recuperer des filiere donnes
  //Recupere toutes les fileres
  Future<List<Filiere>> fetchtSpecifiedFiliere(String fieldName) async {
    print("recuperation...");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(fTable,
          where: 'nomfiliere=?', whereArgs: [fieldName]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Filiere> fList = List.generate(
            convert.length, (index) => Filiere.fromString(convert[index]));
        _fetchSpeciefiedfield = fList;
        print("liste des new filiere ${fList.length}");
        print("Filiere fetched successfully");
        notifyListeners();
        return _fetchSpeciefiedfield;
      });
    });
  }

  //RECUPERATION DE FACULTE
  Future<List<Universite>> fetchAllFac() async {
    print("Recuperation ....");
    final db = await database;
    return db.transaction((txn) async {
      return await txn.query(facTable).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Universite> facList = List.generate(
            convert.length, (index) => Universite.fromString(convert[index]));
        _fetchAllUniv = facList;
        print("liste des new universite ${facList.length}");
        print("Filiere fetched successfully");
        return _fetchAllUniv;
      });
    });
  }

  //RECUPERATION DEs FACULTE pour une option
  Future<List<Universite>> fetchFacForoptions(String name) async {
    print("Recuperation ....");
    final db = await database;
    return db.transaction((txn) async {
      return await txn
          .query(facTable, where: 'name = ?', whereArgs: [name]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Universite> facList = List.generate(
            convert.length, (index) => Universite.fromString(convert[index]));
        _fetchFacForOption = facList;
        print("liste des new universite ${facList.length}");
        print("Filiere fetched successfully");
        return _fetchFacForOption;
      });
    });
  }

  //RECUPERATION DEs FACULTE pour une filiere
  Future<List<Universite>> fetchFacForField(String name) async {
    print("Recuperation ....");
    final db = await database;
    return db.transaction((txn) async {
      return await txn
          .query(facTable, where: 'name = ?', whereArgs: [name]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Universite> facList = List.generate(
            convert.length, (index) => Universite.fromString(convert[index]));
        _fetchFacForFiliere = facList;
        print("liste des new universite ${facList.length}");
        print("Filiere fetched successfully");
        return _fetchFacForFiliere;
      });
    });
  }

  //recuperer une seule universite
  Future<List<Universite>> fetchAnFac(String name) async {
    print("Recuperation ....");
    final db = await database;
    return db.transaction((txn) async {
      return await txn
          .query(facTable, where: 'name =?', whereArgs: [name]).then((value) {
        final convert = List<Map<String, dynamic>>.from(value);
        List<Universite> facList = List.generate(
            convert.length, (index) => Universite.fromString(convert[index]));
        _fetchAnUniv = facList;
        print("liste des new universite ${facList.length}");
        print("Filiere fetched successfully");
        return _fetchAnUniv;
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

//ajout d'historique
  Future<void> addStory(Story story) async {
    print("adding Story...");
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .insert(hTable, story.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace)
          .then((value) {
        print("Insertion termine");
      });
    });
  }

  //ajout d'info
  Future<void> addInfo(Info info) async {
    print("adding Story...");
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn
            .insert(iTable, info.enMa(),
                conflictAlgorithm: ConflictAlgorithm.replace)
            .then((value) {
          print("Insertion termine");
        });
      });
    } catch (e) {
      print("l'info n'est pas enregistrer");
      print("errrreeuurr :  $e");
    }
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
        _filiere.add(file);
        print("Saved in phone storage");
      });
    });
  }

  //Fonction d'ajout de series-filiere
  Future<void> addSerieFiliere(SeriesFiliere sfiliere) async {
    print("Add serifiliere...");
    print(
      sfiliere.acronyme,
    );
    print(sfiliere.nomFiliere);
    print(sfiliere.nomSeries);
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn
            .insert(sfTable, sfiliere.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace)
            .then((value) {
          final file = SeriesFiliere(
              acronyme: sfiliere.acronyme,
              nomSeries: sfiliere.nomSeries,
              nomFiliere: sfiliere.nomFiliere);
          _serfil.add(file);
          notifyListeners();
        });
      });
    } catch (e) {
      print("Errrroeed $e");
    }
  }

  //Ajouter des serie filiere
  Future<void> addSeries(Serie serie) async {
    print("series are adding ...");
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .insert(sTable, serie.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace)
          .then((value) {
        final file = Serie(acronyme: serie.acronyme, nomSerie: serie.nomSerie);
      });
    });
  }

  //FONCTION D'AJOUT DE FACULTE
  Future<void> addFaculty(Universite univ) async {
    print("faculté is adding ...");
    print("Adding univ...");
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .insert(facTable, univ.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace)
          .then((value) {
        print("Univ Inserted");
        final file = Universite(
            name: univ.name,
            mail: univ.mail,
            password: univ.password,
            logo: univ.password);
        _universite.add(file);
        print("Univ saved in local");
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

  //mise a jour du story
  Future<void> update(String table, var values,
      {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    try {
      await db.update(table, values, where: where, whereArgs: whereArgs);
      print("Mise a jour reussie");
    } catch (e) {
      print("Erreur lors de la maj $e");
    }
  }

  //Mise a jour des filieres
  Future<void> updateField(String fieldName, Filiere field) async {
    final db = await database;
    try {
      await db.update(fTable, field.toMap(),
          where: 'facName = ?  and nomfiliere = ?',
          whereArgs: [field.facName, fieldName]);
      print("MAJ faite");
    } catch (e) {
      print("Erreur ....  $e");
    }
    print("MAJ faite");
  }

//Supprimer toutes les options d'une faculté
  Future<void> deleteAllOption(Universite fac) async {
    final db = await database;
    await db.delete(oTable, where: 'fac = ?', whereArgs: [fac.name]);
    print("Suppression termine");
  }

  //Supprimer toutes les info
  Future<void> deleteAllInfo(Universite fac) async {
    final db = await database;
    await db.delete(iTable, where: 'fac=?', whereArgs: [fac.name]);
    print("Info deleted");
  }

//supprimer toutes les fileres
  Future<void> deleteAllFiliere(String fac, String opt) async {
    final mydb = await database;
    await mydb
        .delete(fTable, where: 'facName=? and opt =?', whereArgs: [fac, opt]);
    print("deleted succesfully");
  }

  //supprimer toutes les facultés
  Future<void> deleteSomething(String table) async {
    final db = await database;
    await db.delete(table);
    print("All data deleted succesfully");
  }

//supprimer une seule option
  Future<void> deleteAnOption(Option opt) async {
    final db = await database;
    await db.delete(oTable,
        where: 'fac = ? and nom = ?', whereArgs: [opt.fac, opt.nom]);
    print("Suppression termine");
    notifyListeners();
  }

  //supprimer une seule filiere
  Future<void> deleteAnField(Filiere fil) async {
    final db = await database;
    await db.delete(fTable,
        where: 'nomfiliere = ? and facName = ?',
        whereArgs: [fil.nomfiliere, fil.facName]);
    print("Suppression termine");
    print("maj des donnes");
    notifyListeners();
  }

  //Recuperation et insertion des donnes de mysql vers sqflite

  Future<void> getData() async {
    final db = await database;
    try {
      Serie? serie;
      //fetching from mysql
      var result = await RUD().query("Select acronyme,nomSeries from series");
      for (var row in result!.rows) {
        String acronym = row.assoc()['acronyme']!;
        String nSerie = row.assoc()['nomSeries']!;
        serie = Serie(acronyme: acronym, nomSerie: nSerie);
        await Sqflite().addSeries(serie);
        print("serie enregistre dans sqflite");
      }
    } catch (e) {
      print(e);
    }
    try {
      Option? option;
      //recuperation depuis mysql
      var result =
          await RUD().query("select nom,commentaire,logo,name from Opt");
      for (var row in result!.rows) {
        String nom = row.assoc().values.toList()[0]!;
        String comment = row.assoc().values.toList()[1]!;
        var img = row.assoc()['logo'] as String;
        final decoded = base64Decode(img);
        String name = row.assoc()['name']!;
        option =
            Option(nom: nom, logo: decoded, commentaire: comment, fac: name);
        //on ajoute chaque option pour la fac trouvé

        Sqflite().addOption(option);
        print("option enregistre");

        print("Nouvelle option");
      }
    } catch (e) {
      print(e);
    }
    //Filiere
    try {
      //suppression

      Filiere? filiere;
      //recuperation depuis mysql
      var result = await RUD()
          .query("select nomfiliere,commentaire,logo,facName,opt from filiere");

      for (var row in result!.rows) {
        String nom = row.assoc().values.toList()[0]!;

        String comment = row.assoc().values.toList()[1]!;

        var img = row.assoc()['logo'] as String;
        final decoded = base64Decode(img);
        String fname = row.assoc()['facName']!;

        String option = row.assoc()['opt']!;

        filiere = Filiere(
            nomfiliere: nom,
            commentaire: comment,
            logo: decoded,
            facName: fname,
            option: option);
        print("jusque la ça va");
        //on ajoute chaque option pour la fac trouvé
        await Sqflite().addFiliere(filiere);
        print("filiere enregistre");
      }
    } catch (e) {
      print("Errrrooorr $e");
    }

    try {
      SeriesFiliere? serie;
      //recuperation de serie depuis mysql

      var result =
          await RUD().query("select acronyme,nomSeries ,nomfiliere  from ");

      for (var row in result!.rows) {
        String acronyme = row.assoc().values.toList()[0]!;

        String nomSeries = row.assoc().values.toList()[1]!;
        String nomfiliere = row.assoc().values.toList()[2]!;

        serie = SeriesFiliere(
            acronyme: acronyme, nomSeries: nomSeries, nomFiliere: nomfiliere);
        print("jusque la ça va");
        //on ajoute chaque option pour la fac trouvé
        await addSerieFiliere(serie);
        print("seriefiliere enregistre");
      }
    } catch (e) {
      print("Errrrooorr $e");
    }
    try {
      List<Universite> listuniv = [];
      Universite? univ;
      //recuperation depuis mysql

      var result =
          await RUD().query("select name,mail,password,logo from faculte");
      //name,mail,password,logo

      for (var row in result!.rows) {
        String nom = row.assoc().values.toList()[0]!;
        String mail = row.assoc().values.toList()[1]!;
        String password = row.assoc().values.toList()[2]!;
        var img = row.assoc()['logo'] as String;
        final decoded = base64Decode(img);

        univ = Universite(
            name: nom, mail: mail, password: password, logo: decoded);
        //on ajoute chaque option pour la fac trouvé
        print("faculté is adding ...");
        await Sqflite().addFaculty(univ);
        print("faculté enregistre");
        listuniv.add(univ);
      }
      print(listuniv.length);
    } catch (e) {
      print("Errrrooorr $e");
    }
  }

  //recuperation en cas de changement dans mysql
  Future<void> getDataAgain() async {
    final db = await database;
    try {
      //suppression
      await deleteSomething(sTable);
      await deleteSomething(fTable);
      await deleteSomething(oTable);
      await deleteSomething(facTable);
      await deleteSomething(sfTable);
    } catch (e) {
      print(e);
    }
    try {
      Serie? serie;
      //fetching from mysql
      var result = await RUD().query("Select acronyme,nomSeries from serie");
      for (var row in result!.rows) {
        String acronym = row.assoc()['acronyme']!;
        String nSerie = row.assoc()['nomSeries']!;
        serie = Serie(acronyme: acronym, nomSerie: nSerie);
        await Sqflite().addSeries(serie);
        print("serie enregistre dans sqflite");
      }
    } catch (e) {
      print(e);
    }
    try {
      Option? option;
      //recuperation depuis mysql
      var result =
          await RUD().query("select nom,commentaire,logo,name from Opt");
      for (var row in result!.rows) {
        String nom = row.assoc().values.toList()[0]!;
        String comment = row.assoc().values.toList()[1]!;
        var img = row.assoc()['logo'] as String;
        final decoded = base64Decode(img);
        String name = row.assoc()['name']!;
        option =
            Option(nom: nom, logo: decoded, commentaire: comment, fac: name);
        //on ajoute chaque option pour la fac trouvé

        Sqflite().addOption(option);
        print("option enregistre");

        print("Nouvelle option");
      }
    } catch (e) {
      print(e);
    }
    //Filiere
    try {
      //suppression

      Filiere? filiere;
      //recuperation depuis mysql
      var result = await RUD()
          .query("select nomfiliere,commentaire,logo,facName,opt from filiere");

      for (var row in result!.rows) {
        String nom = row.assoc().values.toList()[0]!;

        String comment = row.assoc().values.toList()[1]!;

        var img = row.assoc()['logo'] as String;
        final decoded = base64Decode(img);
        String fname = row.assoc()['facName']!;

        String option = row.assoc()['opt']!;

        filiere = Filiere(
            nomfiliere: nom,
            commentaire: comment,
            logo: decoded,
            facName: fname,
            option: option);
        print("jusque la ça va");
        //on ajoute chaque option pour la fac trouvé
        await Sqflite().addFiliere(filiere);
        print("filiere enregistre");
      }
    } catch (e) {
      print("Errrrooorr $e");
    }

    try {
      SeriesFiliere? serie;
      //recuperation de serie depuis mysql

      var result = await RUD()
          .query("select acronyme,nomSeries ,nomfiliere  from seriesfiliere");

      for (var row in result!.rows) {
        String acronyme = row.assoc().values.toList()[0]!;

        String nomSeries = row.assoc().values.toList()[1]!;
        String nomfiliere = row.assoc().values.toList()[2]!;

        serie = SeriesFiliere(
            acronyme: acronyme, nomSeries: nomSeries, nomFiliere: nomfiliere);
        print("jusque la ça va");
        //on ajoute chaque option pour la fac trouvé
        await addSerieFiliere(serie);
        print("seriefiliere enregistre");
      }
    } catch (e) {
      print("Errrrooorr $e");
    }
    try {
      List<Universite> listuniv = [];
      Universite? univ;
      //recuperation depuis mysql

      var result =
          await RUD().query("select name,mail,password,logo from faculte");
      //name,mail,password,logo

      for (var row in result!.rows) {
        String nom = row.assoc().values.toList()[0]!;
        String mail = row.assoc().values.toList()[1]!;
        String password = row.assoc().values.toList()[2]!;
        var img = row.assoc()['logo'] as String;
        final decoded = base64Decode(img);

        univ = Universite(
            name: nom, mail: mail, password: password, logo: decoded);
        //on ajoute chaque option pour la fac trouvé
        print("faculté is adding ...");
        await Sqflite().addFaculty(univ);
        print("faculté enregistre");
        listuniv.add(univ);
      }
      print(listuniv.length);
    } catch (e) {
      print("Errrrooorr $e");
    }
  }
}
