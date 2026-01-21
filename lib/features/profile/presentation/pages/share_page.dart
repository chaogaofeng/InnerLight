import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final String _inviteCode = "ZEN-2024";
  bool _copied = false;

  void _handleCopy() {
    Clipboard.setData(ClipboardData(text: _inviteCode));
    setState(() {
      _copied = true;
    });

    // Reset copy state after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('邀请码已复制'),
        duration: Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF8B5A2B),
      ),
    );
  }

  void _handleShareAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已$action'),
        duration: const Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF8B5A2B),
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
          '分享应用',
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
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              // 1. Share Poster Card
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                margin: const EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2EFE9), // slightly darker paper
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.05),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    children: [
                      // Poster Content
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 48,
                          horizontal: 24,
                        ),
                        child: Column(
                          children: [
                            // Logo Area
                            Transform.rotate(
                              angle: 0.05, // Slight rotation (~3 degrees)
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B5A2B),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '禅',
                                        style: GoogleFonts.maShanZheng(
                                          fontSize: 32,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // App Name
                            Text(
                              'Zen Life',
                              style: GoogleFonts.notoSerif(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2C2C2C),
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 32,
                              height: 1,
                              color: const Color(
                                0xFF8B5A2B,
                              ).withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '指尖的修行 · 内心的净土',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8B5A2B),
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Mock QR Code
                            Container(
                              width: 128,
                              height: 128,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(
                                        0xFF8B5A2B,
                                      ).withValues(alpha: 0.2),
                                      width: 2,
                                      style: BorderStyle
                                          .solid, // Should be dashed ideally
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    color: const Color(
                                      0xFFF2EFE9,
                                    ).withValues(alpha: 0.1),
                                  ),
                                  child: GridView.builder(
                                    itemCount: 25,
                                    padding: const EdgeInsets.all(4),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 5,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 2,
                                        ),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color:
                                              (index % 2 == 0 || index % 3 == 0)
                                              ? const Color(0xFF2C2C2C)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            1,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '扫码下载体验',
                              style: GoogleFonts.notoSans(
                                fontSize: 10,
                                color: const Color(0xFF9E9E9E),
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          border: Border(
                            top: BorderSide(
                              color: const Color(
                                0xFF8B5A2B,
                              ).withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '邀请人',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF9E9E9E),
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '善护念居士',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C2C2C),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2EFE9),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                    0xFF8B5A2B,
                                  ).withValues(alpha: 0.1),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '善',
                                  style: GoogleFonts.maShanZheng(
                                    fontSize: 14,
                                    color: const Color(0xFF8B5A2B),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Invite Code Box
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                margin: const EdgeInsets.only(bottom: 40),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '我的邀请码',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _inviteCode,
                              style: GoogleFonts.robotoMono(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2C2C2C),
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _handleCopy,
                      borderRadius: BorderRadius.circular(8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _copied
                              ? const Color(0xFF8B5A2B)
                              : const Color(0xFFF2EFE9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _copied ? Icons.check : Icons.copy,
                              size: 14,
                              color: _copied
                                  ? Colors.white
                                  : const Color(0xFF8B5A2B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _copied ? '已复制' : '复制',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _copied
                                    ? Colors.white
                                    : const Color(0xFF8B5A2B),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Share Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShareButton(
                      '微信',
                      Icons.chat_bubble_outline,
                      const Color(0xFF09BB07),
                      () => _handleShareAction('分享到微信'),
                    ),
                    _buildShareButton(
                      '朋友圈',
                      Icons.camera_alt_outlined,
                      const Color(0xFFFA9D3B),
                      () => _handleShareAction('分享到朋友圈'),
                    ),
                    _buildShareButton(
                      '复制链接',
                      Icons.link,
                      const Color(0xFF8B5A2B),
                      _handleCopy,
                    ), // Reuse copy for link
                    _buildShareButton(
                      '保存图片',
                      Icons.download,
                      const Color(0xFF2C2C2C),
                      () => _handleShareAction('保存图片'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF9E9E9E)),
          ),
        ],
      ),
    );
  }
}
