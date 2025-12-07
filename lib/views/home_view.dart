import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../controllers/code_controller.dart';
import '../widgets/code_editor_widget.dart';

/// Main home view containing the code editor, console, and controls
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final CodeController controller = Get.find();

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1a1a1a),
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF2a2a2a),
                width: 1,
              ),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.code, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Code Playground',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            actions: [
              Obx(() => AnimatedRotation(
                turns: controller.isHelpPanelVisible.value ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: IconButton(
                  icon: const Icon(Icons.help_outline, size: 26),
                  tooltip: 'Help',
                  onPressed: controller.toggleHelpPanel,
                ),
              )),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0a0a0a),
        ),
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Action buttons row
                _buildActionButtons(controller),
                
                const SizedBox(height: 12),
                
                // Code editor area
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 8.0),
                    child: CodeEditorWidget(),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Console output area
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: _buildConsole(controller),
                  ),
                ),
              ],
            ),
            
            // Help panel overlay
            Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: controller.isHelpPanelVisible.value
                  ? _buildHelpPanel(controller)
                  : const SizedBox.shrink(),
            )),
          ],
        ),
      ),
    );
  }

  /// Builds the action buttons (Run and Auto Fix)
  Widget _buildActionButtons(CodeController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Run button with gradient
          _GradientButton(
            onPressed: controller.runCode,
            icon: Icons.play_arrow_rounded,
            label: 'RUN CODE',
            gradient: const LinearGradient(
              colors: [Color(0xFF22c55e), Color(0xFF16a34a)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Auto Fix button with gradient
          _GradientButton(
            onPressed: controller.autoFixCode,
            icon: Icons.auto_fix_high_rounded,
            label: 'AUTO FIX',
            gradient: const LinearGradient(
              colors: [Color(0xFFf59e0b), Color(0xFFe67e22)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          
          const Spacer(),
          
          // Info text with icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a1a),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Write your code and click RUN',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the console output area with glassmorphism
  Widget _buildConsole(CodeController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a1a),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Console header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2a2a2a),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.terminal, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '🖥️ Console Output',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Obx(() => controller.consoleText.value.contains('Running')
                      ? _PulsingIndicator(
                          color: Colors.white.withOpacity(0.8),
                        )
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: controller.consoleText.value.contains('Error')
                                ? const Color(0xFFef4444)
                                : Colors.white.withOpacity(0.6),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (controller.consoleText.value.contains('Error')
                                        ? const Color(0xFFef4444)
                                        : Colors.white)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        )),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0f0f0f),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  child: Obx(() {
                    final text = controller.consoleText.value;
                    return Scrollbar(
                      thumbVisibility: true,
                      thickness: 6,
                      radius: const Radius.circular(3),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(14),
                        child: _buildFormattedConsoleText(text),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds formatted console text with syntax highlighting
  Widget _buildFormattedConsoleText(String text) {
    if (text.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.code_off_rounded,
                size: 48,
                color: Colors.white.withOpacity(0.2),
              ),
              const SizedBox(height: 12),
              Text(
                'Console output will appear here...',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 14,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final lines = text.split('\n');
    final spans = <TextSpan>[];
    bool hasOutputLabel = false;
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      TextSpan span;
      
      if (line.contains('⏳ Running code...')) {
        span = TextSpan(
          text: '$line\n',
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFFfbbf24),
            fontSize: 15,
            height: 1.6,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        );
        spans.add(span);
      } else if (line.contains('📤 Output:')) {
        hasOutputLabel = true;
        span = TextSpan(
          text: '$line\n',
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFF60a5fa),
            fontSize: 17,
            height: 1.6,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        );
        spans.add(span);
        // Add divider after Output: label
        if (i < lines.length - 1 && lines[i + 1].trim().isNotEmpty) {
          spans.add(TextSpan(
            text: '─────────────────────────\n',
            style: TextStyle(
              fontFamily: 'monospace',
              color: Colors.white.withOpacity(0.2),
              fontSize: 14,
              height: 1.6,
            ),
          ));
        }
      } else if (line.contains('✅ Process finished')) {
        span = TextSpan(
          text: '$line\n',
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFF22c55e),
            fontSize: 14,
            height: 1.6,
            fontWeight: FontWeight.w600,
          ),
        );
        spans.add(span);
      } else if (line.contains('❌ Error:') || line.contains('Error:') || line.contains('Compilation Error:')) {
        span = TextSpan(
          text: '$line\n',
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFFef4444),
            fontSize: 14,
            height: 1.6,
            fontWeight: FontWeight.w600,
          ),
        );
        spans.add(span);
      } else if (line.trim().startsWith('(') && line.trim().endsWith(')')) {
        span = TextSpan(
          text: '$line\n',
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFF94a3b8),
            fontSize: 14,
            height: 1.6,
            fontStyle: FontStyle.italic,
          ),
        );
        spans.add(span);
      } else if (line.trim().startsWith('💡')) {
        span = TextSpan(
          text: '$line\n',
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFFa78bfa),
            fontSize: 14,
            height: 1.6,
          ),
        );
        spans.add(span);
      } else if (line.trim().isNotEmpty && !line.trim().startsWith('(')) {
        // Regular output lines
        span = TextSpan(
          text: '$line\n',
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFF4ade80),
            fontSize: 15,
            height: 1.6,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        );
        spans.add(span);
      } else {
        span = TextSpan(
          text: '$line\n',
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFF64748b),
            fontSize: 14,
            height: 1.6,
          ),
        );
        spans.add(span);
      }
        }
        
        return RichText(
          textWidthBasis: TextWidthBasis.longestLine,
          text: TextSpan(children: spans),
        );
  }

  /// Builds the help panel with slide animation and glassmorphism
  Widget _buildHelpPanel(CodeController controller) {
    return GestureDetector(
      onTap: controller.toggleHelpPanel,
      child: Container(
        color: Colors.black.withOpacity(0.6),
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(400 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 400,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1a1a1a),
                      border: Border(
                        left: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Help panel header with gradient
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2a2a2a),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.help, color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Help Center',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white, size: 24),
                                onPressed: controller.toggleHelpPanel,
                              ),
                            ],
                          ),
                        ),
                        
                        // Search input with modern styling
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Ask a question...',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              onSubmitted: controller.searchHelp,
                              onChanged: (value) {
                                controller.helpQuery.value = value;
                              },
                            ),
                          ),
                        ),
                        
                        // Help answer display
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20.0),
                            child: Obx(() {
                              final answer = controller.helpAnswer.value;
                              return answer.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.lightbulb_outline,
                                            size: 64,
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Type a question and press Enter',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.4),
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                      child: SelectableText(
                                        answer,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.6,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pulsing indicator widget for running status
class _PulsingIndicator extends StatefulWidget {
  final Color color;

  const _PulsingIndicator({required this.color});

  @override
  State<_PulsingIndicator> createState() => _PulsingIndicatorState();
}

class _PulsingIndicatorState extends State<_PulsingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_animation.value * 0.6),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Custom gradient button widget with hover effect
class _GradientButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Gradient gradient;

  const _GradientButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.gradient,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.colors.first.withOpacity(0.4),
                blurRadius: _isHovered ? 20 : 10,
                spreadRadius: _isHovered ? 2 : 0,
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: widget.onPressed,
            icon: Icon(widget.icon, size: 20),
            label: Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.8,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
