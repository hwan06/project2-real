import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:flutter_application_hotel/index/index.dart';
import 'package:flutter_application_hotel/travel_layout/travel_PwConfirm.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_hotel/api/hotel_api.dart';

class travel_pw_search extends StatefulWidget {
  const travel_pw_search({super.key});

  @override
  State<travel_pw_search> createState() => _travel_pw_searchState();
}

class _travel_pw_searchState extends State<travel_pw_search> {
  String id = "";
  String pw = "";
  var emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var email;

  emailAuth() async {
    try {
      var res = await http.post(Uri.parse(TravelApi.emailVal), body: {
        'travel_email': emailController.text.trim(),
      });

      if (res.statusCode == 200) {
        var resAuth = jsonDecode(res.body);
        if (resAuth['success'] == true && emailController.text.isNotEmpty) {
          setState(() {
            email = emailController.text.trim();
          });
          Authcomplete();
        } else {
          AuthFaild();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Authcomplete() {
    setState(() {
      emailController.clear();
      Satisfied();
    });
    return ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('이메일 인증 성공')));
  }

  AuthFaild() {
    setState(() {
      emailController.clear();
      neverSatisfied();
    });
    return ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('이메일 인증 실패')));
  }

  Future<void> neverSatisfied() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이메일 인증에 실패하였습니다.'),
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

  Future<void> Satisfied() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이메일 인증에 성공하였습니다.'),
          content: const SingleChildScrollView(),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => travel_pwConfirm(
                              email: email,
                            )));
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
            '비밀번호 찾기',
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
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('비밀번호 찾기'),
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
                      height: 30,
                    ),
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          emailAuth();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '이메일 인증',
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
