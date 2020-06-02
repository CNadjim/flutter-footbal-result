import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:football_result/src/extension/extension.dart';
import 'package:football_result/src/model/match-day.model.dart';
import 'package:football_result/src/service/football.service.dart';
import 'package:football_result/src/widget/loading.widget.dart';
import 'package:numberpicker/numberpicker.dart';

class MatchesPage extends StatelessWidget {
  final footballService = BlocProvider.getBloc<FootballService>();
  final iconSize = 28.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: footballService.streamOfMatchDay,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              (snapshot.data as MatchDay).matches.length > 0) {
            final MatchDay matchDay = snapshot.data;
            final List<String> dates =
                matchDay.matchesSortedByDate.keys.toList();
            return Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                      flex: 1,
                      child: RefreshIndicator(
                        onRefresh: () => footballService.fetchMatches(),
                        child: ListView.builder(
                            shrinkWrap: false,
                            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                            itemCount: dates.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String date = dates[index];
                              return Column(children: [
                                Divider(height: 0.0),
                                ListTile(dense: true, title: Text(date)),
                                Divider(height: 0.0),
                                ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        Divider(height: 0.0),
                                    itemCount: matchDay
                                        .matchesSortedByDate[date].length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final match = matchDay
                                          .matchesSortedByDate[date][index];
                                      return ListTile(
                                          dense: true,
                                          title: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                    flex: 2,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                              flex: 1,
                                                              child: Text(
                                                                  match
                                                                      .home.name,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  softWrap:
                                                                      false)),
                                                          SizedBox(width: 8),
                                                          Flexible(
                                                              flex: 0,
                                                              child: match
                                                                      .home.logo
                                                                      .isNullOrEmpty()
                                                                  ? Image.asset(
                                                                      "assets/images/logo.png",
                                                                      width:
                                                                          iconSize,
                                                                      height:
                                                                          iconSize)
                                                                  : Image.network(
                                                                      match.home
                                                                          .logo,
                                                                      width:
                                                                          iconSize,
                                                                      height:
                                                                          iconSize))
                                                        ])),
                                                SizedBox(width: 5),
                                                Flexible(
                                                    flex: 1,
                                                    child: match.homeScore != null
                                                        ? Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                color: Color.fromRGBO(
                                                                    224, 224, 224, 1),
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            10.0))),
                                                            padding:
                                                                EdgeInsets.fromLTRB(
                                                                    10.0,
                                                                    5.0,
                                                                    10.0,
                                                                    5.0),
                                                            child: Text(
                                                                "${match.homeScore} - ${match.awayScore}",
                                                                style: TextStyle(color: Colors.black87)))
                                                        : Text(" - ")),
                                                SizedBox(width: 5),
                                                Flexible(
                                                    flex: 2,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                              flex: 0,
                                                              child: match
                                                                      .away.logo
                                                                      .isNullOrEmpty()
                                                                  ? Image.asset(
                                                                      "assets/images/logo.png",
                                                                      width:
                                                                          iconSize,
                                                                      height:
                                                                          iconSize)
                                                                  : Image.network(
                                                                      match.away
                                                                          .logo,
                                                                      width:
                                                                          iconSize,
                                                                      height:
                                                                          iconSize)),
                                                          SizedBox(width: 8),
                                                          Flexible(
                                                              flex: 1,
                                                              child: Text(
                                                                  match
                                                                      .away.name,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  softWrap:
                                                                      false)),
                                                        ])),
                                              ]),
                                          onTap: () => null);
                                    })
                              ]);
                            }),
                      )),
                  Card(
                      elevation: 5,
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0)),
                      child: Flex(
                          direction: Axis.horizontal,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NumberPicker.horizontal(
                                initialValue: matchDay.matchDay,
                                minValue: 1,
                                maxValue: 38,
                                zeroPad: true,
                                decoration: new BoxDecoration(
                                  border: new Border.all(style: BorderStyle.solid, color: Colors.white,),
                                ),
                                onChanged: (newValue) =>
                                    footballService.selectMatchDay(newValue))
                          ]))
                ]);
          } else {
            return LoadingIndicator();
          }
        });
  }
}
