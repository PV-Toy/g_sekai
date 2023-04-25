import 'package:g_sekai/main.dart';
import 'package:g_sekai/my_home_page.dart';
import 'package:g_sekai/pages/game_list_page.dart';
import 'package:go_router/go_router.dart';

final gRotuerManager = RouterManager();

enum PageName {
  home();

  static PageName fromStr(String str) => PageName.values.byName(str);
}

class RouterManager {
  final router = GoRouter(routes: [
    GoRoute(
        path: "/",
        builder: (context, state) =>
            const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: [
          GoRoute(
              path: "game_list",
              builder: (context, state) => const GameListPage()),
        ]),
  ]);
}
