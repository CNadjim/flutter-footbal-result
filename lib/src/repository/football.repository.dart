
import 'dart:convert';
import 'package:football_result/src/extension/extension.dart';
import 'package:football_result/src/model/ranking.model.dart';
import 'package:football_result/src/model/standing.model.dart';
import 'package:football_result/src/model/team.model.dart';
import 'package:football_result/src/model/match.model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class FootballRepository {
  List<Team> teams = [];
  final String baseUrl = "https://api.fifa.com/api/v1/";
  final String standingInfoUrl = "calendar/2000000018/400079389/400079800/Standing?language=fr-FR";
  final String teamInfoUrl = "competitions/teams/2000000018/400079389?language=fr-FR";
  final String matchInfoUrl = "calendar/matches?idCompetition=2000000018&idSeason=400079389&language=fr-FR&count=1000000";

  Future<void> getStandings(Ranking ranking) async {
    try {
      Response response = await http.get(baseUrl + standingInfoUrl);
      Map<String, dynamic> json = JsonDecoder().convert(response.body);
      List<Standing> standingGeneral =  json["Results"].map<Standing>((jsonStanding) => Standing.generalFromApiJson(jsonStanding)).toList();
      List<Standing> standingHome =     json["Results"].map<Standing>((jsonStanding) => Standing.homeFromApiJson(jsonStanding)).toList();
      List<Standing> standingAway =     json["Results"].map<Standing>((jsonStanding) => Standing.awayFromApiJson(jsonStanding)).toList();
      await Future.wait([
        Future.forEach(standingGeneral, (standing) => standing.team = replaceTeam(standing.team)),
        Future.forEach(standingHome,    (standing) => standing.team = replaceTeam(standing.team)),
        Future.forEach(standingAway,    (standing) => standing.team = replaceTeam(standing.team))
      ]);
      standingGeneral.sort();
      standingHome.sort();
      standingAway.sort();
      ranking.standingGeneral = standingGeneral;
      ranking.standingAway = standingAway;
      ranking.standingHome = standingHome;
    } catch (error) {
      print(error);
    }
  }


  Future<List<Team>> getTeams() async {
    try {
      Response response = await http.get(baseUrl + teamInfoUrl);
      Map<String, dynamic> json = JsonDecoder().convert(response.body);
      final List<Team> teams = json["Results"].map<Team>((team) => Team.fromApiJson(team)).toList();
      teams.sort((teamA, teamB) => teamA.name.compareTo(teamB.name));
      await Future.forEach(teams, (team) async  => team = await cleanLogo(team));
      this.teams = teams;
      return teams;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<Match>> getMatches() async {
    try {
      Response response = await http.get(baseUrl + matchInfoUrl);
      Map<String, dynamic> json = JsonDecoder().convert(response.body);
      final List<Match> matches = json["Results"].map<Match>((match) => Match.fromApiJson(match)).toList();
      await Future.forEach<Match>(matches, (match) {
        match.winner = match.winnerId.isNullOrEmpty() ? null : getTeam(match.winnerId);
        match.home = getTeam(match.homeTeamId);
        match.away = getTeam(match.awayTeamId);
      });
      return matches;
    } catch (error) {
      print(error);
      return [];
    }
  }


  static Future<Team> cleanLogo(Team team) async{
    Response response = await http.get(team.logo);
    final headers = response.headers;
    team.logo = headers.containsKey("content-type") ? team.logo : '';
    return team;
  }

  Team replaceTeam(Team team){
    return this.teams.firstWhere((fetchedTeam) => fetchedTeam.id == team.id);
  }

  Team getTeam(String id){
    return this.teams.firstWhere((fetchedTeam) => fetchedTeam.id == id);
  }



}
