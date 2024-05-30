import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/index/index.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(), // UserData 인스턴스 생성
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        home: bothLogin(), // 로그인 페이지를 홈으로 설정
      ),
    );
  }
}
