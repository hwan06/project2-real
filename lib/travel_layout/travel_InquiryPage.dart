import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class InquiryInput extends StatefulWidget {
  final Map<String, dynamic> userData;
  const InquiryInput({super.key, required this.userData});

  @override
  State<InquiryInput> createState() => _InquiryInputState();
}

class _InquiryInputState extends State<InquiryInput> {
  final List<String> items = [
    '예약내용을 변경하고싶습니다.',
    '환불관련',
    '예약을 취소하고싶습니다.',
  ];

  String? selectedValue;
  var titleController = TextEditingController();
  var inquiryController = TextEditingController();
  var travelID = "";
  var hotelID = "";
  var inquiryerName = "";
  var travelTel = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userData = Provider.of<UserData>(context, listen: false);

    // UserData에서 사용자 정보 가져오기
    travelID = userData.travelId.toString();
    travelTel = userData.tel.toString();
    inquiryerName = userData.name.toString();
  }

  fetchUserDataFromApi() async {
    try {
      var response = await http.post(Uri.parse(TravelApi.inquiryInput), body: {
        'agency_id': travelID.toString(),
        'hotel_id': widget.userData['hotel_id'].toString(),
        'inquiry_type': selectedValue.toString(),
        'inquiry_content': inquiryController.text.trim(),
        'inquirer_name': inquiryerName.toString(),
        'inquiry_title': titleController.text.trim(),
        'inquirer_tel': travelTel.toString(),
      });

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res['success'] == true) {
          print('문의 성공');
          Navigator.pop(context);
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("문의하기"),
        elevation: 1.0,
        shadowColor: Colors.black,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
            ),
            const Text(
              "1. 문의 유형 선택하기",
              textAlign: TextAlign.left,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        '문의유형',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                items: items
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  width: 400,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    color: Colors.white,
                  ),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down_sharp,
                  ),
                  iconSize: 20,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                  ),
                  offset: const Offset(0, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: WidgetStateProperty.all<double>(6),
                    thumbVisibility: WidgetStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text("2. 제목"),
            SizedBox(
              width: 400,
              child: TextFormField(
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
            ),
            const SizedBox(
              height: 15,
            ),
            const Text("3. 설명"),
            SizedBox(
              width: 400,
              height: 200,
              child: TextFormField(
                controller: inquiryController,
                maxLength: 255,
                maxLines: 12,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 400,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  fetchUserDataFromApi();
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                child: const Text(
                  "문의하기",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
