// lib/utils/round_scorer.dart
import 'package:poker_solver/poker_solver.dart';
import 'hand_validator.dart';
import 'royalty_calculator.dart';
import 'front_hand_evaluator.dart';

class RoundScorer {
  static (int, int) calculate({
    required List<String?> front1,
    required List<String?> middle1,
    required List<String?> back1,
    required List<String?> front2,
    required List<String?> middle2,
    required List<String?> back2,
  }) {
    // 1. Prüfen ob gültig
    final valid1 = HandValidator.isValidHand(
      front: front1.cast<String>(),
      middle: middle1.cast<String>(),
      back: back1.cast<String>(),
    );
    final valid2 = HandValidator.isValidHand(
      front: front2.cast<String>(),
      middle: middle2.cast<String>(),
      back: back2.cast<String>(),
    );

    // 2. Beide foul → sofort 0/0
    if (!valid1 && !valid2) {
      return (0, 0);
    }

    // 3. Royalties für gültige Spieler berechnen
    int royalties1 = 0;
    int royalties2 = 0;

    if (valid1) {
      final r1 = RoyaltyCalculator.calculateRoyalties(
        front: front1.cast<String>(),
        middle: middle1.cast<String>(),
        back: back1.cast<String>(),
      );
      royalties1 = r1.values.fold<int>(0, (sum, val) => sum + val);
    }

    if (valid2) {
      final r2 = RoyaltyCalculator.calculateRoyalties(
        front: front2.cast<String>(),
        middle: middle2.cast<String>(),
        back: back2.cast<String>(),
      );
      royalties2 = r2.values.fold<int>(0, (sum, val) => sum + val);
    }

    // 4. Wenn nur einer foul → sofort Ergebnis mit Royalties
    if (!valid1 && valid2) {
      return (-6 - royalties2, 6 + royalties2);
    }

    if (valid1 && !valid2) {
      return (6 + royalties1, -6 - royalties1);
    }

    // 5. Beide gültig → Reihen vergleichen
    int score1 = 0;
    int score2 = 0;
    int p1Wins = 0;
    int p2Wins = 0;

    // Front-Row
    final frontResult = FrontHandEvaluator.compare(
      front1.cast<String>(),
      front2.cast<String>(),
    );
    if (frontResult > 0) {
      score1 += 1;
      score2 -= 1;
      p1Wins++;
    } else if (frontResult < 0) {
      score1 -= 1;
      score2 += 1;
      p2Wins++;
    }

    // Middle-Row
    final mid1 = Hand.solveHand(middle1.cast<String>());
    final mid2 = Hand.solveHand(middle2.cast<String>());
    final midWinners = Hand.winners([mid1, mid2]);
    if (midWinners.contains(mid1) && !midWinners.contains(mid2)) {
      score1 += 1;
      score2 -= 1;
      p1Wins++;
    } else if (midWinners.contains(mid2) && !midWinners.contains(mid1)) {
      score1 -= 1;
      score2 += 1;
      p2Wins++;
    }

    // Back-Row
    final back1Eval = Hand.solveHand(back1.cast<String>());
    final back2Eval = Hand.solveHand(back2.cast<String>());
    final backWinners = Hand.winners([back1Eval, back2Eval]);
    if (backWinners.contains(back1Eval) && !backWinners.contains(back2Eval)) {
      score1 += 1;
      score2 -= 1;
      p1Wins++;
    } else if (backWinners.contains(back2Eval) &&
        !backWinners.contains(back1Eval)) {
      score1 -= 1;
      score2 += 1;
      p2Wins++;
    }

    // 6. Scoop Bonus
    if (p1Wins == 3) {
      score1 += 3;
      score2 -= 3;
    }
    if (p2Wins == 3) {
      score1 -= 3;
      score2 += 3;
    }

    // 7. Royalties addieren
    score1 += royalties1;
    score1 -= royalties2;
    score2 += royalties2;
    score2 -= royalties1;

    return (score1, score2);
  }
}
