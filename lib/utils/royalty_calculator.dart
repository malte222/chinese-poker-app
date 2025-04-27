// lib/utils/royalty_calculator.dart
import 'package:poker_solver/poker_solver.dart';

class RoyaltyCalculator {
  static Map<String, int> calculateRoyalties({
    required List<String> front,
    required List<String> middle,
    required List<String> back,
  }) {
    final frontPoints = _calculateFrontRoyalties(front);
    final middlePoints = _calculateFiveCardRoyalties(middle, isMiddle: true);
    final backPoints = _calculateFiveCardRoyalties(back, isMiddle: false);

    return {'front': frontPoints, 'middle': middlePoints, 'back': backPoints};
  }

  static int _calculateFrontRoyalties(List<String> front) {
    if (front.length != 3) return 0;

    final ranks = front.map((card) => card[0]).toList();
    final rankCounts = <String, int>{};

    for (var r in ranks) {
      rankCounts[r] = (rankCounts[r] ?? 0) + 1;
    }

    if (rankCounts.length == 1) {
      // Trips in Front
      final rank = rankCounts.keys.first;
      return _tripPoints(rank);
    } else if (rankCounts.length == 2) {
      // Pair
      final pairRank = rankCounts.entries.firstWhere((e) => e.value == 2).key;
      return _pairPoints(pairRank);
    }

    return 0;
  }

  static int _pairPoints(String rank) {
    const pairValues = {
      '6': 1,
      '7': 2,
      '8': 3,
      '9': 4,
      'T': 5,
      'J': 6,
      'Q': 7,
      'K': 8,
      'A': 9,
    };
    return pairValues[rank] ?? 0;
  }

  static int _tripPoints(String rank) {
    const tripValues = {
      '2': 10,
      '3': 11,
      '4': 12,
      '5': 13,
      '6': 14,
      '7': 15,
      '8': 16,
      '9': 17,
      'T': 18,
      'J': 19,
      'Q': 20,
      'K': 21,
      'A': 22,
    };
    return tripValues[rank] ?? 0;
  }

  static int _calculateFiveCardRoyalties(
    List<String> cards, {
    required bool isMiddle,
  }) {
    if (cards.length != 5) return 0;
    final hand = Hand.solveHand(cards);
    final name = hand.name.toLowerCase();

    const middlePoints = {
      'three of a kind': 2,
      'straight': 4,
      'flush': 8,
      'full house': 12,
      'four of a kind': 20,
      'straight flush': 30,
      'royal flush': 50,
    };

    const backPoints = {
      'straight': 2,
      'flush': 4,
      'full house': 6,
      'four of a kind': 10,
      'straight flush': 15,
      'royal flush': 25,
    };

    final table = isMiddle ? middlePoints : backPoints;
    return table[name] ?? 0;
  }
}
