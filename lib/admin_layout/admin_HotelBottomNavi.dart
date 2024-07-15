import 'package:file/memory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/admin_layout/admin_HotelStatistic_in.dart';
import 'package:flutter_application_hotel/admin_layout/admin_HotelStatisticsOut.dart';

class HotelBottomNavigaotionBar extends StatefulWidget {
  const HotelBottomNavigaotionBar({super.key});

  @override
  State<HotelBottomNavigaotionBar> createState() =>
      _HotelBottomNavigaotionBarState();
}

class _HotelBottomNavigaotionBarState extends State<HotelBottomNavigaotionBar> {
  final List<Widget> indexPage = [
    const HotelStatisticsOut(),
    const HotelStatisticIn(),
  ];

  int selectedIndex = 0;

  void onItemTapped(int index) {
    selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.check_mark_circled))
        ],
      )),
    );
  }
}
