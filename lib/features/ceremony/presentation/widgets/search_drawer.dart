import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchCriteria {
  final String keyword;
  final String location;
  final String startDate;
  final String endDate;

  const SearchCriteria({
    this.keyword = '',
    this.location = '',
    this.startDate = '',
    this.endDate = '',
  });

  bool get isEmpty =>
      keyword.isEmpty &&
      location.isEmpty &&
      startDate.isEmpty &&
      endDate.isEmpty;

  SearchCriteria copyWith({
    String? keyword,
    String? location,
    String? startDate,
    String? endDate,
  }) {
    return SearchCriteria(
      keyword: keyword ?? this.keyword,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class SearchDrawer extends StatefulWidget {
  final SearchCriteria initialCriteria;
  final Function(SearchCriteria) onSearch;

  const SearchDrawer({
    super.key,
    required this.initialCriteria,
    required this.onSearch,
  });

  @override
  State<SearchDrawer> createState() => _SearchDrawerState();
}

class _SearchDrawerState extends State<SearchDrawer> {
  late TextEditingController _keywordController;
  late TextEditingController _locationController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  final List<String> _locationSuggestions = [
    '杭州灵隐寺',
    '普陀山',
    '苏州寒山寺',
    '南京鸡鸣寺',
    '终南山',
  ];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _keywordController = TextEditingController(
      text: widget.initialCriteria.keyword,
    );
    _locationController = TextEditingController(
      text: widget.initialCriteria.location,
    );
    _startDateController = TextEditingController(
      text: widget.initialCriteria.startDate,
    );
    _endDateController = TextEditingController(
      text: widget.initialCriteria.endDate,
    );
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _handleReset() {
    _keywordController.clear();
    _locationController.clear();
    _startDateController.clear();
    _endDateController.clear();
    setState(() {});
  }

  void _handleApply() {
    widget.onSearch(
      SearchCriteria(
        keyword: _keywordController.text,
        location: _locationController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
      ),
    );
    Navigator.pop(context);
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B5A2B),
              onPrimary: Colors.white,
              onSurface: Color(0xFF2C2C2C),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFFDFCF8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '高级检索',
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF9E9E9E)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Keyword
          _buildLabel(Icons.search, '关键词'),
          TextField(
            controller: _keywordController,
            decoration: _inputDecoration('搜索法会名称、内容...'),
            style: GoogleFonts.notoSans(fontSize: 14),
          ),
          const SizedBox(height: 20),

          // Location
          _buildLabel(Icons.place_outlined, '地点 / 寺院'),
          Column(
            children: [
              TextField(
                controller: _locationController,
                focusNode: FocusNode()
                  ..addListener(() {
                    // Simple focus listener if needed
                  }),
                onChanged: (value) {
                  setState(() {
                    _showSuggestions = value.isNotEmpty;
                  });
                },
                decoration: _inputDecoration('例如：灵隐寺'),
                style: GoogleFonts.notoSans(fontSize: 14),
              ),
              if (_showSuggestions && _locationController.text.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: _locationSuggestions
                        .where((s) => s.contains(_locationController.text))
                        .map(
                          (s) => InkWell(
                            onTap: () {
                              _locationController.text = s;
                              setState(() => _showSuggestions = false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                s,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Date Range
          _buildLabel(Icons.calendar_today_outlined, '时间范围'),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(_startDateController),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _startDateController,
                      decoration: _inputDecoration('开始日期'),
                      style: GoogleFonts.notoSans(fontSize: 14),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('-', style: TextStyle(color: Color(0xFF9E9E9E))),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(_endDateController),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _endDateController,
                      decoration: _inputDecoration('结束日期'),
                      style: GoogleFonts.notoSans(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _handleReset,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.refresh,
                        size: 16,
                        color: Color(0xFF9E9E9E),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '重置',
                        style: TextStyle(
                          color: const Color(0xFF2C2C2C).withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _handleApply,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF8B5A2B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 16, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        '搜索',
                        style: TextStyle(color: Colors.white, letterSpacing: 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ), // Keyboard padding
        ],
      ),
    );
  }

  Widget _buildLabel(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xFF8B5A2B).withValues(alpha: 0.7),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9E9E9E),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: const Color(0xFF9E9E9E).withValues(alpha: 0.5),
        fontSize: 13,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      filled: true,
      fillColor: const Color(0xFFF9F7F3), // zen-paper/50 ish
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF8B5A2B)),
      ),
      isDense: true,
    );
  }
}
