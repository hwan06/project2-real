import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  late String email;
  late String name;
  late String tel;
  late String travelId;
  late String hotelID;
  late String massege;

  void setLoginTravelData(Map<String, dynamic> data) {
    email = data['travelData']['travel_email'];
    name = data['travelData']['travel_name'];
    tel = data['travelData']['travel_tel'];
    travelId = data['travelData']['agency_id'];
    notifyListeners(); // 데이터 변경을 알립니다.
  }

  void setLoginHotelData(Map<String, dynamic> data) {
    email = data['hotelData']['user_email'];
    name = data['hotelData']['user_name'];
    tel = data['hotelData']['user_tel'];
    hotelID = data['hotelData']['hotel_id'];
    notifyListeners(); // 데이터 변경을 알립니다.
  }
}
