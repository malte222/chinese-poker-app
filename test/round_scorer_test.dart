import 'package:flutter_test/flutter_test.dart';
import 'package:ofc_pineapple/utils/round_scorer.dart';

void main() {
  group('RoundScorer Tests', () {
    test('Spieler 1 Foul, Spieler 2 +6 Royalties', () {
      final (score1, score2) = RoundScorer.calculate(
        front1: ['As', 'Ah', 'Ad'],
        middle1: ['Ks', 'Kh', 'Kd', '5c', '7c'],
        back1: ['Qs', 'Qh', 'Qd', '2c', '3c'],
        front2: ['2s', '3h', '4d'],
        middle2: ['5s', '6h', '7d', '8c', '9c'],
        back2: ['Ts', 'Jh', 'Qd', 'Kc', 'Ac'],
      );

      expect(score1, -12);
      expect(score2, 12);
    });

    test('Eine Hand ungültig (Foul)', () {
      final (score1, score2) = RoundScorer.calculate(
        front1: ['As', 'Ah', '2d'],
        middle1: ['2s', '2h', '2d', '5c', '7c'],
        back1: ['Qs', 'Qh', 'Qd', '2c', '3c'],
        front2: ['3s', '3h', '3d'],
        middle2: ['4s', '4h', '5d', '5c', '6c'],
        back2: ['Ts', 'Th', 'Td', 'Tc', '2s'],
      );

      expect(score1, 17);
      expect(score2, -17);
    });

    test('Beide Hände gültig und gleiche Royalties', () {
      final (score1, score2) = RoundScorer.calculate(
        front1: ['2s', '2h', '2d'],
        middle1: ['As', 'Ah', 'Ad', 'Kc', 'Qc'],
        back1: ['5s', '6h', '7d', '8c', '9c'],
        front2: ['2c', '2d', '2h'],
        middle2: ['Ac', 'Ad', 'Ah', 'Ks', 'Qs'],
        back2: ['5c', '6d', '7h', '8s', '9s'],
      );

      expect(score1, 0);
      expect(score2, 0);
    });
  });
}
