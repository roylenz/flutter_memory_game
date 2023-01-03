import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:memory_game/models/game_state.dart';
import 'package:memory_game/screens/game_screen.dart';
import 'package:path_provider/path_provider.dart';

class LoadGameScreen extends StatefulWidget {
  const LoadGameScreen({super.key});

  @override
  State<LoadGameScreen> createState() => _LoadGameScreenState();
}

class _LoadGameScreenState extends State<LoadGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getSavedGames(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: Wrap(
                      children: (snapshot.data as Map<String, String>)
                          .entries
                          .map((game) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Do you want to delete this game?"),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      File(game.value)
                                                          .deleteSync();
                                                      setState(() {});
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Yes")),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("No")),
                                              ],
                                            );
                                          });
                                    },
                                    onPressed: () async {
                                      File gameFile = File(game.value);
                                      Map<String, String> pairs =
                                          Map<String, String>.from(jsonDecode(
                                              gameFile.readAsStringSync()));
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (context) {
                                        return GameScreen(
                                            gameState: GameState(pairs));
                                      }));
                                    },
                                    child: Text(game.key)),
                              ))
                          .toList()),
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Back")),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<Map<String, String>> _getSavedGames() async {
    Directory directory = (await getApplicationSupportDirectory());
    List<FileSystemEntity> games = directory.listSync();
    Map<String, String> gamesNames = {};
    for (var game in games) {
      gamesNames[_pathToGameName(game.path)] = game.path;
    }
    return gamesNames;
  }

  String _pathToGameName(String path) {
    return path
        .split("/")
        .last
        .split("\\")
        .last
        .replaceAll(".json", "")
        .replaceAll("_", " ");
  }
}
