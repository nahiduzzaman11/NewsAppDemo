import 'package:flutter/material.dart';
import 'package:news_api/http/custome_http.dart';
import 'package:news_api/model/news_model.dart';
import 'package:provider/provider.dart';

class NewsProvider with ChangeNotifier{

  NewsModel? newsModel;
  Future<NewsModel> getHomeData(int pageNo,String sortBy)async{
    newsModel=await CustomeHttpRequest.fetchHomeData(pageNo,sortBy);
    return newsModel!;
  }


}