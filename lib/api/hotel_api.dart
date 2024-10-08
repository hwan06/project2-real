class HotelApi {
  static const hostConnect = "http://192.168.123.4";
  static const hostConnectUser = "$hostConnect/user";

  static const signup = "$hostConnect/hotel/signup.jsp";
  static const login = "$hostConnect/hotel/login.jsp";
  static const userUpdate = "$hostConnect/hotel/hotel_update.jsp";
  static const userPwUpdate = "$hostConnect/hotel/password_change.jsp";
  static const resvUpdate = "$hostConnect/hotel/resv_cancel_update.jsp";
  static const resvSelect = "$hostConnect/hotel/resv_related_select.jsp";
  static const cancelSelect = "$hostConnect/hotel/resv_cancel_select.jsp";
  static const emailVal = "$hostConnect/hotel/validate_email.jsp";
  static const resvConfirm = "$hostConnect/hotel/resv_related_update.jsp";
  static const resvInfoUpdate = "$hostConnect/hotel/inquiry_info_update.jsp";
  static const inquiryBeforeSelect =
      "$hostConnect/hotel/room_inquiry_null_select.jsp";
  static const inquiryAfterSelect =
      "$hostConnect/hotel/room_inquiry_not_null_select.jsp";
  static const sendAnswer = "$hostConnect/hotel/room_inquiry_answer_insert.jsp";
  static const answerUpdate =
      "$hostConnect/hotel/room_inquiry_answer_update.jsp";
  static const inquiryDelete =
      "$hostConnect/hotel/room_inquiry_answer_delete.jsp";
  static const cancelGraph = "$hostConnect/hotel/statistics.jsp";
  static const cancelGraph2 = "$hostConnect/hotel/statistics_in.jsp";
  static const allGraph = "$hostConnect/hotel/all_statistics.jsp";
  static const hotelUpload = "$hostConnect/hotel/hotel_info_insert.jsp";
  static const hotelList = "$hostConnect/hotel/hotel_list.jsp";
  static const hotelStatisticDetail = "$hostConnect/hotel/resv_all.jsp";
  static const hotelImageUpload = "$hostConnect/hotel/hotel_br.jsp";
}
