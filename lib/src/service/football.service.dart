import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:football_result/src/model/match-day.model.dart';
import 'package:football_result/src/model/ranking.model.dart';
import 'package:football_result/src/model/team.model.dart';
import 'package:football_result/src/repository/football.repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:football_result/src/model/match.model.dart';

class FootballService extends BlocBase{
  final FootballRepository repository = new FootballRepository();

  List<Match> matchRepository = [];

  final BehaviorSubject<int> currentPage = new BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<Ranking> rankings = new BehaviorSubject<Ranking>.seeded(Ranking(RankingType.GENERAL));
  final BehaviorSubject<List<Team>> teams = new BehaviorSubject<List<Team>>.seeded([]);
  final BehaviorSubject<MatchDay> matchDay = new BehaviorSubject<MatchDay>.seeded(MatchDay(1,[]));

  FootballService() {
    fetchTeams().then((value){
      Future.wait([
        fetchStandings(),
        fetchMatches().then((value) => selectMatchDay(1))
      ]);
    });
  }

  int get valueOfPage => currentPage.value;
  Ranking       get valueOfRanking => rankings.value;
  List<Team>    get valueOfTeam => teams.value;
  Stream<MatchDay>    get streamOfMatchDay  => matchDay.stream.asBroadcastStream();
  Stream<Ranking>     get streamOfRankings  => rankings.stream.asBroadcastStream();
  Stream<List<Team>>  get streamOfTeams     => teams.stream.asBroadcastStream();
  Stream<int>  get streamOfPage     => currentPage.stream.asBroadcastStream();

  Future<void> selectPage(int index) async{
    this.currentPage.sink.add(index);
  }

  Future<void> selectRanking(RankingType rankingType) async{
    rankings.value.activeRanking = rankingType;
    this.rankings.sink.add(rankings.value);
  }

  Future<void> selectMatchDay(int selectedMatchDay) async{
    MatchDay matchDay = new MatchDay(selectedMatchDay, this.matchRepository.where((match) => match.matchDay == selectedMatchDay).toList());
    this.matchDay.sink.add(matchDay);
  }

  Future<Ranking> fetchStandings() async {
    await repository.getStandings(rankings.value);
    rankings.sink.add(rankings.value);
    return rankings.value;
  }

  Future<List<Match>> fetchMatches() async {
    final List<Match> fetchedMatches = await repository.getMatches();
    this.matchRepository = fetchedMatches;
    return fetchedMatches;
  }

  Future<List<Team>> fetchTeams() async {
    final List<Team> fetchedTeams = await repository.getTeams();
    teams.sink.add(fetchedTeams);
    return fetchedTeams;
  }


  @override
  void dispose() {
    currentPage.close();
    matchDay.close();
    rankings.close();
    teams.close();
    super.dispose();
  }
}