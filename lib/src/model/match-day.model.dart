import 'package:football_result/src/model/match.model.dart';
import 'package:intl/intl.dart';

class MatchDay{
  final dateFormat = new DateFormat('yyyy/MM/dd');
  int matchDay;
  List<Match> matches;
  Map<String, List<Match>> matchesSortedByDate = new Map();

  MatchDay(this.matchDay, this.matches){
    this.matches.forEach((match) {
      final String date = dateFormat.format(match.date);
      if(this.matchesSortedByDate.containsKey(date)){
        this.matchesSortedByDate.update(date, (value) => value..add(match));
      }else{
        this.matchesSortedByDate.putIfAbsent(date, () => [match]);
      }
    });
  }
}