import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_ReservationCompleteDetail.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // intl 패키지 추가

class CheckInDetail extends StatefulWidget {
  final String hotelID;
  final DateTime? fromDate; // 타입 변경
  final DateTime? toDate; // 타입 변경
  final String sep;
  final bool isFullRange;
  const CheckInDetail(
      {super.key,
      required this.hotelID,
      required this.fromDate,
      required this.toDate,
      required this.sep,
      required this.isFullRange});

  @override
  State<CheckInDetail> createState() => _CheckInDetailState();
}

List<Map<String, dynamic>> reservatingList = [];
List<Map<String, dynamic>> confirmedList = [];
List<Map<String, dynamic>> canceledList = [];
List<Map<String, dynamic>> _userData = [];
String hotelID = "";

class _CheckInDetailState extends State<CheckInDetail> {
  static const TextStyle style = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );

  Future<void> _fetchUserDataFromApi() async {
    try {
      if (widget.isFullRange == false) {
        var response =
            await http.post(Uri.parse(TravelApi.travelStaticDetail), body: {
          'agency_id': travelID,
          'hotel_id': widget.hotelID,
          'from_date': widget.fromDate != null
              ? DateFormat('yyyyMMdd').format(widget.fromDate!)
              : "",
          'to_date': widget.toDate != null
              ? DateFormat('yyyyMMdd').format(widget.toDate!)
              : "",
          'sep': widget.sep
        });

        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);

          if (responseBody['success'] == true) {
            List<dynamic>? userDataList = responseBody['resv_list'];

            setState(() {
              _userData = userDataList!.map((userData) {
                return {
                  'check_out_date': userData['check_out_date'],
                  "travel_reservation_status":
                      userData['travel_reservation_status'],
                  "hotel_reservation_status":
                      userData['hotel_reservation_status'],
                  "room_count": userData['room_count'].toString(),
                  "night_count": userData['night_count'].toString(),
                  "hotel_price": userData['hotel_price'].toString(),
                  "guest_count": userData['guest_count'].toString(),
                  "check_in_date": userData['check_in_date'],
                  "hotel_name": userData['hotel_name'],
                  "hotel_id": userData['hotel_id'],
                };
              }).toList();
            });
          }
        }
      } else {
        print(33);
        var response =
            await http.post(Uri.parse(TravelApi.travelStaticDetail), body: {
          'agency_id': travelID,
          'hotel_id': hotelID,
        });

        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          print(responseBody);

          if (responseBody['success'] == true) {
            List<dynamic>? userDataList = responseBody['resv_list'];

            setState(() {
              _userData = userDataList!.map((userData) {
                return {
                  'check_out_date': userData['check_out_date'],
                  "travel_reservation_status":
                      userData['travel_reservation_status'],
                  "hotel_reservation_status":
                      userData['hotel_reservation_status'],
                  "room_count": userData['room_count'].toString(),
                  "night_count": userData['night_count'].toString(),
                  "hotel_price": userData['hotel_price'].toString(),
                  "guest_count": userData['guest_count'].toString(),
                  "check_in_date": userData['check_in_date'],
                  "hotel_name": userData['hotel_name'],
                  "hotel_id": userData['hotel_id'],
                };
              }).toList();
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UserData userData = Provider.of<UserData>(context, listen: false);
    travelID = userData.travelId;
    hotelID = widget.hotelID;
    print(travelID);
    print(hotelID);
    print(widget.fromDate);
    print(widget.toDate);
    print(widget.sep);

    _fetchUserDataFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "예약 현황",
                style: style,
              ),
              Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                  5: FlexColumnWidth(1),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      _buildColumnTitle2("호텔명", 32),
                      _buildColumnTitle2("진행상황", 32),
                      _buildColumnTitle2("인원수", 32),
                      _buildColumnTitle2("객실수", 32),
                      _buildColumnTitle2("금액", 32),
                      _buildColumnTitle2("체크인날짜", 32),
                      _buildColumnTitle2("체크아웃날짜", 32),
                      _buildColumnTitle2("숙박수", 32),
                    ],
                  ),
                  ..._userData.map(
                    (data) => TableRow(children: [
                      _buildRowValue(data['hotel_name']),
                      _getStatusText(data['travel_reservation_status'],
                          data['hotel_reservation_status']),
                      _buildRowValue(data['guest_count'] + "명"),
                      _buildRowValue(data['room_count'] + "개"),
                      _buildRowValue(
                          "${NumberFormat("#,##0").format(int.parse(data['hotel_price']))}원"),
                      _buildRowValue(data['check_in_date']),
                      _buildRowValue(data['check_out_date']),
                      _buildRowValue(data['night_count'] + "일"),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _getStatusText(String status1, String status2) {
  if (status1 == "1" && status2 == "0") {
    return const Text(
      "수락 요청",
      style: TextStyle(
        fontFamily: 'Pretendard',
        color: Color(0xFFFFA500),
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
    );
  } else if (status1 == "1" && status2 == "1") {
    return const Text(
      "수락 완료",
      style: TextStyle(
        fontFamily: 'Pretendard',
        color: Color(0xFF0000FF),
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
    );
  } else if (status1 == "2" && status2 == "1") {
    return const Text(
      "컨펌 요청",
      style: TextStyle(
        fontFamily: 'Pretendard',
        color: Color(0xFF800080),
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
    );
  } else if (status1 == "2" && status2 == "2") {
    return const Text(
      "컨펌 완료",
      style: TextStyle(
        fontFamily: 'Pretendard',
        color: Color(0xFF008000),
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
    );
  } else if (status1 == "3" || status2 == "3") {
    return const Text(
      "예약 취소",
      style: TextStyle(
        fontFamily: 'Pretendard',
        color: Color(0xFFFF0000),
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
    );
  } else if (status1 == "4" && status2 == "4") {
    return const Text(
      "예약 불가",
      style: TextStyle(
        fontFamily: 'Pretendard',
        color: Color(0xFF808080),
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
    );
  } else {
    return const Text("알 수 없음");
  }
}

Widget _buildColumnTitle2(String title, double height) {
  const TextStyle textStyle = TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500,
      fontSize: 20,
      color: Colors.white);

  return Container(
    color: const Color.fromARGB(255, 47, 0, 255),
    height: height,
    child: Center(
      child: Text(
        title,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget _buildRowValue(String text) {
  const TextStyle textStyle = TextStyle(fontFamily: 'Pretendard', fontSize: 18);
  return Container(
    height: 30,
    color: Colors.white,
    child: Center(
      child: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
