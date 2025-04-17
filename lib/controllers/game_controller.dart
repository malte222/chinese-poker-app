// lib/controllers/game_controller.dart
import 'dart:math';
import 'package:flutter/material.dart';

class GameController extends ChangeNotifier {
  // Beispielhafte Felder, die du aus deiner bisherigen Logik übernehmen kannst.
  late List<String> deck;
  int currentPlayer = 1;
  int round = 1;
  bool player1Finished = false;
  bool player2Finished = false;

  // Hände als Liste von Kartencodes, z. B. "2C", "KD", etc.
  List<String> player1Hand = [];
  List<String> player2Hand = [];

  // Fixierte Boards als Listen von String? (13 Slots)
  List<String?> player1Front = List.filled(3, null);
  List<String?> player1Middle = List.filled(5, null);
  List<String?> player1Back = List.filled(5, null);
  List<String?> player2Front = List.filled(3, null);
  List<String?> player2Middle = List.filled(5, null);
  List<String?> player2Back = List.filled(5, null);

  // Tracker für neue Platzierungen ab Runde 2
  List<int> player1NewPlacements = [];
  List<int> player2NewPlacements = [];

  // Kartengrößen (für UI-Komponenten)
  final double cardWidth = 45;
  final double cardHeight = 68;

  GameController() {
    _startGame();
  }

  void _startGame() {
    final suits = ['C', 'D', 'H', 'S'];
    final ranks = [
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
    deck = [
      for (var s in suits)
        for (var r in ranks) '$r$s',
    ];
    deck.shuffle(Random());
    // Runde 1: 5 Karten für beide Spieler
    player1Hand = deck.sublist(0, 5);
    player2Hand = deck.sublist(5, 10);
    deck = deck.sublist(10);
    notifyListeners();
  }

  void _drawNewHand(int player) {
    int count = 3;
    if (deck.length < count) count = deck.length;
    if (player == 1) {
      player1Hand = deck.sublist(0, count);
    } else {
      player2Hand = deck.sublist(0, count);
    }
    deck = deck.sublist(count);
    notifyListeners();
  }

  // Beispielmethode: Endturn, die den Zustand ändert.
  void endTurn() {
    // Hier implementierst du deine bestehende Logik (aus _endTurn) und rufst notifyListeners() am Ende auf.
    // Beispiel (stark vereinfacht):
    if (round == 1) {
      if (currentPlayer == 1 && player1Hand.isEmpty) {
        player1Finished = true;
        currentPlayer = 2;
      } else if (currentPlayer == 2 && player2Hand.isEmpty) {
        player2Finished = true;
        if (player1Finished && player2Finished) {
          round = 2;
          player1NewPlacements = [];
          player2NewPlacements = [];
          currentPlayer = 1;
          _drawNewHand(1);
        } else {
          currentPlayer = 1;
        }
      }
    } else {
      List<int> currentPlacements =
          currentPlayer == 1 ? player1NewPlacements : player2NewPlacements;
      if (currentPlacements.length == 2) {
        if (currentPlayer == 1 && player1Hand.length == 1) {
          player1Hand.clear();
        } else if (currentPlayer == 2 && player2Hand.length == 1) {
          player2Hand.clear();
        }
        if (currentPlayer == 1) {
          player1NewPlacements = [];
        } else {
          player2NewPlacements = [];
        }
        currentPlayer = currentPlayer == 1 ? 2 : 1;
        round++;
        _drawNewHand(currentPlayer);
      }
    }
    notifyListeners();
  }

  // Weitere Methoden zur Handhabung von Kartenplatzierungen (placeCard, moveCard, etc.)
}
