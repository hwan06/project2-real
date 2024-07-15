import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/hotel_api.dart';
import 'package:flutter_application_hotel/api/image.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_hotel/login/travel_Login.dart';
import 'package:http/http.dart' as http;

class HotelSign extends StatefulWidget {
  const HotelSign({super.key});

  @override
  State<HotelSign> createState() => _SignState();
}

class _SignState extends State<HotelSign> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectHotelName();
  }

  final formKey = GlobalKey<FormState>();

  final List<String> hotelNames = [];

  String? selectedValue;
  String password = '';
  String passwordConfirm = '';

  bool _passwordVisible = false;
  bool _passwordVisible2 = false;
  late bool validationResult;
  bool isButtonActive = false;

  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var telController = TextEditingController();
  var passwordController = TextEditingController();

  String? validatePassword(String value) {
    String pattern =
        r'^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,15}$';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      return '비밀번호를 입력하세요';
    } else if (value.length < 8) {
      return '비밀번호는 8자리 이상이어야 합니다';
    } else if (!regExp.hasMatch(value)) {
      return '특수문자, 문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
    } else {
      return null; //null을 반환하면 정상
    }
  }

  String? validatePasswordConfirm(String password, String passwordConfirm) {
    if (passwordConfirm.isEmpty) {
      return '비밀번호 확인칸을 입력하세요';
    } else if (password != passwordConfirm) {
      return '입력한 비밀번호가 서로 다릅니다.';
    } else {
      return null; //null을 반환하면 정상
    }
  }

  selectHotelName() async {
    var res = await http.post(Uri.parse(HotelApi.hotelList));

    if (res.statusCode == 200) {
      var data = json.decode(res.body);

      if (data['success'] == true) {
        List<dynamic> hotelInfoData = data['hotel_info_data'];

        for (var hotel in hotelInfoData) {
          if (hotel['hotel_name'] != null && hotel['hotel_name'].isNotEmpty) {
            setState(() {
              hotelNames.add(hotel['hotel_name']);
            });
          }
        }

        print(hotelNames);
      }
    }
  }

  saveInfo() async {
    try {
      var res = await http.post(
        Uri.parse(HotelApi.signup),
        body: {
          "user_email": emailController.text.trim(),
          "user_pw": passwordController.text.trim(),
          "hotel_name": selectedValue.toString().trim(),
          "user_tel": telController.text.trim(),
          "user_name": userNameController.text.trim(),
        },
      );
      print(res.body);
      if (res.statusCode == 200) {
        var resSignup = jsonDecode(res.body);
        if (resSignup['success'] == true) {
          setState(() {
            userNameController.clear();
            emailController.clear();
            passwordController.clear();
            telController.clear();
            complete();
          });
        } else {
          print('실패');
          failed();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void complete() {
    Navigator.popUntil(context, (route) => route.isFirst);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('가입성공')));
  }

  void failed() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('가입실패')));
  }

  Widget gap() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget text(String text) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: text,
          style: const TextStyle(
              fontFamily: 'Pretendard', fontSize: 16, color: Colors.black),
        ),
        const TextSpan(
          text: "*",
          style: TextStyle(
              fontFamily: 'Pretendard', fontSize: 16, color: Colors.pink),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '호텔 회원 가입',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            width: 80,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              child: const Text(
                "로그인",
                style: TextStyle(fontFamily: "Pretendard", color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                width: 60.0,
                height: 30.0,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text("이메일"),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 370.0,
                          child: TextFormField(
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 40,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1)),
                              counterText: '',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "이메일을 입력하세요.";
                              } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return "올바른 이메일 주소를 입력하세요.";
                              }
                              return null;
                            },
                            controller: emailController,
                          ),
                        ),
                      ],
                    ),
                    gap(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text("비밀번호"),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 370.0,
                          child: TextFormField(
                            obscureText: !_passwordVisible,
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.visiblePassword,
                            maxLength: 40,
                            onChanged: (value) {
                              password = value;
                            },
                            validator: (value) => validatePassword(value!),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 1)),
                              counterText: '',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  icon: Icon(_passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                            ),
                            controller: passwordController,
                          ),
                        ),
                      ],
                    ),
                    gap(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text("비밀번호 확인"),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 370.0,
                          child: TextFormField(
                            obscureText: !_passwordVisible2,
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.visiblePassword,
                            maxLength: 40,
                            onChanged: (value) {
                              passwordConfirm = value;
                            },
                            validator: (value) =>
                                validatePasswordConfirm(password, value!),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(width: 1)),
                              counterText: '',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible2 = !_passwordVisible2;
                                    });
                                  },
                                  icon: Icon(_passwordVisible2
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    gap(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text("호텔"),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '호텔선택',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            items: hotelNames
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
                              width: 370,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(5),
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
                              width: 370,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              offset: const Offset(0, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: WidgetStateProperty.all<double>(6),
                                thumbVisibility:
                                    WidgetStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    gap(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text("전화번호"),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 370.0,
                          child: TextFormField(
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.phone,
                            maxLength: 40,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "전화번호를 입력하세요.";
                              }
                              return null;
                            },
                            controller: telController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1)),
                              counterText: '',
                              prefixIcon: Icon(Icons.phone),
                            ),
                          ),
                        ),
                      ],
                    ),
                    gap(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text("이름"),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: 370.0,
                            child: TextFormField(
                              cursorColor: Colors.blue,
                              keyboardType: TextInputType.name,
                              maxLength: 40,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return '이름을 입력하세요';
                                }
                                return null;
                              },
                              controller: userNameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1)),
                                counterText: '',
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    gap(),
                    Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                        width: 370.0,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            saveInfo();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '가입하기',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
