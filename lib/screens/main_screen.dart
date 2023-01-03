import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:memory_game/screens/edit_game_screen.dart';
import 'package:memory_game/screens/load_game_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
              child: Text(
            "Memory Game",
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          )),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return EditGameScreen();
                    }));
                  },
                  child: Text("Create a new game")),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return LoadGameScreen();
                    }));
                  },
                  child: Text("Load game"))
            ],
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
