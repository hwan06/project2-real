import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/admin_api.dart';
import 'package:http/http.dart' as http;

class HotelUpdatePage extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String hotelName;
  const HotelUpdatePage({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.hotelName,
  });

  @override
  State<HotelUpdatePage> createState() => _HotelUpdatePageState();
}

class _HotelUpdatePageState extends State<HotelUpdatePage> {
  List<dynamic> data = [];
  late String userName;
  late String hotelTel;
  late String hotelEmail;
  late String hotelName;
  late String pw;
  String sep = "";
  var nameController = TextEditingController();
  var telController = TextEditingController();
  var emailController = TextEditingController();
  var agencyNameController = TextEditingController();
  var pwController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userName = widget.name;
    hotelEmail = widget.email;
    hotelTel = widget.phone;
    hotelName = widget.hotelName;

    nameController = TextEditingController(text: userName);
    emailController = TextEditingController(text: hotelEmail);
    telController = TextEditingController(text: hotelTel);
    agencyNameController = TextEditingController(text: hotelName);
    pwController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    telController.dispose();
    emailController.dispose();
    agencyNameController.dispose();
    pwController.dispose();
    super.dispose();
  }

  Future<void> _Confirm() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '수정하시겠습니까?',
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
                update();
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

  Future<void> update() async {
    print(emailController.text);
    print(pwController.text);
    print(nameController.text);
    print(telController.text);
    print(sep);
    try {
      var response =
          await http.post(Uri.parse(AdminApi.hotelInfoUpdate), body: {
        "user_email": emailController.text.trim(),
        "user_pw": pwController.text.trim(),
        "user_name": nameController.text.trim(),
        "user_tel": telController.text.trim(),
        "sep": sep.trim(),
      });

      if (response.statusCode == 200) {
        print(response.body);
        Navigator.pop(context, true);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수정하기'),
        elevation: 1.0,
        shadowColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 330,
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "호텔명",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  readOnly: true,
                  controller: agencyNameController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "이메일",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          sep = "1";
                        });
                        _Confirm();
                      },
                      child: const Text("변경"),
                    ),
                    isDense: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "비밀번호 재설정",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  controller: pwController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: TextButton(
                        onPressed: () {
                          setState(() {
                            sep = "2";
                          });
                          _Confirm();
                        },
                        child: const Text("변경")),
                    isDense: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "이름",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          sep = "3";
                        });
                        _Confirm();
                      },
                      child: const Text("변경"),
                    ),
                    isDense: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "전화번호",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  controller: telController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          sep = "4";
                        });
                        _Confirm();
                      },
                      child: const Text("변경"),
                    ),
                    isDense: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 330,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.amber,
                      ),
                    ),
                    child: const Text(
                      '뒤로가기',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          color: Colors.amber),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}