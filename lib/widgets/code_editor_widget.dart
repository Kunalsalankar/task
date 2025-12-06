import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:code_text_field/code_text_field.dart' as code_field;
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import '../controllers/code_controller.dart';

/// Code editor widget with syntax highlighting
class CodeEditorWidget extends StatefulWidget {
  const CodeEditorWidget({super.key});

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late CodeController _controller;
  late code_field.CodeController _codeController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CodeController>();
    
    // Initialize the code editor controller with Dart syntax highlighting
    _codeController = code_field.CodeController(
      text: _controller.codeText.value,
      language: dart,
    );

    // Listen to changes in the GetX controller and update code editor
    ever(_controller.codeText, (String newCode) {
      if (_codeController.text != newCode) {
        _codeController.text = newCode;
      }
    });

    // Listen to code editor changes and update GetX controller
    _codeController.addListener(() {
      if (_controller.codeText.value != _codeController.text) {
        _controller.updateCode(_codeController.text);
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF23241F), // Monokai background color
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Editor header
          Row(
            children: [
              const Icon(Icons.code, size: 16, color: Colors.white70),
              const SizedBox(width: 8),
              const Text(
                'Code Editor',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Dart',
                style: TextStyle(
                  color: Colors.blue[300],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Code editor field
          Expanded(
            child: code_field.CodeTheme(
              data: code_field.CodeThemeData(styles: monokaiSublimeTheme),
              child: SingleChildScrollView(
                child: code_field.CodeField(
                  controller: _codeController,
                  textStyle: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                  lineNumberStyle: const code_field.LineNumberStyle(
                    width: 50,
                    textStyle: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                  expands: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
