import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/admin_api.dart';
import 'package:flutter_application_hotel/admin_layout/admin_index.dart';
import 'package:flutter_application_hotel/hotel_layout/hotel_confirm.dart';
import 'package:flutter_application_hotel/login/hotel_signup.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  String id = "";
  String pw = "";

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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

  adminLogin() async {
    try {
      var res = await http.post(Uri.parse(AdminApi.login), body: {
        'admin_id': emailController.text.trim(),
        'admin_pw': passwordController.text.trim(),
      });

      if (res.statusCode == 200) {
        var resLogin = jsonDecode(res.body);

        if (resLogin['success'] == true) {
          setState(() {
            emailController.clear();
            passwordController.clear();
          });

          complete();
        } else {
          neverSatisfied();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  complete() {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const admin_index()));
  }

  Future<void> neverSatisfied() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그인에 실패하였습니다.'),
          content: const SingleChildScrollView(),
          actions: [
            TextButton(
              child: const Text('확인'),
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
          leadingWidth: 120,
          title: const Text(
            '로그인',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black54,
              ),
              label: const Text(
                '뒤로가기',
                style: TextStyle(color: Colors.black54),
              ),
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.grey.withOpacity(0.04);
                  }
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.grey.withOpacity(0.12);
                  }
                  return Colors.black;
                }),
              ),
            ),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        body: Center(
          child: Form(
              key: formKey,
              child: Container(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('관리자 로그인'),
                      ],
                    ),
                    const SizedBox(
                        width: 100,
                        child: Divider(color: Colors.black, thickness: 2.0)),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                        width: 350,
                        child: TextFormField(
                          onChanged: (value) => id = value,
                          keyboardType: TextInputType.emailAddress,
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
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.perm_identity),
                              hintText: '이메일을 입력하세요.'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) => pw = value,
                        // validator: (value) => validatePassword(value!),
                        controller: passwordController,
                        onFieldSubmitted: (_) async {
                          adminLogin();
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: '비밀번호를 입력하세요.'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const confirm_hotel()));
                            },
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Row(
                                children: [
                                  Text(
                                    '회원가입',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                              ' | ',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HotelSignUp()));
                            },
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Row(
                                children: [
                                  Text(
                                    '아이디 찾기',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                              ' | ',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HotelSignUp()));
                            },
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Row(
                                children: [
                                  Text(
                                    '비밀번호 찾기',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          adminLogin();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '로그인',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ));
  }
}
