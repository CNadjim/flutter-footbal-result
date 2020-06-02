
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/widgets.dart';
import 'package:football_result/src/service/football.service.dart';


class AppState extends StatelessWidget{
  final Widget child;

  AppState({this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc<FootballService>((_) => new FootballService())
      ],
      child: child,
    );
  }
}