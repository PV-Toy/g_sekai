import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Constant {
  static const isDev = kDebugMode;
  static final isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
}

extension StringExtension on String {
  String toCapitalized() =>
      isEmpty ? this : "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
}

const blank = SizedBox();
