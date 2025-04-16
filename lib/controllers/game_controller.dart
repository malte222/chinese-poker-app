// lib/controllers/game_controller.dart
import 'dart:math';
import '../models/card_model.dart';
import '../models/game_state.dart';
import '../models/player_model.dart';

class GameController {
  late GameState gameState;

  GameController() {
    _initializeGame();
  }

  void _initializeGame() {
    // Erstelle und mische ein Deck
    List<String> suits = ['C', 'D', 'H', 'S'];
    List<String> ranks = [
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'T',
      'J',
      'Q',
      'K',
      'A',
    ];
    List<CardModel> deck = [
      for (var s in suits)
        for (var r in ranks) CardModel(rank: r, suit: s),
    ];
    deck.shuffle(Random());

    // Erstelle Spieler
    PlayerModel player1 = PlayerModel(name: 'Spieler 1');
    PlayerModel player2 = PlayerModel(name: 'Spieler 2');

    // Runde 1: 5 Karten an beide Spieler
    player1.hand = deck.sublist(0, 5);
    player2.hand = deck.sublist(5, 10);
    deck = deck.sublist(10);

    gameState = GameState(
      round: 1,
      currentPlayer: 1,
      deck: deck,
      player1: player1,
      player2: player2,
    );
  }

  // Beispielmethoden:
  void placeCard({
    required int playerNum,
    required String cardCode,
    required String row, // "front", "middle", "back"
    required int slotIndex,
    // Falls ab Runde 2, tracke neue Platzierung
    bool isNewPlacement = false,
  }) {
    PlayerModel player = playerNum == 1 ? gameState.player1 : gameState.player2;
    // Logic: Nur in leere Slots legen, dann Karte aus der Hand entfernen
    List<CardModel?> targetRow;
    if (row == 'front') {
      targetRow = player.front;
    } else if (row == 'middle') {
      targetRow = player.middle;
    } else {
      targetRow = player.back;
    }
    if (targetRow[slotIndex] == null) {
      // Entferne Karte aus der Hand
      player.hand.removeWhere((card) => card.code == cardCode);
      // Füge Karte in Slot
      targetRow[slotIndex] = CardModel.fromCode(cardCode);
      if (isNewPlacement) {
        player.newPlacements.add(slotIndex);
      }
    }
  }

  void endTurn() {
    // Logik zum Wechseln des Spielers, Ziehen neuer Karten etc.
    // Hier würdest du deinen bisherigen _endTurn()-Code einbauen.
  }
}
