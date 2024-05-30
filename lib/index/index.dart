import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/login/hotel_login.dart' as hotel;
import 'package:flutter_application_hotel/login/travel_login.dart' as travel;
import 'package:flutter_application_hotel/hotel_layout/hotel_confirm.dart';
import '../../travel_layout/travel_confirm.dart';
import 'package:flutter_application_hotel/login/admin_login.dart'
    as managementer;
import 'package:flutter_application_hotel/login/admin_signup.dart';

class bothLogin extends StatelessWidget {
  const bothLogin({super.key});

  @override
  Widget build(BuildContext context) {
    String confirm = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '로그인 또는 회원가입',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 145,
                  height: 130,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const hotel.Login()));
                        confirm = "hotel";
                        print(confirm);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hotel,
                            size: 50,
                            color: Colors.white,
                          ),
                          Text(
                            '호텔 로그인',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  width: 50,
                ),
                SizedBox(
                  width: 145,
                  height: 130,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const travel.Login()));
                        confirm = "travel";
                        print(confirm);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.airplane_ticket,
                            color: Colors.white,
                            size: 50,
                          ),
                          Text(
                            '여행사 로그인',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  width: 50,
                ),
                SizedBox(
                  width: 145,
                  height: 130,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const managementer.Login()));
                        confirm = "travel";
                        print(confirm);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.manage_accounts,
                            color: Colors.white,
                            size: 50,
                          ),
                          Text(
                            '관리자 로그인',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: SizedBox(
                width: 530,
                child: Divider(
                  thickness: 2.0,
                  color: Colors.black45,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 145,
                        height: 130,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const confirm_hotel()));
                              confirm = "hotel";
                              print(confirm);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.hotel,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                Text(
                                  '호텔 회원가입',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      SizedBox(
                        width: 145,
                        height: 130,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const confirm_travel()));
                              confirm = "travel";
                              print(confirm);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.airplane_ticket,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                Text(
                                  '여행사 회원가입',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      SizedBox(
                        width: 145,
                        height: 130,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const adminSignUp()));
                              confirm = "travel";
                              print(confirm);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.manage_accounts,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                Text(
                                  '관리자 회원가입',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
