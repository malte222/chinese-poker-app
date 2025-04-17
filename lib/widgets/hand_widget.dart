// lib/widgets/hand_widget.dart
import 'package:flutter/material.dart';
import 'card_widget.dart';

class HandWidget extends StatelessWidget {
  final List<String> hand;
  final bool draggable;
  final double cardWidth;
  final double cardHeight;

  const HandWidget({
    super.key,
    required this.hand,
    this.draggable = true,
    this.cardWidth = 45,
    this.cardHeight = 68,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          hand.map((card) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child:
                  draggable
                      ? Draggable<String>(
                        data: card,
                        feedback: Material(
                          color: Colors.transparent,
                          child: CardWidget(cardCode: card, small: true),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: CardWidget(cardCode: card, small: true),
                        ),
                        child: CardWidget(cardCode: card),
                      )
                      : CardWidget(cardCode: card),
            );
          }).toList(),
    );
  }
}
