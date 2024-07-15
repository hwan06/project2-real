import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_BottomNavi.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_CancelStatisticOut.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_Main.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_MyPage.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_ReservationCompleteList.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_ReservationConfirmList.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_CancelList.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_inquiryAfterSelect.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_inquiryBeforeSelect.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_ReservationList.dart';

class hotel_index extends StatefulWidget {
  final String name;
  final String email;
  final String tel;
  final String pw;
  const hotel_index(
      {required this.email,
      required this.name,
      required this.tel,
      required this.pw,
      super.key});

  @override
  createState() => _MainViewState(email, name, tel, pw);
}

class _MainViewState extends State<hotel_index> {
  bool _reloadPage = false;
  String name;
  String email;
  String tel;
  String pw;
  late List<Widget> views;

  _MainViewState(this.email, this.name, this.tel, this.pw);

  @override
  void initState() {
    super.initState();
    views = [
      const HotelMainPage(),
      const ReservationList(),
      const ReservationConfirmList(),
      const ReservationComplete(),
      const CancelList(),
      const HotelInquiryBeforeList(),
      const HotelInquiryAfterList(),
      const HStatisticBottomNavi(),
      hotel_MyPage(email: email, name: name, tel: tel, pw: pw)
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
        return const HotelMainPage();
      case 1:
        return const ReservationList();
      case 2:
        return const ReservationConfirmList();
      case 3:
        return const ReservationComplete();
      case 4:
        return const CancelList();
      case 5:
        return const HotelInquiryBeforeList();
      case 6:
        return const HotelInquiryAfterList();
      case 7:
        return const HStatisticBottomNavi();
      case 8:
        return hotel_MyPage(email: email, name: name, tel: tel, pw: pw);
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
        shape: Border(
          bottom: BorderSide(width: 3, color: Colors.grey.shade200),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
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
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text(
              '메인화면',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              setState(() {
                selectedIndex = 0;
                Navigator.pop(context);
              });
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.list),
            title: const Text(
              '리스트',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.timer),
                title: const Text(
                  '수락대기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text(
                  '컨펌대기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.check),
                title: const Text(
                  '컨펌완료',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = 3;
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text(
                  '취소 리스트',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = 4;
                    Navigator.pop(context);
                  });
                },
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
              ListTile(
                title: const Text(
                  '답변대기 리스트',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = 5;
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                title: const Text(
                  '답변완료 리스트',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = 6;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.graph_circle),
            title: const Text(
              '통계',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              setState(() {
                selectedIndex = 7;
                Navigator.pop(context);
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              '마이페이지',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              setState(() {
                selectedIndex = 8;
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
    );
  }
}
