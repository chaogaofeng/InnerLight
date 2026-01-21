import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileEditPage extends StatefulWidget {
  final String initialName;
  final String initialTitle;
  final Color initialColor;

  const ProfileEditPage({
    super.key,
    required this.initialName,
    required this.initialTitle,
    required this.initialColor,
  });

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameController;
  late String _selectedTitle;
  late Color _avatarColor;

  final List<Color> _avatarColors = const [
    Color(0xFFF2EFE9), // Default Paper
    Color(0xFFE6EFE9), // Pale Green
    Color(0xFFF9F7F3), // Warm White
    Color(0xFFEFEDE7), // Sepia
    Color(0xFFE0E7E9), // Light Blue
    Color(0xFFE9E0E0), // Light Red
  ];

  final List<String> _titles = const ['初发心', '在家居士', '行者', '禅修者', '护法'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _selectedTitle = widget.initialTitle;
    _avatarColor = widget.initialColor;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _cycleAvatarColor() {
    setState(() {
      final index = _avatarColors.indexOf(_avatarColor);
      Color nextColor;
      if (index == -1) {
        nextColor = _avatarColors[0];
      } else {
        nextColor = _avatarColors[(index + 1) % _avatarColors.length];
      }
      _avatarColor = nextColor;
    });
  }

  void _handleSave() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入法名')));
      return;
    }

    Navigator.pop(context, {
      'name': _nameController.text.trim(),
      'title': _selectedTitle,
      'avatarColor': _avatarColor,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF8), // zen-bg
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFCF8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '个人设置',
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // 1. Avatar Section
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _cycleAvatarColor,
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(
                                  0xFF8B5A2B,
                                ).withValues(alpha: 0.2),
                                width: 2,
                              ),
                              color: const Color(0xFFFDFCF8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                color: _avatarColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: const Color(
                                    0xFF8B5A2B,
                                  ).withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5A2B),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFFDFCF8),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.refresh,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '点击头像切换底色',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF9E9E9E).withValues(alpha: 0.8),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // 2. Name Input
              CrossAxisAlignment.start != CrossAxisAlignment.start
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            '法名 / 昵称',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(
                                0xFF8B5A2B,
                              ).withValues(alpha: 0.8),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _nameController,
                          style: GoogleFonts.notoSerif(
                            fontSize: 18,
                            color: const Color(0xFF2C2C2C),
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: '请输入您的法名',
                            hintStyle: TextStyle(
                              color: const Color(
                                0xFF9E9E9E,
                              ).withValues(alpha: 0.3),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: const Color(
                                  0xFF8B5A2B,
                                ).withValues(alpha: 0.2),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF8B5A2B),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                          ),
                          maxLength: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, top: 4),
                          child: Text(
                            '给自己起一个庄严的法名，时刻提醒自己。',
                            style: TextStyle(
                              fontSize: 10,
                              color: const Color(
                                0xFF9E9E9E,
                              ).withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 32),

              // 3. Title Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      '修行身份',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.8),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.8,
                        ),
                    itemCount: _titles.length,
                    itemBuilder: (context, index) {
                      final title = _titles[index];
                      final isSelected = _selectedTitle == title;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTitle = title;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(
                                    0xFF8B5A2B,
                                  ).withValues(alpha: 0.05)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF8B5A2B)
                                  : const Color(
                                      0xFF8B5A2B,
                                    ).withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.notoSerif(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? const Color(0xFF8B5A2B)
                                      : const Color(
                                          0xFF2C2C2C,
                                        ).withValues(alpha: 0.6),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Color(0xFF8B5A2B),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // 4. Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5A2B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                  ),
                  child: const Text(
                    '保存修改',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
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
