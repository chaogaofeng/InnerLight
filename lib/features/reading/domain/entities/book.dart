/// Book chapter entity
class Chapter {
  final String id;
  final String title;
  final String contentOriginal;
  final String? contentVernacular; // 白话文

  const Chapter({
    required this.id,
    required this.title,
    required this.contentOriginal,
    this.contentVernacular,
  });
}

/// Book entity
class Book {
  final String id;
  final String title;
  final String author;
  final String coverStyle; // 'dark' | 'light' | 'gold'
  final String desc;
  final String category; // '经', '论', '公案', '故事'
  final String level; // 'intro' | 'core' | 'advanced'
  final int progress; // 0-100
  final List<Chapter> chapters;
  final int readCount;
  final String? audioUrl;
  final String? videoUrl;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverStyle,
    required this.desc,
    required this.category,
    required this.level,
    required this.progress,
    required this.chapters,
    required this.readCount,
    this.audioUrl,
    this.videoUrl,
  });
}
