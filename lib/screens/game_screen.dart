import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../widgets/board_widget.dart';
import '../widgets/hand_widget.dart';
import '../widgets/rules_dialog.dart';
import '../widgets/score_dialog.dart';

class GameScreen extends StatelessWidget {
  final int playerCount;
  const GameScreen({super.key, required this.playerCount});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final isP1 = game.currentPlayer == 1;

    // Slot‐Daten für aktive/ inaktive Spieler
    final activeFront = isP1 ? game.player1Front : game.player2Front;
    final activeMiddle = isP1 ? game.player1Middle : game.player2Middle;
    final activeBack = isP1 ? game.player1Back : game.player2Back;
    final activeHand = isP1 ? game.player1Hand : game.player2Hand;

    final inactiveFront = isP1 ? game.player2Front : game.player1Front;
    final inactiveMiddle = isP1 ? game.player2Middle : game.player1Middle;
    final inactiveBack = isP1 ? game.player2Back : game.player1Back;

    final w = game.cardWidth;
    final h = game.cardHeight;

    if (game.isRoundOver) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Spieler 1
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Spieler 1 (${game.lastRoundScorePlayer1 >= 0 ? '+' : ''}${game.lastRoundScorePlayer1})",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  BoardWidget(
                    front: game.player1Front,
                    middle: game.player1Middle,
                    back: game.player1Back,
                    isSlotDraggable: (_, __) => false,
                    onCardDropped: (_, __, ___) {},
                    slotWidth: game.cardWidth,
                    slotHeight: game.cardHeight,
                  ),
                ],
              ),

              // Spieler 2
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Spieler 2 (${game.lastRoundScorePlayer2 >= 0 ? '+' : ''}${game.lastRoundScorePlayer2})",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  BoardWidget(
                    front: game.player2Front,
                    middle: game.player2Middle,
                    back: game.player2Back,
                    isSlotDraggable: (_, __) => false,
                    onCardDropped: (_, __, ___) {},
                    slotWidth: game.cardWidth,
                    slotHeight: game.cardHeight,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<GameController>().startNextRound();
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Neue Runde starten"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // pro Slot prüfen, ob er aktuell drag-fähig sein soll:
    bool isSlotDraggable(String row, int idx) {
      // 1) Nur im aktiven Board:
      if ((isP1 && game.currentPlayer != 1) ||
          (!isP1 && game.currentPlayer != 2)) {
        return false;
      }

      // Shortcut auf die Slot-Listen
      final slotArray =
          {
            'front': activeFront,
            'middle': activeMiddle,
            'back': activeBack,
          }[row]!;

      // R1: solange Spieler noch nicht bestätigt hat, darf alles verschoben werden
      if (game.round == 1) {
        return true;
      }

      // Ab R2: nur leere Slots (für neue Platzierung) oder
      // schon in dieser Runde gelegte Slots („neue Platzierungen“) sind drag-fähig.
      final placements =
          isP1 ? game.player1NewPlacements : game.player2NewPlacements;

      // 2a) Leerer Slot und noch weniger als 2 neue Karten gelegt → darf legen
      if (slotArray[idx] == null && placements.length < 2) {
        return true;
      }

      // 2b) Bereits in dieser Runde platzierter Slot → darf zwischen den neuen Plätzten verschoben werden
      if (slotArray[idx] != null && placements.contains(idx)) {
        return true;
      }

      // Alles andere (alte, fixierte Slots) bleibt undraggable
      return false;
    }

    // Hand‐ oder Button‐Anzeige analog deiner bisherigen Logik
    Widget handArea;
    if (game.round == 1) {
      handArea =
          activeHand.isNotEmpty
              ? HandWidget(
                hand: activeHand,
                draggable: true,
                cardWidth: w,
                cardHeight: h,
              )
              : SizedBox(
                height: h + 8,
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
                height: h + 8,
                child: ElevatedButton.icon(
                  onPressed: game.endTurn,
                  icon: const Icon(Icons.check),
                  label: const Text("Zug beenden"),
                ),
              )
              : HandWidget(
                hand: activeHand,
                draggable: true,
                cardWidth: w,
                cardHeight: h,
              );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Inaktives, fixiertes Board
          Positioned(
            left: 20,
            top: 74,
            child: BoardWidget(
              front: inactiveFront,
              middle: inactiveMiddle,
              back: inactiveBack,
              slotWidth: w,
              slotHeight: h,
              // keine Drops hier
              onCardDropped: (_, __, ___) {},
              isSlotDraggable: (_, __) => false,
            ),
          ),

          // Aktives Board
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
                  slotWidth: w,
                  slotHeight: h,

                  // Callback nur ausführen, wenn isSlotDraggable true liefert:
                  onCardDropped: (card, row, idx) {
                    if (!isSlotDraggable(row, idx)) return;
                    game.placeCard(
                      player: game.currentPlayer,
                      cardCode: card,
                      row: row,
                      slotIndex: idx,
                      isNewPlacement: game.round >= 2,
                    );
                  },

                  isSlotDraggable: isSlotDraggable,
                ),

                const SizedBox(height: 8),
                handArea,
              ],
            ),
          ),
          // ℹ️ Info-Button rechts oben
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const RulesDialog(),
                );
              },
            ),
          ),
          // Listen-Button links oben (für Scores)
          Positioned(
            left: 10,
            top: 40,
            child: IconButton(
              icon: const Icon(Icons.list),
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const ScoreDialog(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
