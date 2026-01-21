import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum LegalType { service, privacy }

class LegalPage extends StatelessWidget {
  final LegalType type;

  const LegalPage({super.key, required this.type});

  String get _title {
    return type == LegalType.service ? '平台服务协议' : '用户隐私协议';
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
          _title,
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              // Document Header
              Column(
                children: [
                  Text(
                    _title,
                    style: GoogleFonts.notoSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0x668C857B),
                          shape: BoxShape.circle,
                        ),
                      ), // zen-subtle/40
                      const SizedBox(width: 8),
                      const Text(
                        '生效日期：2023年10月27日',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8C857B),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0x668C857B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                height: 1,
                color: const Color(0xFF8B5A2B).withValues(alpha: 0.1),
              ),
              const SizedBox(height: 32),

              // Content
              type == LegalType.service
                  ? _buildServiceContent()
                  : _buildPrivacyContent(),

              const SizedBox(height: 48),

              // Footer
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 32),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: const Color(0xFF8B5A2B).withValues(alpha: 0.05),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5A2B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '禅',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFDFCF8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Zen Life · 善护念',
                      style: GoogleFonts.notoSans(
                        fontSize: 10,
                        color: const Color(0xFF8C857B),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.notoSerif(
              fontSize: 14,
              color: const Color(0xCC2C2C2C), // ink/80
              height: 1.8,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          '1. 信息收集',
          '在您使用本平台服务时，我们可能会收集您的姓名、联系方式、法名、修行记录（如诵经次数、供灯记录）等信息，以便为您提供更好的个性化服务体验。',
        ),
        _buildSection(
          '2. 信息使用',
          '我们严格遵守法律法规及与用户的约定，将收集的信息用于以下用途：提供服务、产品开发和服务优化、安全保障。我们不会向任何无关第三方提供、出售、出租、分享或交易您的个人信息。',
        ),
        _buildSection(
          '3. 信息保护',
          '我们致力于保护您的个人信息安全。我们使用各种安全技术和程序来保护您的个人信息不被未经授权的访问、使用或泄漏。',
        ),
        _buildSection('4. 变更通知', '如隐私政策发生变更，我们将通过弹窗、公告等方式通知您。'),
      ],
    );
  }

  Widget _buildServiceContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          '1. 服务条款的确认与接纳',
          'Zen Life（以下简称“本平台”）提供的服务将完全按照其发布的服务条款和操作规则严格执行。用户必须完全同意所有服务条款并完成注册程序，才能成为本平台的正式用户。',
        ),
        _buildSection(
          '2. 服务内容',
          '本平台服务的具体内容由本平台根据实际情况提供，例如线上共修、电子经书阅读、虚拟木鱼、在线供灯等。本平台保留随时变更、中断或终止部分或全部网络服务的权利。',
        ),
        _buildSection(
          '3. 用户行为规范',
          '用户在使用本平台服务时，必须遵守中华人民共和国相关法律法规的规定，不得利用本服务进行任何违法或不正当的活动，包括但不限于传播色情、暴力、反动内容，或进行任何可能损害本平台利益的行为。',
        ),
        _buildSection(
          '4. 知识产权',
          '本平台提供的网络服务中包含的任何文本、图片、图形、音频和/或视频资料均受版权、商标和/或其它财产所有权法律的保护，未经相关权利人同意，上述资料均不得在任何媒体直接或间接发布、播放、出于播放或发布目的而改写或再发行。',
        ),
      ],
    );
  }
}
