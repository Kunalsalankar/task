import 'package:get/get.dart';
import '../services/auto_fix_service.dart';
import '../services/help_service.dart';

/// Main controller managing the code editor state using GetX
class CodeController extends GetxController {
  // Observable state variables
  final codeText = ''.obs;
  final consoleText = ''.obs;
  final isHelpPanelVisible = false.obs;
  final helpQuery = ''.obs;
  final helpAnswer = ''.obs;

  // Service instances
  final AutoFixService _autoFixService = AutoFixService();
  final HelpService _helpService = HelpService();

  @override
  void onInit() {
    super.onInit();
    // Set initial code with a sample
    codeText.value = '''void main() {
  print("Hello, World!");
}''';
    consoleText.value = '';
  }

  /// Updates the code text
  void updateCode(String newCode) {
    codeText.value = newCode;
  }

  /// Checks for syntax errors in the code
  String? _checkSyntaxErrors(String code) {
    final lines = code.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trimRight();
      
      // Skip empty lines and comments
      if (trimmed.isEmpty || trimmed.startsWith('//')) {
        continue;
      }
      
      // Skip lines that are declarations (void, class, if, for, while)
      if (trimmed.contains('void ') || 
          trimmed.contains('class ') || 
          trimmed.contains('if ') || 
          trimmed.contains('for ') || 
          trimmed.contains('while ')) {
        continue;
      }
      
      // Skip lines ending with opening or closing brace
      if (trimmed.endsWith('{') || trimmed.endsWith('}')) {
        continue;
      }
      
      // If line already ends with semicolon, it's fine
      if (trimmed.endsWith(';')) {
        continue;
      }
      
      // Check for print statements - they must end with );
      if (trimmed.contains('print(')) {
        // If it ends with ) but NOT );, it's missing a semicolon
        if (trimmed.endsWith(')') && !trimmed.endsWith(');')) {
          return 'Missing semicolon on line ${i + 1}';
        }
      }
      
      // Check for assignment statements that need semicolons
      if (trimmed.contains('=') && 
          !trimmed.contains('==') && 
          !trimmed.contains('!=') &&
          !trimmed.endsWith(';') &&
          !trimmed.contains('void ') && 
          !trimmed.contains('class ')) {
        return 'Missing semicolon on line ${i + 1}';
      }
      
      // Check for return statements
      if (trimmed.startsWith('return') && !trimmed.endsWith(';')) {
        return 'Missing semicolon on line ${i + 1}';
      }
    }
    
    return null;
  }

  /// Simulates running the code and displays output in console
  Future<void> runCode() async {
    if (codeText.value.trim().isEmpty) {
      consoleText.value = '❌ Error: No code to run!';
      return;
    }

    consoleText.value = '⏳ Running code...';
    
    // Simulate short delay for realism
    await Future.delayed(const Duration(milliseconds: 500));

    // Check for syntax errors first
    final syntaxError = _checkSyntaxErrors(codeText.value);
    if (syntaxError != null) {
      consoleText.value = '''⏳ Running code...

❌ Compilation Error:
   $syntaxError
   
💡 Tip: Use the AUTO FIX button to automatically fix this issue!

❌ Process finished with exit code 1''';
      return;
    }

    // Extract all print statements and their content
    // Match print("...") or print('...')
    final printPatternDouble = RegExp(r'print\s*\(\s*"([^"]*)"\s*\)', multiLine: true);
    final printPatternSingle = RegExp(r"print\s*\(\s*'([^']*)'\s*\)", multiLine: true);
    
    final matchesDouble = printPatternDouble.allMatches(codeText.value);
    final matchesSingle = printPatternSingle.allMatches(codeText.value);
    
    final outputs = <String>[];
    for (var match in matchesDouble) {
      outputs.add(match.group(1) ?? '');
    }
    for (var match in matchesSingle) {
      outputs.add(match.group(1) ?? '');
    }
    
    if (outputs.isEmpty) {
      // Check if there's a print statement without quotes (for variables, etc.)
      final hasPrint = RegExp(r'print\s*\(').hasMatch(codeText.value);
      if (hasPrint) {
        consoleText.value = '''⏳ Running code...

📤 Output:
   (Print statement found but output cannot be determined)

✅ Process finished with exit code 0''';
      } else {
        consoleText.value = '''⏳ Running code...

📤 Output:
   (No print statement found)
   💡 Try adding: print("Hello, World!");

✅ Process finished with exit code 0''';
      }
    } else {
      
      // Build console output with all print statements
      final outputLines = outputs.map((out) => '   $out').join('\n');
      consoleText.value = '''⏳ Running code...

📤 Output:
$outputLines

✅ Process finished with exit code 0''';
    }
  }

  /// Applies auto-fix to the current code
  void autoFixCode() {
    final fixedCode = _autoFixService.fixCode(codeText.value);
    codeText.value = fixedCode;
    consoleText.value = 'Auto-fix applied successfully!';
  }

  /// Toggles the help panel visibility
  void toggleHelpPanel() {
    isHelpPanelVisible.value = !isHelpPanelVisible.value;
    if (!isHelpPanelVisible.value) {
      // Reset help query and answer when closing
      helpQuery.value = '';
      helpAnswer.value = '';
    }
  }

  /// Processes the help query using keyword matching
  void searchHelp(String query) {
    helpQuery.value = query;
    helpAnswer.value = _helpService.getHelp(query);
  }

  /// Copies the current code to clipboard
  void copyCode() {
    // In a real app, you'd use Clipboard.setData
    consoleText.value = '📋 Code copied to clipboard!';
  }

  /// Clears the code editor
  void clearCode() {
    codeText.value = '';
    consoleText.value = '';
  }

  /// Formats the code (same as auto-fix for now)
  void formatCode() {
    final formattedCode = _autoFixService.fixCode(codeText.value);
    codeText.value = formattedCode;
    consoleText.value = '✨ Code formatted successfully!';
  }
}
