import 'package:an_app/model/db_management/sqflite_management/sqflite_conn.dart';
import 'package:an_app/model/iniversities%20model/story_model.dart';

import '../../iniversities model/classe_universite.dart';

class FetcUnivInfo {
  //Recuperer tous les universites
  List<Universite> _fetchAnUniv = [];
  List<Universite> get fetchAnUniv => _fetchAnUniv;
  //Recuperer tous les universites
  List<Universite> _fetchAllUniv = [];
  List<Universite> get fetchAllUniv => _fetchAllUniv;
  Sqflite base = Sqflite();
  static const facTable = 'faculte';
  Future<List<Universite>> fetchAllFac() async {
    print("Recuperation ....");
    final db = await base.database;
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

  //recuperer une seule universite
  Future<List<Universite>> fetchAnFac(String name) async {
    print("Recuperation ....");
    final db = await base.database;
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

  // Future<void> addOption(Option opt) async {
  //   print("Sqflite.....");
  //   final db = await database;
  //   print("Database created");
  //   await db.transaction((txn) async {
  //     await txn
  //         .insert(oTable, opt.toMap(),
  //             conflictAlgorithm: ConflictAlgorithm.replace)
  //         .then((value) {
  //       print("Insertion termine");
  //       final file = Option(
  //           nom: opt.nom,
  //           logo: opt.logo,
  //           commentaire: opt.commentaire,
  //           fac: opt.fac);
  //       _option.add(file);
  //       print("Sauvegarder en locale");
  //     });
  //   });
  // }

}
