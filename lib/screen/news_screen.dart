import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart' as http;
import '../model/api_model/news_api_model.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  NewsListState createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  late Future<NewsApiResponse> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

  Future<NewsApiResponse> fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=tesla&from=2023-08-25&sortBy=publishedAt&apiKey=758e3f700a494a82a9f5a68fa0409751'));
    if (response.statusCode == 200) {
      NewsApiResponse newsApiResponse =
          NewsApiResponse.fromJson(json.decode(response.body));
      List<String> titles =
          newsApiResponse.articles.map((e) => e.title).toList();
      updateAppWidget(titles);
      return newsApiResponse;
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<void> updateAppWidget(List<String> articleTitles) async {
    await HomeWidget.saveWidgetData<String>(
        'news_titles', json.encode(articleTitles));
    await HomeWidget.updateWidget(
        name: 'HomeScreenWidgetProvider', iOSName: 'HomeScreenWidgetProvider');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News List'),
      ),
      body: FutureBuilder<NewsApiResponse>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.articles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        snapshot.data!.articles[index].title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text(snapshot.data!.articles[index].description),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
