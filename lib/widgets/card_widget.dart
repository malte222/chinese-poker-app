// lib/widgets/card_widget.dart
import 'package:flutter/material.dart';
import 'dart:math';

class CardWidget extends StatelessWidget {
  final String cardCode;
  final bool small;
  final bool rotated;

  const CardWidget({
    super.key,
    required this.cardCode,
    this.small = false,
    this.rotated = false,
  });

  @override
  Widget build(BuildContext context) {
    final double width = small ? 45 * 0.8 : 45;
    final double height = small ? 68 * 0.8 : 68;
    final image = Image.asset(
      'assets/cards/$cardCode.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder:
          (context, error, stackTrace) => Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              cardCode,
              style: const TextStyle(color: Colors.black, fontSize: 10),
            ),
          ),
    );
    return rotated ? Transform.rotate(angle: pi / 2, child: image) : image;
  }
}
