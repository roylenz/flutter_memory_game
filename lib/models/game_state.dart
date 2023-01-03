import 'package:memory_game/models/card.dart';

class GameState {
  late Map<CardModel, CardModel> cardsToPairs;
  late List<CardModel> shuffledCards;

  GameState(Map<String, String> pairs) {
    cardsToPairs = {};
    for (var entry in pairs.entries) {
      CardModel cardA = CardModel(
        text: entry.key,
      );
      CardModel cardB = CardModel(
        text: entry.value,
      );
      cardsToPairs[cardA] = cardB;
      cardsToPairs[cardB] = cardA;
    }
    shuffledCards = cardsToPairs.keys.toList();
    shuffledCards.shuffle();
  }
}
