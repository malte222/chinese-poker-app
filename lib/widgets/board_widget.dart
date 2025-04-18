// lib/widgets/board_widget.dart
import 'package:flutter/material.dart';
import 'slot_widget.dart';

class BoardWidget extends StatelessWidget {
  final List<String?> front;
  final List<String?> middle;
  final List<String?> back;
  final bool canDrag;
  final double slotWidth;
  final double slotHeight;

  const BoardWidget({
    super.key,
    required this.front,
    required this.middle,
    required this.back,
    required this.canDrag,
    this.slotWidth = 45,
    this.slotHeight = 68,
  });

  Widget _buildRow(List<String?> slots, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return SlotWidget(
          cardCode: slots[index],
          canDrag: canDrag,
          width: slotWidth,
          height: slotHeight,
          onCardDropped: (data) {
            // Hier kannst du den Callback implementieren – z. B. per Provider an den Controller weiterreichen.
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildRow(front, 3), _buildRow(middle, 5), _buildRow(back, 5)],
    );
  }
}
