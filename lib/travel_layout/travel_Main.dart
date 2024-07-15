import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String name = "";
  String agency_name = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final data = Provider.of<UserData>(context, listen: false);
    name = data.name;
    agency_name = data.agency_name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "이름: $name",
                style: const TextStyle(fontFamily: 'Pretendard', fontSize: 28),
              ),
              Text(
                "여행사명: $agency_name",
                style: const TextStyle(fontFamily: 'Pretendard', fontSize: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
