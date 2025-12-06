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
    consoleText.value = 'Console output will appear here...';
  }

  /// Updates the code text
  void updateCode(String newCode) {
    codeText.value = newCode;
  }

  /// Simulates running the code and displays output in console
  void runCode() {
    if (codeText.value.trim().isEmpty) {
      consoleText.value = 'Error: No code to run!';
      return;
    }

    // Simulate code execution with fake output
    consoleText.value = '''Running code...
-------------------
Output:
Hello, World!
-------------------
Process finished with exit code 0
Execution time: 0.${DateTime.now().millisecond}s''';
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
