import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_hotel/admin_layout/admin_TravelUpdata.dart';
import 'package:flutter_application_hotel/api/admin_api.dart';
import 'package:http/http.dart' as http;

class TravelUserInfo extends StatefulWidget {
  const TravelUserInfo({super.key});

  @override
  State<TravelUserInfo> createState() => _TravelUserInfoState();
}

class _TravelUserInfoState extends State<TravelUserInfo> {
  bool isLoading = false;
  bool hasData = false;
  String email = "";
  List<Map<String, dynamic>> _inquiryData = [];
  Future<void> selectTravelUserInfo() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.post(Uri.parse(AdminApi.travelUser));
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        if (res['success'] = true) {
          List<dynamic> dataList = res['travel_member_data'];
          setState(() {
            _inquiryData = dataList.map((data) {
              return {
                "travel_email": data['travel_email'],
                "travel_tel": data['travel_tel'],
                "travel_name": data['travel_name'],
                "agency_name": data['agency_name'],
              };
            }).toList();
          });
          isLoading = false;
          hasData = _inquiryData.isEmpty;
          print(dataList);
        }
      }
    } catch (e) {}
  }

  Future<void> deleteAccount(String email) async {
    try {
      var response = await http.post(Uri.parse(AdminApi.travelAccountDelete),
          body: {"travel_email": email.toString().trim()});
      print(response.statusCode);
      print(response.body);
      var res = jsonDecode(response.body);

      if (res['success'] == true) {
        print("success");
        setState(() {
          selectTravelUserInfo();
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectTravelUserInfo();
  }

  void updatePage(
      String name, String phone, String email, String agencyName) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TravelUpdatePage(
                name: name,
                phone: phone,
                email: email,
                agencyName: agencyName)));
    if (result == true) {
      setState(() {
        selectTravelUserInfo();
      });
    }
  }

  Future<void> _cancel(String email) async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제하시겠습니까?'),
          content: const SingleChildScrollView(),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteAccount(email);
              },
            ),
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        shadowColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          "여행사 회원",
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasData
              ? const Center(
                  child: Text(
                    "리스트가 비어있습니다.",
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 22,
                        color: Colors.red),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(children: [
                              Container(
                                color: Colors.lightBlue,
                                padding: const EdgeInsets.all(8),
                                child: const Text(
                                  "여행사명",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                color: Colors.lightBlue,
                                padding: const EdgeInsets.all(8),
                                child: const Text(
                                  "이름",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                color: Colors.lightBlue,
                                padding: const EdgeInsets.all(8),
                                child: const Text(
                                  "전화번호",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                color: Colors.lightBlue,
                                padding: const EdgeInsets.all(8),
                                child: const Text(
                                  "이메일",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                              ),
                            ]),
                            ..._inquiryData.map(
                              (data) => TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    data['agency_name'],
                                    style: const TextStyle(
                                        fontFamily: 'Pretendard', fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(data['travel_name'],
                                      style: const TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 16),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(data['travel_tel'],
                                      style: const TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 16),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(data['travel_email'],
                                      style: const TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 16),
                                      textAlign: TextAlign.center),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        updatePage(
                                            data['travel_name'],
                                            data['travel_tel'],
                                            data['travel_email'],
                                            data['agency_name']);
                                      },
                                      child: const Text(
                                        "정보변경",
                                        style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.amber),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          email = data['travel_email'];
                                        });
                                        _cancel(email);
                                      },
                                      child: const Text(
                                        "삭제",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
    );
  }
}
