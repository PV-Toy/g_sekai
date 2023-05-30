import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:g_sekai/logic/common/app/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yaml_writer/yaml_writer.dart';

class MsgException implements Error {
  final String _message;
  final dynamic res;
  final StackTrace stack = StackTrace.current;
  Exception? reason;
  MsgException(this._message, [this.res]) {
    logger.error(["MSG EXCEPTION LOG", _message, res ?? '', stack.toString()]);
  }

  @override
  String toString() => _message;

  @override
  StackTrace? get stackTrace => stack;
}

final DateTime _startTime = DateTime.now();

class Logger {
  static const enableStackTrace = false;

  final String tag;

  Logger(this.tag);

  static IOSink? s;
  static int pt = DateTime.now().microsecondsSinceEpoch;
  void _fwrite(obj, List<String> st) async {
    if (kIsWeb) return;
    if (!Constant.isDev) return;
    if (s == null) {
      var dir = Constant.isMobile
          ? await getTemporaryDirectory()
          : Directory('./tmp');
      var file = File("${Constant.isDev ? "/tmp" : dir.path}/app.log");
      log([Directory.current, file].toString());
      s = file.openWrite();
    }
    final now = DateTime.now();
    final ct = now.microsecondsSinceEpoch;
    final dt = ct - pt;
    pt = ct;
    final o = [DateTime.now(), dt / 1000, obj];
    s!.writeln(o.toString());
    if (enableStackTrace) {
      s!.writeln(st.map((v) => "    $v").join('\n').toString());
    }
  }

  void _log(obj, List<String>? st) {
    if (st != null) {
      log(obj.toString(),
          name: "Logger", stackTrace: StackTrace.fromString(st.join('\n')));
    } else {
      log(obj.toString(), name: "Logger");
    }
  }

  _out(isdump, type, v) {
    final ct = DateTime.now();
    final dt = ct.difference(_startTime);
    var o = [dt.inMilliseconds, type, tag, v];
    final st = StackTrace.current.toString().split('\n');
    final st2 = st.sublist(2, 5);
    if (!isdump) {
      if (enableStackTrace) {
        _log(o, st2);
      } else {
        _log(o, null);
      }
    }
    _fwrite(o, st2);
  }

  debug(dynamic args) {
    _dbg(args, (trimmed) {
      _out(false, 'debug', trimmed);
    });
  }

  info(Object? args) {
    _out(false, 'info', args?.toShortenedIfHeavy());
  }

  warn(dynamic args) {
    _out(false, 'warn', args);
  }

  error(Object args) {
    if (args is Error) {
      var msg = args.toString();
      if (args is MsgException) {
        msg = '$args${args.res != null ? ': ${args.res}' : ''}';
      }
      log('', error: msg, name: "ERROR", stackTrace: args.stackTrace);
      _out(true, 'error', msg);
      _out(true, 'error', args.stackTrace);
    } else {
      log('', error: args.toString(), name: "ERROR");
      _out(true, 'error', args);
    }
  }

  sdump(dynamic args) {
    _dbg(args, (trimmed) {
      _out(true, 'sdump', trimmed);
    });
  }

  jdump(dynamic args) {
    _dbg(args, (trimmed) {
      final o = jsonEncode(trimmed);
      _out(true, 'jdump', o);
    });
  }

  static final _yamlWritter = YAMLWriter();
  ydump(dynamic args) {
    _dbg(args, (trimmed) {
      final o = _yamlWritter.write(trimmed);
      _out(true, 'ydump', o);
    });
  }

  void _dbg(dynamic args, void Function(dynamic trimmedArgs) cb) {
    if (!kDebugMode) return cb(args);
    if (args is Object) {
      return cb(args.toShortenedIfHeavy());
    }
    return cb(args);
  }
}

final Logger logger = Logger('_');

const _maximumColSize = 200;
const _maximumStrLength = 2000;

extension on Object {
  bool get isHeavy {
    final obj = this;
    if (obj is String) {
      return obj.length > _maximumStrLength;
    }
    Iterable? iterable = obj is Map
        ? obj.values
        : obj is Iterable
            ? obj
            : const [];
    if (iterable.isEmpty) return false;
    int count = _maximumColSize;
    final iter = iterable.iterator;
    dynamic val;
    while (iter.moveNext()) {
      if (--count < 0) return true;
      val = iter.current;
      if (val is! Object) continue;
      if (val.isHeavy) {
        return true;
      }
    }

    return false;
  }

  Object toShortenedIfHeavy() {
    if (!isHeavy) {
      return this;
    }
    final obj = this;
    if (obj is String) {
      return obj.shortened;
    }
    if (obj is Iterable) {
      return obj.shortened;
    }
    if (obj is Map) {
      return obj.shortened;
    }
    return obj;
  }
}

extension on String {
  String get shortened =>
      "!HEAVY_DATA! - '''${substring(0, _maximumStrLength)} ... ... ... '''";
}

extension on Map {
  Map get shortened {
    final newMap = {};
    int count = _maximumColSize;
    final iter = entries.iterator;
    while (iter.moveNext()) {
      if (--count < 0) break;
      final entry = iter.current.shortened;
      newMap[entry.key] = entry.value;
    }
    return newMap..["SHORTENED"] = "... ... ...";
  }
}

extension on Iterable {
  Iterable get shortened {
    final newIter = [];
    int count = _maximumColSize;
    final iter = iterator;
    while (iter.moveNext()) {
      if (--count < 0) break;
      final val = iter.current;
      newIter.add(val is Object ? val.toShortenedIfHeavy() : val);
    }
    return newIter..add("... ... ...");
  }
}

extension on MapEntry {
  MapEntry get shortened => MapEntry(
      key, value is Object ? (value as Object).toShortenedIfHeavy() : value);
}
