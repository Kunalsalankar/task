/// Service for providing help based on keyword matching
class HelpService {
  /// Returns help text based on keyword matching in the query
  String getHelp(String query) {
    final lowerQuery = query.toLowerCase();

    // Keyword matching logic
    if (lowerQuery.contains('semicolon') || lowerQuery.contains(';')) {
      return _getSemicolonHelp();
    } else if (lowerQuery.contains('run') || lowerQuery.contains('execute')) {
      return _getRunHelp();
    } else if (lowerQuery.contains('indent') || lowerQuery.contains('indentation')) {
      return _getIndentationHelp();
    } else if (lowerQuery.contains('bracket') || lowerQuery.contains('brace') || lowerQuery.contains('{') || lowerQuery.contains('}')) {
      return _getBracketHelp();
    } else if (lowerQuery.contains('auto') || lowerQuery.contains('fix')) {
      return _getAutoFixHelp();
    } else if (lowerQuery.contains('print')) {
      return _getPrintHelp();
    } else if (lowerQuery.isEmpty) {
      return 'Please enter a question to get help.';
    } else {
      return _getDefaultHelp();
    }
  }

  String _getSemicolonHelp() {
    return '''**Semicolon Help**

In Dart/Flutter, semicolons are used to end statements.

✓ Correct:
  print("Hello");
  int x = 5;

✗ Incorrect:
  print("Hello")
  int x = 5

Tip: Use the Auto Fix button to automatically add missing semicolons!''';
  }

  String _getRunHelp() {
    return '''**How to Run Code**

1. Write your Dart code in the editor
2. Click the RUN button (▶️)
3. View the output in the console below

Note: This is a simulated environment. The code doesn't actually execute, but shows sample output.''';
  }

  String _getIndentationHelp() {
    return '''**Indentation Help**

Proper indentation makes code readable:

✓ Good indentation:
void main() {
  if (true) {
    print("Hello");
  }
}

✗ Poor indentation:
void main() {
if (true) {
print("Hello");
}
}

Tip: Use the Auto Fix button to automatically fix indentation!''';
  }

  String _getBracketHelp() {
    return '''**Bracket/Brace Help**

Curly braces {} must be balanced:

✓ Correct:
void main() {
  print("Hello");
}

✗ Missing closing brace:
void main() {
  print("Hello");

Tip: Auto Fix can detect and add missing closing braces!''';
  }

  String _getAutoFixHelp() {
    return '''**Auto Fix Feature**

The Auto Fix button automatically fixes:
• Missing semicolons
• Extra spaces
• Indentation issues
• Missing closing brackets

Simply click the "Auto Fix" button to apply all fixes at once!''';
  }

  String _getPrintHelp() {
    return '''**Print Statement Help**

Use print() to output text:

Example:
  print("Hello, World!");
  print("Value: " + value.toString());

Remember to:
• Use quotes for strings
• End with a semicolon
• Close parentheses properly''';
  }

  String _getDefaultHelp() {
    return '''**Help Topics**

I can help you with:
• Semicolons - How to use semicolons
• Run - How to run your code
• Indentation - Formatting your code
• Brackets - Using braces correctly
• Auto Fix - Using the auto-fix feature
• Print - Using print statements

Try asking about any of these topics!''';
  }
}
