import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/hotel_api.dart';
import 'package:http/http.dart' as http;

class hotel_MyPage extends StatefulWidget {
  final String name;
  final String email;
  final String tel;
  final String pw;
  const hotel_MyPage(
      {required this.email,
      required this.name,
      required this.tel,
      required this.pw,
      super.key});

  @override
  State<hotel_MyPage> createState() => _hotel_MyPageState();
}

class _hotel_MyPageState extends State<hotel_MyPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var nameController = TextEditingController(); // 정보변경전/후 나타내는 값
  var name2Controller = TextEditingController(); // 정보변경 입력값
  var emailController = TextEditingController();
  var telController = TextEditingController(); // 정보변경전/후 나타내는 값
  var tel2Controller = TextEditingController(); // 정보변경 입력값
  var pwController = TextEditingController();
  var pw2Controller = TextEditingController(); // 정보변경 후 저장할

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = widget.email;
    nameController.text = widget.name;
    telController.text = widget.tel;
    name2Controller.text = nameController.text.trim();
    tel2Controller.text = telController.text.trim();
    pwController.text = pw2Controller.text.trim();
  }

  userUpdate() async {
    try {
      var res = await http.post(Uri.parse(HotelApi.userUpdate), body: {
        'user_email': emailController.text.trim(),
        'user_name': name2Controller.text.trim(),
        'user_tel': tel2Controller.text.trim(),
        'user_pw': pwController.text.trim()
      });

      if (res.statusCode == 200) {
        var resUpdate = jsonDecode(res.body);
        if (resUpdate['success'] == true && pwController.text == widget.pw) {
          complete();
        } else if (pwController.text != widget.pw) {
          failed();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  complete() {
    setState(() {
      pwController.clear();
      nameController.text = name2Controller.text.trim();
      telController.text = tel2Controller.text.trim();
    });
  }

  failed() {
    setState(() {
      pwController.clear();
      name2Controller.text = nameController.text.trim();
      tel2Controller.text = telController.text.trim();
    });
  }

  userPwUpdate() async {
    try {
      var resPw = await http.post(Uri.parse(HotelApi.userPwUpdate), body: {
        'user_email': emailController.text.trim(),
        'user_pw': pw2Controller.text.trim(),
      });

      if (resPw.statusCode == 200) {
        var resPwUpdate = jsonDecode(resPw.body);
        if (resPwUpdate['success'] == true &&
            emailController.text == widget.email &&
            pw2Controller.text.isNotEmpty) {
          pwComplete();
        } else {
          pwFaild();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  pwComplete() {
    setState(() {
      pwController.text = pw2Controller.text.trim();
      pw2Controller.clear();
    });
    return ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('비밀번호 변경 성공')));
  }

  pwFaild() {
    return ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('비밀번호 변경 실패')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: Center(
        child: Column(
          children: [
            const Text(
              '나의 정보',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Table(
                border: TableBorder.all(),
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: [
                  TableRow(
                    children: [
                      Container(
                        color: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
                        child: const Text('이메일', textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
                        child: Text(emailController.text,
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                  TableRow(children: [
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: const Text('이름', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: Text(nameController.text,
                          textAlign: TextAlign.center),
                    ),
                  ]),
                  TableRow(children: [
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: const Text('전화번호', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child:
                          Text(telController.text, textAlign: TextAlign.center),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 130.0),
                              child: AlertDialog(
                                title: const Text(
                                  '내 정보 변경',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Form(
                                      key: _formkey,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 4.0),
                                                  child: Text('이메일'),
                                                ),
                                                TextFormField(
                                                  readOnly: true,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  controller: emailController,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 6.0),
                                                  child: Text('이름'),
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.name,
                                                  controller: name2Controller,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 6.0),
                                                  child: Text('전화번호'),
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  controller: tel2Controller,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 6.0),
                                                  child: Text('현재 비밀번호'),
                                                ),
                                                TextFormField(
                                                  obscureText: true,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  controller: pwController,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (pwController.text == (widget.pw)) {
                                          Navigator.pop(context);
                                          userUpdate();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text('정보변경 성공')));
                                        } else {
                                          userUpdate();
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text('정보변경 실패')));
                                        }
                                      });
                                    },
                                    child: const Text('정보변경'),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('취소')),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: const Text(
                    '정보 변경',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 130.0),
                              child: AlertDialog(
                                title: const Text(
                                  '비밀번호 변경',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Form(
                                      key: _formkey,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 4.0),
                                                  child: Text('이메일'),
                                                ),
                                                TextFormField(
                                                  readOnly: true,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  controller: emailController,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 4.0),
                                                  child: Text('비밀번호'),
                                                ),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "비밀번호를 입력하세요.";
                                                    }
                                                    return null;
                                                  },
                                                  obscureText: true,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  controller: pw2Controller,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      userPwUpdate();
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      '비밀번호 변경',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      '취소',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      '비밀번호 변경',
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
