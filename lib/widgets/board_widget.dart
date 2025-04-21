import 'package:flutter/material.dart';
import 'slot_widget.dart';

/// Callback, wenn eine Karte in einen Slot abgelegt wird.
typedef CardDropCallback =
    void Function(String cardCode, String row, int slotIndex);

/// Prüft pro Slot, ob er drag‐fähig sein soll.
typedef SlotDraggableChecker = bool Function(String row, int slotIndex);

class BoardWidget extends StatelessWidget {
  final List<String?> front;
  final List<String?> middle;
  final List<String?> back;
  final CardDropCallback onCardDropped;
  final SlotDraggableChecker isSlotDraggable;
  final double slotWidth;
  final double slotHeight;

  const BoardWidget({
    super.key,
    required this.front,
    required this.middle,
    required this.back,
    required this.onCardDropped,
    required this.isSlotDraggable,
    this.slotWidth = 45,
    this.slotHeight = 68,
  });

  Widget _buildRow(List<String?> slots, String rowName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(slots.length, (index) {
        return SlotWidget(
          cardCode: slots[index],
          canDrag: isSlotDraggable(rowName, index),
          width: slotWidth,
          height: slotHeight,
          onCardDropped: (card) {
            onCardDropped(card, rowName, index);
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(front, 'front'),
        _buildRow(middle, 'middle'),
        _buildRow(back, 'back'),
      ],
    );
  }
}
