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

  @override
  void initState() {
    super.initState();
    // 비동기적으로 데이터를 가져오는 시뮬레이션 (예: 네트워크 요청 등)
    _fetchUserDataFromApi();
  }

  Future<void> _fetchUserDataFromApi() async {
    try {
      var response = await http.post(Uri.parse(AdminApi.travelconfirm));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true) {
          // 'data' 필드가 null인지 확인 후 데이터 추출
          List<dynamic>? userDataList = responseBody['travel_list'];

          if (userDataList != null) {
            _userData = userDataList.map((userData) {
              return {
                'email': userData['travel_email'],
                'phone': userData['travel_tel'],
                'name': userData['travel_name'],
                'agency_id': userData['agency_id'],
              };
            }).toList();

            setState(() {
              // 화면 업데이트
            });
          } else {
            throw "User data is null"; // 데이터가 null일 경우 처리
          }
        } else {
          throw "Failed to fetch user data"; // 요청이 실패하면 예외 발생
        }
      } else {
        throw "Failed to load user data: ${response.statusCode}";
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
    return _userData.isEmpty
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
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(3),
                      3: FlexColumnWidth(2),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Container(
                            color: Colors.lightBlue,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              '이름',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            color: Colors.lightBlue,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              '전화번호',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            color: Colors.lightBlue,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              '이메일',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                        Container(
                            color: Colors.lightBlue,
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              '승인 / 거절',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                      ]),
                      ..._userData.map((user) => TableRow(children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(user['name'])),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(user['phone'])),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(user['email'])),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            )
                          ])),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
