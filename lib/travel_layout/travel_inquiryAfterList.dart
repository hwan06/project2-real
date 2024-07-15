import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/hotel_api.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class TravelInquiryAfterList extends StatefulWidget {
  const TravelInquiryAfterList({super.key});

  @override
  State<TravelInquiryAfterList> createState() => _TravelInquiryAfterListState();
}

class _TravelInquiryAfterListState extends State<TravelInquiryAfterList> {
  var agencyID = "";
  var message = "";

  List<Map<String, dynamic>> _inquiryData = [];
  bool isLoading = false;
  bool hasData = false;

  @override
  void initState() {
    super.initState();

    final userData = Provider.of<UserData>(context, listen: false);
    agencyID = userData.travelId;
    selectInquiry();
  }

  Future<void> selectInquiry() async {
    setState(() {
      isLoading = true;
    });

    try {
      var res = await http.post(Uri.parse(TravelApi.inquiryAfterSelect), body: {
        'agency_id': agencyID,
      });
      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        print(response);

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
                "agency_name": userData['agency_name'],
                'border_id': userData['border_id'],
                'inquiry_answer': userData['inquiry_answer'],
                'agency_id': userData['agency_id'],
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
                                    '상세정보',
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
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Message(
                                                message:
                                                    user['inquiry_content'],
                                                title: user['inquiry_title'],
                                                agencyId: user['agency_id'],
                                                inquiryAnswer:
                                                    user['inquiry_answer'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          '답변보기',
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

class Message extends StatelessWidget {
  String message;
  String title;
  String agencyId;
  String inquiryAnswer;
  Message({
    super.key,
    required this.message,
    required this.title,
    required this.agencyId,
    required this.inquiryAnswer,
  });

  var messageController = TextEditingController();
  var titleController = TextEditingController();
  var answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> answerView() async {
      try {
        var res =
            await http.post(Uri.parse(TravelApi.inquiryAfterSelect), body: {
          'agency_id': agencyId,
        });

        if (res.statusCode == 200) {
          Navigator.pop(context, true);
        }
      } catch (e) {}
    }

    messageController = TextEditingController(text: message);
    titleController = TextEditingController(text: title);
    answerController = TextEditingController(text: inquiryAnswer);
    return Scaffold(
      appBar: AppBar(
        title: const Text('메세지'),
        elevation: 1.0,
        shadowColor: Colors.black,
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          height: 800,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "문의 제목",
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  TextField(
                    readOnly: true,
                    controller: titleController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "상세메세지",
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  TextField(
                    maxLines: 5,
                    readOnly: true,
                    controller: messageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "답변 메세지",
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  TextField(
                    maxLines: 5,
                    readOnly: true,
                    controller: answerController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: const BorderSide(
                        color: Colors.amber,
                        width: 2,
                      ),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    "뒤로가기",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
