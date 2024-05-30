import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_hotel/api/hotel_api.dart';

class HotelSignUp extends StatefulWidget {
  const HotelSignUp({super.key});

  @override
  State<HotelSignUp> createState() => _SignState();
}

class _SignState extends State<HotelSignUp> {
  final formKey = GlobalKey<FormState>();

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
  var hotelidController = TextEditingController();

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

  saveInfo() async {
    try {
      var res = await http.post(
        Uri.parse(HotelApi.signup),
        body: {
          "user_email": emailController.text.trim(),
          "user_pw": passwordController.text.trim(),
          "user_tel": telController.text.trim(),
          "user_name": userNameController.text.trim(),
          "hotel_id": hotelidController.text.trim(),
        },
      );
      if (res.statusCode == 200) {
        var resSignup = jsonDecode(res.body);
        signUpComplete();

        if (resSignup['success'] == true) {
          setState(() {
            userNameController.clear();
            emailController.clear();
            passwordController.clear();
            telController.clear();
          });
        }
      } else {
        signUpFailed();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  signUpComplete() {
    Navigator.popUntil(context, (route) => route.isFirst);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('가입 성공')));
  }

  signUpFailed() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('가입 실패')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
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
      ),
      body: Center(
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
                  SizedBox(
                    width: 370.0,
                    child: TextFormField(
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 40,
                      decoration: const InputDecoration(
                          counterText: '',
                          prefixIcon: Icon(Icons.email),
                          hintText: 'email@example.com'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "이메일을 입력하세요.";
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return "올바른 이메일 주소를 입력하세요.";
                        }
                        return null;
                      },
                      controller: emailController,
                    ),
                  ),
                  SizedBox(
                    width: 370.0,
                    child: TextFormField(
                      obscureText: !_passwordVisible,
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.visiblePassword,
                      maxLength: 40,
                      decoration: InputDecoration(
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
                        hintText: '비밀번호',
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                      controller: passwordController,
                      validator: (value) => validatePassword(value!),
                    ),
                  ),
                  SizedBox(
                    width: 370.0,
                    child: TextFormField(
                      obscureText: !_passwordVisible2,
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.visiblePassword,
                      maxLength: 40,
                      decoration: InputDecoration(
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
                          hintText: '비밀번호 확인'),
                      onChanged: (value) {
                        passwordConfirm = value;
                      },
                      validator: (value) =>
                          validatePasswordConfirm(password, passwordConfirm),
                    ),
                  ),
                  SizedBox(
                    width: 370.0,
                    child: TextFormField(
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.phone,
                      maxLength: 40,
                      decoration: const InputDecoration(
                          counterText: '',
                          prefixIcon: Icon(Icons.admin_panel_settings),
                          hintText: '호텔 ID'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return '호텔 ID를 입력하세요.';
                        }
                        return null;
                      },
                      controller: hotelidController,
                    ),
                  ),
                  SizedBox(
                    width: 370.0,
                    child: TextFormField(
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.phone,
                      maxLength: 40,
                      decoration: const InputDecoration(
                          counterText: '',
                          prefixIcon: Icon(Icons.phone),
                          hintText: '전화번호'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return '전화번호를 입력하세요. ("-" 제외)';
                        }
                        return null;
                      },
                      controller: telController,
                    ),
                  ),
                  SizedBox(
                    width: 370.0,
                    child: TextFormField(
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.name,
                      maxLength: 40,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "이름을 입력하세요.";
                        } else if (!RegExp('[ㄱ-ㅎ|가-힣|·|：]').hasMatch(value)) {
                          return "한글을 입력하세요.";
                        }
                        return null;
                      },
                      controller: userNameController,
                      decoration: const InputDecoration(
                          counterText: '',
                          prefixIcon: Icon(Icons.person),
                          hintText: '이름'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      width: 370.0,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
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
    );
  }
}
