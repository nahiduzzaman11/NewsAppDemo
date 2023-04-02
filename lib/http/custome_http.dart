import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_api/model/news_model.dart';

class CustomeHttpRequest {
  static Future<NewsModel> fetchHomeData(int pageNo,String sortBy) async {
    String url =
        "https://newsapi.org/v2/everything?q=ramadan&sortBy=$sortBy&pageSize=10&page=${pageNo}&apiKey=cb4e91a3cc1442258b4a403340a9210a";

    NewsModel? newsModel;
    var responce = await http.get(Uri.parse(url));
    print("status code is ${responce.statusCode}");
    var data = jsonDecode(responce.body);
    print("our responce is ${data}");
    newsModel = NewsModel.fromJson(data);
    return newsModel!;
  }
}
