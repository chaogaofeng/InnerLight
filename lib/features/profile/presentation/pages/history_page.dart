import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  final List<Map<String, dynamic>> _records = const [
    {'id': 1, 'date': '2023年10月26日', 'type': '阅读', 'desc': '阅读《心经》部分章节'},
    {'id': 2, 'date': '2023年10月25日', 'type': '修行', 'desc': '完成每日冥想'},
    {'id': 3, 'date': '2023年10月23日', 'type': '佛事', 'desc': '参与线上讲经法会'},
    {'id': 4, 'date': '2023年10月20日', 'type': '阅读', 'desc': '开始阅读《金刚经》'},
    {'id': 5, 'date': '2023年10月18日', 'type': '修行', 'desc': '敲击木鱼 108 下'},
    {'id': 6, 'date': '2023年10月15日', 'type': '佛事', 'desc': '日常供灯祈福'},
  ];

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
          '功德记录',
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
            children: [
              // Subtitle
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    '仅用于个人修行与自省记录',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF2C2C2C).withValues(alpha: 0.6),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              // 1. Overview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFCF8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5D4F43).withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '个人记录概览',
                      style: GoogleFonts.notoSerif(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildOverviewItem('阅读: 5 部'),
                        _buildOverviewItem('修行: 30 次'),
                        _buildOverviewItem('佛事参与: 2 次'),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Timeline
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFCF8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5D4F43).withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '时间记录',
                      style: GoogleFonts.notoSerif(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Stack(
                      children: [
                        // Vertical Line
                        Positioned(
                          top: 8,
                          bottom: 8,
                          left: 5,
                          child: Container(
                            width: 1,
                            color: const Color(
                              0xFF8B5A2B,
                            ).withValues(alpha: 0.2),
                          ),
                        ),

                        // Items
                        Column(
                          children: _records.map((record) {
                            final isLast = record == _records.last;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: isLast ? 0 : 32,
                                left: 24,
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Dot
                                  Positioned(
                                    left: -24.5,
                                    top: 4,
                                    child: Container(
                                      width: 11,
                                      height: 11,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD8D0C5),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFFDFCF8),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Content
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        record['date'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: const Color(
                                            0xFF9E9E9E,
                                          ).withValues(alpha: 0.8),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            child: Text(
                                              record['type'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: const Color(
                                                  0xFF2C2C2C,
                                                ).withValues(alpha: 0.7),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 12,
                                            color: const Color(
                                              0xFF8B5A2B,
                                            ).withValues(alpha: 0.2),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              record['desc'],
                                              style: GoogleFonts.notoSerif(
                                                fontSize: 14,
                                                color: const Color(0xFF2C2C2C),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // Separator
                                  if (!isLast)
                                    Positioned(
                                      bottom: -16,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 1,
                                        color: const Color(
                                          0xFF8B5A2B,
                                        ).withValues(alpha: 0.05),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Phase Record
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFCF8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF5D4F43).withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '阶段记录',
                      style: GoogleFonts.notoSerif(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '持续阅读一段时间',
                      style: GoogleFonts.notoSerif(
                        fontSize: 14,
                        color: const Color(0xFF2C2C2C).withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Footer
              Center(
                child: Text(
                  '功德不在于数字，而在于觉察',
                  style: GoogleFonts.notoSerif(
                    fontSize: 12,
                    color: const Color(0xFF2C2C2C).withValues(alpha: 0.4),
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String text) {
    return Text(
      text,
      style: GoogleFonts.notoSerif(
        fontSize: 14,
        color: const Color(0xFF2C2C2C).withValues(alpha: 0.8),
      ),
    );
  }
}
