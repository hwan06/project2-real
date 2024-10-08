import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/hotel_api.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_hotel/api/admin_api.dart';

class HotelUploadList extends StatefulWidget {
  const HotelUploadList({super.key});

  @override
  _HotelUploadListState createState() => _HotelUploadListState();
}

class _HotelUploadListState extends State<HotelUploadList> {
  List<Map<String, dynamic>> _userData = []; // 데이터베이스에서 가져온 사용자 데이터
  var hotelName = "";
  var hotelCeoName = "";
  var hotelTel = "";
  var hotelAddress = "";
  bool isLoading = false;
  bool hasData = false;

  Image? image;
  String? _base64Image;

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
      var response = await http.post(Uri.parse(AdminApi.hotelUploadList));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          // 'data' 필드가 null인지 확인 후 데이터 추출
          List<dynamic>? userDataList = responseBody['hotel_list'];
          print(responseBody);

          if (userDataList != null) {
            setState(() {
              _userData = userDataList.map((userData) {
                return {
                  'hotel_name': userData['hotel_name'],
                  'hotel_tel': userData['hotel_tel'],
                  'hotel_ceo_name': userData['hotel_ceo_name'],
                  'hotel_address': userData['hotel_address'],
                };
              }).toList();
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
      var response = await http.post(Uri.parse(AdminApi.accept1), body: {
        'sep': "hotel",
        'change': "true",
        'hotel_name': hotelName.toString().trim(),
        'hotel_ceo_name': hotelCeoName.toString().trim(),
        'hotel_tel': hotelTel.toString().trim(),
        'hotel_address': hotelAddress.toString().trim(),
      });

      if (response.statusCode == 200) {
        print(hotelName);
        print(hotelCeoName);
        print(hotelTel);
        print(hotelAddress);
        setState(() {
          _fetchUserDataFromApi();
        });
      }
    } catch (e) {}
  }

  Future<void> _cancelUser() async {
    try {
      var response = await http.post(Uri.parse(AdminApi.accept1), body: {
        'sep': "hotel",
        'change': "false",
        'hotel_name': hotelName.toString().trim(),
        'hotel_ceo_name': hotelCeoName.toString().trim(),
        'hotel_tel': hotelTel.toString().trim(),
        'hotel_address': hotelAddress.toString().trim(),
      });

      if (response.statusCode == 200) {
        print(response);
        print(hotelName);
        print(hotelCeoName);
        print(hotelTel);
        print(hotelAddress);
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
          "호텔 등록 페이지",
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
                )) // 데이터가 로드될 때까지 로딩 스피너 표시
              : Padding(
                  padding: const EdgeInsets.all(10.0),
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    '대표자명',
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
                                    '호텔명',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                  color: Colors.lightBlue,
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    '호텔주소',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                  color: Colors.lightBlue,
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    '사업자등록증',
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
                            ..._userData.map(
                              (user) => TableRow(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        user['hotel_ceo_name'],
                                        textAlign: TextAlign.center,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        user['hotel_tel'],
                                        textAlign: TextAlign.center,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        user['hotel_name'],
                                        textAlign: TextAlign.center,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        user['hotel_address'],
                                        textAlign: TextAlign.center,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          "보기",
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            hotelName = user['hotel_name'];
                                            hotelTel = user['hotel_tel'];
                                            hotelCeoName =
                                                user['hotel_ceo_name'];
                                            hotelAddress =
                                                user['hotel_address'];
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
                                            hotelName = user['hotel_name'];
                                            hotelTel = user['hotel_tel'];
                                            hotelCeoName =
                                                user['hotel_ceo_name'];
                                            hotelAddress =
                                                user['hotel_address'];
                                          });
                                          _cancel();
                                        },
                                        child: const Text(
                                          '거절',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
