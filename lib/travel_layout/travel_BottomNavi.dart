import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/travel_layout/travel_TravelStatisticIn.dart';
import 'package:flutter_application_hotel/travel_layout/travel_TravelStatisticOut.dart';

class TStatisticBottomNavi extends StatefulWidget {
  const TStatisticBottomNavi({super.key});

  @override
  State<TStatisticBottomNavi> createState() => _TStatisticBottomNaviState();
}

class _TStatisticBottomNaviState extends State<TStatisticBottomNavi> {
  final PageController _pageController = PageController();
  final List<Widget> _pages = [
    const TravelStatisticIn(),
    const TravelStatisticOut(),
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildNavItem(
                  icon: CupertinoIcons.check_mark_circled,
                  label: '체크인',
                  index: 0,
                ),
                _buildNavItem(
                  icon: CupertinoIcons.check_mark_circled_solid,
                  label: '체크아웃',
                  index: 1,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width *
                _selectedIndex /
                _pages.length,
            child: Container(
              width: MediaQuery.of(context).size.width / _pages.length,
              height: 4.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      {required IconData icon, required String label, required int index}) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _onItemTapped(index),
          child: Container(
            color: Colors.transparent, // 클릭 가능한 영역을 확장하기 위해 투명 배경 추가
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
