import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:maphia_game/game2.dart';
import 'package:maphia_game/home.dart';

void main() => runApp(const MyApp());

class MyApp extends HookWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<IO.Socket> socket = useState(IO.io(
        'https://maphiagame-apps.electro-magnet45.repl.co',
        IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
            {'key': 'ad@h&120p78u9'}).build()));
    return MaterialApp(
        title: 'Maphia Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => Home(socket),
          '/game2': (BuildContext context) => Game2(socket)
        });
  }
}
