class Option {
  String nom;
  var logo;
  String commentaire;
  String fac;
  Option(
      {required this.nom,
      required this.commentaire,
      required this.fac,
      required this.logo});

  Map<String, dynamic> toMap() =>
      {'nom': nom, 'logo': logo, 'commentaire': commentaire, 'fac': fac};
  factory Option.deString(Map<String, dynamic> value) => Option(
      nom: value['nom'],
      logo: value['logo'],
      commentaire: value['commentaire'],
      fac: value['fac']);
}
