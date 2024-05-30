import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Message extends StatefulWidget {
  final String message;
  final String title;
  final String borderID;
  const Message({
    super.key,
    required this.message,
    required this.title,
    required this.borderID,
  });

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  late TextEditingController messageController;
  late TextEditingController titleController;
  late TextEditingController titleEditController;
  late TextEditingController contentController;
  bool isEditing = false;
  var travelID = "";
  var message = "";
  var hotelID = "";
  List<Map<String, dynamic>> _inquiryData = [];
  bool isLoading = false;
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController(text: widget.message);
    titleController = TextEditingController(text: widget.title);
    titleEditController = TextEditingController();
    contentController = TextEditingController();
    selectInquiry();
  }

  Future<void> sendUpdate() async {
    try {
      var res = await http.post(Uri.parse(TravelApi.inquiryUpdate), body: {
        'inquiry_title': titleEditController.text.trim(),
        'inquiry_content': contentController.text.trim(),
        'border_id': widget.borderID.toString().trim(),
      });

      if (res.statusCode == 200) {
        print('내용 변경 완료');
        Navigator.pop(context, true);
      }
    } catch (e) {}
  }

  Future<void> inquiryDelete() async {
    try {
      var res = await http.post(Uri.parse(TravelApi.inquiryDelete), body: {
        'border_id': widget.borderID.toString().trim(),
      });

      if (res.statusCode == 200) {
        print(200);
      }
    } catch (e) {}
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

  Future deleteConfirm() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('문의를 삭제하시겠습니까?'),
          content: const SingleChildScrollView(),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.pop(context, true);
                inquiryDelete();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('메세지'),
        elevation: 1.0,
        shadowColor: Colors.black,
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          height: 750,
          child: Column(
            children: [
              buildTextSection("문의 제목", titleController, readOnly: true, 1),
              const SizedBox(height: 10),
              buildTextSection("문의 내용", messageController, readOnly: true, 5),
              if (isEditing) const SizedBox(height: 20),
              if (isEditing)
                buildEditableTextSection("제목 수정", titleEditController, 1),
              const SizedBox(height: 10),
              if (isEditing)
                buildEditableTextSection("내용 수정", contentController, 5),
              const SizedBox(height: 20),
              if (isEditing)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: sendUpdate,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      "변경내용 전송",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: Colors.blue,
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
                      isEditing = !isEditing;
                    });
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
                  child: Text(
                    isEditing ? "수정 취소" : "수정하기",
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await deleteConfirm();

                    if (result == true) {
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    "문의삭제",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    "뒤로가기",
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.green,
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

  Widget buildTextSection(
      String title, TextEditingController controller, int maxLine,
      {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextField(
          maxLines: maxLine,
          readOnly: readOnly,
          controller: controller,
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
    );
  }

  Widget buildEditableTextSection(
      String title, TextEditingController controller, int maxLine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextField(
          maxLines: maxLine,
          controller: controller,
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
    );
  }
}
