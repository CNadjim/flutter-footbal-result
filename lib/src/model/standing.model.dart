import 'package:football_result/src/model/team.model.dart';

class Standing extends Comparable<Standing>{
  final int matchDay;
  final int points;
  final int won;
  final int lost;
  final int drawn;
  final int played;
  Team team;

  Standing({this.matchDay, this.team, this.points, this.won, this.lost, this.drawn, this.played});

  static Standing generalFromApiJson(Map<String, dynamic> json) {
    return Standing(
        matchDay: json["MatchDay"],
        points: json["Points"],
        won: json["Won"],
        lost: json["Lost"],
        drawn: json["Drawn"],
        played: json["Played"],
        team: Team.fromApiJson(json["Team"]));
  }

  static Standing homeFromApiJson(Map<String, dynamic> json) {
    return Standing(
        matchDay: json["MatchDay"],
        points: json["HomePoints"],
        won: json["HomeWon"],
        lost: json["HomeLost"],
        drawn: json["HomeDrawn"],
        played: json["HomePlayed"],
        team: Team.fromApiJson(json["Team"]));
  }

  static Standing awayFromApiJson(Map<String, dynamic> json) {
    return Standing(
        matchDay: json["MatchDay"],
        points: json["AwayPoints"],
        won: json["AwayWon"],
        lost: json["AwayLost"],
        drawn: json["AwayDrawn"],
        played: json["AwayPlayed"],
        team: Team.fromApiJson(json["Team"]));
  }

  @override
  int compareTo(Standing other) {
    return other.points.compareTo(points);
  }
}