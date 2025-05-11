import 'dart:math';
import 'package:flutter/material.dart';
import '/utils/round_scorer.dart';
import '/utils/logger.dart';

/// Spiel-Controller mit allen Logiken für Pineapple OFC.
class GameController extends ChangeNotifier {
  /// Das Karten-Deck als Liste von Codes (z.B. "2C", "KH").
  late List<String> deck;

  /// Aktueller Spieler (1 oder 2).
  int currentPlayer = 1;

  /// Aktuelle Runde: 1 = erste 5 Karten, ab 2 = je 3 Karten pro Zug.
  int round = 1;

  int round1StartPlayer = 1;

  /// Flags, ob Spieler Runde 1 abgeschlossen haben.
  bool player1Finished = false;
  bool player2Finished = false;

  /// Hände der Spieler.
  List<String> player1Hand = [];
  List<String> player2Hand = [];

  /// Fixierte Boards (Front: 3, Middle: 5, Back: 5) je Spieler.
  List<String?> player1Front = List.filled(3, null);
  List<String?> player1Middle = List.filled(5, null);
  List<String?> player1Back = List.filled(5, null);
  List<String?> player2Front = List.filled(3, null);
  List<String?> player2Middle = List.filled(5, null);
  List<String?> player2Back = List.filled(5, null);

  /// Tracker für neue Platzierungen ab Runde 2 (max 2 pro Zug).
  List<int> player1NewPlacements = [];
  List<int> player2NewPlacements = [];

  List<int> player1Scores = [];
  List<int> player2Scores = [];

  int lastRoundScorePlayer1 = 0;
  int lastRoundScorePlayer2 = 0;

  bool lastRoundCalculated = false;

  /// Standard-Kartengrößen für das UI.
  final double cardWidth = 45;
  final double cardHeight = 68;

  /// Konstruktor: startet das Spiel sofort.
  GameController() {
    _startGame();
  }

  /// Initialisiert und mischt das Deck, verteilt die ersten 5 Karten.
  void _startGame() {
    final suits = ['c', 'd', 'h', 's'];
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
    Logger.log('New game started. Deck was shuffled');
    lastRoundCalculated = false;
    player1Hand = deck.sublist(0, 5);
    player2Hand = deck.sublist(5, 10);
    deck = deck.sublist(10);

    notifyListeners();
  }

  void startNextRound() {
    // Alles zurücksetzen
    player1Hand.clear();
    player2Hand.clear();

    player1Front = List.filled(3, null);
    player1Middle = List.filled(5, null);
    player1Back = List.filled(5, null);
    player2Front = List.filled(3, null);
    player2Middle = List.filled(5, null);
    player2Back = List.filled(5, null);

    player1NewPlacements = [];
    player2NewPlacements = [];

    lastRoundCalculated = false;

    // Startspieler wechselt!
    currentPlayer = currentPlayer == 1 ? 2 : 1;
    round1StartPlayer = currentPlayer;

    round = 1;

    player1Finished = false;
    player2Finished = false;

    lastRoundScorePlayer1 = 0;
    lastRoundScorePlayer2 = 0;

    // Jetzt gezielt neu Karten austeilen:
    final suits = ['c', 'd', 'h', 's'];
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

    player1Hand = deck.sublist(0, 5);
    player2Hand = deck.sublist(5, 10);
    deck = deck.sublist(10);

    notifyListeners();
  }

  /// Ab Runde 2: Verteilt drei neue Karten an den angegebenen Spieler.
  void _drawNewHand(int player) {
    int count = 3;
    if (deck.length < count) {
      count = deck.length;
    }
    if (player == 1) {
      player1Hand = deck.sublist(0, count);
    } else {
      player2Hand = deck.sublist(0, count);
    }
    deck = deck.sublist(count);
    notifyListeners();
  }

