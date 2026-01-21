import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../../core/widgets/zen_app_bar.dart';
import '../widgets/book_cover.dart';
import '../widgets/book_list_item.dart';
import '../../data/mock_books.dart';
import '../../domain/entities/book.dart';
import 'bookstore_page.dart';
import 'book_detail_page.dart';

class ReadLibraryPage extends StatefulWidget {
  const ReadLibraryPage({super.key});

  @override
  State<ReadLibraryPage> createState() => _ReadLibraryPageState();
}

class _ReadLibraryPageState extends State<ReadLibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['经', '论', '公案', '故事'];

  // Mock user's book IDs
  List<String> _myBookIds = ['sutra_1', 'sutra_2', '故事_1', 'sutra_4', 'case_1'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Book> get myBooks {
    return mockBooks.where((b) => _myBookIds.contains(b.id)).toList();
  }

  Book? get lastReadBook {
    final booksInProgress =
        myBooks.where((b) => b.progress > 0 && b.progress < 100).toList()
          ..sort((a, b) => b.progress.compareTo(a.progress));
    return booksInProgress.isNotEmpty ? booksInProgress.first : null;
  }

  List<Book> getBooksByCategory(String category) {
    return myBooks.where((b) => b.category == category).toList();
  }

  List<Book> getIntroBooks(String category) {
    return getBooksByCategory(
      category,
    ).where((b) => b.level == 'intro').toList();
  }

  List<Book> getCoreBooks(String category) {
    return getBooksByCategory(
      category,
    ).where((b) => b.level == 'core').toList();
  }

  String _getDateString() {
    final now = DateTime.now();
    final months = [
      '1月',
      '2月',
      '3月',
      '4月',
      '5月',
      '6月',
      '7月',
      '8月',
      '9月',
      '10月',
      '11月',
      '12月',
    ];
    final weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    return '${months[now.month - 1]}${now.day}日 · ${weekdays[now.weekday - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFDFCF8,
      ), // zen-bg (matching ceremony page)
      appBar: const ZenAppBar(title: '藏经阁'),
      body: Column(
        children: [
          // Hero Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getDateString(),
                      style: GoogleFonts.notoSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF8B5A2B).withValues(alpha: 0.6),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '深入经藏 智慧如海',
                      style: GoogleFonts.maShanZheng(
                        fontSize: 28,
                        height: 1.2,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                  ],
                ),
                // Zen Stamp
                Transform.rotate(
                  angle: 0.2,
                  child: Opacity(
                    opacity: 0.2,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF8B5A2B),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF8B5A2B)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '般\n若',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.maShanZheng(
                            fontSize: 24,
                            color: const Color(0xFF8B5A2B),
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Last Read Banner
          if (lastReadBook != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: _LastReadBanner(
                book: lastReadBook!,
                onTap: () => _openBookDetail(lastReadBook!),
              ),
            ),

          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.withOpacity(AppColors.zenPaper, 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.withOpacity(AppColors.zenBrown, 0.05),
              ),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _tabs.asMap().entries.map((entry) {
                final idx = entry.key;
                final tab = entry.value;
                final isSelected = _tabController.index == idx;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _tabController.animateTo(idx);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.withOpacity(
                                  Colors.black,
                                  0.05,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColors.zenBrown
                            : AppColors.zenSubtle,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((category) {
                final introBooks = getIntroBooks(category);
                final coreBooks = getCoreBooks(category);
                final totalCount = introBooks.length + coreBooks.length;

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    // Stats
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, left: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.menu_book,
                            size: 12,
                            color: AppColors.zenBrown,
                          ),
                          const SizedBox(width: 6),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$totalCount',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.zenBrown,
                                    fontFamily: 'NotoSans',
                                  ),
                                ),
                                const TextSpan(
                                  text: ' 部典籍',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.zenSubtle,
                                    fontFamily: 'NotoSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 1,
                            height: 12,
                            color: AppColors.withOpacity(
                              AppColors.zenBrown,
                              0.2,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.zenBrown,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '每日精进',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.zenSubtle,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Intro Section
                    _BookSection(
                      title: '基础入门',
                      books: introBooks,
                      onSelectBook: _openBookDetail,
                      onAddBook: _openBookstore,
                      showAddButton: true,
                    ),

                    const SizedBox(height: 16),

                    // Core Section
                    _BookSection(
                      title: '核心经典',
                      books: coreBooks,
                      onSelectBook: _openBookDetail,
                    ),

                    const SizedBox(height: 48),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _openBookDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
    );
  }

  void _openBookstore() async {
    final updatedBookIds = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => BookstorePage(initialBookIds: _myBookIds),
      ),
    );

    if (updatedBookIds != null) {
      setState(() {
        _myBookIds = updatedBookIds;
      });
    }
  }
}

// Last Read Banner Widget
class _LastReadBanner extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const _LastReadBanner({required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF3E3832),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            BookCover(
              title: book.title,
              coverStyle: book.coverStyle,
              size: 'sm',
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA6937C),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '继续修习',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '已读 ${book.progress}%',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'RobotoMono',
                          color: AppColors.withOpacity(Colors.white, 0.5),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'NotoSerif',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF2EFE9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.desc,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.withOpacity(Colors.white, 0.4),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.withOpacity(Colors.white, 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.menu_book, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// Book Section Widget
class _BookSection extends StatelessWidget {
  final String title;
  final List<Book> books;
  final Function(Book) onSelectBook;
  final VoidCallback? onAddBook;
  final bool showAddButton;

  const _BookSection({
    required this.title,
    required this.books,
    required this.onSelectBook,
    this.onAddBook,
    this.showAddButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.withOpacity(AppColors.zenBrown, 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.zenInk,
                  letterSpacing: 4,
                ),
              ),
              if (showAddButton && onAddBook != null) ...[
                const Spacer(),
                InkWell(
                  onTap: onAddBook,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.withOpacity(AppColors.zenBrown, 0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '添书',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.withOpacity(
                              AppColors.zenBrown,
                              0.6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.add,
                          size: 14,
                          color: AppColors.withOpacity(AppColors.zenBrown, 0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (books.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(16),
              color: AppColors.withOpacity(AppColors.zenPaper, 0.3),
            ),
            child: Center(
              child: Text(
                '暂无相关典籍',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.withOpacity(AppColors.zenSubtle, 0.4),
                  letterSpacing: 4,
                ),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppColors.zenBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.withOpacity(AppColors.zenBrown, 0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.withOpacity(Colors.black, 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: books.asMap().entries.map((entry) {
                final idx = entry.key;
                final book = entry.value;
                return BookListItem(
                  title: book.title,
                  author: book.author,
                  desc: book.desc,
                  progress: book.progress,
                  isLast: idx == books.length - 1,
                  onTap: () => onSelectBook(book),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
