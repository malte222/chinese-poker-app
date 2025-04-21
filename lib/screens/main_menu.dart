import 'package:flutter/material.dart';
import 'pineapple_setup.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'OFC Pineapple Poker',
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PineappleSetupScreen(),
                  ),
                );
              },
              child: const Text('Lokales Spiel'),
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: null, // deaktiviert
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: const Text('Online-Spiel (bald verfügbar)'),
            ),
          ],
        ),
      ),
    );
  }
}
