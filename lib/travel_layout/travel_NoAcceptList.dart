import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:flutter_application_hotel/travel_layout/travel_InquiryPage.dart';
import 'package:flutter_application_hotel/travel_layout/travel_NoAcceptDetail.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ReservationNoAcceptList extends StatefulWidget {
  const ReservationNoAcceptList({super.key});

  @override
  _ReservationNoAcceptListState createState() =>
      _ReservationNoAcceptListState();
}

class _ReservationNoAcceptListState extends State<ReservationNoAcceptList> {
  List<Map<String, dynamic>> _userData = []; // 데이터베이스에서 가져온 사용자 데이터
  var reservation_id = "";
  var hotelID = "";
  bool isLoading = false;
  bool hasData = false;
  String? travelID;

  @override
  void initState() {
    super.initState();

    // Provider를 통해 UserData 가져오기
    final userData = Provider.of<UserData>(context, listen: false);

    // UserData에서 사용자 정보 가져오기
    travelID = userData.travelId.toString();
    // 비동기적으로 데이터를 가져오는 시뮬레이션 (예: 네트워크 요청 등)
    _fetchUserDataFromApi();
  }

  Future<void> _fetchUserDataFromApi() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(Uri.parse(TravelApi.resvSelect), body: {
        'travel_reservation_status': "4",
        'hotel_reservation_status': "4",
        "agency_id": travelID,
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true) {
          List<dynamic>? userDataList = responseBody['resv_list'];
          print(userDataList);

          setState(() {
            _userData = userDataList!.map((userData) {
              return {
                'reservation_id': userData['reservation_id'].toString(),
                'inquirer_name': userData['inquirer_name'],
                'check_out_date': userData['check_out_date'],
                "travel_reservation_status":
                    userData['travel_reservation_status'],
                "agency_id": userData['agency_id'],
                "room_count": userData['room_count'].toString(),
                "night_count": userData['night_count'].toString(),
                "hotel_id": userData['hotel_id'].toString(),
                "hotel_price": userData['hotel_price'].toString(),
                "guest_count": userData['guest_count'].toString(),
                "inquirer_tel": userData['inquirer_tel'],
                "check_in_date": userData['check_in_date'],
                "hotel_name": userData['hotel_name'],
              };
            }).toList();

            isLoading = false;
            hasData = _userData.isNotEmpty;
          });
        } else {
          setState(() {
            isLoading = false;
            hasData = false;
          });
          throw "Failed to fetch user data";
        }
      } else {
        setState(() {
          isLoading = false;
          hasData = false;
        });
        throw "Failed to load user data: ${response.statusCode}";
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasData = false;
      });
      print("Error fetching user data: $e");
    }
  }

  Future<void> resvCancel() async {
    try {
      var response =
          await http.post(Uri.parse(TravelApi.resvcancelUpdate), body: {
        'reservation_id': reservation_id,
      });

      if (response.statusCode == 200) {
        _fetchUserDataFromApi();
      }
    } catch (e) {
      print("Error canceling reservation: $e");
    }
  }

  Future<void> _cancleConfirm() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('예약을 취소하시겠습니까?'),
          actions: [
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(fontFamily: 'Pretendard', color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                resvCancel();
              },
            ),
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void viewDetail(Map<String, dynamic> userData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoAcceptDetail(ReserverInfo: userData),
      ),
    );

    if (result == true) {
      setState(() {
        _fetchUserDataFromApi();
      });
    }
  }

  void inquiryInput(Map<String, dynamic> userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InquiryInput(userData: userData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '예약불가 리스트',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 2,
        backgroundColor: Colors.purple[200],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasData
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.separated(
                    itemCount: _userData.length,
                    separatorBuilder: (context, index) =>
                        const Divider(), // 각 항목 사이에 구분선 추가
                    itemBuilder: (context, index) {
                      Map<String, dynamic> user = _userData[index];

                      return ListTile(
                        title: Text(
                          user['inquirer_name'].toString(),
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          user['hotel_name'].toString(),
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                viewDetail(user);
                              },
                              child: const Text(
                                '자세히보기',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontFamily: 'Pretendard'),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  reservation_id = user['reservation_id'];
                                });
                                _cancleConfirm();
                              },
                              child: const Text(
                                '취소',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Pretendard'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text(
                    '리스트가 비어있습니다.',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.red,
                      fontSize: 22,
                    ),
                  ),
                ),
    );
  }
}
