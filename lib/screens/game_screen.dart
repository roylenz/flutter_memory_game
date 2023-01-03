import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:memory_game/models/game_state.dart';

import '../models/card.dart';

class GameScreen extends StatefulWidget {
  final GameState gameState;
  const GameScreen({super.key, required this.gameState});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Map<CardModel, CardModel> cardsToPairs = {};
  CardModel? selectedCard;
  bool lock = false;
  int numOfCardsFlipped = 0;
  @override
  void initState() {
    cardsToPairs = widget.gameState.cardsToPairs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CardModel> cards = widget.gameState.shuffledCards;
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: GridView.count(
              crossAxisCount: 5,
              childAspectRatio: MediaQuery.of(context).size.aspectRatio,
              children: cards
                  .map((card) => InkWell(
                        child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: Center(
                                child: Text(card.isHidden ? "" : card.text))),
                        onTap: () async {
                          if (!lock) {
                            if (selectedCard == null && card.isHidden) {
                              selectedCard = card;
                              card.isHidden = !card.isHidden;
                              setState(() {});
                              return;
                            } else if (selectedCard != null &&
                                card != selectedCard &&
                                card.isHidden) {
                              lock = true;
                              card.isHidden = !card.isHidden;
                              setState(() {});
                              if (cardsToPairs[card]!.text !=
                                  selectedCard!.text) {
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                selectedCard!.isHidden = true;
                                card.isHidden = true;
                                setState(() {});
                              } else {
                                numOfCardsFlipped += 2;
                              }
                              lock = false;
                              selectedCard = null;
                            }
                          }
                        },
                      ))
                  .toList()),
        ),
        if (numOfCardsFlipped == cardsToPairs.length)
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Back")),
        SizedBox(
          height: 50,
        )
      ],
    ));
  }
}
