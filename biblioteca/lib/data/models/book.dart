class Book {
  final String id;
  final String title;
  final String author;
  final String? synopsis;
  final String? publisher;
  final int? pages;
  final String? coverUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.synopsis,
    this.publisher,
    this.pages,
    this.coverUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: (json['id'] ?? json['_id'] ?? json['uuid'] ?? '').toString(),
    title: json['title'] ?? '',
    author: json['author'] ?? '',
    synopsis: json['synopsis'],
    publisher: json['publisher'],
    pages: json['pages'] is int
        ? json['pages']
        : int.tryParse('${json['pages'] ?? ''}'),
    coverUrl: json['cover_url'] ?? json['coverUrl'],
  );

  Map<String, dynamic> toBody() => {
    'book': {
      'title': title,
      'author': author,
      if (synopsis != null) 'synopsis': synopsis,
      if (publisher != null) 'publisher': publisher,
      if (pages != null) 'pages': pages,
      if (coverUrl != null) 'cover_url': coverUrl,
    },
  };
}
