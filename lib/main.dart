import 'package:flutter/material.dart';
import 'package:maphia_game/game2.dart';
import 'package:maphia_game/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Maphia Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => const Home(),
          '/game2': (BuildContext context) => const Game2()
        });
  }
}
