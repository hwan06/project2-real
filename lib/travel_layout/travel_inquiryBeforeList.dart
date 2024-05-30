import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_application_hotel/travel_layout/travel_inquiryMessage.dart';

class TravelInquiryBeforeList extends StatefulWidget {
  const TravelInquiryBeforeList({super.key});

  @override
  State<TravelInquiryBeforeList> createState() =>
      _TravelInquiryBeforeListState();
}

class _TravelInquiryBeforeListState extends State<TravelInquiryBeforeList> {
  var travelID = "";
  var message = "";
  var hotelID = "";
  List<Map<String, dynamic>> _inquiryData = [];
  bool isLoading = false;
  bool hasData = false;

  @override
  void initState() {
    super.initState();

    final userData = Provider.of<UserData>(context, listen: false);
    travelID = userData.travelId;
    selectInquiry();
  }

  Future<void> selectInquiry() async {
    setState(() {
      isLoading = true;
    });

    try {
      var res =
          await http.post(Uri.parse(TravelApi.inquiryBeforeSelect), body: {
        'agency_id': travelID,
      });
      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);

        if (response['success']) {
          List<dynamic> inquiryData = response['room_inquiry_data'];
          setState(() {
            _inquiryData = inquiryData.map((userData) {
              return {
                'write_date': userData['write_date'].toString(),
                'inquiry_title': userData['inquiry_title'],
                'inquiry_type': userData['inquiry_type'],
                "inquirer_name": userData['inquirer_name'],
                "inquiry_content": userData['inquiry_content'],
                "hotel_name": userData['hotel_name'],
                'border_id': userData['border_id'],
              };
            }).toList();
            isLoading = false;
            hasData = _inquiryData.isNotEmpty;
          });
        } else {
          setState(() {
            isLoading = false;
            hasData = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          hasData = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '문의 리스트',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        backgroundColor: Colors.purple[200],
        elevation: 2.0,
        shadowColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasData
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(2),
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
                                    '이름',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                  color: Colors.lightBlue,
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    '호텔명',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                  color: Colors.lightBlue,
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    '문의날짜',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                  color: Colors.lightBlue,
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    '문의유형',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                  color: Colors.lightBlue,
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    '설명보기',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ]),
                            ..._inquiryData.map((user) => TableRow(children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        user['inquirer_name'],
                                        style: const TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        user['hotel_name'],
                                        style: const TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        user['write_date'],
                                        style: const TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        user['inquiry_type'],
                                        style: const TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Message(
                                                message:
                                                    user['inquiry_content'],
                                                title: user['inquiry_title'],
                                                borderID: user['border_id']
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                          if (result == true) {
                                            selectInquiry();
                                          }
                                        },
                                        child: const Text(
                                          '메세지보기',
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 15,
                                              color: Colors.green),
                                        ),
                                      )
                                    ],
                                  ),
                                ])),
                          ],
                        ),
                      ),
                    ],
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
