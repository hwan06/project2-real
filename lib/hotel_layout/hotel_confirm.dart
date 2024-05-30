import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/login/hotel_signup.dart';

class confirm_hotel extends StatefulWidget {
  const confirm_hotel({super.key});

  @override
  State<confirm_hotel> createState() => _confirm_pageState();
}

class _confirm_pageState extends State<confirm_hotel> {
  bool _isServiceTermsAgreed = false;
  bool _isPrivacyPolicyAgreed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('약관 동의')),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            "서비스 이용 약관 동의",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Checkbox(
                            value: _isServiceTermsAgreed,
                            onChanged: (bool? value) {
                              setState(() {
                                _isServiceTermsAgreed = value!;
                              });
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "개인정보 처리방침 동의",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Checkbox(
                            value: _isPrivacyPolicyAgreed,
                            onChanged: (bool? value) {
                              setState(() {
                                _isPrivacyPolicyAgreed = value!;
                              });
                            }),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                          onPressed:
                              _isPrivacyPolicyAgreed && _isServiceTermsAgreed
                                  ? () {
                                      {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HotelSignUp()));
                                      }
                                    }
                                  : null,
                          child: const Text('다음으로')),
                    )
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
