import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../features/practice/data/mock_data.dart';
import 'success_page.dart';

class RegisterPage extends StatefulWidget {
  final Event event;
  final VoidCallback onSubmit;

  const RegisterPage({super.key, required this.event, required this.onSubmit});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _wishController = TextEditingController();
  String _selectedType = 'online';

  String get _nameLabel {
    if (widget.event.formType == 'lamp') return "供灯人姓名";
    if (widget.event.formType == 'copying') return "抄经人姓名";
    return "您的姓名";
  }

  String get _typeLabel {
    if (widget.event.formType == 'lamp') return "供灯方式";
    if (widget.event.formType == 'copying') return "抄写方式";
    return "参与方式";
  }

  String get _option1Label {
    if (widget.event.formType == 'lamp') return "线上代供";
    if (widget.event.formType == 'copying') return "邮寄经书";
    return "线上共修";
  }

  String get _option2Label {
    if (widget.event.formType == 'copying') return "到场抄写";
    return "亲临现场";
  }

  String get _submitLabel {
    if (widget.event.formType == 'lamp') return "确认供灯";
    if (widget.event.formType == 'copying') return "申请抄写";
    return "确认提交";
  }

  IconData get _option1Icon {
    if (widget.event.formType == 'copying') return Icons.mail_outline;
    return Icons.language;
  }

  void _handleSubmit() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请填写完整信息')));
      return;
    }

    // Call parent to update state (e.g. mark as registered)
    widget.onSubmit();

    // Navigate to Success Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessPage(
          event: widget.event,
          onHome: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
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
          widget.event.formType == 'copying'
              ? "抄写登记"
              : (widget.event.formType == 'lamp' ? "供灯登记" : "报名登记"),
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Header Text
              Text(
                '填写信息',
                style: GoogleFonts.notoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.event.formType == 'lamp'
                    ? "一盏心灯，照亮前程。"
                    : widget.event.formType == 'copying'
                    ? "沐手焚香，静心抄写。"
                    : "请如实填写，以便我们为您安排。",
                style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(height: 32),

              // Form
              _buildTextField(
                label: _nameLabel,
                controller: _nameController,
                hint: "请输入真实姓名或法名",
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: "联系方式",
                controller: _phoneController,
                hint: "用于接收通知",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),

              // Type Selector
              Text(
                _typeLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8B5A2B),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeOption(
                      value: 'online',
                      icon: _option1Icon,
                      label: _option1Label,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTypeOption(
                      value: 'offline',
                      icon: Icons.place_outlined,
                      label: _option2Label,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Wish
              _buildTextField(
                label: "祈福心愿 (选填)",
                controller: _wishController,
                hint: "愿以此功德...",
                maxLines: 3,
              ),

              const SizedBox(height: 48),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleSubmit,
                  icon:
                      const SizedBox.shrink(), // No icon for simple clean look or add arrow
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _submitLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 2,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5A2B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shadowColor: const Color(0xFF8B5A2B).withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8B5A2B),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.notoSerif(
            fontSize: 16,
            color: const Color(0xFF2C2C2C),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFF9E9E9E).withValues(alpha: 0.5),
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 0,
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0x338B5A2B)),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0x338B5A2B)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF8B5A2B)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeOption({
    required String value,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedType == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5A2B) : const Color(0xFFFDFCF8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8B5A2B)
                : const Color(0xFF8B5A2B).withValues(alpha: 0.1),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
