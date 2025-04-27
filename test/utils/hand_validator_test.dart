import 'package:flutter_test/flutter_test.dart';
import 'package:ofc_pineapple/utils/hand_validator.dart';

void main() {
  group('HandValidator', () {
    test('gültige Hand', () {
      final front = ['4s', '4h', 'Ks'];
      final middle = ['9s', '3s', '5s', 'Qs', 'Ks'];
      final back = ['9h', '2h', '5h', 'Qh', 'Kh'];

      final result = HandValidator.isValidHand(
        front: front,
        middle: middle,
        back: back,
      );

      expect(result, isFalse);
    });
  });
}
