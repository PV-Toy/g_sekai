import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Constant {
  static const isDev = kDebugMode;
  static final isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
}

const blank = SizedBox();
