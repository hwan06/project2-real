import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:http/http.dart' as http;

class travel_MyPage extends StatefulWidget {
  final String name;
  final String email;
  final String tel;
  final String pw;
  const travel_MyPage(
      {required this.email,
      required this.name,
      required this.tel,
      required this.pw,
      super.key});

  @override
  State<travel_MyPage> createState() => _travel_MyPageState();
}

class _travel_MyPageState extends State<travel_MyPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var nameController = TextEditingController(); // 정보변경전/후 나타내는 값
  var name2Controller = TextEditingController(); // 정보변경 입력값
  var emailController = TextEditingController();
  var telController = TextEditingController(); // 정보변경전/후 나타내는 값
  var tel2Controller = TextEditingController(); // 정보변경 입력값
  var pwController = TextEditingController();
  var newEmailController = TextEditingController(); // 새로받아오는 이메일

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = widget.email;
    nameController.text = widget.name;
    telController.text = widget.tel;
    name2Controller.text = nameController.text.trim();
    tel2Controller.text = telController.text.trim();
  }

  userUpdate() async {
    try {
      var res = await http.post(Uri.parse(TravelApi.userUpdate), body: {
        'travel_email': emailController.text.trim(),
        'travel_name': name2Controller.text.trim(),
        'travel_tel': tel2Controller.text.trim(),
        'travel_pw': pwController.text.trim()
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
                                                keyboardType:
                                                    TextInputType.emailAddress,
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
                                                keyboardType:
                                                    TextInputType.emailAddress,
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
                ))
          ],
        ),
      ),
    );
  }
}
