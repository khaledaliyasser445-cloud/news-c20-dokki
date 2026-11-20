import 'package:dio/dio.dart';
import 'package:news_c20_dokki/models/articles_response.dart';
import 'package:news_c20_dokki/models/sources_response.dart';

class ApiManger {
  ApiManger()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://newsapi.org',
            receiveTimeout: const Duration(seconds: 180),
            connectTimeout: const Duration(seconds: 180),
            headers: {
              'X-Api-Key': const String.fromEnvironment('NEWS_API_KEY'),
            },
          ),
        );

  final Dio dio;

  Future<SourcesResponse> getSources(String category) async {
    final response = await dio.get(
      '/v2/top-headlines/sources',
      queryParameters: {'category': category},
    );
    return SourcesResponse.fromJson(response.data);
  }

  Future<ArticlesResponse> getArticles(String source) async {
    final response = await dio.get(
      '/v2/top-headlines',
      queryParameters: {'sources': source},
    );
    return ArticlesResponse.fromJson(response.data);
  }

  Future<ArticlesResponse> searchArticles(String query) async {
    final response = await dio.get(
      '/v2/everything',
      queryParameters: {
        'q': query,
        'language': 'en',
        'sortBy': 'publishedAt',
        'pageSize': 20,
      },
    );
    return ArticlesResponse.fromJson(response.data);
  }
}
