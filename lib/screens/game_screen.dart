// lib/screens/game_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../widgets/board_widget.dart';
import '../widgets/hand_widget.dart';

class GameScreen extends StatelessWidget {
  /// Anzahl der Spieler (2 oder 3)
  final int playerCount;

  const GameScreen({super.key, required this.playerCount});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    // aktuell unterstützen wir nur playerCount == 2,
    // später kannst du hier auf playerCount reagieren.
    final isPlayer1 = game.currentPlayer == 1;

    // … Rest bleibt unverändert …
    final slotW = game.cardWidth;
    final slotH = game.cardHeight;

    // Inaktives Board
    final inactiveFront = isPlayer1 ? game.player2Front : game.player1Front;
    final inactiveMiddle = isPlayer1 ? game.player2Middle : game.player1Middle;
    final inactiveBack = isPlayer1 ? game.player2Back : game.player1Back;

    // Aktives Board
    final activeFront = isPlayer1 ? game.player1Front : game.player2Front;
    final activeMiddle = isPlayer1 ? game.player1Middle : game.player2Middle;
    final activeBack = isPlayer1 ? game.player1Back : game.player2Back;
    final activeHand = isPlayer1 ? game.player1Hand : game.player2Hand;

    Widget handArea;
    if (game.round == 1) {
      handArea =
          activeHand.isNotEmpty
              ? HandWidget(
                hand: activeHand,
                draggable: true,
                cardWidth: slotW,
                cardHeight: slotH,
              )
              : SizedBox(
                height: slotH + 8,
                child: ElevatedButton.icon(
                  onPressed: game.endTurn,
                  icon: const Icon(Icons.check),
                  label: const Text("Zug beenden"),
                ),
              );
    } else {
      handArea =
          activeHand.length == 1
              ? SizedBox(
                height: slotH + 8,
                child: ElevatedButton.icon(
                  onPressed: game.endTurn,
                  icon: const Icon(Icons.check),
                  label: const Text("Zug beenden"),
                ),
              )
              : HandWidget(
                hand: activeHand,
                draggable: true,
                cardWidth: slotW,
                cardHeight: slotH,
              );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: 20,
            top: 40,
            child: BoardWidget(
              front: inactiveFront,
              middle: inactiveMiddle,
              back: inactiveBack,
              canDrag: false,
              slotWidth: slotW,
              slotHeight: slotH,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Spieler ${game.currentPlayer}',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 8),
                BoardWidget(
                  front: activeFront,
                  middle: activeMiddle,
                  back: activeBack,
                  canDrag: true,
                  slotWidth: slotW,
                  slotHeight: slotH,
                ),
                const SizedBox(height: 8),
                handArea,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
