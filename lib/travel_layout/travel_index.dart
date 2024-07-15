import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/index/index.dart';
import 'package:flutter_application_hotel/travel_layout/travel_BottomNavi.dart';
import 'package:flutter_application_hotel/travel_layout/travel_CancelList.dart';
import 'package:flutter_application_hotel/travel_layout/travel_CompleteList.dart';
import 'package:flutter_application_hotel/travel_layout/travel_ConfirmWatingList.dart';
import 'package:flutter_application_hotel/travel_layout/travel_Main.dart';
import 'package:flutter_application_hotel/travel_layout/travel_NoAcceptDetail.dart';
import 'package:flutter_application_hotel/travel_layout/travel_ReservatingList.dart';
import 'package:flutter_application_hotel/travel_layout/travel_inquiryAfterList.dart';
import 'package:flutter_application_hotel/travel_layout/travel_inquiryBeforeList.dart';
import 'travel_NoAcceptList.dart';
import 'travel_myPage.dart';
import 'travel_HotelSearch.dart';

class travel_index extends StatefulWidget {
  final String name;
  final String email;
  final String tel;
  final String pw;
  const travel_index(
      {required this.email,
      required this.name,
      required this.tel,
      required this.pw,
      super.key});

  @override
  createState() => _MainViewState(email, name, tel, pw);
}

class _MainViewState extends State<travel_index> {
  String name;
  String email;
  String tel;
  String pw;
  late List<Widget> views;
  bool _reloadPage = false; // 페이지 리로드 플래그

  _MainViewState(this.email, this.name, this.tel, this.pw);

  @override
  void initState() {
    super.initState();
    views = [
      const MainPage(),
      const searchBar(),
      const ReservatingList(),
      const ConfirmWatingList(),
      const CompleteList(),
      const ReservationNoAcceptList(),
      const CancelList(),
      const TravelInquiryBeforeList(),
      const TravelInquiryAfterList(),
      const TStatisticBottomNavi(),
      travel_MyPage(email: email, name: name, tel: tel, pw: pw)
    ];
  }

  int selectedIndex = 0;

  Future<void> _refreshPage(int index) async {
    setState(() {
      views[index] = _getPage(index); // 리빌드
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const Center();
      case 1:
        return const searchBar();
      case 2:
        return const ReservatingList();
      case 3:
        return const ConfirmWatingList();
      case 4:
        return const CompleteList();
      case 5:
        return const ReservationNoAcceptList();
      case 6:
        return const CancelList();
      case 7:
        return const TravelInquiryBeforeList();
      case 8:
        return const TravelInquiryAfterList();
      case 9:
        return const TStatisticBottomNavi();
      case 10:
        return travel_MyPage(email: email, name: name, tel: tel, pw: pw);
      default:
        return const Center();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_reloadPage) {
      _refreshPage(selectedIndex);
      _reloadPage = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'AnyStay',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'CantoraOne',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const bothLogin()),
                  (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        shape:
            Border(bottom: BorderSide(width: 3, color: Colors.grey.shade200)),
      ),
      drawer: buildDrawer(),
      body: views.elementAt(selectedIndex),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'AnyStay Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.dashboard,
            text: '메인화면',
            index: 0,
          ),
          _buildDrawerItem(
            icon: Icons.search_outlined,
            text: '호텔검색',
            index: 1,
          ),
          ExpansionTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: const Text(
              '예약',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            children: <Widget>[
              _buildDrawerItem(
                text: '수락대기',
                index: 2,
              ),
              _buildDrawerItem(
                text: '컨펌대기',
                index: 3,
              ),
              _buildDrawerItem(
                text: '컨펌완료',
                index: 4,
              ),
              _buildDrawerItem(
                text: '예약불가',
                index: 5,
              ),
              _buildDrawerItem(
                text: '취소리스트',
                index: 6,
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.question_answer),
            title: const Text(
              '문의',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            children: <Widget>[
              _buildDrawerItem(
                text: '답변대기 리스트',
                index: 7,
              ),
              _buildDrawerItem(
                text: '답변완료 리스트',
                index: 8,
              ),
            ],
          ),
          _buildDrawerItem(
            icon: CupertinoIcons.graph_circle_fill,
            text: '통계',
            index: 9,
          ),
          _buildDrawerItem(
            icon: Icons.person,
            text: '마이페이지',
            index: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      {IconData? icon, required String text, required int index}) {
    return ListTile(
      leading: icon != null
          ? Icon(
              icon,
              color: selectedIndex == index ? Colors.blue : Colors.black,
            )
          : null,
      title: Text(
        text,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          color: selectedIndex == index ? Colors.blue : Colors.black,
        ),
      ),
      onTap: () {
        setState(() {
          selectedIndex = index;
          Navigator.pop(context);
        });
      },
    );
  }
}
