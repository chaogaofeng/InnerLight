import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/zen_app_bar.dart';
import '../widgets/book_cover.dart';
import '../../data/mock_books.dart';
import '../../domain/entities/book.dart';
import 'book_detail_page.dart';

class BookstorePage extends StatefulWidget {
  final List<String> initialBookIds;

  const BookstorePage({super.key, required this.initialBookIds});

  @override
  State<BookstorePage> createState() => _BookstorePageState();
}

class _BookstorePageState extends State<BookstorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['全部', '经', '论', '公案', '故事'];

  late List<String> _myBookIds;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _myBookIds = List.from(widget.initialBookIds);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Book> get filteredBooks {
    final activeTab = _tabs[_tabController.index];
    if (activeTab == '全部') {
      return mockBooks;
    }
    return mockBooks.where((b) => b.category == activeTab).toList();
  }

  void _toggleBook(String bookId) {
    setState(() {
      if (_myBookIds.contains(bookId)) {
        _myBookIds.remove(bookId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已从书架移除'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        _myBookIds.add(bookId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已加入书架'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.zenBrown,
          ),
        );
      }
    });
  }

  void _openBookDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zenBg,
      appBar: ZenAppBar(
        title: '结缘经书',
        onBack: () => Navigator.pop(context, _myBookIds),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.withOpacity(AppColors.zenPaper, 0.5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '搜索经书名称...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.withOpacity(AppColors.zenSubtle, 0.7),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: AppColors.withOpacity(AppColors.zenSubtle, 0.7),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(fontSize: 14, color: AppColors.zenInk),
              ),
            ),
          ),

          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.withOpacity(AppColors.zenPaper, 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.withOpacity(AppColors.zenBrown, 0.05),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(4),
              child: Row(
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
                      margin: const EdgeInsets.only(right: 8),
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
          ),

          // Book List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((_) {
                final books = filteredBooks;

                if (books.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 48,
                          color: AppColors.withOpacity(AppColors.zenBrown, 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无此类经书',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.withOpacity(
                              AppColors.zenSubtle,
                              0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final isAdded = _myBookIds.contains(book.id);

                    return _BookStoreItem(
                      book: book,
                      isAdded: isAdded,
                      onToggle: () => _toggleBook(book.id),
                      onClick: () => _openBookDetail(book),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Book Store Item Widget
class _BookStoreItem extends StatelessWidget {
  final Book book;
  final bool isAdded;
  final VoidCallback onToggle;
  final VoidCallback onClick;

  const _BookStoreItem({
    required this.book,
    required this.isAdded,
    required this.onToggle,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.withOpacity(AppColors.zenBrown, 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.withOpacity(Colors.black, 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Cover
              BookCover(
                title: book.title,
                coverStyle: book.coverStyle,
                size: 'sm',
              ),
              const SizedBox(width: 20),

              // Book Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Author
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            book.title,
                            style: AppTextStyles.notoSerifBold(16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          book.author,
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'NotoSerif',
                            color: AppColors.withOpacity(
                              AppColors.zenBrown,
                              0.8,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      book.desc,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.withOpacity(AppColors.zenSubtle, 0.8),
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Category Tag and Action Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.zenPaper,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppColors.withOpacity(
                                AppColors.zenBrown,
                                0.05,
                              ),
                            ),
                          ),
                          child: Text(
                            '${book.category} · ${book.level == 'intro' ? '入门' : '进阶'}',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.withOpacity(
                                AppColors.zenSubtle,
                                0.8,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onToggle,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isAdded
                                  ? AppColors.zenPaper
                                  : AppColors.zenBrown,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isAdded
                                    ? AppColors.withOpacity(
                                        AppColors.zenBrown,
                                        0.05,
                                      )
                                    : AppColors.zenBrown,
                              ),
                              boxShadow: isAdded
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: AppColors.withOpacity(
                                          AppColors.zenBrown,
                                          0.2,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isAdded ? Icons.check : Icons.add,
                                  size: 14,
                                  color: isAdded
                                      ? AppColors.zenSubtle
                                      : Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isAdded ? '已在书架' : '加入书架',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isAdded
                                        ? AppColors.zenSubtle
                                        : Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
