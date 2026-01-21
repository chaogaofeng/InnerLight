import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock_data.dart';
import '../../domain/entities/practice_tool.dart';

class PracticeToolsPage extends StatefulWidget {
  final List<String> enabledToolIds;

  const PracticeToolsPage({super.key, required this.enabledToolIds});

  @override
  State<PracticeToolsPage> createState() => _PracticeToolsPageState();
}

class _PracticeToolsPageState extends State<PracticeToolsPage> {
  late List<String> _currentEnabledIds;

  @override
  void initState() {
    super.initState();
    _currentEnabledIds = List.from(widget.enabledToolIds);
  }

  void _toggleTool(String id) {
    setState(() {
      if (_currentEnabledIds.contains(id)) {
        _currentEnabledIds.remove(id);
      } else {
        _currentEnabledIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pop with the new list when back button is pressed
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(_currentEnabledIds);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFCF8), // Zen Paper
        appBar: AppBar(
          backgroundColor: const Color(0xFFFDFCF8),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
            onPressed: () => Navigator.of(context).pop(_currentEnabledIds),
          ),
          centerTitle: true,
          title: Text(
            '法宝库',
            style: GoogleFonts.notoSans(
              color: const Color(0xFF2C2C2C), // Zen Ink
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        body: SafeArea(
          child: DefaultTextStyle(
            style: GoogleFonts.notoSans(color: const Color(0xFF2C2C2C)),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Intro Section
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Text(
                        '工欲善其事，必先利其器',
                        style: GoogleFonts.notoSerif(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                      Container(
                        width: 48,
                        height: 1,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                      ),
                      Text(
                        '选择助您修行的方便法门',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(
                            0xFF2C2C2C,
                          ).withValues(alpha: 0.6), // Zen Subtle
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Lists
                _buildSection('已启用', _getTools(true)),
                const SizedBox(height: 24),
                _buildSection('更多法宝', _getTools(false)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PracticeTool> _getTools(bool enabled) {
    return allPracticeTools
        .where(
          (t) => enabled
              ? _currentEnabledIds.contains(t.id)
              : !_currentEnabledIds.contains(t.id),
        )
        .toList();
  }

  Widget _buildSection(String title, List<PracticeTool> tools) {
    if (tools.isEmpty) {
      if (title == '更多法宝') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(title),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  '暂无更多法宝',
                  style: TextStyle(fontSize: 12, color: Colors.black26),
                ),
              ),
            ),
          ],
        );
      }
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        const SizedBox(height: 16),
        ...tools.map((tool) => _buildToolItem(tool)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2C2C2C).withValues(alpha: 0.4),
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildToolItem(PracticeTool tool) {
    final isAdded = _currentEnabledIds.contains(tool.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7F3).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isAdded
                  ? const Color(0xFF8B5A2B)
                  : const Color(0xFFFDFCF8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isAdded
                    ? const Color(0xFF8B5A2B)
                    : const Color(0xFF8B5A2B).withValues(alpha: 0.1),
              ),
            ),
            child: Icon(
              tool.icon,
              size: 22,
              color: isAdded
                  ? Colors.white
                  : const Color(0xFF8B5A2B).withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 16),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tool.title,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tool.desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF2C2C2C).withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          // Action Button
          IconButton(
            onPressed: () => _toggleTool(tool.id),
            icon: Icon(
              isAdded ? Icons.check : Icons.add,
              color: isAdded
                  ? const Color(0xFF8B5A2B).withValues(alpha: 0.4)
                  : const Color(0xFF8B5A2B),
            ),
            style: IconButton.styleFrom(
              backgroundColor: isAdded
                  ? Colors.transparent
                  : const Color(0xFF8B5A2B).withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
