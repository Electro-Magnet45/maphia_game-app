import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Game2 extends HookWidget {
  const Game2(this.socket, {Key? key}) : super(key: key);
  final ValueNotifier<IO.Socket> socket;

  @override
  Scaffold build(BuildContext context) {
    final ValueNotifier<String> mode2 = useState<String>('inputMode');
    final ValueNotifier<Map> randItem2 = useState({'name': 'loading&*'});
    final ValueNotifier<List<bool>> disButton2 =
        useState<List<bool>>([false, false]);

    void connectToServer() {
      socket.value.on('randomItem2', (e) {
        disButton2.value[1] = false;
        randItem2.value = e;
      });
      socket.value.on("gameEnd2", (_) {
        mode2.value = 'inputMode';
        disButton2.value = <bool>[false, false];
        randItem2.value = {'name': 'loading&*'};
      });
    }

    void handleClear() => socket.value.emit('clearItems');

    void handlePlay(int index) {
      disButton2.value[index] = true;
      socket.value.emit('playGame2');
    }

    useEffect(() {
      connectToServer();
      return () {};
    }, []);

    return Scaffold(
        body: Center(
            child: mode2.value == 'inputMode'
                ? InputMode(
                    socket: socket.value, mode: mode2, handleClear: handleClear)
                : GameMode(
                    randItem: randItem2,
                    disButton: disButton2,
                    handlePlay: (int index) => handlePlay(index))));
  }
}

class GameMode extends HookWidget {
  const GameMode(
      {Key? key,
      required this.randItem,
      required this.handlePlay,
      required this.disButton})
      : super(key: key);
  final ValueNotifier<Map> randItem;
  final void Function(int) handlePlay;
  final ValueNotifier<List<bool>> disButton;

  @override
  Widget build(BuildContext context) {
    if (randItem.value['name'] == 'loading&*') {
      return ElevatedButton(
          onPressed: () => disButton.value[0] ? null : handlePlay(0),
          child: const Text('Start Game', style: TextStyle(fontSize: 24)));
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(randItem.value['name'],
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(randItem.value['type'], style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 40),
          ElevatedButton(
              onPressed: () => disButton.value[1] ? null : handlePlay(1),
              child: const Text('Next Level'))
        ]);
  }
}

class InputMode extends HookWidget {
  const InputMode(
      {Key? key,
      required this.socket,
      required this.mode,
      required this.handleClear})
      : super(key: key);
  final IO.Socket socket;
  final ValueNotifier<String> mode;
  final void Function() handleClear;

  void handleSubmit(
      ValueNotifier<String> newItem,
      ValueNotifier<String> itemType,
      ValueNotifier<String> mode,
      ValueNotifier<bool> submit) {
    if (newItem.value.isEmpty) return;
    submit.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    socket.emit('newItem', {'name': newItem.value, 'type': itemType.value});
    Future.delayed(
        const Duration(milliseconds: 1500), () => mode.value = 'gameMode');
  }

  @override
  Column build(BuildContext context) {
    final ValueNotifier<String> newItem = useState<String>('');
    final ValueNotifier<String> itemType = useState<String>('Name');
    final ValueNotifier<bool> submit = useState<bool>(false);
    final Size _size = MediaQuery.of(context).size;

    return Column(children: <Widget>[
      SizedBox(height: MediaQuery.of(context).padding.top + 20),
      const Text("Game 2", style: TextStyle(fontSize: 22)),
      const SizedBox(height: 20),
      Row(children: <TextButton>[
        TextButton(
            onPressed: () =>
                Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false),
            child: const Text('Go Back'))
      ]),
      GestureDetector(
        onLongPress: handleClear,
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.black),
            child: const Text('Clear Items',
                style: TextStyle(color: Colors.white))),
      ),
      const Spacer(),
      SizedBox(
          width: Platform.isAndroid ? _size.width - 60 : _size.width / 2,
          child: TextField(
              autofocus: true,
              onChanged: (String val) => newItem.value = val,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  hintText: "Item Name",
                  contentPadding: EdgeInsets.all(20)))),
      const SizedBox(height: 20),
      SizedBox(
          width: Platform.isAndroid ? _size.width - 160 : _size.width / 4,
          child: DropdownButtonFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(16)),
              value: itemType.value,
              onChanged: (e) => itemType.value = e.toString(),
              items: <String>['Name', 'Place', 'Animal', 'Thing']
                  .map<DropdownMenuItem<String>>((String e) =>
                      DropdownMenuItem<String>(value: e, child: Text(e)))
                  .toList())),
      const SizedBox(height: 60),
      ElevatedButton(
          onPressed: () => submit.value
              ? null
              : handleSubmit(newItem, itemType, mode, submit),
          child: const Text('Submit')),
      const Spacer()
    ]);
  }
}
