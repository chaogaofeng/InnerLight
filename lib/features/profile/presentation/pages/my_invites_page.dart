import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyInvitesPage extends StatelessWidget {
  const MyInvitesPage({super.key});

  static const List<Map<String, dynamic>> _invites = [
    {
      'id': 1,
      'name': '净心居士',
      'date': '2023-10-26',
      'merit': 50,
      'avatarColor': Color(0xFFE6EFE9),
    },
    {
      'id': 2,
      'name': '悟道师兄',
      'date': '2023-10-25',
      'merit': 50,
      'avatarColor': Color(0xFFF9F7F3),
    },
    {
      'id': 3,
      'name': '随缘',
      'date': '2023-10-22',
      'merit': 50,
      'avatarColor': Color(0xFFE0E7E9),
    },
    {
      'id': 4,
      'name': '一念',
      'date': '2023-10-18',
      'merit': 50,
      'avatarColor': Color(0xFFF2EFE9),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final totalMerit = _invites.fold<int>(
      0,
      (sum, item) => sum + (item['merit'] as int),
    );
    final totalFriends = _invites.length;

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
          '我的邀请',
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
              // 1. Statistics Card
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5D4F43), Color(0xFF3E3832)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Decorations
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '累计邀请功德',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '$totalMerit',
                                        style: GoogleFonts.notoSerif(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '点',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '已邀请好友',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '$totalFriends',
                                        style: GoogleFonts.notoSerif(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '位',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            height: 1,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.card_giftcard,
                                    size: 14,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '每邀请一位好友，功德 +50',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDFCF8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.share,
                                      size: 12,
                                      color: Color(0xFF8B5A2B),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '继续邀请',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF8B5A2B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. List Header
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.people_alt_outlined,
                          size: 16,
                          color: Color(0xFF8B5A2B),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '邀请记录',
                          style: GoogleFonts.notoSerif(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2C2C2C),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '仅显示最近记录',
                      style: TextStyle(
                        fontSize: 10,
                        color: const Color(0xFF9E9E9E).withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Invite List
              Column(
                children: _invites.map((invite) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: invite['avatarColor'],
                                border: Border.all(
                                  color: const Color(
                                    0xFF8B5A2B,
                                  ).withValues(alpha: 0.1),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  size: 18,
                                  color: const Color(
                                    0xFF8B5A2B,
                                  ).withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  invite['name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C2C2C),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${invite['date']} 加入',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: const Color(
                                      0xFF9E9E9E,
                                    ).withValues(alpha: 0.8),
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '+${invite['merit']}',
                              style: GoogleFonts.robotoMono(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF8B5A2B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '功德值',
                              style: TextStyle(
                                fontSize: 9,
                                color: const Color(
                                  0xFF9E9E9E,
                                ).withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Footer
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 1,
                      height: 24,
                      color: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '广结善缘 功德无量',
                      style: GoogleFonts.notoSerif(
                        fontSize: 10,
                        color: const Color(0xFF2C2C2C).withValues(alpha: 0.4),
                        letterSpacing: 2,
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
}
