import 'package:flutter/material.dart';
import 'package:news_api/provider/news_provider.dart';
import 'package:news_api/screen/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.x
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return NewsProvider();
          },
        ),
      ],
      child: MaterialApp(
       debugShowCheckedModeBanner: false,
        home: HomePage()
      ),
    );
  }
}