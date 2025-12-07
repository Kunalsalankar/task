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
  print("Hello, World!")
}''';
    consoleText.value = '';
  }

  /// Updates the code text
  void updateCode(String newCode) {
    codeText.value = newCode;
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
}
