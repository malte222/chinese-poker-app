import 'package:flutter/material.dart';
import 'game_screen.dart';

class PineappleSetupScreen extends StatefulWidget {
  const PineappleSetupScreen({super.key});

  @override
  State<PineappleSetupScreen> createState() => _PineappleSetupScreenState();
}

class _PineappleSetupScreenState extends State<PineappleSetupScreen> {
  int selectedPlayers = 2;

  void startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(playerCount: selectedPlayers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hintergrundbild
          Positioned.fill(
            child: Image.asset(
              'assets/images/setup_screen.png', // Genauso wie im MainMenuScreen
              fit: BoxFit.cover,
            ),
          ),
          // Inhalt oben drauf
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Player count',
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
                      child: Text('2 Players'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text('3 Players'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: startGame,
                  child: const Text('Start game'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
