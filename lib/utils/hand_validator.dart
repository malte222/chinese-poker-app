import 'package:poker_solver/poker_solver.dart';

/// Prüft, ob ein Spieler eine gültige Hand hat (kein Foul).
/// Dafür muss Back ≥ Middle ≥ Front (mit 2 Junkkarten).
class HandValidator {
  static const List<String> junkPool1 = ['2c', '3c', '4c', '5c', '6c', '7c'];
  static const List<String> junkPool2 = ['2d', '3d', '4d', '5d', '6d', '7d'];

  static const String rankOrder = 'A23456789TJQKA';

  /// Hauptfunktion: true, wenn kein Foul (Back ≥ Middle ≥ Front).
  static bool isValidHand({
    required List<String> front,
    required List<String> middle,
    required List<String> back,
  }) {
    final frontJunk = _findValidJunkCombo(front);
    if (frontJunk == null) return false;

    final frontFull = [...front, ...frontJunk];
    final frontHand = Hand.solveHand(frontFull);
    final middleHand = Hand.solveHand(middle);
    final backHand = Hand.solveHand(back);

    // back ≥ middle ≥ front
    final winners1 = Hand.winners([backHand, middleHand]);
    if (!winners1.contains(backHand)) return false;

    final winners2 = Hand.winners([middleHand, frontHand]);
    if (!winners2.contains(middleHand)) return false;

    return true;
  }

  /// Sucht ein gültiges Junkkartenpaar zur Ergänzung der Front.
  static List<String>? _findValidJunkCombo(List<String> front) {
    for (final j1 in junkPool1) {
      for (final j2 in junkPool2) {
        if (_isValidJunkCombo(front, j1, j2)) {
          return [j1, j2];
        }
      }
    }
    return null;
  }

  /// Prüft, ob j1 und j2 eine gültige Ergänzung zu front sind.
  static bool _isValidJunkCombo(List<String> front, String j1, String j2) {
    final frontRanks = front.map((c) => c[0]).toSet();

    // 1. Kein Pair unter Junk-Karten
    if (j1[0] == j2[0]) return false;

    // 2. Kein Rang der Junk-Karten in der Front
    if (frontRanks.contains(j1[0]) || frontRanks.contains(j2[0])) return false;

    // 3. Kein Straight mit Junk + Front
    final fullHand = [...front, j1, j2];
    final indices = <int>{};
    for (final card in fullHand) {
      final i = rankOrder.indexOf(card[0]);
      if (i == -1) return false;
      indices.add(i);
    }

    final sorted = indices.toList()..sort();
    for (int i = 0; i <= sorted.length - 5; i++) {
      if (sorted[i + 4] - sorted[i] == 4) return false;
    }

    return true;
  }
}
