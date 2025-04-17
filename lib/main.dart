// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/game_controller.dart';
import 'screens/main_menu.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pineapple OFC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenuScreen(),
        // Wir navigieren direkt via Navigator.push, daher hier kein Eintrag für /game nötig
      },
    );
  }
}
