// lib/models/player_model.dart
import 'card_model.dart';

class PlayerModel {
  final String name;
  List<CardModel> hand;
  // Boards: Front (3), Middle (5), Back (5) – optional als Liste von Karten, bei denen ein Slot null sein kann.
  List<CardModel?> front;
  List<CardModel?> middle;
  List<CardModel?> back;

  // Tracker für neue Platzierungen ab Runde 2
  List<int> newPlacements;

  PlayerModel({
    required this.name,
    List<CardModel>? hand,
    List<CardModel?>? front,
    List<CardModel?>? middle,
    List<CardModel?>? back,
    List<int>? newPlacements,
  }) : hand = hand ?? [],
       front = front ?? List.filled(3, null),
       middle = middle ?? List.filled(5, null),
       back = back ?? List.filled(5, null),
       newPlacements = newPlacements ?? [];
}
