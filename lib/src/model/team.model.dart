
class Team {
  String id;
  String name;
  String shortName;
  String logo;

  Team({this.name, this.shortName, this.logo, this.id});

  static Team fromApiJson(Map<String, dynamic> json) {
    return Team(
      name: json["Name"][0]["Description"],
      shortName: json["Abbreviation"],
      logo: (json["PictureUrl"] as String).replaceAll("{format}-{size}", "sq-6"),
      id : json["IdTeam"]
    );
  }

}