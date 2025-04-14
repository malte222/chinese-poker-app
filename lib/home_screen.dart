import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chinese Poker Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Willkommen bei Pineapple Chinese Poker!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Hier kannst du später Navigation zu deinem Setup oder Spiel starten
                Navigator.pushNamed(context, '/setup');
              },
              child: const Text('Spiel starten'),
            ),
          ],
        ),
      ),
    );
  }
}