  /// Platzieren oder Verschieben einer Karte im angegebenen Slot.
  /// - Erkennt automatisch, ob die Karte aus der Hand oder aus einem Slot kommt.
  /// - Tauscht bei Ziel­belegung, verschiebt sonst.
  /// - Optional als neue Platzierung (für Runde >=2).
  void placeCard({
    required int player,
    required String cardCode,
    required String row, // 'front' | 'middle' | 'back'
    required int slotIndex,
    bool isNewPlacement = false,
  }) {
    // 1) Hand- und Slot-Referenzen je Spieler
    final hand = player == 1 ? player1Hand : player2Hand;
    final mapSlots = <String, List<String?>>{
      'front': player == 1 ? player1Front : player2Front,
      'middle': player == 1 ? player1Middle : player2Middle,
      'back': player == 1 ? player1Back : player2Back,
    };

    final targetSlots = mapSlots[row]!;

    // 2) Finde heraus, ob die Karte aktuell in einem Slot liegt
    String? sourceRow;
    int? sourceIndex;
    mapSlots.forEach((r, slots) {
      final idx = slots.indexOf(cardCode);
      if (idx != -1) {
        sourceRow = r;
        sourceIndex = idx;
      }
    });
    final fromSlot = sourceRow != null;

    // 3) Erzeuge Copy von occupant, falls vorhanden
    final occupant = targetSlots[slotIndex];

    if (fromSlot) {
      // --- Verschieben zwischen Slots ---
      final srcSlots = mapSlots[sourceRow!]!;
      if (occupant != null) {
        // Swap: Karte A (cardCode) und Karte B (occupant) tauschen
        srcSlots[sourceIndex!] = occupant;
        targetSlots[slotIndex] = cardCode;
      } else {
        // Move: A aus src entfernen, nach target verschieben
        srcSlots[sourceIndex!] = null;
        targetSlots[slotIndex] = cardCode;
      }
    } else {
      // --- Ablegen aus der Hand ---
      if (!hand.contains(cardCode)) return; // Sicherheitscheck
      hand.remove(cardCode);

      if (occupant != null) {
        // Evict: Karte B zurück in die Hand, A hinein
        targetSlots[slotIndex] = cardCode;
        hand.add(occupant);
      } else {
        // Einfache Platzierung
        targetSlots[slotIndex] = cardCode;
      }

      // Markiere neue Platzierung (nur ab Runde 2 relevant)
      if (isNewPlacement) {
        if (player == 1) {
          player1NewPlacements.add(slotIndex);
        } else {
          player2NewPlacements.add(slotIndex);
        }
      }
    }

    notifyListeners();
  }

  /// Beendet den aktuellen Zug und wechselt Spieler/Runde gemäß den Pineapple OFC-Regeln.
  void endTurn() {
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
          currentPlayer = round1StartPlayer;
          _drawNewHand(currentPlayer);
        } else {
          currentPlayer = 1;
        }
      }
    } else {
      final currentPlacements =
          currentPlayer == 1 ? player1NewPlacements : player2NewPlacements;
      if (currentPlacements.length == 2) {
        if (currentPlayer == 1 && player1Hand.length == 1) {
          player1Hand.clear();
        } else if (currentPlayer == 2 && player2Hand.length == 1) {
          player2Hand.clear();
        }

        if (currentPlayer == 1) {
          player1NewPlacements = [];
          currentPlayer = 2;
          _drawNewHand(2); // explizit hier
        } else {
          player2NewPlacements = [];
          currentPlayer = 1;
          round++;
          _drawNewHand(1);
        }
      }
    }
    notifyListeners();
    if (isRoundOver) {
      final (p1, p2) = RoundScorer.calculate(
        front1: player1Front,
        middle1: player1Middle,
        back1: player1Back,
        front2: player2Front,
        middle2: player2Middle,
        back2: player2Back,
      );

      lastRoundScorePlayer1 = p1;
      lastRoundScorePlayer2 = p2;

      player1Scores.add(p1);
      player2Scores.add(p2);
      lastRoundCalculated = true;
      notifyListeners();
    }
  }

  /// Gibt true zurück, wenn alle Slots beider Spieler nicht mehr null sind.
  bool get isRoundOver {
    // sammle alle Slots beider Spieler
    final slots1 = [...player1Front, ...player1Middle, ...player1Back];
    final slots2 = [...player2Front, ...player2Middle, ...player2Back];
    // prüfe, ob irgendwo noch null ist
    return !slots1.contains(null) && !slots2.contains(null);
  }
}
