class Serie {
  String acronyme;
  String nomSerie;
  Serie({required this.acronyme, required this.nomSerie});
  Map<String, dynamic> toMap() => {'acronyme': acronyme, 'nomSerie': nomSerie};
  factory Serie.fronString(Map<String, dynamic> map) =>
      Serie(acronyme: map['acronyme'], nomSerie: map['nomSerie']);
}
