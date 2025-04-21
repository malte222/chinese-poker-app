// lib/models/card_model.dart
class CardModel {
  final String rank;
  final String suit;

  CardModel({required this.rank, required this.suit});

  String get code => '$rank$suit';

  factory CardModel.fromCode(String code) {
    if (code.length < 2) throw ArgumentError('Ungültiger Kartencode');
    return CardModel(
      rank: code.substring(0, code.length - 1),
      suit: code.substring(code.length - 1),
    );
  }
}
