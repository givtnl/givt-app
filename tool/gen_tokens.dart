// ignore_for_file: avoid_print
//
// Design token code generator. Reads DTCG-style JSON and emits Flutter token classes.
//
// Usage (from project root): dart run tool/gen_tokens.dart
//
// Requires:
//   design-tokens/source/givt.tokens.json
//   design-tokens/source/givt4kids.tokens.json
// (Copy from Downloads: Givt.tokens.json -> givt.tokens.json, Givt4Kids.tokens.json -> givt4kids.tokens.json)

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

void main(List<String> args) {
  final projectRoot = _projectRoot();
  final sourceDir = Directory(p.join(projectRoot.path, 'design-tokens', 'source'));
  final givtJson = File(p.join(sourceDir.path, 'givt.tokens.json'));
  final givt4kidsJson = File(p.join(sourceDir.path, 'givt4kids.tokens.json'));

  if (!givtJson.existsSync()) {
    print('Error: ${givtJson.path} not found. Copy Givt.tokens.json from Downloads to design-tokens/source/givt.tokens.json');
    exit(1);
  }
  if (!givt4kidsJson.existsSync()) {
    print('Error: ${givt4kidsJson.path} not found. Copy Givt4Kids.tokens.json from Downloads to design-tokens/source/givt4kids.tokens.json');
    exit(1);
  }

  final outDir = Directory(p.join(
    projectRoot.path,
    'lib',
    'features',
    'family',
    'shared',
    'design',
    'tokens',
  ));
  if (!outDir.existsSync()) outDir.createSync(recursive: true);

  final givtTokens = _parseTokenFile(givtJson);
  final givt4kidsTokens = _parseTokenFile(givt4kidsJson);

  _writeTokenDart(File(p.join(outDir.path, 'fun_givt_tokens_generated.dart')), 'FunGivtTokensGenerated', givtTokens);
  _writeTokenDart(File(p.join(outDir.path, 'fun_givt4kids_tokens_generated.dart')), 'FunGivt4KidsTokensGenerated', givt4kidsTokens);

  print('Generated ${outDir.path}/fun_givt_tokens_generated.dart and fun_givt4kids_tokens_generated.dart');
}

Directory _projectRoot() {
  var dir = Directory.current;
  while (dir.path != dir.parent.path) {
    if (File(p.join(dir.path, 'pubspec.yaml')).existsSync()) return dir;
    dir = dir.parent;
  }
  return Directory.current;
}

/// Flatten path segments to a Dart identifier (camelCase, no leading digit).
/// e.g. ["primary", "primary40"] -> "primary40"; ["neutral-variant", "50"] -> "neutralVariant50".
String _toDartName(List<String> path) {
  if (path.isEmpty) return 'token';
  String camelSegment(String s) {
    if (!s.contains('-')) return s;
    final parts = s.toLowerCase().split('-');
    if (parts.isEmpty) return s;
    return parts.first + parts.skip(1).map((e) => e.isEmpty ? e : '${e[0].toUpperCase()}${e.length > 1 ? e.substring(1) : ''}').join();
  }
  final segments = path.map(camelSegment).toList();
  // Redundant prefix: ["primary", "primary40"] -> "primary40".
  if (path.length >= 2 && path.last.toLowerCase().startsWith(path[path.length - 2].toString().toLowerCase())) {
    segments.removeRange(0, segments.length - 1);
  }
  var name = segments.join();
  if (name.isEmpty) name = 'token';
  if (name[0].compareTo('0') >= 0 && name[0].compareTo('9') <= 0) return 'value$name';
  return name;
}

/// Recursively collect tokens with $type and $value; keys are flattened paths.
Map<String, _TokenValue> _parseTokenFile(File file) {
  final map = <String, _TokenValue>{};
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  void walk(dynamic node, List<String> path) {
    if (node is Map<String, dynamic>) {
      if (node.containsKey(r'$type') && node.containsKey(r'$value')) {
        final type = node[r'$type'] as String?;
        final value = node[r'$value'];
        final name = _toDartName(path);
        if (name.isNotEmpty) map[name] = _TokenValue(type: type ?? 'unknown', value: value);
        return;
      }
      for (final e in node.entries) {
        if (e.key.startsWith(r'$')) continue;
        walk(e.value, [...path, e.key]);
      }
    }
  }
  walk(json, []);
  return map;
}

class _TokenValue {
  final String type;
  final dynamic value;

  _TokenValue({required this.type, required this.value});
}

String _dartValue(_TokenValue t) {
  switch (t.type) {
    case 'color':
      return _colorDart(t.value);
    case 'dimension':
    case 'number':
      return _numberDart(t.value);
    case 'fontFamily':
    case 'string':
      return _stringDart(t.value);
    default:
      if (t.value is num) return _numberDart(t.value);
      if (t.value is String) return _stringDart(t.value);
      return '/* ${t.type}: ${t.value} */ null';
  }
}

String _colorDart(dynamic v) {
  if (v is String) {
    final hex = v.replaceFirst('#', '');
    if (hex.length == 6) return 'Color(0xFF${hex.toUpperCase()})';
    if (hex.length == 8) return 'Color(0x${hex.toUpperCase()})';
  }
  if (v is Map<String, dynamic>) {
    final r = (v['r'] as num?)?.toInt() ?? 0;
    final g = (v['g'] as num?)?.toInt() ?? 0;
    final b = (v['b'] as num?)?.toInt() ?? 0;
    final a = (v['alpha'] as num?)?.toDouble() ?? 1.0;
    if (a >= 1.0) return 'Color(0xFF${_toHex(r)}${_toHex(g)}${_toHex(b)})';
    return 'Color.fromRGBO($r, $g, $b, $a)';
  }
  return 'Colors.black';
}

String _toHex(int n) {
  final h = n.clamp(0, 255).toRadixString(16);
  return h.length == 1 ? '0$h' : h;
}

String _numberDart(dynamic v) {
  if (v is int) return '$v';
  if (v is double) return '$v';
  if (v is String) {
    final n = num.tryParse(v);
    if (n != null) return '$n';
  }
  return '0';
}

String _stringDart(dynamic v) {
  if (v is! String) return "'${v.toString().replaceAll("'", r"\'")}'";
  return "'${v.replaceAll(r'\', r'\\').replaceAll("'", r"\'")}'";
}

void _writeTokenDart(File out, String className, Map<String, _TokenValue> tokens) {
  final sb = StringBuffer();
  sb.writeln("// Generated by tool/gen_tokens.dart. Do not edit by hand.");
  sb.writeln('');
  sb.writeln('import \'package:flutter/material.dart\';');
  sb.writeln('');
  sb.writeln('/// Design tokens for $className.');
  sb.writeln('class $className {');
  sb.writeln('  $className._();');
  sb.writeln('');

  final colorKeys = <String>[];
  final otherKeys = <String>[];
  for (final k in tokens.keys) {
    if (tokens[k]!.type == 'color') colorKeys.add(k); else otherKeys.add(k);
  }
  colorKeys.sort();
  otherKeys.sort();

  for (final k in colorKeys) {
    final t = tokens[k]!;
    sb.writeln('  static const $k = ${_dartValue(t)};');
  }
  if (otherKeys.isNotEmpty && colorKeys.isNotEmpty) sb.writeln('');
  for (final k in otherKeys) {
    final t = tokens[k]!;
    final dartVal = _dartValue(t);
    if (t.type == 'fontFamily' || t.type == 'string') sb.writeln('  static const String $k = $dartVal;');
    else sb.writeln('  static const $k = $dartVal;');
  }

  sb.writeln('}');
  out.writeAsStringSync(sb.toString());
}
