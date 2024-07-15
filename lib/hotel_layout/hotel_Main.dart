import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:provider/provider.dart';

class HotelMainPage extends StatefulWidget {
  const HotelMainPage({super.key});

  @override
  State<HotelMainPage> createState() => _HotelMainPageState();
}

class _HotelMainPageState extends State<HotelMainPage> {
  String name = "";
  String hotel_name = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final data = Provider.of<UserData>(context, listen: false);

    name = data.name;
    hotel_name = data.hotel_name;
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
                "호텔명: $hotel_name",
                style: const TextStyle(fontFamily: 'Pretendard', fontSize: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
