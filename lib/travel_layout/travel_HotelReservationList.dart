import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:flutter_application_hotel/travel_layout/travel_InquiryPage.dart';
import 'package:flutter_application_hotel/travel_layout/travel_ReservationDetail.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ReservationList extends StatefulWidget {
  const ReservationList({super.key});

  @override
  _ReservationListState createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  List<Map<String, dynamic>> _userData = [];
  var reservation_id = "";

  bool isLoading = false;
  bool hasData = false;
  dynamic date = "";

  String? travelID;

  @override
  void initState() {
    super.initState();

    final userData = Provider.of<UserData>(context, listen: false);
    travelID = userData.travelId.toString();
    _fetchUserDataFromApi();
  }

  Future<void> _fetchUserDataFromApi() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(Uri.parse(TravelApi.resvSelect), body: {
        'travel_reservation_status': "0",
        'hotel_reservation_status': "0",
        "agency_id": travelID,
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true) {
          List<dynamic>? userDataList = responseBody['resv_list'];

          setState(() {
            _userData = userDataList!.map((userData) {
              return {
                'reservation_id': userData['reservation_id'].toString(),
                'inquirer_name': userData['inquirer_name'],
                'check_out_date': userData['check_out_date'],
                'agency_id': userData['agency_id'],
                "travel_reservation_status":
                    userData['travel_reservation_status'],
                "hotel_reservation_status":
                    userData['hotel_reservation_status'],
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
        'cancel_date': date.toString().replaceAll(",", ""),
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
      context: context,
      barrierDismissible: false,
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
                date = DateTime.now();
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
        builder: (context) => ReservationDetail(ReserverInfo: userData),
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
            builder: (context) => InquiryInput(userData: userData)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '예약리스트',
          style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        elevation: 2,
        backgroundColor: Colors.purple[200],
        shadowColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasData
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(height: 10),
                    itemCount: _userData.length,
                    itemBuilder: (context, index) {
                      var user = _userData[index];
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
