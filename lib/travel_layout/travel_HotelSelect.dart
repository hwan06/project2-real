import 'package:flutter/material.dart';
import '../../travel_layout/travel_HotelReservation.dart';

class HotelSelect extends StatefulWidget {
  final Map<String, dynamic> hotelList; // 호텔 이름을 저장할 변수

  const HotelSelect({
    super.key,
    required this.hotelList,
  });
  @override
  _HotelSignUpState createState() => _HotelSignUpState();
}

class _HotelSignUpState extends State<HotelSelect> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> hotelInfo = [
      {
        'hotel_name': widget.hotelList['hotel_name'],
        'hotel_id': widget.hotelList['hotel_id'],
        'hotel_address': widget.hotelList['hotel_address'],
        'hotel_rating': widget.hotelList['hotel_rating'].toString(),
        'hotel_price': widget.hotelList['hotel_price'].toString(),
      }
    ];
    String hotelName = widget.hotelList['hotel_name'];
    String hotelAddress = widget.hotelList['hotel_address'];
    String hotelRating = widget.hotelList['hotel_rating'].toString();
    String hotelPrice = widget.hotelList['hotel_price'].toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(hotelName,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: Container(
            color: const Color.fromRGBO(247, 242, 250, 1),
            width: 750,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: 250,
                  child: const Text('사진',
                      style: TextStyle(color: Colors.white, fontSize: 50),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: 50),
                Container(
                  color: Colors.white,
                  width: 500,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('평점: ',
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24)),
                          Text(hotelRating,
                              style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24)),
                          const Icon(Icons.star, color: Colors.yellowAccent)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('위치: ',
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400)),
                          Text(hotelAddress,
                              style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('가격: ',
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400)),
                          Text(hotelPrice,
                              style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Reservation(
                                    hotelList: hotelInfo,
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Text('예약하기',
                        style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
