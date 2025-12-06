import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/code_controller.dart';
import '../widgets/code_editor_widget.dart';

/// Main home view containing the code editor, console, and controls
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final CodeController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Editor App'),
        centerTitle: true,
        actions: [
          // Help button in top-right
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: controller.toggleHelpPanel,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Action buttons row
              _buildActionButtons(controller),
              
              const Divider(height: 1),
              
              // Code editor area
              Expanded(
                flex: 3,
                child: CodeEditorWidget(),
              ),
              
              const Divider(height: 1),
              
              // Console output area
              Expanded(
                flex: 1,
                child: _buildConsole(controller),
              ),
            ],
          ),
          
          // Help panel overlay
          Obx(() => controller.isHelpPanelVisible.value
              ? _buildHelpPanel(controller)
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  /// Builds the action buttons (Run and Auto Fix)
  Widget _buildActionButtons(CodeController controller) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          // Run button
          ElevatedButton.icon(
            onPressed: controller.runCode,
            icon: const Icon(Icons.play_arrow),
            label: const Text('RUN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Auto Fix button
          ElevatedButton.icon(
            onPressed: controller.autoFixCode,
            icon: const Icon(Icons.auto_fix_high),
            label: const Text('Auto Fix'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          
          const Spacer(),
          
          // Info text
          const Text(
            'Write your code and click RUN',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the console output area
  Widget _buildConsole(CodeController controller) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Console header
          Row(
            children: [
              const Icon(Icons.terminal, size: 16, color: Colors.white70),
              const SizedBox(width: 8),
              const Text(
                'Console Output',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Console text output
          Expanded(
            child: SingleChildScrollView(
              child: Obx(() => SelectableText(
                controller.consoleText.value,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.greenAccent,
                  fontSize: 13,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the help panel as a side drawer
  Widget _buildHelpPanel(CodeController controller) {
    return GestureDetector(
      onTap: controller.toggleHelpPanel, // Close when tapping outside
      child: Container(
        color: Colors.black54,
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping inside panel
            child: Container(
              width: 400,
              height: double.infinity,
              color: Colors.grey[900],
              child: Column(
                children: [
                  // Help panel header
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.deepPurple,
                    child: Row(
                      children: [
                        const Icon(Icons.help, color: Colors.white),
                        const SizedBox(width: 12),
                        const Text(
                          'Help Center',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: controller.toggleHelpPanel,
                        ),
                      ],
                    ),
                  ),
                  
                  // Search input
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Ask a question...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                      ),
                      onSubmitted: controller.searchHelp,
                      onChanged: (value) {
                        // Update query as user types
                        controller.helpQuery.value = value;
                      },
                    ),
                  ),
                  
                  // Help answer display
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Obx(() {
                        final answer = controller.helpAnswer.value;
                        return answer.isEmpty
                            ? const Center(
                                child: Text(
                                  'Type a question and press Enter',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SelectableText(
                                  answer,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
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
    );
  }
}
