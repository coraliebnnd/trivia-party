import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playBackgroundMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.setVolume(0.5);
    await _audioPlayer.play(AssetSource('sounds/music.mp3'));
  }

  static Future<void> stopMusic() async {
    await _audioPlayer.stop();
  }

  static Future<void> pauseMusic() async {
    await _audioPlayer.pause();
  }

  static Future<void> resumeMusic() async {
    await _audioPlayer.resume();
  }
}
