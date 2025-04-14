import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final int playerCount;

  const HomeScreen({super.key, required this.playerCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Spiel mit $playerCount Spieler${playerCount > 1 ? "n" : ""}',
        ),
      ),
      body: Center(
        child: Text(
          'Das Spiel startet mit $playerCount Spieler${playerCount > 1 ? "n" : ""}.',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
