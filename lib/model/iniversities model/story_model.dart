class Story {
  String intro, contenu, fac;
  Story({required this.intro, required this.contenu, required this.fac});

  Map<String, dynamic> toMap() =>
      {'intro': intro, 'contenu': contenu, 'fac': fac};

  factory Story.fromString(Map<String, dynamic> map) =>
      Story(intro: map['intro'], contenu: map['contenu'], fac: map['fac']);
}
