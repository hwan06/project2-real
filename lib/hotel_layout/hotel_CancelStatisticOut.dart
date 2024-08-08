import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/hotel_api.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_CancelStatisticOut.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_HotelStatisticDetailIn.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_ReservationCompleteDetail.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HotelStatisticOut extends StatefulWidget {
  const HotelStatisticOut({super.key});

  @override
  State<HotelStatisticOut> createState() => _HotelStatisticOutState();
}

class _HotelStatisticOutState extends State<HotelStatisticOut> {
  List<dynamic> cancelList = [];
  String hotelID = "";
  DateTimeRange? selectedDateRange;
  bool isFullRangeSelected = false;

  int totalReservations = 0;
  int canceledReservations = 0;
  int totalNightCount = 0;
  int confirmedReservations = 0;
  int reservating = 0;
  DateTime? fromDate1;
  DateTime? toDate1;
  String totalPrice = "";
  String travelID = "";

  static const TextStyle textStyle = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: Colors.white);

  @override
  void initState() {
    super.initState();
    final userData = Provider.of<UserData>(context, listen: false);
    hotelID = userData.hotelID.toString();
    fromDate1 = DateTime(2000);
    toDate1 = DateTime.now();
    isFullRangeSelected = true;
    selectAllGraph();
  }

  Future<void> selectCancelGraph(
      String fromDate, String toDate, String hotelID) async {
    try {
      var res = await http.post(Uri.parse(HotelApi.cancelGraph), body: {
        'from_date': fromDate,
        'to_date': toDate,
        'hotel_id': hotelID,
      });

      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        print(response);

        setState(() {
          cancelList = response['listArray'];
          totalReservations = response['total_reservations'];
          canceledReservations = response['canceled_reservations'];
          totalNightCount = response['total_night_count'];
          reservating = response['active_reservations'];
          confirmedReservations = response['confirmed_reservations'];
          totalPrice = response['total_price'];
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> selectAllGraph() async {
    print(hotelID);
    try {
      var res = await http.post(Uri.parse(HotelApi.allGraph), body: {
        'hotel_id': hotelID,
      });

      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        print(response);

        setState(() {
          cancelList = response['listArray'];
          totalReservations = response['total_reservations'];
          canceledReservations = response['canceled_reservations'];
          totalNightCount = response['total_night_count'];
          reservating = response['active_reservations'];
          confirmedReservations = response['confirmed_reservations'];
          totalPrice = response['total_price'].toString();
          fromDate1 = DateTime(2000);
          toDate1 = DateTime.now();
        });
        print("cancelList: $cancelList");
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
        isFullRangeSelected = false;
        var fromDate = DateFormat('yyyyMMdd').format(picked.start);
        var toDate = DateFormat('yyyyMMdd').format(picked.end);
        selectCancelGraph(fromDate, toDate, hotelID);
      });
    }
  }

  void _updateDateRange(int days, {bool subtract = false}) {
    var now = DateTime.now();
    var startDate = subtract ? now.subtract(Duration(days: days)) : now;
    var endDate = subtract ? now : now.add(Duration(days: days));
    setState(() {
      selectedDateRange = DateTimeRange(start: startDate, end: endDate);
      isFullRangeSelected = false;
      fromDate1 = startDate;
      toDate1 = endDate;
      selectCancelGraph(
        DateFormat('yyyyMMdd').format(startDate),
        DateFormat('yyyyMMdd').format(endDate),
        hotelID,
      );
    });
  }

  void _selectFullRange() {
    setState(() {
      selectedDateRange = DateTimeRange(
        start: DateTime(2000),
        end: DateTime.now(),
      );
      fromDate1 = DateTime(2000);
      toDate1 = DateTime.now();
      isFullRangeSelected = true;
      selectAllGraph();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectDateRange(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    isFullRangeSelected
                        ? '전체선택됨'
                        : selectedDateRange == null
                            ? '날짜 선택'
                            : '${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}',
                    style: const TextStyle(
                        fontFamily: "Pretendard",
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                _buildFilterButton('어제', 1, subtract: true),
                _buildFilterButton('오늘', 0),
                _buildFilterButton('7일', 7),
                _buildFilterButton('1개월', 30),
                _buildFilterButton('3개월', 90),
                _buildFilterButton('전체', 3650,
                    isFullRange: true), // 대략 10년을 전체 기간으로 설정
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryTable(),
            const SizedBox(height: 16),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 1200,
                  child: Column(
                    children: [
                      Table(
                        border: TableBorder.all(),
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                          4: FlexColumnWidth(1),
                          5: FlexColumnWidth(1),
                          6: FlexColumnWidth(1),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              _buildColumnTitle("여행사명", 32),
                              _buildColumnTitle("전체건수", 32),
                              _buildColumnTitle("컨펌완료", 32),
                              _buildColumnTitle("진행중인 예약", 32),
                              _buildColumnTitle("취소건수", 32),
                              _buildColumnTitle("거래금액", 32),
                              _buildColumnTitle("숙박수", 32),
                            ],
                          ),
                          ...cancelList.map((data) {
                            return TableRow(children: [
                              _buildRowValue(data['agency_name'].toString()),
                              _buildRowValue1(
                                  "${data['total_reservations']}건",
                                  data['agency_id'],
                                  fromDate1,
                                  toDate1,
                                  "check_out",
                                  isFullRangeSelected),
                              _buildRowValue("${data['confirm']}건"),
                              _buildRowValue("${data['active_reservations']}건"),
                              _buildRowValue("${data['cancel']}건"),
                              _buildRowValue("${data['total_price']}원"),
                              _buildRowValue("${data['total_room_nights']}박"),
                            ]);
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, int days,
      {bool subtract = false, bool isFullRange = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          if (isFullRange) {
            _selectFullRange();
          } else {
            _updateDateRange(days, subtract: subtract);
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.black,
        ),
        child: Text(
          label,
          style: const TextStyle(
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSummaryTable() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1200,
          child: Column(
            children: [
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
                      _buildColumnTitle2("전체건수", 32),
                      _buildColumnTitle2("컨펌완료", 32),
                      _buildColumnTitle2("진행중인예약", 32),
                      _buildColumnTitle2("취소건수", 32),
                      _buildColumnTitle2("거래금액", 32),
                      _buildColumnTitle2("숙박수", 32),
                    ],
                  ),
                  TableRow(children: [
                    _buildRowValue("$totalReservations건"),
                    _buildRowValue("$confirmedReservations건"),
                    _buildRowValue("$reservating건"),
                    _buildRowValue("$canceledReservations건"),
                    _buildRowValue("$totalPrice원"),
                    _buildRowValue("$totalNightCount박"),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumnTitle(String title, double height) {
    const TextStyle textStyle = TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: Colors.white);

    return Container(
      color: Colors.blueAccent,
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
    const TextStyle textStyle =
        TextStyle(fontFamily: 'Pretendard', fontSize: 18);
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
}

Widget _buildRowValue1(
  String text,
  String travelID,
  DateTime? fromDate,
  DateTime? toDate,
  String sep,
  bool isFullRange,
) {
  const TextStyle textStyle = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 18,
      color: Colors.blue,
      decoration: TextDecoration.underline,
      decorationColor: Colors.blue);
  return Builder(builder: (context) {
    return Container(
      height: 30,
      color: Colors.white,
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HotelCheckInDetail(
                          travelID: travelID,
                          fromDate: fromDate,
                          toDate: toDate,
                          sep: sep,
                          isFullRange: isFullRange,
                        )));
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  });
}
