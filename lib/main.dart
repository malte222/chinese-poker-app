import 'package:flutter/material.dart';
import 'screens/main_menu.dart';
import 'screens/game_screen.dart'; // Beispiel für den GameScreen

void main() {
  // WidgetsFlutterBinding.ensureInitialized();  // falls du asynchrone Initialisierungen vornehmen musst
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pineapple OFC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      // Hier legst du initialRoute und andere Routen fest
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenuScreen(),
        '/game': (context) => const GameScreen(playerCount: 2),
        // Weitere Routen können hier ergänzt werden, z.B.:
        // '/home': (context) => const HomeScreen(),
        // '/pineapple-setup': (context) => const PineappleSetupScreen(),
      },
    );
  }
}
