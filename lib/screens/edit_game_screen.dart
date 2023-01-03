import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:memory_game/models/game_state.dart';
import 'package:memory_game/screens/game_screen.dart';
import 'package:path_provider/path_provider.dart';

class EditGameScreen extends StatelessWidget {
  final Map<String, String>? game;
  const EditGameScreen({super.key, this.game});

  @override
  Widget build(BuildContext context) {
    List<MapEntry<TextEditingController, TextEditingController>> controllers =
        [];
    for (int i = 0; i < 10; i++) {
      controllers
          .add(MapEntry(TextEditingController(), TextEditingController()));
    }
    TextEditingController nameController = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    Text("Game Name:"),
                    Expanded(child: TextField(controller: nameController)),
                  ],
                ),
                for (int i = 0; i < 10; i++)
                  Row(
                    children: [
                      const Text("First:"),
                      Expanded(
                          child: TextField(
                        controller: controllers[i].key,
                      )),
                      const Text("Pair:"),
                      Expanded(
                          child: TextField(
                        controller: controllers[i].value,
                      ))
                    ],
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    _saveGame(context, nameController.text, controllers);
                  },
                  child: const Text("Save")),
              ElevatedButton(
                  onPressed: () async {
                    var pairs = await _saveGame(context, "last", controllers,
                        ignoreOverride: true);
                    if (pairs != null) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return GameScreen(gameState: GameState(pairs));
                      }));
                    }
                  },
                  child: const Text("Play")),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Back"))
            ],
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  Future<dynamic> errorDialog(BuildContext context, String title) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(title),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("ok"))
            ],
            actionsAlignment: MainAxisAlignment.spaceAround,
          );
        });
  }

  Future<Map<String, String>?> _saveGame(BuildContext context, String gameName,
      List<MapEntry<TextEditingController, TextEditingController>> controllers,
      {bool ignoreOverride = false}) async {
    Map<String, String> pairs = {};
    if (gameName.trim() == "") {
      errorDialog(context, "Game name cannot be empty or contain only spaces");
      return null;
    }
    for (var pair in controllers) {
      if (pair.key.text.trim() == "" || pair.value.text.trim() == "") {
        await errorDialog(context, "one or more of the cards isn't filled");
        return null;
      }
      pairs[pair.key.text] = pair.value.text;
    }
    Directory directory = (await getApplicationSupportDirectory());
    String path = "${directory.path}/${gameName.replaceAll(" ", "_")}.json";
    File file = File(path);
    if (!ignoreOverride && file.existsSync()) {
      print(path);
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text("Do you want to override the saved game?"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      file.writeAsStringSync(jsonEncode(pairs));
                      Navigator.of(context).pop();
                    },
                    child: const Text("Yes")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("No"))
              ],
              actionsAlignment: MainAxisAlignment.spaceAround,
            );
          });
      return null;
    }
    file.writeAsStringSync(jsonEncode(pairs));
    return pairs;
  }
}
