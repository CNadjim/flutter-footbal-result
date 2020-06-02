import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:football_result/src/extension/extension.dart';
import 'package:football_result/src/model/ranking.model.dart';
import 'package:football_result/src/service/football.service.dart';
import 'package:football_result/src/widget/loading.widget.dart';

class StandingPage extends StatelessWidget {
  final footballService = BlocProvider.getBloc<FootballService>();

  final Map<RankingType, Widget> myTabs = const <RankingType, Widget>{
    RankingType.GENERAL: Text("Général"),
    RankingType.HOME: Text("Domicile"),
    RankingType.AWAY: Text("Extérieur")
  };

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: footballService.streamOfRankings,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final Ranking ranking = snapshot.data;
          if (snapshot.hasData) {
            if((snapshot.data as Ranking).getStandingForActiveRanking() == null){
              return Column(mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Card(
                  elevation:3,
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                  child: Container(child: Padding(padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0), child: CupertinoSlidingSegmentedControl(groupValue: ranking.activeRanking, children: myTabs, onValueChanged: (selected) => footballService.selectRanking(selected)))),
                ),
                Center(
                    child: LoadingIndicator()
                )
              ]);
            }else{
              return Column(mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Card(
                  elevation:3,
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                  child: Container(child: Padding(padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0), child: CupertinoSlidingSegmentedControl(groupValue: ranking.activeRanking, children: myTabs, onValueChanged: (selected) => footballService.selectRanking(selected)))),
                ),
                Expanded(
                    flex: 1,
                    child: RefreshIndicator(
                        onRefresh: () => footballService.fetchStandings(),child :SingleChildScrollView(
                        child: Container(
                            child: DataTable(
                              horizontalMargin: 18,
                              headingRowHeight: 32,
                              columnSpacing: 20.0,
                              columns: [
                                DataColumn(label: Text('Equipe')),
                                DataColumn(label: Text('J'), numeric: true),
                                DataColumn(label: Text('G'), numeric: true),
                                DataColumn(label: Text('N'), numeric: true),
                                DataColumn(label: Text('P'), numeric: true),
                                DataColumn(label: Text('Pts'), numeric: true),
                              ],
                              rows: ranking.getStandingForActiveRanking()// Loops through dataColumnText, each iteration assigning the value to element
                                  .map( (standing) =>
                                  DataRow(cells: <DataCell> [
                                    DataCell(Row(
                                      children: [
                                          standing.team.logo.isNullOrEmpty() ? Image.asset("assets/images/logo.png", width: 30.0, height: 30.0) : Image.network(standing.team.logo, width: 30.0, height: 30.0),
                                          Text("    "),
                                          Flexible(child : Text(standing.team.name, overflow: TextOverflow.ellipsis, softWrap: false))
                                      ],
                                    )), //Extracting from Map element the value
                                    DataCell(Text(standing.matchDay.toString())),
                                    DataCell(Text(standing.won.toString())),
                                    DataCell(Text(standing.drawn.toString())),
                                    DataCell(Text(standing.lost.toString())),
                                    DataCell(Text(standing.points.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                  ])).toList(),
                            )
                        )
                    )))
              ]);
            }
          } else {
            return LoadingIndicator();
          }
        });
  }
}
