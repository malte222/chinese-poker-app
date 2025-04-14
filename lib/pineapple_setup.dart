import 'package:flutter/material.dart';
import 'home_screen.dart';

class PineappleSetupScreen extends StatefulWidget {
  final int playerCount;

  const PineappleSetupScreen({super.key, required this.playerCount});

  @override
  State<PineappleSetupScreen> createState() => _PineappleSetupScreenState();
}

class _PineappleSetupScreenState extends State<PineappleSetupScreen> {
  int selectedPlayers = 2;

  void startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(playerCount: selectedPlayers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pineapple OFC - Spieleranzahl wählen',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 24),
            ToggleButtons(
              isSelected: [selectedPlayers == 2, selectedPlayers == 3],
              onPressed: (index) {
                setState(() {
                  selectedPlayers = index + 2;
                });
              },
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              selectedColor: Colors.black,
              fillColor: Colors.white,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text('2 Spieler'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text('3 Spieler'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: startGame,
              child: const Text('Spiel starten'),
            ),
          ],
        ),
      ),
    );
  }
}
