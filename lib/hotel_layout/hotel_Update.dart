import 'package:flutter/material.dart';
import 'package:flutter_application_hotel/api/hotel_api.dart';
import 'package:flutter_application_hotel/travel_layout/TravelInfo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_hotel/api/travel_api.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdatePage extends StatefulWidget {
  final String name;
  final String phone;
  final dynamic startDate;
  final dynamic endDate;
  final String roomcount;
  final String guest;
  final String night;
  final String price;
  final String reservationID;
  const UpdatePage({
    super.key,
    required this.reservationID,
    required this.name,
    required this.phone,
    required this.startDate,
    required this.endDate,
    required this.roomcount,
    required this.guest,
    required this.night,
    required this.price,
  });

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  DateTime? _startDate;
  DateTime? _endDate;
  var _nightCount = 0;
  List<dynamic> data = [];
  var reservation_id = "";
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController roomCountController;
  late TextEditingController guestController;
  late TextEditingController nightController;
  late TextEditingController priceController;
  late String username;
  late String userTel;
  late String travelID;

  @override
  void initState() {
    super.initState();

    _startDate = widget.startDate;
    _endDate = widget.endDate;
    roomCountController = TextEditingController(text: widget.roomcount);
    guestController = TextEditingController(text: widget.guest);
    nightController = TextEditingController(text: widget.night);
    priceController = TextEditingController(text: widget.price);
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
    _nightCount = _endDate!.difference(_startDate!).inDays;
    final userData = Provider.of<UserData>(context, listen: false);
    username = userData.name.toString();
    userTel = userData.tel.toString();

    roomCountController.addListener(_updatePrice);
    nightController.addListener(_updatePrice);
  }

  @override
  void dispose() {
    roomCountController.dispose();
    nightController.dispose();
    super.dispose();
  }

  Future<void> selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: _startDate ?? DateTime.now(),
        end: _endDate ?? DateTime.now().add(const Duration(days: 1)),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _nightCount = picked.end.difference(picked.start).inDays;
        nightController.text = _nightCount.toString();
        _updatePrice();
      });
    }
  }

  void _updatePrice() {
    int roomCount = int.tryParse(roomCountController.text) ?? 0;
    int nightCount = int.tryParse(nightController.text) ?? 0;
    int basePrice = (int.parse(widget.price) /
            int.parse(widget.night) /
            int.parse(widget.roomcount))
        .toInt();

    int totalPrice = basePrice * roomCount * nightCount;
    setState(() {
      priceController.text = totalPrice.toString();
    });
  }

  Future<void> _Confirm(String id) async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '수정하시겠습니까?',
            style: TextStyle(
                fontFamily: 'Pretendard', fontWeight: FontWeight.w700),
          ),
          content: const SingleChildScrollView(),
          actions: [
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(
                    fontFamily: 'Pretendard', fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                update(id);
              },
            ),
            TextButton(
              child: const Text(
                '취소',
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> update(String id) async {
    try {
      var response = await http.post(Uri.parse(HotelApi.resvInfoUpdate), body: {
        'inquirer_name': nameController.text.trim().toString(),
        'inquirer_tel': phoneController.text.trim().toString(),
        'check_in_date': _startDate.toString().replaceAll(",", "").trim(),
        'check_out_date': _endDate.toString().replaceAll(",", "").trim(),
        'night_count': nightController.text.trim(),
        'guest_count': guestController.text.trim().toString(),
        'room_count': roomCountController.text.trim().toString(),
        'hotel_price': priceController.text.trim().toString(),
        'reservation_id': id.toString(),
      });

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
      print('안바뀜');
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = _startDate ?? widget.startDate;
    DateTime endDate = _endDate ?? widget.endDate;
    String price = widget.price;
    reservation_id = widget.reservationID;

    return Scaffold(
      appBar: AppBar(
        title: const Text('수정하기'),
        elevation: 1.0,
        shadowColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "예약자명",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  readOnly: true,
                  controller: nameController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "전화번호",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  readOnly: true,
                  controller: phoneController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "객실수",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  controller: roomCountController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "날짜 선택",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: selectDateRange,
                  child: AbsorbPointer(
                    child: SizedBox(
                      width: 270,
                      child: TextFormField(
                        controller: TextEditingController(
                          text: _endDate != null
                              ? '${DateFormat('yyyy-MM-dd').format(startDate)} ~ ${DateFormat('yyyy-MM-dd').format(endDate)}'
                              : '',
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: '날짜 선택',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "인원수",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  controller: guestController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "박 수",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  readOnly: true,
                  controller: nightController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "총가격",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  readOnly: true,
                  controller: priceController,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: () {
                      _Confirm(reservation_id);
                      print(price);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.amber,
                      ),
                    ),
                    child: const Text(
                      '수정하기',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          color: Colors.amber),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
