import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/book.dart';
import '../widgets/book_cover.dart';
import '../widgets/content_drawer.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool _isIntroExpanded = false;
  bool _isCollected = false;

  String _formatReadCount(int count) {
    return count > 9999
        ? '${(count / 10000).toStringAsFixed(1)}万'
        : count.toString();
  }

  void _showTOC() {
    ContentDrawer.show(
      context: context,
      title: '目录',
      subtitle: '共 ${widget.book.chapters.length} 章节',
      icon: Icons.list,
      child: Column(
        children: widget.book.chapters.asMap().entries.map((entry) {
          final idx = entry.key;
          final chapter = entry.value;
          return InkWell(
            onTap: () {
              Navigator.pop(context);
              _startReading();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.withOpacity(AppColors.zenBrown, 0.05),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '${(idx + 1).toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSerif',
                      fontWeight: FontWeight.bold,
                      color: AppColors.withOpacity(AppColors.zenBrown, 0.3),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.zenInk,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chapter.contentOriginal.substring(0, 30) + '...',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.withOpacity(
                              AppColors.zenSubtle,
                              0.7,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: AppColors.withOpacity(AppColors.zenSubtle, 0.6),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showCoreContent() {
    final corePoints = [
      {'title': '缘起性空', 'desc': '世间万物皆由因缘和合而生，无有固定不变之自性。'},
      {'title': '般若智慧', 'desc': '超越世俗认识的终极智慧，能断除烦恼，到达彼岸。'},
      {'title': '究竟涅槃', 'desc': '超越生死的境界，获得彻底的解脱与安乐。'},
      {'title': '慈悲喜舍', 'desc': '四无量心，普度众生，利乐有情。'},
    ];

    ContentDrawer.show(
      context: context,
      title: '核心内容',
      subtitle: '义理精要 · 智慧结晶',
      icon: Icons.auto_awesome,
      child: Column(
        children: corePoints.asMap().entries.map((entry) {
          final idx = entry.key;
          final point = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.zenPaper,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    ['一', '二', '三', '四'][idx],
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSerif',
                      fontWeight: FontWeight.bold,
                      color: AppColors.zenBrown,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        point['title']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.zenInk,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        point['desc']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.withOpacity(
                            AppColors.zenSubtle,
                            0.8,
                          ),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showAnnotations() {
    final annotations = [
      {
        'master': '僧肇法师',
        'title': '注维摩诘经',
        'content':
            '大乘部，该经也是般若经类的精要之作，阐述了五蕴皆空、色空不二的般若智慧。一切诸法，皆由因缘和合而生，无有自性，故曰空。',
      },
      {
        'master': '憨山大师',
        'title': '心经直指',
        'content':
            '般若者，乃诸佛之母，众生之慧命也。照见五蕴皆空，则度一切苦厄。五蕴身心，原本是妄，由于妄执，故受轮回。若能照破，则当下解脱。',
      },
    ];

    ContentDrawer.show(
      context: context,
      title: '名师注解',
      subtitle: '《${widget.book.title}》共 ${annotations.length} 条收录',
      icon: Icons.message,
      child: Column(
        children: annotations.map((annotation) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.withOpacity(AppColors.zenBrown, 0.05),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
                        ),
                      ),
                      child: Text(
                        annotation['master']!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSerif',
                          color: AppColors.zenBrown,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '《${annotation['title']}》',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.withOpacity(AppColors.zenSubtle, 0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  annotation['content']!,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'NotoSerif',
                    color: AppColors.withOpacity(AppColors.zenInk, 0.8),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _startReading() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('开始阅读功能开发中...'),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.zenBrown,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zenBg,
      body: Stack(
        children: [
          // Content
          CustomScrollView(
            slivers: [
              // Custom AppBar
              SliverAppBar(
                backgroundColor: AppColors.withOpacity(AppColors.zenBg, 0.9),
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.zenInk),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.share_outlined,
                      color: AppColors.zenInk,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: AppColors.zenInk),
                    onPressed: () {},
                  ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BookCover(
                            title: widget.book.title,
                            coverStyle: widget.book.coverStyle,
                            size: 'lg',
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.book.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NotoSerif',
                                    color: AppColors.zenInk,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '典藏诵读版',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'NotoSerif',
                                    color: Color(0xFF8a8a8a),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.book.author,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'NotoSerif',
                                    color: AppColors.withOpacity(
                                      AppColors.zenBrown,
                                      0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildTag('大乘部'),
                                    const SizedBox(width: 8),
                                    _buildTag('注解对照'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Stats Bar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2EFE9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.withOpacity(
                            AppColors.zenBrown,
                            0.05,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${_formatReadCount(widget.book.readCount)}人读过',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.withOpacity(
                                AppColors.zenBrown,
                                0.7,
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 12,
                            color: AppColors.withOpacity(
                              AppColors.zenBrown,
                              0.2,
                            ),
                          ),
                          Text(
                            '${widget.book.chapters.length} 章节',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.withOpacity(
                                AppColors.zenBrown,
                                0.7,
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 12,
                            color: AppColors.withOpacity(
                              AppColors.zenBrown,
                              0.2,
                            ),
                          ),
                          Text(
                            '约 5000 字',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.withOpacity(
                                AppColors.zenBrown,
                                0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Introduction
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '内容简介',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NotoSerif',
                              color: AppColors.zenInk,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.book.desc +
                                (_isIntroExpanded
                                    ? ' 此外，本版本特邀高僧大德进行注疏，深入浅出地讲解经文大意，帮助读者更好地领悟佛法智慧。'
                                    : '...'),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.withOpacity(
                                AppColors.zenInk,
                                0.7,
                              ),
                              height: 1.6,
                            ),
                            maxLines: _isIntroExpanded ? null : 3,
                            textAlign: TextAlign.justify,
                          ),
                          TextButton(
                            onPressed: () => setState(
                              () => _isIntroExpanded = !_isIntroExpanded,
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isIntroExpanded ? '收起' : '展开',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.withOpacity(
                                      AppColors.zenBrown,
                                      0.6,
                                    ),
                                  ),
                                ),
                                Icon(
                                  _isIntroExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: AppColors.withOpacity(
                                    AppColors.zenBrown,
                                    0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Feature Menu
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            Icons.list,
                            '目录',
                            _showTOC,
                            isFirst: true,
                          ),
                          _buildMenuItem(
                            Icons.auto_awesome,
                            '核心内容',
                            _showCoreContent,
                          ),
                          _buildMenuItem(
                            Icons.message,
                            '专家注解',
                            _showAnnotations,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.withOpacity(AppColors.zenBg, 0),
                    AppColors.zenBg,
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.withOpacity(Colors.white, 0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.withOpacity(Colors.black, 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _startReading,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.zenBrown,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: AppColors.withOpacity(
                            AppColors.zenBrown,
                            0.2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '开始阅读',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () =>
                              setState(() => _isCollected = !_isCollected),
                          icon: Icon(
                            _isCollected
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isCollected
                                ? Colors.red[800]
                                : AppColors.zenBrown,
                            size: 24,
                          ),
                        ),
                        Text(
                          _isCollected ? '已收藏' : '收藏',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.zenBrown,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.withOpacity(AppColors.zenBrown, 0.2),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, color: AppColors.zenSubtle),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: AppColors.withOpacity(AppColors.zenBrown, 0.05),
                  ),
                ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppColors.withOpacity(AppColors.zenBrown, 0.6),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.zenInk,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.withOpacity(AppColors.zenSubtle, 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
