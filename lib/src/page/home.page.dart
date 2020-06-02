import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:football_result/src/page/competition.page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CompetitionPage()));
      },
      child: const Text('Enabled Button', style: TextStyle(fontSize: 20)),
    );
  }

}