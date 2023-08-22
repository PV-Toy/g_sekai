import 'package:audioplayers/audioplayers.dart';

class MusicManager {
  static MusicManager? _instance;
  static MusicManager get instance => _instance ?? MusicManager();
  late AudioPlayer player;
  MusicManager() {
    player = AudioPlayer();
  }
}
