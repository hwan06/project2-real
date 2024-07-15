import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/admin_layout/admin_HotelUploadList.dart';
import 'package:flutter_application_hotel/admin_layout/admin_TravelUploadList.dart';
import 'package:flutter_application_hotel/admin_layout/admin_TraveluserConfirm.dart';
import 'package:flutter_application_hotel/admin_layout/admin_TravelStatistics.dart';
import 'package:flutter_application_hotel/admin_layout/admin_HotelUserInfo.dart';
import 'package:flutter_application_hotel/admin_layout/admin_HotelStatisticsOut.dart';
import 'package:flutter_application_hotel/admin_layout/admin_travelUserInfo.dart';
import 'package:flutter_application_hotel/index/index.dart';
import 'package:flutter_application_hotel/admin_layout/admin_HoteluserConfirm.dart';

class AdminIndex extends StatefulWidget {
  const AdminIndex({super.key});

  @override
  createState() => _AdminIndexState();
}

class _AdminIndexState extends State<AdminIndex> {
  late List<Widget> views;

  @override
  void initState() {
    super.initState();
    views = [
      const Center(),
      const HotelUploadList(),
      const TravelUploadList(),
      const TravelUserConfirm(),
      const HoteluserConfirm(),
      const TravelUserInfo(),
      const HotelUserInfo(),
      const TravelCancleStatistics(),
      const HotelStatisticsOut(),
    ];
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout, color: Colors.black),
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
          ListTile(
            leading: const Icon(CupertinoIcons.building_2_fill),
            title: const Text(
              '호텔 등록',
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
            leading: const Icon(CupertinoIcons.airplane),
            title: const Text(
              '여행사 등록',
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
          ExpansionTile(
            title: const Text(
              "가입승인",
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: const Icon(CupertinoIcons.check_mark_circled),
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text(
                  '여행사 가입승인',
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
                leading: const Icon(Icons.person_add),
                title: const Text(
                  '호텔 가입승인',
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
            title: const Text(
              "회원관리",
              style: TextStyle(
                  fontFamily: 'Pretendard', fontWeight: FontWeight.w500),
            ),
            leading: const Icon(CupertinoIcons.folder_badge_person_crop),
            children: [
              ListTile(
                leading: const Icon(Icons.auto_graph_outlined),
                title: const Text(
                  '여행사 회원관리',
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
                leading: const Icon(Icons.auto_graph_outlined),
                title: const Text(
                  '호텔 회원관리',
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
          ExpansionTile(
            title: const Text(
              "통계",
              style: TextStyle(
                  fontFamily: 'Pretendard', fontWeight: FontWeight.w500),
            ),
            leading: const Icon(CupertinoIcons.graph_circle),
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  '호텔통계',
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
                  '여행사통계',
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
        ],
      ),
    );
  }
}
