import 'package:dio/dio.dart';
import 'Article.dart';

class Apicontroller {
  Future<List<Article>> getdatas() async {
    final response = await Dio().get(
      'https://api.spaceflightnewsapi.net/v4/articles/?limit=20',
    );

    final List results = response.data['results'];

    return results.map((item) => Article.fromJson(item)).toList();
  }
}