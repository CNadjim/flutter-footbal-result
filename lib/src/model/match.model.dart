import 'package:football_result/src/model/team.model.dart';

class Match {
  Team home;
  Team away;
  int homeScore;
  int awayScore;
  DateTime date;
  String stadium;
  Team winner;
  String homeTeamId;
  String awayTeamId;
  String winnerId;
  int matchDay;

  Match({this.home, this.away, this.date, this.matchDay, this.homeScore, this.awayScore, this.stadium, this.winner,this.homeTeamId, this.awayTeamId, this.winnerId});

  static Match fromApiJson(Map<String, dynamic> json) {
    return Match(
      homeTeamId: json["Home"]["IdTeam"],
      awayTeamId: json["Away"]["IdTeam"],
      date: DateTime.parse(json["Date"]),
      homeScore: json["HomeTeamScore"],
      awayScore: json["AwayTeamScore"],
      winnerId: json["Winner"],
      matchDay: int.parse(json["MatchDay"])
    );
  }
}