/// Service for automatically fixing common code issues
class AutoFixService {
  /// Fixes common code issues like missing semicolons, indentation, etc.
  String fixCode(String code) {
    String fixedCode = code;

    // 1. Add missing semicolons at end of lines
    fixedCode = _addMissingSemicolons(fixedCode);

    // 2. Remove extra spaces (multiple spaces to single space)
    fixedCode = _removeExtraSpaces(fixedCode);

    // 3. Fix basic indentation
    fixedCode = _fixIndentation(fixedCode);

    // 4. Fix simple bracket issues (add missing closing brackets)
    fixedCode = _fixBrackets(fixedCode);

    return fixedCode;
  }

  /// Adds semicolons to lines that likely need them
  String _addMissingSemicolons(String code) {
    final lines = code.split('\n');
    final fixedLines = <String>[];

    for (var line in lines) {
      final trimmed = line.trimRight();
      
      // Skip empty lines, lines with braces, or lines already ending with semicolon
      if (trimmed.isEmpty || 
          trimmed.endsWith('{') || 
          trimmed.endsWith('}') ||
          trimmed.endsWith(';') ||
          trimmed.endsWith('(') ||
          trimmed.endsWith(')') ||
          trimmed.startsWith('//') ||
          trimmed.contains('void ') ||
          trimmed.contains('class ') ||
          trimmed.contains('if ') ||
          trimmed.contains('for ') ||
          trimmed.contains('while ')) {
        fixedLines.add(line);
      } else {
        // Add semicolon if it looks like a statement
        if (trimmed.contains('print(') || 
            trimmed.contains('=') || 
            trimmed.contains('return')) {
          fixedLines.add('$trimmed;');
        } else {
          fixedLines.add(line);
        }
      }
    }

    return fixedLines.join('\n');
  }

  /// Removes extra spaces (multiple consecutive spaces)
  String _removeExtraSpaces(String code) {
    // Replace multiple spaces with single space, but preserve indentation
    final lines = code.split('\n');
    final fixedLines = <String>[];

    for (var line in lines) {
      // Get leading whitespace
      final leadingSpaces = line.length - line.trimLeft().length;
      final leading = line.substring(0, leadingSpaces);
      final content = line.substring(leadingSpaces);
      
      // Remove extra spaces in content only
      final fixedContent = content.replaceAll(RegExp(r' {2,}'), ' ');
      fixedLines.add('$leading$fixedContent');
    }

    return fixedLines.join('\n');
  }

  /// Fixes basic indentation using simple rules
  String _fixIndentation(String code) {
    final lines = code.split('\n');
    final fixedLines = <String>[];
    int indentLevel = 0;
    const indentSize = 2; // 2 spaces per indent level

    for (var line in lines) {
      final trimmed = line.trim();
      
      if (trimmed.isEmpty) {
        fixedLines.add('');
        continue;
      }

      // Decrease indent for closing braces
      if (trimmed.startsWith('}')) {
        indentLevel = (indentLevel - 1).clamp(0, 100);
      }

      // Add proper indentation
      final indent = ' ' * (indentLevel * indentSize);
      fixedLines.add('$indent$trimmed');

      // Increase indent after opening braces
      if (trimmed.endsWith('{')) {
        indentLevel++;
      }
    }

    return fixedLines.join('\n');
  }

  /// Attempts to fix simple bracket mismatches
  String _fixBrackets(String code) {
    // Count opening and closing braces
    final openBraces = '{'.allMatches(code).length;
    final closeBraces = '}'.allMatches(code).length;

    // Add missing closing braces at the end
    if (openBraces > closeBraces) {
      final missing = openBraces - closeBraces;
      code = code + ('\n}' * missing);
    }

    return code;
  }
}
