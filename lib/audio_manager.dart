// lib/audio_manager.dart
import 'package:just_audio/just_audio.dart';

class AudioManager {
  // 1) Singleton-Instanz
  AudioManager._();
  static final AudioManager instance = AudioManager._();

  // 2) Der globale Player
  final AudioPlayer player = AudioPlayer();

  // 3) Initialisierung (einmalig aufrufen)
  Future<void> init() async {
    await player.setAsset('assets/music/dreambig.mp3');
    player.setLoopMode(LoopMode.one);
    player.setVolume(0.5);
    player.play();
  }

  // 4) Optional: Pause, Resume, Lautstärke…
  void pause() => player.pause();
  void resume() => player.play();
  void dispose() => player.dispose();
}
