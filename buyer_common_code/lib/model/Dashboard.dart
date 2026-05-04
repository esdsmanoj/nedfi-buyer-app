class Dashboards {
  Dashboards({
    required this.success,
    required this.error,
    required this.status,
    required this.data,
    required this.message,
  });
  late final int success;
  late final int error;
  late final int status;
  late final List<DashboardData> data;
  late final String message;

  Dashboards.fromJson(Map<String, dynamic> json){
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = List.from(json['data']).map((e)=>DashboardData.fromJson(e)).toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['error'] = error;
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class DashboardData {
  DashboardData({
    required this.totalFarmer,
    required this.totalBooking,
    required this.upcomingBooking,
    required this.pastBooking,
    required this.bookingCancelled,
    required this.bookingMissed,
  });
  late final String totalFarmer;
  late final String totalBooking;
  late final String upcomingBooking;
  late final String pastBooking;
  late final String bookingCancelled;
  late final String bookingMissed;

  DashboardData.fromJson(Map<String, dynamic> json){
    totalFarmer = json['total_farmer'].toString();
    totalBooking = json['total_booking'].toString();
    upcomingBooking = json['upcoming_booking'].toString();
    pastBooking = json['past_booking'].toString();
    bookingCancelled = json['booking_cancelled'].toString();
    bookingMissed = json['booking_missed'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['total_farmer'] = totalFarmer;
    _data['total_booking'] = totalBooking;
    _data['upcoming_booking'] = upcomingBooking;
    _data['past_booking'] = pastBooking;
    _data['booking_cancelled'] = bookingCancelled;
    _data['booking_missed'] = bookingMissed;
    return _data;
  }
}