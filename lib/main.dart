import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:g_sekai/pages/firebase_options.dart';
import 'package:g_sekai/managers/routes/route_manager.dart';
import 'package:g_sekai/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: GTheme.lightTheme.widgetThemedDEBUG,
      darkTheme: GTheme.darkTheme.widgetThemedDEBUG,
      routerConfig: gRoutuerManager.router,
    );
  }
}
