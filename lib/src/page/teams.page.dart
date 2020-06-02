import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:football_result/src/extension/extension.dart';
import 'package:football_result/src/model/team.model.dart';
import 'package:football_result/src/service/football.service.dart';
import 'package:football_result/src/widget/loading.widget.dart';

class TeamPage extends StatelessWidget {
  final footballService = BlocProvider.getBloc<FootballService>();
  final iconSize = 100.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: footballService.streamOfTeams,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<Team> teams = snapshot.data;
                return RefreshIndicator(
                    onRefresh: () => footballService.fetchTeams(),
                    child: ListView.separated(
                        separatorBuilder: (context, index) =>  Divider(height: 0),
                        itemCount: teams.length,
                        itemBuilder: (BuildContext context, int index) {
                          final team = teams[index];
                          return  ListTile(
                            dense: false,
                            contentPadding:  EdgeInsets.only(right: 20.0),
                            leading:  team.logo.isNullOrEmpty() ? Image.asset("assets/images/logo.png", width: iconSize, height: iconSize) : Image.network(team.logo, width: iconSize, height: iconSize),
                            title: Text(team.name),
                              subtitle: Text(team.shortName),
                            trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () => null
                          );
                        }));
              } else {
                return LoadingIndicator();
              }
            }));
  }
}
