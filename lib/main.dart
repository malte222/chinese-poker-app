// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Für SystemChrome
import 'package:provider/provider.dart';
import 'controllers/game_controller.dart';
import 'screens/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Nur Landscape-Modus zulassen
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Statusleiste & Navigationsleiste ausblenden (immersiv)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

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
      routes: {'/': (context) => const MainMenuScreen()},
    );
  }
}
