import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_hotel/api/admin_api.dart';

class TravelUserConfirm extends StatefulWidget {
  const TravelUserConfirm({super.key});

  @override
  _TravelUserConfirmState createState() => _TravelUserConfirmState();
}

class _TravelUserConfirmState extends State<TravelUserConfirm> {
  List<Map<String, dynamic>> _userData = []; // 데이터베이스에서 가져온 사용자 데이터
  var acceptEmail = "";
  bool isLoading = false;
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    // 비동기적으로 데이터를 가져오는 시뮬레이션 (예: 네트워크 요청 등)
    _fetchUserDataFromApi();
  }

  Future<void> _fetchUserDataFromApi() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.post(Uri.parse(AdminApi.travelconfirm));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true) {
          // 'data' 필드가 null인지 확인 후 데이터 추출
          List<dynamic>? userDataList = responseBody['travel_list'];

          if (userDataList != null) {
            setState(() {
              _userData = userDataList.map((userData) {
                return {
                  'email': userData['travel_email'],
                  'phone': userData['travel_tel'],
                  'name': userData['travel_name'],
                  'agency_name': userData['agency_name'],
                };
              }).toList();

              print(userDataList);

              isLoading = false;
              hasData = userDataList.isEmpty;
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      // 에러 처리
    }
  }

  Future<void> _acceptUser() async {
    try {
      var response = await http.post(Uri.parse(AdminApi.accept), body: {
        'sep': "travel",
        'change': "true",
        'email': acceptEmail,
      });

      if (response.statusCode == 200) {
        setState(() {
          _fetchUserDataFromApi();
        });
      }
    } catch (e) {}
  }

  Future<void> _cancelUser() async {
    try {
      var response = await http.post(Uri.parse(AdminApi.accept), body: {
        'sep': "travel",
        'change': "false",
        'email': acceptEmail,
      });

      if (response.statusCode == 200) {
        setState(() {
          _fetchUserDataFromApi();
        });
      }
    } catch (e) {}
  }

  Future<void> _accept() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('승인하시겠습니까?'),
          content: const SingleChildScrollView(),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                _acceptUser();
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

  Future<void> _cancel() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('거절하시겠습니까?'),
          content: const SingleChildScrollView(),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                _cancelUser();
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
        title: const Text(
          "여행사 가입승인 페이지",
          style:
              TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
        elevation: 1.0,
        shadowColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasData
              ? const Center(
                  child: Text(
                  '리스트가 비어있습니다.',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Pretendard',
                    fontSize: 22,
                  ),
                ))

              /// 데이터가 로드될 때까지 로딩 스피너 표시
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 500,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Table(
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text(
                                        '이름',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      )),
                                  Container(
                                      color: Colors.lightBlue,
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text(
                                        '전화번호',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      )),
                                  Container(
                                      color: Colors.lightBlue,
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text(
                                        '이메일',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      )),
                                  Container(
                                      color: Colors.lightBlue,
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text(
                                        '여행사명',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      )),
                                  Container(
                                      color: Colors.lightBlue,
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text(
                                        '승인 / 거절',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      )),
                                ]),
                                ..._userData.map((user) => TableRow(children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            user['name'],
                                            textAlign: TextAlign.center,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            user['phone'],
                                            textAlign: TextAlign.center,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            user['email'],
                                            textAlign: TextAlign.center,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            user['agency_name'],
                                            textAlign: TextAlign.center,
                                          )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                acceptEmail = user['email'];
                                              });
                                              _accept();
                                            },
                                            child: const Text(
                                              '승인',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  acceptEmail = user['email'];
                                                });
                                                _cancel();
                                              },
                                              child: const Text(
                                                '거절',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))
                                        ],
                                      )
                                    ])),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
