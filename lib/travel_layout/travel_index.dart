import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/index/index.dart';
import 'package:flutter_application_hotel/travel_layout/travel_CancelList.dart';
import 'package:flutter_application_hotel/travel_layout/travel_CompleteList.dart';
import 'package:flutter_application_hotel/travel_layout/travel_ReservationContinue.dart';
import 'package:flutter_application_hotel/travel_layout/travel_inquiryAfterList.dart';
import 'package:flutter_application_hotel/travel_layout/travel_inquiryBeforeList.dart';
import 'travel_confirmList.dart';
import 'travel_myPage.dart';
import 'travel_HotelSearch.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:flutter_application_hotel/travel_layout/travel_HotelReservationList.dart';

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
      const Center(),
      const searchBar(),
      const ReservationList(),
      const ReservationContinueList(),
      const ReservationConfirmList(),
      const CancelList(),
      const CompleteList(),
      const TravelInquiryBeforeList(),
      const TravelInquiryAfterList(),
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
        return const ReservationList();
      case 3:
        return const ReservationContinueList();
      case 4:
        return const ReservationConfirmList();
      case 5:
        return const CancelList();
      case 6:
        return const CompleteList();
      case 7:
        return const TravelInquiryBeforeList();
      case 8:
        return const TravelInquiryAfterList();
      case 9:
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
        automaticallyImplyLeading: false,
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
      body: Sidebar(),
    );
  }

  Row Sidebar() {
    return Row(
      children: [
        Container(
          color: Colors.grey[200],
          child: SideNavigationBar(
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: '메인화면',
              ),
              SideNavigationBarItem(
                icon: Icons.search_outlined,
                label: '호텔검색',
              ),
              SideNavigationBarItem(
                icon: Icons.list_alt_outlined,
                label: '예약리스트',
              ),
              SideNavigationBarItem(
                icon: Icons.list_alt_outlined,
                label: '예약진행중 리스트',
              ),
              SideNavigationBarItem(
                icon: Icons.list_alt_outlined,
                label: '최종컨펌대기 리스트',
              ),
              SideNavigationBarItem(
                icon: Icons.cancel,
                label: '취소리스트',
              ),
              SideNavigationBarItem(
                icon: Icons.check,
                label: '예약완료 리스트',
              ),
              SideNavigationBarItem(
                icon: Icons.question_answer,
                label: '답변대기 리스트',
              ),
              SideNavigationBarItem(
                icon: Icons.question_answer_outlined,
                label: '답변완료 리스트',
              ),
              SideNavigationBarItem(
                icon: Icons.person,
                label: '마이페이지',
              ),
            ],
            theme: SideNavigationBarTheme(
              itemTheme: SideNavigationBarItemTheme(
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.black26,
                  iconSize: 32.5,
                  labelTextStyle:
                      const TextStyle(fontSize: 15, color: Colors.black)),
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              dividerTheme: SideNavigationBarDividerTheme.standard(),
            ),
            onTap: (index) async {
              if (index == selectedIndex) {
                await _refreshPage(index);
              } else {
                setState(() {
                  selectedIndex = index;
                });
              }
            },
            toggler: SideBarToggler(
                expandIcon: Icons.keyboard_arrow_right,
                shrinkIcon: Icons.keyboard_arrow_left,
                onToggle: () {}),
          ),
        ),
        Expanded(
          child: views.elementAt(selectedIndex),
        )
      ],
    );
  }
}
