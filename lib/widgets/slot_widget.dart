// lib/widgets/slot_widget.dart
import 'package:flutter/material.dart';
import 'card_widget.dart';

class SlotWidget extends StatelessWidget {
  final String? cardCode;
  final bool canDrag;
  final double width;
  final double height;
  final void Function(String) onCardDropped;

  const SlotWidget({
    super.key,
    required this.cardCode,
    required this.canDrag,
    required this.width,
    required this.height,
    required this.onCardDropped,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) {
        onCardDropped(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: width,
          height: height,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white10,
            border: Border.all(color: Colors.white30),
            borderRadius: BorderRadius.circular(6),
          ),
          child:
              cardCode != null
                  ? (canDrag
                      ? Draggable<String>(
                        data: cardCode!,
                        feedback: Material(
                          color: Colors.transparent,
                          child: CardWidget(cardCode: cardCode!),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: CardWidget(cardCode: cardCode!),
                        ),
                        child: CardWidget(cardCode: cardCode!),
                      )
                      : CardWidget(cardCode: cardCode!, small: true))
                  : const SizedBox.shrink(),
        );
      },
    );
  }
}
