import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    // textTheme: _getTextTheme(isDarkMode: true),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    // colorScheme: _darkColorScheme,
  ).widgetThemedRELEASE;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    // textTheme: _getTextTheme(),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    // colorScheme: _lightColorScheme,
  ).widgetThemedRELEASE;
}

extension ThemeExt on ThemeData {
  TextTheme get $t => textTheme;
  ColorScheme get $c => colorScheme;

  ///개발환경에선 실시간으로 바뀐 테마데이터가 hot-reload에 적용될 수 있도록 함.
  ThemeData get widgetThemedDEBUG => kDebugMode ? _widgetThemed : this;

  ///릴리즈모드에서는 성능을 위해 static 테마객체만 한 번 업데이트함.
  ThemeData get widgetThemedRELEASE => kDebugMode ? this : _widgetThemed;
  ThemeData get _widgetThemed => copyWith(
          chipTheme: ChipThemeData(
        showCheckmark: false,
        labelPadding: const EdgeInsets.all(0),
        shape: const StadiumBorder(),
        side: MaterialStateBorderSide.resolveWith((states) => BorderSide(
            width: 1,
            color: states.contains(MaterialState.selected)
                ? Colors.transparent
                : $c.outline)),
      ));
}
