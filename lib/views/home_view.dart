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
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0f172a),
              const Color(0xFF1e293b).withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Action buttons row
                _buildActionButtons(controller),
                
                const SizedBox(height: 8),
                
                // Code editor area
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CodeEditorWidget(),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Console output area
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Run button with gradient
          _GradientButton(
            onPressed: controller.runCode,
            icon: Icons.play_arrow,
            label: 'RUN CODE',
            gradient: const LinearGradient(
              colors: [Color(0xFF10b981), Color(0xFF059669)],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Auto Fix button with gradient
          _GradientButton(
            onPressed: controller.autoFixCode,
            icon: Icons.auto_fix_high,
            label: 'AUTO FIX',
            gradient: const LinearGradient(
              colors: [Color(0xFFf59e0b), Color(0xFFd97706)],
            ),
          ),
          
          const Spacer(),
          
          // Info text with icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.white.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  'Write your code and click RUN',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
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
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea).withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
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
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.terminal, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Console Output',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10b981),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10b981).withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Console text output with proper scrolling
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1b26).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Obx(() => SingleChildScrollView(
                    child: SelectableText(
                      controller.consoleText.value,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Color(0xFF00ffff), // Bright cyan for better visibility
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
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
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1e293b).withOpacity(0.95),
                          const Color(0xFF0f172a).withOpacity(0.95),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
                            gradient: LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
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
                                  color: const Color(0xFF667eea).withOpacity(0.1),
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
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF667eea),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF667eea),
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
                letterSpacing: 0.5,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
