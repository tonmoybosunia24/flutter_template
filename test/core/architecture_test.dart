import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Verifies that every file in `lib/` follows the template's architecture and design-system rules defined in `AGENTS.md`.
void main() {
  final libDir = Directory('lib');
  final dartFiles =
      libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  String normalizePath(File file) => file.path.replaceAll(r'\', '/');

  // Strips single-line and multi-line comments so doc comments don't trigger false positives.
  String stripComments(String source) {
    return source
        .replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '')
        .replaceAll(RegExp(r'//.*'), '');
  }

  test('no hardcoded Color(0x...) or Colors.* outside lib/core/theme/', () {
    final violations = <String>[];
    final colorLiteral = RegExp(r'\b(Color\s*\(\s*0x|Colors\.)');

    for (final file in dartFiles) {
      final path = normalizePath(file);
      if (path.startsWith('lib/core/theme/')) continue;

      final code = stripComments(file.readAsStringSync());
      if (colorLiteral.hasMatch(code)) {
        violations.add(path);
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use semantic theme colors via context.appColors instead of hardcoded Color(0x...) or Colors.* in: ${violations.join(', ')}',
    );
  });

  test('no raw Text(...) widget outside CustomText', () {
    final violations = <String>[];
    final rawTextWidget = RegExp(r'(?<![\w.])Text\s*\(');

    for (final file in dartFiles) {
      final path = normalizePath(file);
      if (path == 'lib/core/widgets/custom_text.dart') continue;

      final code = stripComments(file.readAsStringSync());
      if (rawTextWidget.hasMatch(code)) {
        violations.add(path);
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use CustomText instead of Flutter\'s raw Text widget in: ${violations.join(', ')}',
    );
  });

  test('no hardcoded asset paths outside asset path utility classes', () {
    final violations = <String>[];
    final assetLiteral = RegExp(r'''['"]assets/''');
    const allowedFiles = {
      'lib/core/utils/app_icons.dart',
      'lib/core/utils/app_illustrations.dart',
      'lib/core/utils/app_images.dart',
    };

    for (final file in dartFiles) {
      final path = normalizePath(file);
      if (allowedFiles.contains(path)) continue;

      final code = stripComments(file.readAsStringSync());
      if (assetLiteral.hasMatch(code)) {
        violations.add(path);
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use IconPath, IllustrationPath, or ImagePath constants instead of hardcoded asset strings in: ${violations.join(', ')}',
    );
  });

  test('no print() or debugPrint() calls in lib/', () {
    final violations = <String>[];
    final printCall = RegExp(r'\b(print|debugPrint)\s*\(');

    for (final file in dartFiles) {
      final path = normalizePath(file);
      final code = stripComments(file.readAsStringSync());
      if (printCall.hasMatch(code)) {
        violations.add(path);
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Use AppLogger instead of print() or debugPrint() in: ${violations.join(', ')}',
    );
  });

  test('views, widgets, and controllers do not import core/network directly', () {
    final violations = <String>[];
    final networkImport = RegExp(r'''import\s+['"].*core/network/''');

    for (final file in dartFiles) {
      final path = normalizePath(file);
      final isUiOrController =
          path.startsWith('lib/core/widgets/') ||
          (path.startsWith('lib/features/') &&
              (path.contains('/view/') ||
                  path.contains('/widgets/') ||
                  path.contains('/controller/')));
      if (!isUiOrController) continue;

      final code = stripComments(file.readAsStringSync());
      if (networkImport.hasMatch(code)) {
        violations.add(path);
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Only repositories and bindings may import core/network/. Violations in: ${violations.join(', ')}',
    );
  });

  test('no _buildXxx() methods that return widgets', () {
    final violations = <String>[];
    final buildHelper = RegExp(r'\bWidget\??\s+_build\w*\s*\(');

    for (final file in dartFiles) {
      final code = stripComments(file.readAsStringSync());
      if (buildHelper.hasMatch(code)) violations.add(normalizePath(file));
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Inline the widget in the tree or extract a widget class instead of a _buildXxx() method in: ${violations.join(', ')}',
    );
  });

  test('sizes are not hoisted into local variables', () {
    final violations = <String>[];
    final hoistedSize = RegExp(
      r'^\s*final\s+\w+\s*=\s*get(Width|Height|Radius|Sp)\(',
      multiLine: true,
    );

    for (final file in dartFiles) {
      final path = normalizePath(file);
      final isUi =
          path.startsWith('lib/core/widgets/') ||
          path.startsWith('lib/features/');
      if (!isUi) continue;

      final code = stripComments(file.readAsStringSync());
      if (hoistedSize.hasMatch(code)) violations.add(path);
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Write getWidth/getHeight/getRadius/getSp inline at each use instead of a local variable in: ${violations.join(', ')}',
    );
  });

  test('CustomText never gets fontSize or fontWeight', () {
    final violations = <String>[];
    final nestedCall = RegExp(r'\([^()]*\)');
    final sizeOrWeight = RegExp(r'\b(fontSize|fontWeight)\s*:');

    for (final file in dartFiles) {
      final path = normalizePath(file);
      if (path == 'lib/core/widgets/custom_text.dart') continue;

      final code = stripComments(file.readAsStringSync());
      for (final match in RegExp(r'\bCustomText\(').allMatches(code)) {
        // Finds the end of this CustomText(...) call by matching parentheses.
        var depth = 1;
        var end = match.end;
        while (end < code.length && depth > 0) {
          if (code[end] == '(') depth++;
          if (code[end] == ')') depth--;
          end++;
        }

        // Removes nested calls, so a StrutStyle(fontSize: ...) argument doesn't count.
        var args = code.substring(match.end, end - 1);
        while (nestedCall.hasMatch(args)) {
          args = args.replaceAll(nestedCall, '');
        }

        if (sizeOrWeight.hasMatch(args)) {
          violations.add(path);
          break;
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Pick a context.textTheme style instead of passing fontSize or fontWeight to CustomText in: ${violations.join(', ')}',
    );
  });

  test('feature widgets are prefixed with their feature name', () {
    final violations = <String>[];
    final featureWidget = RegExp(r'^lib/features/(\w+)/widgets/(\w+)\.dart$');

    for (final file in dartFiles) {
      final match = featureWidget.firstMatch(normalizePath(file));
      if (match == null) continue;

      final feature = match.group(1)!;
      if (!match.group(2)!.startsWith('${feature}_')) {
        violations.add(normalizePath(file));
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Name feature widgets <feature>_<name>.dart in: ${violations.join(', ')}',
    );
  });

  test('doc comments follow the one-line /// rule', () {
    final violations = <String>[];
    final declaration = RegExp(
      r'^(abstract |sealed |base |final |interface |mixin )*(class|enum|extension|mixin)\b',
    );

    for (final file in dartFiles) {
      final path = normalizePath(file);
      final lines = file.readAsLinesSync();

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];

        if (RegExp(r'^\s+///').hasMatch(line)) {
          violations.add('$path:${i + 1} uses /// inside a class body');
        }

        if (line.startsWith('///') && i > 0 && lines[i - 1].startsWith('///')) {
          violations.add('$path:${i + 1} spreads a /// doc over several lines');
        }

        if (declaration.hasMatch(line)) {
          // Skips annotations such as @immutable between the doc and the declaration.
          var previous = i - 1;
          while (previous >= 0 && lines[previous].startsWith('@')) {
            previous--;
          }
          if (previous < 0 || !lines[previous].startsWith('///')) {
            violations.add('$path:${i + 1} has no /// doc');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Give every class, enum, extension and mixin exactly one /// line, and use // inside class bodies:\n${violations.join('\n')}',
    );
  });
}
