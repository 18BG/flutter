class Universite {
  int? id;
  String name;
  String mail;
  String password;
  var logo;
  Universite(
      {required this.name,
      required this.mail,
      required this.password,
      required this.logo});
  Map<String, dynamic> toMap() =>
      {'name': name, 'mail': mail, 'password': password, 'logo': logo};

  factory Universite.fromString(Map<String, dynamic> map) => Universite(
      name: map['name'],
      mail: map['mail'],
      password: map['password'],
      logo: map['logo']);
}
