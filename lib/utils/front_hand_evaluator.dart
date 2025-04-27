// lib/utils/front_hand_evaluator.dart

class FrontHandEvaluator {
  static const String rankOrder = '23456789TJQKA';

  /// Gibt 1 zurück, wenn hand1 stärker ist, -1 wenn hand2 stärker, 0 bei Gleichstand.
  static int compare(List<String> hand1, List<String> hand2) {
    final score1 = _score(hand1);
    final score2 = _score(hand2);

    for (int i = 0; i < 4; i++) {
      if (score1[i] > score2[i]) return 1;
      if (score1[i] < score2[i]) return -1;
    }

    return 0;
  }

  /// Wandelt eine Hand in einen Score:
  /// [Stufencode (3=Trips, 2=Pair, 1=HighCard), HighestRank, Second, Third]
  static List<int> _score(List<String> hand) {
    final ranks = hand.map((c) => c[0]).toList();
    final rankCounts = <String, int>{};
    for (final r in ranks) {
      rankCounts[r] = (rankCounts[r] ?? 0) + 1;
    }

    if (rankCounts.length == 1) {
      // Trips
      return [3, rankOrder.indexOf(ranks[0]), 0, 0];
    } else if (rankCounts.length == 2) {
      // Pair + Kicker
      final pairRank = rankCounts.entries.firstWhere((e) => e.value == 2).key;
      final kicker = rankCounts.entries.firstWhere((e) => e.value == 1).key;
      return [2, rankOrder.indexOf(pairRank), rankOrder.indexOf(kicker), 0];
    } else {
      // High Card
      final sorted =
          ranks..sort(
            (a, b) => rankOrder.indexOf(b).compareTo(rankOrder.indexOf(a)),
          );
      return [
        1,
        rankOrder.indexOf(sorted[0]),
        rankOrder.indexOf(sorted[1]),
        rankOrder.indexOf(sorted[2]),
      ];
    }
  }
}
