class Info {
  String titre, contenue, fac;
  var image;
  DateTime datedebut, datefin;
  Info(
      {required this.titre,
      required this.contenue,
      required this.fac,
      required this.image,
      required this.datedebut,
      required this.datefin});

  Map<String, dynamic> enMa() => {
        'titre': titre,
        'contenue': contenue,
        'fac': fac,
        'image': image,
        'datedebut': datedebut.toIso8601String(),
        'datefin': datefin.toIso8601String()
      };

  factory Info.fromString(Map<String, dynamic> map) => Info(
      titre: map['titre'],
      contenue: map['contenue'],
      fac: map['fac'],
      image: map['image'],
      datedebut: DateTime.parse(map['datedebut']),
      datefin: DateTime.parse(map['datefin']));
}



// titre varchar(50) not null, contenue varchar(5000) 
// not null, image longblob,datedebut Date,datefin date
// ,fac varchar(50)