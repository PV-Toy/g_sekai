import 'package:g_sekai/pages/my_home_page.dart';
import 'package:g_sekai/pages/game_list_page.dart';
import 'package:go_router/go_router.dart';

final gRoutuerManager = RouterManager();

enum PageName {
  home();

  static PageName fromStr(String str) => PageName.values.byName(str);
}

class RouterManager {
  final router = GoRouter(routes: [
    GoRoute(
      name: "home",
      path: "/",
      builder: (context, state) =>
          const MyHomePage(title: 'Flutter Demo Home Page'),
      // routes: [
      //   ShellRoute(
      //       routes: [GoRoute(path: "game_list")],
      //       builder: (context, state, child) => const GameListPage()),
      // ],
    ),
  ]);
}
