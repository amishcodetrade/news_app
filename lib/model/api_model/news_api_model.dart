class NewsApiResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  NewsApiResponse({required this.status, required this.totalResults, required this.articles});

  factory NewsApiResponse.fromJson(Map<String, dynamic> json) {
    return NewsApiResponse(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: (json['articles'] as List).map((e) => Article.fromJson(e)).toList(),
    );
  }
}

class Article {
  final Source source;
  final String title;
  final String description;

  Article({required this.source, required this.title, required this.description});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      title: json['title'],
      description: json['description'],
    );
  }
}

class Source {
  final String? id;
  final String name;

  Source({this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'],
    );
  }
}