// lib/models/game_state.dart
import 'player_model.dart';
import 'card_model.dart';

class GameState {
  int round;
  int currentPlayer; // 1 oder 2
  List<CardModel> deck;
  PlayerModel player1;
  PlayerModel player2;

  GameState({
    required this.round,
    required this.currentPlayer,
    required this.deck,
    required this.player1,
    required this.player2,
  });
}
