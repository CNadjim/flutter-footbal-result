import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:custom_navigator/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:football_result/src/app.route.dart';
import 'package:football_result/src/page/config.page.dart';
import 'package:football_result/src/page/home.page.dart';
import 'package:football_result/src/page/subscription.page.dart';
import 'package:football_result/src/service/football.service.dart';
import 'package:football_result/src/widget/loading.widget.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Football Result",
        theme: ThemeData.dark(),
        routes: {
          AppRoute.home: (context) {
            return buildRoute(context, HomePage());
          },
          AppRoute.subscription: (context) {
            return buildRoute(context, SubscriptionPage());
          },
          AppRoute.config: (context) {
            return buildRoute(context, ConfigPage());
          }
        });
  }

  Widget buildRoute(BuildContext context, Widget widget) {
    final footballService = BlocProvider.getBloc<FootballService>();
    final List<Widget> pages = [HomePage(), SubscriptionPage(), ConfigPage()];
    return StreamBuilder(
        stream: footballService.streamOfPage,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final int index = snapshot.data;
            return CustomScaffold(
              scaffold: Scaffold(
                  body: pages[index],
                  bottomNavigationBar: BottomNavigationBar(
                      onTap: (value) => footballService.selectPage(value),
                      currentIndex: index,
                      items: [
                        new BottomNavigationBarItem(icon: new Icon(Icons.view_list), title: new Text("Compétitions")),
                        new BottomNavigationBarItem(icon: new Icon(Icons.star), title: new Text("Abonements")),
                        new BottomNavigationBarItem(icon: new Icon(Icons.settings), title: new Text("Paramètres"))
                      ])),
              children: pages,
              onItemTap: (value) => footballService.selectPage(value),
            );
          } else {
            return LoadingIndicator();
          }
        });
  }
}
