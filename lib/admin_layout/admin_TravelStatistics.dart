import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/admin_api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TravelCancleStatistics extends StatefulWidget {
  const TravelCancleStatistics({super.key});

  @override
  State<TravelCancleStatistics> createState() => _TravelCancleStatisticsState();
}

class _TravelCancleStatisticsState extends State<TravelCancleStatistics> {
  List<dynamic> cancelList = [];
  DateTimeRange? selectedDateRange;
  bool isFullRangeSelected = false;

  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드
    var now = DateTime.now();
    var fromDateInit =
        DateFormat('yyyyMMdd').format(now.subtract(const Duration(days: 30)));
    var toDateInit = DateFormat('yyyyMMdd').format(now);
    selectAllGraph();
  }

  Future<void> selectCancelGraph(String fromDate, String toDate) async {
    try {
      var res = await http.post(Uri.parse(AdminApi.travelCancelGraph), body: {
        'from_date': fromDate,
        'to_date': toDate,
      });

      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        print(response);

        setState(() {
          cancelList = response['listArray'];
        });
        print(cancelList);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> selectAllGraph() async {
    try {
      var res = await http.post(Uri.parse(AdminApi.travelAllGraph), body: {
        'from_date': '20000101',
        'to_date': DateFormat('yyyyMMdd').format(DateTime.now()),
      });

      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        print(response);

        setState(() {
          cancelList = response['listArray'];
        });
        print(cancelList);
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
        selectCancelGraph(fromDate, toDate);
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
      selectCancelGraph(
        DateFormat('yyyyMMdd').format(startDate),
        DateFormat('yyyyMMdd').format(endDate),
      );
    });
  }

  void _selectFullRange() {
    setState(() {
      selectedDateRange = DateTimeRange(
        start: DateTime(2000),
        end: DateTime.now(),
      );
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
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      DataTable(
                        columnSpacing: 90,
                        columns: const [
                          DataColumn(
                            label: Text(
                              "호텔명",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 20,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              "전체건수",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 20,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              "컨펌 완료 건수",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 20,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              "취소 건수",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 20,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              "거래금액",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 20,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              "숙박수",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 20,
                              ),
                            ),
                            numeric: true,
                          ),
                        ],
                        rows: cancelList.map((data) {
                          return DataRow(cells: [
                            DataCell(Text(
                              data['hotel_name'].toString(),
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            )),
                            DataCell(Text(
                              data['total_reservations'].toString(),
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            )),
                            DataCell(Text(
                              data['confirm'].toString(),
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            )),
                            DataCell(Text(
                              data['cancel'].toString(),
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            )),
                            DataCell(Text(
                              data['total_price'].toString(),
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            )),
                            DataCell(Text(
                              data['total_room_nights'].toString(),
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            )),
                          ]);
                        }).toList(),
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
            backgroundColor: Colors.black),
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
}
