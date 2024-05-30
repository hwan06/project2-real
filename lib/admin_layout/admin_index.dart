import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/admin_layout/admin_TraveluserConfirm.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:flutter_application_hotel/index/index.dart';
import 'package:flutter_application_hotel/admin_layout/admin_HoteluserConfirm.dart';

class admin_index extends StatefulWidget {
  const admin_index({super.key});

  @override
  createState() => _MainViewState();
}

class _MainViewState extends State<admin_index> {
  late List<Widget> views;

  _MainViewState();

  @override
  void initState() {
    views = [
      const Center(),
      const TravelUserConfirm(),
      const HoteluserConfirm(),
      const Center(
        child: Text('통계'),
      ),
    ];
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                icon: Icons.person_add,
                label: '여행사 가입승인',
              ),
              SideNavigationBarItem(
                icon: Icons.person_add,
                label: '호텔 가입승인',
              ),
              SideNavigationBarItem(
                icon: Icons.auto_graph_outlined,
                label: '통계',
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
            onTap: (index) {
              setState(() {
                if (index >= 0 && index < views.length) {
                  // views의 길이에 맞게 범위를 확인합니다.
                  selectedIndex = index;
                }
              });
            },
            toggler: SideBarToggler(
                expandIcon: Icons.keyboard_arrow_left,
                shrinkIcon: Icons.keyboard_arrow_right,
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
