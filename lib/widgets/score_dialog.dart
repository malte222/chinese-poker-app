import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';

class ScoreDialog extends StatelessWidget {
  const ScoreDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final p1 = game.player1Scores;
    final p2 = game.player2Scores;
    final rounds = p1.length;

    return AlertDialog(
      backgroundColor: Colors.black87,
      title: const Text('Punktestand', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: rounds + 1,
          itemBuilder: (context, index) {
            if (index < rounds) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Runde ${index + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "P1: ${p1[index]} | P2: ${p2[index]}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              );
            } else {
              final sum1 = p1.fold(0, (a, b) => a + b);
              final sum2 = p2.fold(0, (a, b) => a + b);
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Summe",
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "P1: $sum1 | P2: $sum2",
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Schließen', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
