import 'package:flutter/material.dart';
import 'pineapple_setup.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hintergrundbild
          Positioned.fill(
            child: Image.asset(
              'assets/images/main_menu.png', // Pfad anpassen!
              fit: BoxFit.cover,
            ),
          ),
          // Menü-Inhalt
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 150),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PineappleSetupScreen(),
                      ),
                    );
                  },
                  child: const Text('Pass & Play'),
                ),
                const SizedBox(height: 1),
                ElevatedButton(
                  onPressed: null, // deaktiviert
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Play online'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
