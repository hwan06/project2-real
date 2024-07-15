import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  List<Map<String, dynamic>> resv = [];
  late String email;
  late String name;
  late String tel;
  late String travelId;
  late String hotelID;
  late String massege;
  late String agency_name;
  late String hotel_name;

  void setLoginTravelData(Map<String, dynamic> data) {
    email = data['travelData']['travel_email'];
    name = data['travelData']['travel_name'];
    tel = data['travelData']['travel_tel'];
    travelId = data['travelData']['agency_id'];
    agency_name = data['travelData']['agency_name'];
    notifyListeners(); // 데이터 변경을 알립니다.
  }

  void setLoginHotelData(Map<String, dynamic> data) {
    email = data['hotelData']['user_email'];
    name = data['hotelData']['user_name'];
    tel = data['hotelData']['user_tel'];
    hotelID = data['hotelData']['hotel_id'];
    hotel_name = data['hotelData']['hotel_name'];
    notifyListeners(); // 데이터 변경을 알립니다.
  }
}
