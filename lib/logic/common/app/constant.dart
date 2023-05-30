import 'dart:io';

import 'package:flutter/foundation.dart';

class Constant {
  static const isDev = kDebugMode;
  static final isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
}
