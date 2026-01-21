import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String _selectedPlanId = 'year';
  String _paymentMethod = 'wechat';

  final List<Map<String, String>> _plans = [
    {'id': 'month', 'label': '月度订阅', 'price': '¥18.00', 'period': '/月'},
    {'id': 'quarter', 'label': '季度订阅', 'price': '¥48.00', 'period': '/季'},
    {'id': 'year', 'label': '年度订阅', 'price': '¥180.00', 'period': '/年'},
  ];

  void _handleSubscribe() {
    // Mock processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF8B5A2B)),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.pop(context); // Close loader

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('订阅成功！感谢您的护持。'),
          backgroundColor: Color(0xFF8B5A2B),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context); // Close page
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
          '善捐订阅',
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
              // Intro
              Text(
                '本订阅仅为支持平台维护发展，完全自愿，请随缘乐助。',
                style: GoogleFonts.notoSerif(
                  fontSize: 14,
                  color: const Color(0xFF2C2C2C).withValues(alpha: 0.8),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),

              // 1. Content
              _buildSectionHeader('订阅支持内容'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2EFE9).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                  ),
                ),
                child: const Text(
                  '支持平台日常运营，解锁更多线上共修活动、阅读古籍经典、以及更多辅助修行工具。',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                    height: 1.6,
                  ),
                ),
              ),

              // 2. Plans
              _buildSectionHeader('订阅周期'),
              Column(
                children: _plans.map((plan) {
                  final isSelected = _selectedPlanId == plan['id'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPlanId = plan['id']!;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFDFCF8)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF8B5A2B)
                              : const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF8B5A2B,
                                  ).withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            plan['label']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? const Color(0xFF8B5A2B)
                                  : const Color(0xFF2C2C2C),
                            ),
                          ),
                          Row(
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: plan['price'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C2C2C),
                                      ),
                                    ),
                                    TextSpan(
                                      text: plan['period'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9E9E9E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? const Color(0xFF8B5A2B)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF8B5A2B)
                                        : const Color(
                                            0xFF8B5A2B,
                                          ).withValues(alpha: 0.2),
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // 3. Payment Method
              _buildSectionHeader('支付方式'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  children: [
                    _buildPaymentOption(
                      id: 'wechat',
                      label: '微信支付',
                      icon: Icons.chat_bubble,
                      color: const Color(0xFF09BB07),
                    ),
                    Container(
                      height: 1,
                      color: const Color(0xFF8B5A2B).withValues(alpha: 0.05),
                    ),
                    _buildPaymentOption(
                      id: 'alipay',
                      label: '支付宝',
                      icon: Icons.account_balance_wallet,
                      color: const Color(0xFF1677FF),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Footer Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5A2B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    shadowColor: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                  ),
                  child: const Text(
                    '确认订阅',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 12,
                      color: Color(0xFF9E9E9E),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '支持出于善意，不等同于修行结果',
                      style: TextStyle(fontSize: 10, color: Color(0xFF9E9E9E)),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.notoSerif(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2C2C2C),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _paymentMethod == id;

    return InkWell(
      onTap: () {
        setState(() {
          _paymentMethod = id;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFF8B5A2B)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF8B5A2B)
                      : const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
