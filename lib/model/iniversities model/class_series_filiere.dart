class SeriesFiliere {
  String acronyme;
  String nomSeries;
  String nomFiliere;

  SeriesFiliere(
      {required this.acronyme,
      required this.nomSeries,
      required this.nomFiliere});

  Map<String, dynamic> toMap() => {
        'acronyme': acronyme,
        'nomSeries': this.nomSeries,
        'nomfiliere': this.nomFiliere
      };

  factory SeriesFiliere.fromString(Map<String, dynamic> map) => SeriesFiliere(
      acronyme: map['acronyme'],
      nomSeries: map['nomSeries'],
      nomFiliere: map['nomfiliere']);
}
