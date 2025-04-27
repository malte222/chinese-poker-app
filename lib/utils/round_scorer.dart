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

    if (!valid1 && !valid2) return (0, 0);
    if (!valid1) return (-6, 6);
    if (!valid2) return (6, -6);

    int score1 = 0;
    int score2 = 0;
    int p1Wins = 0;
    int p2Wins = 0;

    // Front-Row Vergleich
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

    // Middle-Row Vergleich
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

    // Back-Row Vergleich
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

    // Bonuspunkte für einen Scoop (3 von 3 Reihen gewonnen)
    if (p1Wins == 3) score1 += 3;
    if (p2Wins == 3) score2 += 3;

    // Royalties berechnen
    final royalties1 = RoyaltyCalculator.calculateRoyalties(
      front: front1.cast<String>(),
      middle: middle1.cast<String>(),
      back: back1.cast<String>(),
    );
    final royalties2 = RoyaltyCalculator.calculateRoyalties(
      front: front2.cast<String>(),
      middle: middle2.cast<String>(),
      back: back2.cast<String>(),
    );

    final int totalRoyalties1 = royalties1.values.fold<int>(
      0,
      (sum, val) => sum + val,
    );
    final int totalRoyalties2 = royalties2.values.fold<int>(
      0,
      (sum, val) => sum + val,
    );

    score1 += totalRoyalties1;
    score2 += totalRoyalties2;

    return (score1, score2);
  }
}
