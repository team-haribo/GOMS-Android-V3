import 'package:flutter/material.dart';
import 'package:project_setting/presentation/map_page/widget/place_review_container.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlaceReviewContainer(
                placeName: '메가MGC커피 광주송정시장점',
                category: '카페',
                address: '광주 광산구 내상로 23 가동 1층',
                reviewDetailContent: '밥많이먹어라바보야오늘은안된다고',
                createdAt: DateTime.now(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
