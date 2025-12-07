import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:code_text_field/code_text_field.dart' as code_field;
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'dart:ui';
import '../controllers/code_controller.dart';

/// Code editor widget with syntax highlighting and glassmorphism
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1e1e1e),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Editor header with gradient
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2a2a2a),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2a2a2a),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.code, size: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '🧑‍💻 Code Editor',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    // Toolbar buttons
                    _ToolbarButton(
                      icon: Icons.copy_rounded,
                      tooltip: 'Copy Code',
                      onPressed: _controller.copyCode,
                    ),
                    const SizedBox(width: 8),
                    _ToolbarButton(
                      icon: Icons.format_align_left_rounded,
                      tooltip: 'Format Code',
                      onPressed: _controller.formatCode,
                    ),
                    const SizedBox(width: 8),
                    _ToolbarButton(
                      icon: Icons.clear_rounded,
                      tooltip: 'Clear Code',
                      onPressed: _controller.clearCode,
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Dart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Code editor field
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: code_field.CodeTheme(
                    data: code_field.CodeThemeData(styles: monokaiSublimeTheme),
                    child: SingleChildScrollView(
                      child: code_field.CodeField(
                        controller: _codeController,
                        textStyle: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 15,
                          height: 1.6,
                          letterSpacing: 0.3,
                        ),
                        lineNumberStyle: code_field.LineNumberStyle(
                          width: 50,
                          textStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'monospace',
                          ),
                          background: const Color(0xFF252525),
                          margin: 10,
                        ),
                        expands: false,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Toolbar button widget for code editor actions
class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}
