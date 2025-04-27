import 'package:flutter_test/flutter_test.dart';
import 'package:ofc_pineapple/utils/front_hand_evaluator.dart';

void main() {
  group('FrontHandEvaluator.compare', () {
    test('Trips vs Pair', () {
      final result = FrontHandEvaluator.compare(
        ['7c', '7d', '7h'],
        ['8c', '8d', '2h'],
      );
      expect(result, 1); // Trips > Pair
    });

    test('Pair vs High Card', () {
      final result = FrontHandEvaluator.compare(
        ['Qc', 'Qd', '2h'],
        ['Ac', 'Kd', '3s'],
      );
      expect(result, 1); // Pair > High Card
    });

    test('High Card vs High Card', () {
      final result = FrontHandEvaluator.compare(
        ['Ac', 'Kd', '3s'],
        ['Kc', 'Qd', '4s'],
      );
      expect(result, 1); // A-high > K-high
    });

    test('Pair vs Pair (higher pair wins)', () {
      final result = FrontHandEvaluator.compare(
        ['9c', '9d', '2h'],
        ['8c', '8d', '2s'],
      );
      expect(result, 1); // 99 > 88
    });

    test('Pair vs Pair (same pair, kicker decides)', () {
      final result = FrontHandEvaluator.compare(
        ['8c', '8d', '5s'],
        ['8h', '8s', '4c'],
      );
      expect(result, 1); // same pair, 5 kicker > 4
    });

    test('Trips vs Trips (higher trips wins)', () {
      final result = FrontHandEvaluator.compare(
        ['Qd', 'Qc', 'Qh'],
        ['Jd', 'Jc', 'Jh'],
      );
      expect(result, 1); // QQQ > JJJ
    });

    test('High Card vs High Card (tie)', () {
      final result = FrontHandEvaluator.compare(
        ['Ac', 'Kd', '2h'],
        ['Ah', 'Ks', '2d'],
      );
      expect(result, 0); // Same high cards
    });
  });
}
