import 'dart:typed_data';

class MyJoinResultModel {
  String acronyme;
  String nomSeries;
  String commentaire;
  Uint8List logo;
  String facName;
  String opt;
  String nomFiliere;

  MyJoinResultModel(
      {required this.acronyme,
      required this.nomSeries,
      required this.commentaire,
      required this.logo,
      required this.facName,
      required this.opt,
      required this.nomFiliere});
}
