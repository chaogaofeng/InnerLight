import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../features/practice/data/mock_data.dart';
import 'register_page.dart';

class CeremonyDetailPage extends StatefulWidget {
  final Event event;

  const CeremonyDetailPage({super.key, required this.event});

  @override
  State<CeremonyDetailPage> createState() => _CeremonyDetailPageState();
}

class _CeremonyDetailPageState extends State<CeremonyDetailPage> {
  bool _isCollected = false;
  bool _isRegistered = false;

  void _toggleCollection() {
    setState(() {
      _isCollected = !_isCollected;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isCollected ? '已收藏' : '已取消收藏'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(
          event: widget.event,
          onSubmit: () {
            setState(() {
              _isRegistered = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('报名成功'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Color(0xFF8B5A2B),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getButtonText(String formType) {
    if (_isRegistered) return '已报名';
    switch (formType) {
      case 'lamp':
        return '立即供灯';
      case 'copying':
        return '申请抄写';
      default:
        return '立即报名';
    }
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
          widget.event.title,
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isCollected ? Icons.favorite : Icons.favorite_border,
              color: _isCollected
                  ? const Color(0xFF8B5A2B)
                  : const Color(0xFF2C2C2C),
            ),
            onPressed: _toggleCollection,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF2C2C2C)),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('已复制活动链接')));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Header Section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F7F3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFBA1A1A).withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  widget.event.status,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFBA1A1A),
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.event.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerif(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C2C2C),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 1,
                    color: const Color(0xFF9E9E9E).withValues(alpha: 0.3),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.event.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 1,
                    color: const Color(0xFF9E9E9E).withValues(alpha: 0.3),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 2. Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F7F3).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: -32,
                      top: -32,
                      child: Icon(
                        widget.event.icon,
                        size: 140,
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.05),
                      ),
                    ),
                    Column(
                      children: [
                        _buildInfoRow(
                          '时间',
                          widget.event.time,
                          Icons.calendar_today_outlined,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(height: 1, color: Color(0x1A8B5A2B)),
                        ),
                        _buildInfoRow(
                          '地点',
                          widget.event.temple,
                          Icons.place_outlined,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(height: 1, color: Color(0x1A8B5A2B)),
                        ),
                        _buildInfoRow(
                          '形式',
                          widget.event.typeDisplay,
                          Icons.language,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 3. Description
              Row(
                children: [
                  const Icon(
                    Icons.description_outlined,
                    size: 20,
                    color: Color(0xFF8B5A2B),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '活动缘起',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B5A2B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.event.description,
                style: GoogleFonts.notoSerif(
                  fontSize: 16,
                  height: 1.8,
                  color: const Color(0xFF2C2C2C).withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 48),

              // 4. Action Section
              if (_isRegistered)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.confirmation_number_outlined,
                          color: Color(0xFF8B5A2B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '报名已确认',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '您已成功报名此活动。\n届时请凭此凭证或登记信息入场。',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF2C2C2C).withValues(alpha: 0.6),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.check_circle, size: 18),
                          label: const Text('已报名'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            disabledForegroundColor: const Color(
                              0xFF8B5A2B,
                            ).withValues(alpha: 0.5),
                            side: BorderSide(
                              color: const Color(
                                0xFF8B5A2B,
                              ).withValues(alpha: 0.2),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '随喜参与',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '本活动为自愿参与，无任何强制要求。\n愿以此功德，普及于一切。',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF2C2C2C).withValues(alpha: 0.6),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _handleRegister,
                          icon: Icon(
                            widget.event.icon,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: Text(
                            _getButtonText(widget.event.formType),
                            style: const TextStyle(
                              fontSize: 16,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5A2B),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 4,
                            shadowColor: const Color(
                              0xFF8B5A2B,
                            ).withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF2C2C2C).withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
        ),
        Icon(icon, size: 20, color: const Color(0xFF8B5A2B)),
      ],
    );
  }
}
