import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/hotel_api.dart';
import 'package:http/http.dart' as http;

class hotel_pwConfirm extends StatefulWidget {
  final String email;
  const hotel_pwConfirm({required this.email, super.key});

  @override
  State<hotel_pwConfirm> createState() => _hotel_pwConfirmState();
}

class _hotel_pwConfirmState extends State<hotel_pwConfirm> {
  var emailController = TextEditingController();
  var pwController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = widget.email;
  }

  userPwUpdate() async {
    try {
      var resPw = await http.post(Uri.parse(HotelApi.userPwUpdate), body: {
        'user_email': emailController.text.trim(),
        'user_pw': pwController.text.trim(),
      });

      if (resPw.statusCode == 200) {
        var resPwUpdate = jsonDecode(resPw.body);
        if (resPwUpdate['success'] == true &&
            emailController.text == widget.email &&
            pwController.text.isNotEmpty) {
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
    return ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('비밀번호 변경 성공')));
  }

  pwFaild() {
    return ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('비밀번호 변경 실패')));
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text('이메일'),
                      ),
                      TextFormField(
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text('비밀번호'),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "비밀번호를 입력하세요.";
                          }
                          return null;
                        },
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
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
            userPwUpdate();
            Navigator.popUntil(context, (route) => route.isFirst);
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
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: const Text(
            '취소',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
