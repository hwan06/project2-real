import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_hotel/api/hotel_reservation.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:provider/provider.dart';

class Reservation extends StatefulWidget {
  const Reservation({super.key, required this.hotelList});
  final List<Map<String, dynamic>> hotelList;

  @override
  State<Reservation> createState() => _ReservationState();
}

late String username;
late String userTel;
late String travelID;

var userNameController = TextEditingController(text: username);
var userPhoneController = TextEditingController(text: userTel);
var guestCountController = TextEditingController();
var nightCountController = TextEditingController();
var hotelPriceController = TextEditingController();
var roomCountController = TextEditingController();
var travelIDController = TextEditingController(text: travelID);

class _ReservationState extends State<Reservation> {
  DateTime? _startDate;
  DateTime? _endDate;
  var hotelname2;
  var _nightCount = 0;
  bool resvConfirm = false;

  void updatePrice() {
    int roomCount = int.tryParse(roomCountController.text) ?? 0;
    int basePrice = 0;
    String priceStr =
        widget.hotelList[0]['hotel_price'].toString().replaceAll(",", "");
    basePrice = int.tryParse(priceStr) ?? 0;

    int totalPrice;
    setState(() {
      totalPrice = basePrice * roomCount * _nightCount;
      hotelPriceController.text = totalPrice.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    roomCountController.addListener(updatePrice);
    nightCountController.addListener(updatePrice);

    // Provider를 통해 UserData 가져오기
    final userData = Provider.of<UserData>(context, listen: false);

    // UserData에서 사용자 정보 가져오기
    username = userData.name.toString();
    userTel = userData.tel.toString();
    travelID = userData.travelId.toString();

    // 컨트롤러 초기값 설정
    userNameController.text = username;
    userPhoneController.text = userTel;
    travelIDController.text = travelID;
  }

  Future<void> selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: _startDate ?? DateTime.now(),
        end: _endDate ?? DateTime.now().add(const Duration(days: 1)),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _nightCount = picked.end.difference(picked.start).inDays;
        updatePrice();
      });
    }
  }

  hotelReservation() async {
    try {
      var res = await http.post(
        Uri.parse(HotelReservation.reservation),
        body: {
          "hotel_id":
              widget.hotelList[0]['hotel_id'].toString(), // int를 String으로 변환
          "inquirer_name": username,
          "inquirer_tel": userTel,
          "guest_count": guestCountController.text.trim(),
          "night_count": _nightCount.toString(), // int를 String으로 변환
          "room_count": roomCountController.text.trim(),
          "hotel_price": hotelPriceController.text.trim(),
          "check_in_date": _startDate.toString(), // DateTime을 String으로 변환
          "check_out_date": _endDate.toString(), // DateTime을 String으로 변환
          "agency_id": travelID,
        },
      );

      if (res.statusCode == 200) {
        print('200');
        var resReservation = jsonDecode(res.body);
        reservationComplete();

        if (resReservation['success'] == true) {
          userNameController.clear();
          userPhoneController.clear();
          guestCountController.clear();
          nightCountController.clear();
          roomCountController.clear();
          hotelPriceController.clear();
          _startDate = null;
          _endDate = null;
          _nightCount = 0; // 선택한 날짜와 박수 초기화
        }
      }
    } catch (e) {
      print(e);
    }
  }

  reservationComplete() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('예약이 접수 되었습니다.', textAlign: TextAlign.center)));
    Navigator.pop(context);
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('예약하시겠습니까?'),
          content: const SingleChildScrollView(),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {
                  hotelname2 = widget.hotelList[0]['hotel_name'];
                });

                hotelReservation();
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
    String hotelName = widget.hotelList[0]['hotel_name'];
    String hotelAddress = widget.hotelList[0]['hotel_address'];
    String hotelRating = widget.hotelList[0]['hotel_rating'].toString();
    String hotelPrice = widget.hotelList[0]['hotel_price'].toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          hotelName,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 1.0,
        shadowColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '이름',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: TextFormField(
                    // initialValue: username,
                    readOnly: true,
                    controller: userNameController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(top: 25, left: 10),
                        hintStyle: const TextStyle(
                          fontFamily: 'Pretendard',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '전화번호',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: TextFormField(
                    // initialValue: userTel,
                    readOnly: true,
                    controller: userPhoneController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(top: 25, left: 10),
                        hintText: '전화번호를 입력하세요.',
                        hintStyle: const TextStyle(
                          fontFamily: 'Pretendard',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '여행사ID',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: TextFormField(
                    readOnly: true,
                    controller: travelIDController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(top: 25, left: 10),
                        hintStyle: const TextStyle(
                          fontFamily: 'Pretendard',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '인원수',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: TextFormField(
                    controller: guestCountController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(top: 25, left: 10),
                        hintText: '인원수를 입력하세요.',
                        hintStyle: const TextStyle(
                          fontFamily: 'Pretendard',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '객실수',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: TextFormField(
                    controller: roomCountController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(top: 25, left: 10),
                        hintText: '객실수를 입력하세요.',
                        hintStyle: const TextStyle(
                          fontFamily: 'Pretendard',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '날짜',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: selectDateRange,
                  child: AbsorbPointer(
                    child: SizedBox(
                      width: 270,
                      child: TextFormField(
                        controller: TextEditingController(
                          text: _endDate != null
                              ? '${DateFormat('yyyy-MM-dd').format(_startDate!)} ~ ${DateFormat('yyyy-MM-dd').format(_endDate!)}'
                              : '',
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: '날짜 선택',
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 15.0, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        '총가격',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: TextFormField(
                    controller: hotelPriceController,
                    readOnly: true,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.only(top: 25, left: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SizedBox(
                    width: 270,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        _neverSatisfied();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        '예약하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
