import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_hotel/api/travel_api.dart';

class CompleteListDetail extends StatefulWidget {
  final Map<String, dynamic> ReserverInfo;
  const CompleteListDetail({
    super.key,
    required this.ReserverInfo,
  });

  @override
  State<CompleteListDetail> createState() => _CompleteListDetailState();
}

List<dynamic> data = [];

class _CompleteListDetailState extends State<CompleteListDetail> {
  var reservation_id = "";

  @override
  Widget build(BuildContext context) {
    String reservationId = widget.ReserverInfo['reservation_id'].toString();
    String hotelID = widget.ReserverInfo['hotel_id'].toString();
    String travelID = widget.ReserverInfo['agency_id'].toString();
    String hotelname = widget.ReserverInfo['hotel_name'];
    String inquiryName = widget.ReserverInfo['inquirer_name'];
    String inquiryTel = widget.ReserverInfo['inquirer_tel'];
    String nightCount = widget.ReserverInfo['night_count'].toString();
    String guestCount = widget.ReserverInfo['guest_count'].toString();
    String roomCount = widget.ReserverInfo['room_count'].toString();
    String checkInDate = widget.ReserverInfo['check_in_date'];
    String checkOutDate = widget.ReserverInfo['check_out_date'];
    String totalPrice = widget.ReserverInfo['hotel_price'].toString();
    String resvStatus = widget.ReserverInfo['travel_reservation_status'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('상세정보'),
        elevation: 1.0,
        shadowColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 200,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '호텔 ID: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      hotelID,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '여행사 ID: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      travelID,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '호텔명: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      hotelname,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '예약자명: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      inquiryName,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '전화번호: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      inquiryTel,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '체크인: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      checkInDate,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '체크아웃: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      checkOutDate,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '인원수: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      guestCount,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '박 수: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      nightCount,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '객실수: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      roomCount,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '지불액: ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      totalPrice,
                      style: const TextStyle(
                          fontFamily: 'Pretendard', fontSize: 15),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                    child: const Text(
                      '뒤로가기',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
