import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/image.dart';
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class TravelSign extends StatefulWidget {
  const TravelSign({super.key});

  @override
  State<TravelSign> createState() => _SignState();
}

class _SignState extends State<TravelSign> {
  final formKey = GlobalKey<FormState>();

  String password = '';
  String passwordConfirm = '';

  bool isButtonActive = false;

  TextEditingController agencyNameController = TextEditingController();
  TextEditingController agencyAddressController = TextEditingController();
  TextEditingController agencyTelController = TextEditingController();
  TextEditingController agencyCEONameController = TextEditingController();

  File? _image;
  Image? image;
  String? _base64Image;

  Future<void> _pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
        _convertImageToBase64(_image!);
      });
    }
  }

  void _convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    setState(() {
      _base64Image = base64Encode(imageBytes);
    });
  }

  Future<void> imageUpload() async {
    if (_base64Image == null) return;

    var url = Uri.parse(ImageApi.travelImageUpload);
    var headers = {
      "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
    };

    var response = await http.post(url,
        headers: headers, body: {"agency_id": "6", "image": _base64Image});

    if (response.statusCode == 200) {
      print(response.body);
      print(response.statusCode);
      print('Image uploaded successfully');
    } else {
      print('Image upload failed with status: ${response.statusCode}');
      print('Response body: ${response.body}'); // 응답 내용 출력
    }
  }

  Future<void> fetchImage() async {
    var url = Uri.parse(
        ImageApi.travelImageSelect); // 예: http://example.com/api/image/6

    var headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };
    var body = {"agency_id": "6"};

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _base64Image = data['image'];
        image = Image.memory(base64Decode(_base64Image!));
      });
    } else {
      print('Failed to load image with status: ${response.statusCode}');
    }
  }

  String? validatePassword(String value) {
    String pattern =
        r'^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,15}$';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      return '비밀번호를 입력하세요';
    } else if (value.length < 8) {
      return '비밀번호는 8자리 이상이어야 합니다';
    } else if (!regExp.hasMatch(value)) {
      return '특수문자, 문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
    } else {
      return null; // null을 반환하면 정상
    }
  }

  String? validatePasswordConfirm(String password, String passwordConfirm) {
    if (passwordConfirm.isEmpty) {
      return '비밀번호 확인칸을 입력하세요';
    } else if (password != passwordConfirm) {
      return '입력한 비밀번호가 서로 다릅니다.';
    } else {
      return null; // null을 반환하면 정상
    }
  }

  Future<void> saveInfo() async {
    try {
      var res = await http.post(
        Uri.parse(TravelApi.travelUpload),
        body: {
          'agency_name': agencyNameController.text.trim(),
          'agency_tel': agencyTelController.text.trim(),
          'ceo_name': agencyCEONameController.text.trim(),
        },
      );
      print(res.body);
      if (res.statusCode == 200) {
        var resSignup = jsonDecode(res.body);
        if (resSignup['success'] == true) {
          await imageUpload(); // 이미지 업로드 메서드 호출
          setState(() {
            agencyNameController.clear();
            agencyAddressController.clear();
            agencyCEONameController.clear();
            agencyTelController.clear();
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
        title: const Text(
          '여행사 회원 가입',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                width: 60.0,
                height: 30.0,
              ),
              Form(
                key: formKey,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      image != null
                          ? image!
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: RichText(
                                      text: const TextSpan(children: [
                                        TextSpan(
                                          text: "여행사명",
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: "*",
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 16,
                                              color: Colors.pink),
                                        ),
                                      ]),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: SizedBox(
                                    width: 370.0,
                                    child: TextFormField(
                                      cursorColor: Colors.blue,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1),
                                        ),
                                        counterText: '',
                                        prefixIcon: Icon(CupertinoIcons
                                            .rectangle_on_rectangle_angled),
                                      ),
                                      controller: agencyNameController,
                                      validator: (_) {
                                        if (agencyNameController.text.isEmpty) {
                                          return "여행사명을 입력하세요.";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                    text: "전화번호",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "*",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 16,
                                        color: Colors.pink),
                                  ),
                                ]),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: 370.0,
                              child: TextFormField(
                                controller: agencyTelController,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.phone,
                                maxLength: 40,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                  ),
                                  counterText: '',
                                  prefixIcon: Icon(CupertinoIcons.phone_circle),
                                ),
                                validator: (_) {
                                  if (agencyTelController.text.isEmpty) {
                                    return "전화번호를 입력하세요";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                    text: "대표자명",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "*",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 16,
                                        color: Colors.pink),
                                  ),
                                ]),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: 370.0,
                              child: TextFormField(
                                controller: agencyCEONameController,
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.text,
                                maxLength: 40,
                                onChanged: (value) {
                                  passwordConfirm = value;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                  ),
                                  counterText: '',
                                  prefixIcon:
                                      Icon(CupertinoIcons.person_circle),
                                ),
                                validator: (_) {
                                  if (agencyCEONameController.text.isEmpty) {
                                    return "대표자명을 입력하세요.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: _pickImage,
                              child: const Text('이미지 업로드'),
                            ),
                            _image != null
                                ? Image.file(
                                    _image!,
                                    width: 100,
                                    height: 100,
                                  )
                                : const Text('이미지가 선택되지 않았습니다.'),
                          ],
                        ),
                      ),
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
                              if (_image == null) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        "이미지가 선택되지 않았습니다.",
                                        style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "닫기",
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 15,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                );
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
                              '신청하기',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
