import 'package:football_result/src/model/standing.model.dart';

enum RankingType{
  GENERAL,
  HOME,
  AWAY
}
class Ranking{
  RankingType activeRanking;
  List<Standing> standingGeneral;
  List<Standing> standingHome;
  List<Standing> standingAway;

  Ranking(activeRanking, {this.standingGeneral, this.standingHome, this.standingAway}) : this.activeRanking = activeRanking ?? RankingType.GENERAL;

  List<Standing> getStandingForActiveRanking(){
    switch(activeRanking){
      case RankingType.GENERAL: return this.standingGeneral; break;
      case RankingType.HOME: return this.standingHome; break;
      case RankingType.AWAY: return this.standingAway; break;
      default: return this.standingGeneral; break;
    }
  }
}