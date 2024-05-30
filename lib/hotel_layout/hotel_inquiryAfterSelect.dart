import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/hotel_api.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HotelInquiryAfterList extends StatefulWidget {
  const HotelInquiryAfterList({super.key});

  @override
  State<HotelInquiryAfterList> createState() => _HotelInquiryAfterListState();
}

class _HotelInquiryAfterListState extends State<HotelInquiryAfterList> {
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
    hotelID = userData.hotelID;
    selectInquiry();
  }

  Future<void> selectInquiry() async {
    setState(() {
      isLoading = true;
    });

    try {
      var res = await http.post(Uri.parse(HotelApi.inquiryAfterSelect), body: {
        'hotel_id': hotelID,
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
                                    '여행사명',
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
                                        user['agency_name'],
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
                                          selectInquiry();
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Message(
                                                message:
                                                    user['inquiry_content'],
                                                title: user['inquiry_title'],
                                                borderID: user['border_id'],
                                                inquiryAnswer:
                                                    user['inquiry_answer'],
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

class Message extends StatefulWidget {
  final String message;
  final String title;
  final String borderID;
  final String inquiryAnswer;
  const Message({
    super.key,
    required this.message,
    required this.title,
    required this.borderID,
    required this.inquiryAnswer,
  });

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  late TextEditingController messageController;
  late TextEditingController titleController;
  late TextEditingController answerController;
  bool isAnswerEditable = false;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController(text: widget.message);
    titleController = TextEditingController(text: widget.title);
    answerController = TextEditingController(text: widget.inquiryAnswer);
  }

  Future<void> inquiryDelete() async {
    try {
      var res = await http.post(Uri.parse(HotelApi.inquiryDelete), body: {
        'border_id': widget.borderID,
      });

      if (res.statusCode == 200) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Handle exception
    }
  }

  Future<void> answerUpdate() async {
    try {
      var res = await http.post(Uri.parse(HotelApi.answerUpdate), body: {
        'inquiry_answer': answerController.text,
        'border_id': widget.borderID,
      });

      if (res.statusCode == 200) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Handle exception
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    readOnly: !isAnswerEditable,
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
              if (isAnswerEditable)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      answerUpdate();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: const BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      "답변수정 전송",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isAnswerEditable = !isAnswerEditable;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: const BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    isAnswerEditable ? "수정 취소" : "답변수정",
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    inquiryDelete();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      backgroundColor: Colors.white),
                  child: const Text(
                    "답변삭제",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ),
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
