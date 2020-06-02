import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:football_result/src/page/matches.page.dart';
import 'package:football_result/src/page/standings.page.dart';
import 'package:football_result/src/page/teams.page.dart';

class CompetitionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
              title: Text('Ligue 1'),
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: "Match"),
                  Tab(text: "Classement"),
                  Tab(text: "Equipe"),
                  Tab(text: "Statistique")
                ],
              )
          ),
          body: TabBarView(
            children: [
              MatchesPage(),
              StandingPage(),
              TeamPage(),
              TeamPage(),
            ],
          )
      ),
    );
  }

}