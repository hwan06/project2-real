import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/hotel_api.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_Update.dart';
import 'package:http/http.dart' as http;

class ReservationDetail extends StatefulWidget {
  final Map<String, dynamic> ReserverInfo;
  const ReservationDetail({
    super.key,
    required this.ReserverInfo,
  });

  @override
  State<ReservationDetail> createState() => _ReservationDetailState();
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

class _ReservationDetailState extends State<ReservationDetail> {
  Future<void> _resvConfirm() async {
    try {
      var response = await http.post(Uri.parse(HotelApi.resvConfirm), body: {
        'reservation_id': reservationId,
        'travel_reservation_status': "1",
        'hotel_reservation_status': "1",
      });

      if (response.statusCode == 200) {
        print('200');
        if (mounted) {
          Navigator.pop(context, true); // 현재 페이지 닫기
        }
        setState(() {
          // _fetchUserDataFromApi();
        });
      }
    } catch (e) {}
  }

  Future<void> _resvConfirm1() async {
    try {
      var response = await http.post(Uri.parse(HotelApi.resvConfirm), body: {
        'reservation_id': reservationId,
        'travel_reservation_status': "4",
        'hotel_reservation_status': "4",
      });

      if (response.statusCode == 200) {
        print('200');
        if (mounted) {
          Navigator.pop(context, true); // 현재 페이지 닫기
        }
        setState(() {
          // _fetchUserDataFromApi();
        });
      }
    } catch (e) {}
  }

  Future<void> _resvConfirm2() async {
    try {
      var response = await http.post(Uri.parse(TravelApi.resvUpdate), body: {
        'reservation_id': reservationId,
        'travel_reservation_status': "4",
        'hotel_reservation_status': "4",
      });

      if (response.statusCode == 200) {
        setState(() {
          // _fetchUserDataFromApi();
        });
      }
    } catch (e) {}
  }

  Future<void> _confirm() {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '예약불가 상태로 변경하시겠습니까?',
            style: TextStyle(
                fontFamily: 'Pretendard', fontWeight: FontWeight.w700),
          ),
          content: const SingleChildScrollView(),
          actions: [
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(
                    fontFamily: 'Pretendard', fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _resvConfirm1();
                _resvConfirm2();
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

  Future<void> _Confirm() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '예약을 수락하시겠습니까?',
            style: TextStyle(
                fontFamily: 'Pretendard', fontWeight: FontWeight.w700),
          ),
          content: const SingleChildScrollView(),
          actions: [
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(
                    fontFamily: 'Pretendard', fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _resvConfirm();
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
    DateTime startDate = DateTime.parse(checkInDate);
    DateTime endDate = DateTime.parse(checkOutDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('상세정보'),
        elevation: 1.0,
        shadowColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(30),
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
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        reservation_id =
                            widget.ReserverInfo['reservation_id'].toString();
                      });
                      _Confirm();
                    },
                    style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        side: const BorderSide(
                          width: 2,
                          color: Colors.green,
                        )),
                    child: const Text(
                      '예약수락',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        reservation_id =
                            widget.ReserverInfo['reservation_id'].toString();
                      });
                      _confirm();
                    },
                    style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        side: const BorderSide(
                          width: 2,
                          color: Colors.red,
                        )),
                    child: const Text(
                      '예약불가',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          color: Colors.red),
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
