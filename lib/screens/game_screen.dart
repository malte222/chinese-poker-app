import 'package:flutter/material.dart';
import '../widgets/board_widget.dart';
import '../widgets/hand_widget.dart';

class GameScreen extends StatefulWidget {
  final int playerCount;
  const GameScreen({super.key, required this.playerCount});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> deck;

  // Aktueller Spieler: 1 oder 2
  int currentPlayer = 1;
  // Runde 1: 5 Karten; ab Runde 2: 3 neue Karten pro Zug
  int round = 1;

  // Flags, ob Spieler Runde 1 abgeschlossen haben.
  bool player1Finished = false;
  bool player2Finished = false;

  // Hände (als Liste von Kartencodes, z.B. "2C", "KD")
  List<String> player1Hand = [];
  List<String> player2Hand = [];

  // Fixierte Boards – insgesamt 13 Slots:
  // Front: 3, Middle: 5, Back: 5.
  // Diese Karten stammen aus abgeschlossenen Runden und sind fix.
  List<String?> player1Front = List.filled(3, null);
  List<String?> player1Middle = List.filled(5, null);
  List<String?> player1Back = List.filled(5, null);
  List<String?> player2Front = List.filled(3, null);
  List<String?> player2Middle = List.filled(5, null);
  List<String?> player2Back = List.filled(5, null);

  // Für Runde >= 2: Tracker, in welche Slots in der aktuellen Runde neue Karten gelegt wurden.
  // Pro Zug dürfen genau 2 neue Karten platziert werden.
  List<int> player1NewPlacements = [];
  List<int> player2NewPlacements = [];

  // Kartengrößen (werden später auch an die Widgets weitergegeben)
  final double cardWidth = 45;
  final double cardHeight = 68;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  // Erstelle und mische das Deck, verteile in Runde 1 jeweils 5 Karten an beide Spieler.
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
    deck.shuffle();
    player1Hand = deck.sublist(0, 5);
    player2Hand = deck.sublist(5, 10);
    deck = deck.sublist(10);
  }

  /// Ab Runde 2: Ziehe 3 neue Karten für den aktiven Spieler.
  void _drawNewHand(int player) {
    int count = 3;
    if (deck.length < count) count = deck.length;
    if (player == 1) {
      player1Hand = deck.sublist(0, count);
    } else {
      player2Hand = deck.sublist(0, count);
    }
    deck = deck.sublist(count);
  }

  /// Steuert den Zugwechsel.
  /// • In Runde 1: Jeder Spieler legt seine 5 Karten. Sobald der aktive Spieler seine Hand leer hat, wird sein Zug beendet.
  ///   Erst wenn beide Spieler ihre Runde 1 abgeschlossen haben, wechselt das Spiel in Runde 2.
  /// • Ab Runde 2: Der aktive Spieler bekommt 3 neue Karten. Er muss genau 2 davon auf sein Board legen.
  ///   Sobald in der Hand nur 1 Karte übrig bleibt, erscheint der Button; beim Drücken wird diese verbleibende Karte verbrannt.
  void _endTurn() {
    setState(() {
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
          // Burn die verbleibende Karte, falls vorhanden.
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
    });
  }

  /// Baut das aktive Board des aktiven Spielers.
  /// Dieses Widget zeigt das Board (über BoardWidget) und den Handbereich (über HandWidget).
  Widget buildActiveBoard() {
    final isPlayer1 = currentPlayer == 1;
    // Wähle die Slot-Daten für den aktiven Spieler.
    final front = isPlayer1 ? player1Front : player2Front;
    final middle = isPlayer1 ? player1Middle : player2Middle;
    final back = isPlayer1 ? player1Back : player2Back;
    // Wähle die Hand-Karten für den aktiven Spieler.
    final activeHand = isPlayer1 ? player1Hand : player2Hand;

    // Für den Board-Bereich nutzen wir BoardWidget.
    final board = BoardWidget(
      front: front,
      middle: middle,
      back: back,
      canDrag:
          true, // Während des aktiven Zugs sollen alle Karten verschiebbar sein.
      slotWidth: cardWidth,
      slotHeight: cardHeight,
    );

    // HandWidget zeigt die Hand-Karten. Sobald alle Karten abgelegt sind (bei Runde 1 hand ist leer,
    // oder in Runde 2, wenn 2 neue Karten platziert wurden – d.h. hand.length == 1),
    // erscheint stattdessen der Button.
    Widget handArea;
    if (round == 1) {
      handArea =
          activeHand.isNotEmpty
              ? HandWidget(
                hand: activeHand,
                draggable: true,
                cardWidth: cardWidth,
                cardHeight: cardHeight,
              )
              : Container(
                height: cardHeight + 8,
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: _endTurn,
                  icon: const Icon(Icons.check),
                  label: const Text("Zug beenden"),
                ),
              );
    } else {
      handArea =
          activeHand.length == 1
              ? Container(
                height: cardHeight + 8,
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: _endTurn,
                  icon: const Icon(Icons.check),
                  label: const Text("Zug beenden"),
                ),
              )
              : HandWidget(
                hand: activeHand,
                draggable: true,
                cardWidth: cardWidth,
                cardHeight: cardHeight,
              );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isPlayer1 ? "Spieler 1" : "Spieler 2",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        board,
        const SizedBox(height: 8),
        handArea,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Das fixierte Board des inaktiven Spielers (alle Züge aus vorherigen Runden)
          Positioned(
            left: 20,
            top: 40,
            child: BoardWidget(
              front: currentPlayer == 1 ? player2Front : player1Front,
              middle: currentPlayer == 1 ? player2Middle : player1Middle,
              back: currentPlayer == 1 ? player2Back : player1Back,
              canDrag: false,
              slotWidth: cardWidth,
              slotHeight: cardHeight,
            ),
          ),
          // Das aktive Board in der Mitte
          Align(alignment: Alignment.center, child: buildActiveBoard()),
        ],
      ),
    );
  }
}
