import 'package:g_sekai/logic/common/app/logger.dart';

extension EnumExt<T extends Enum> on Iterable<T> {
  T findbyStr(String? str, {T Function(ArgumentError e)? orElse}) {
    try {
      return byName(str ?? "");
    } on ArgumentError catch (e) {
      final fb = orElse?.call(e) ?? last;
      logger.error(
          '[$T] ${e.message}: "${e.invalidValue}". fall back to "${fb.name}"');
      return fb;
    }
  }
}
