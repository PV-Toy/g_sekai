import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:g_sekai/firebase_options.dart';
import 'package:g_sekai/firebase_test.dart';
import 'package:g_sekai/managers/route_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FilmList(),
    );
    // .router(
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   routerConfig: gRotuerManager.router,

    // );
  }
}
