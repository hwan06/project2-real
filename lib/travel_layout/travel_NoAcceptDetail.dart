import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/hotel_api.dart';
import 'package:flutter_application_hotel/travel_layout/travel_TravelUpdate.dart';
import 'package:get/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_hotel/api/travel_api.dart';

class NoAcceptDetail extends StatefulWidget {
  final Map<String, dynamic> ReserverInfo;
  const NoAcceptDetail({
    super.key,
    required this.ReserverInfo,
  });

  @override
  State<NoAcceptDetail> createState() => _NoAcceptDetailState();
}

List<dynamic> data = [];
String reservationId = "";
String hotelID = "";
String travelID = "";
String hotelname = "";
String inquiryName = "";
String inquiryTel = "";
String nightCount = "";
String guestCount = "";
String roomCount = "";
String checkInDate = "";
String checkOutDate = "";
String totalPrice = "";
String resvStatus = "";
var reservation_id = "";

class _NoAcceptDetailState extends State<NoAcceptDetail> {
  Future<void> _Confirm() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '예약내용을 변경하시겠습니까?',
            style: TextStyle(
                fontFamily: 'Pretendard', fontWeight: FontWeight.w700),
          ),
          actions: [
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(
                    fontFamily: 'Pretendard', fontWeight: FontWeight.w700),
              ),
              onPressed: () async {
                DateTime startDate = DateTime.parse(checkInDate);
                DateTime endDate = DateTime.parse(checkOutDate);
                Navigator.of(context).pop();
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatePage(
                      reservationID: reservationId,
                      name: inquiryName,
                      phone: inquiryTel,
                      startDate: startDate,
                      endDate: endDate,
                      roomcount: roomCount,
                      guest: guestCount,
                      night: nightCount,
                      price: totalPrice,
                    ),
                  ),
                );

                if (result != null) {
                  print(result);
                  _resvRefresh(result.toString());
                  _resvRefresh1(result.toString());
                }
              },
            ),
            TextButton(
              child: const Text(
                '취소',
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _resvRefresh(String id) async {
    try {
      var response = await http.post(Uri.parse(HotelApi.resvConfirm), body: {
        'reservation_id': id.toString().trim(),
        'travel_reservation_status': "1",
        'hotel_reservation_status': "0",
      });

      if (response.statusCode == 200) {
        print(response.body);
        Navigator.pop(context, true);
      } else {}
    } catch (e) {}
  }

  Future<void> _resvRefresh1(String id) async {
    try {
      var response = await http.post(Uri.parse(TravelApi.resvUpdate), body: {
        'reservation_id': id.toString().trim(),
        'travel_reservation_status': "1",
        'hotel_reservation_status': "0",
      });

      if (response.statusCode == 200) {
        print(response.body);
      } else {}
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reservationId = widget.ReserverInfo['reservation_id'].toString();
    hotelID = widget.ReserverInfo['hotel_id'].toString();
    travelID = widget.ReserverInfo['agency_id'].toString();
    hotelname = widget.ReserverInfo['hotel_name'];
    inquiryName = widget.ReserverInfo['inquirer_name'];
    inquiryTel = widget.ReserverInfo['inquirer_tel'];
    nightCount = widget.ReserverInfo['night_count'].toString();
    guestCount = widget.ReserverInfo['guest_count'].toString();
    roomCount = widget.ReserverInfo['room_count'].toString();
    checkInDate = widget.ReserverInfo['check_in_date'];
    checkOutDate = widget.ReserverInfo['check_out_date'];
    totalPrice = widget.ReserverInfo['hotel_price'].toString();
    resvStatus = widget.ReserverInfo['travel_reservation_status'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상세정보'),
        elevation: 1.0,
        shadowColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 200,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '호텔 ID: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      hotelID,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '여행사 ID: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      travelID,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '호텔명: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      hotelname,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '예약자명: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      inquiryName,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '전화번호: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      inquiryTel,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '체크인: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      checkInDate,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '체크아웃: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      checkOutDate,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '인원수: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      guestCount,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '박 수: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      nightCount,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '객실수: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      roomCount,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '지불액: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      totalPrice,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: () async {
                      _Confirm();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.green,
                      ),
                    ),
                    child: const Text(
                      '변경하기',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
