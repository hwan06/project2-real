import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:http/http.dart' as http;

class travelSignUp extends StatefulWidget {
  const travelSignUp({super.key});

  @override
  State<travelSignUp> createState() => _SignState();
}

class _SignState extends State<travelSignUp> {
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
  var travelidController = TextEditingController();

  void printData() {
    print(userNameController);
  }

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
        Uri.parse(TravelApi.signup),
        body: {
          "travel_email": emailController.text.trim(),
          "travel_pw": passwordController.text.trim(),
          "agency_id": travelidController.text.trim().toString(),
          "travel_tel": telController.text.trim(),
          "travel_name": userNameController.text.trim(),
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
            travelidController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        title: const Text(
          '여행사 회원 가입',
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
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.grey.withOpacity(0.04);
                }
                if (states.contains(MaterialState.pressed)) {
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
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (value) => validatePassword(value!),
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
                      controller: passwordController,
                    ),
                  ),
                  SizedBox(
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
                    ),
                  ),
                  SizedBox(
                    width: 370.0,
                    child: TextFormField(
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.number,
                      maxLength: 40,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "여행사ID를 입력하세요.";
                        }
                        return null;
                      },
                      controller: travelidController,
                      decoration: const InputDecoration(
                          counterText: '',
                          prefixIcon: Icon(Icons.admin_panel_settings),
                          hintText: '여행사 ID'),
                    ),
                  ),
                  SizedBox(
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
                          counterText: '',
                          prefixIcon: Icon(Icons.phone),
                          hintText: '전화번호'),
                    ),
                  ),
                  SizedBox(
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
