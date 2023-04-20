import 'package:an_app/model/iniversities%20model/class_option.dart';

class Filiere {
  String nomfiliere;
  String commentaire;
  var logo;
  String facName;
  String option;

  Filiere({
    required this.nomfiliere,
    required this.commentaire,
    required this.logo,
    required this.facName,
    required this.option,
  });
  Map<String, dynamic> toMap() => {
        'nomfiliere': nomfiliere,
        'commentaire': commentaire,
        'logo': logo,
        'facName': facName,
        'opt': option,
      };
  factory Filiere.fromString(Map<String, dynamic> value) => Filiere(
        nomfiliere: value['nomfiliere'],
        commentaire: value['commentaire'],
        logo: value['logo'],
        facName: value['facName'],
        option: value['opt'],
      );
}
