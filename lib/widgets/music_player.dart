import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:g_sekai/managers/music/music_manager.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final manager = MusicManager.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromRGBO(39, 11, 14, 1),
        height: 150,
        padding: const EdgeInsets.fromLTRB(30, 22, 30, 90),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.menu,
              color: Colors.white,
              size: 28,
            ),
            Container(
              child: const Text('노래 제목!~~~'),
            ),
            IconButton(
              onPressed: () async {
                // await manager.player.stop();
                print("@@@@@@@@@@@@@@@");
                await manager.player.play(UrlSource(
                    "http://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3"));
              },
              icon: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 28,
              ),
            ),
            const Icon(
              Icons.skip_next,
              color: Colors.white,
              size: 28,
            ),
          ],
        ));
  }
}
