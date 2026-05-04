

import 'package:nedfi_seller_common_code/components/help/string_handlers.dart';

class VideoCall {
  String? title;
  String? meeting_link;
  String? farmer_id;

  VideoCall({
    this.title,
    this.meeting_link,
    this.farmer_id,
  });

  VideoCall.fromMap(Map<String, dynamic> map) {
    title =
        map[VideoCallFieldNames.title] ?? StringHandlers.NotAvailable;
    meeting_link = map[VideoCallFieldNames.meeting_link] ?? "";
    farmer_id = map[VideoCallFieldNames.farmer_id] ?? StringHandlers.NotAvailable;
  }

  factory VideoCall.fromJson(Map<String, dynamic> map) {
    return VideoCall(
      title:
          map[VideoCallFieldNames.title] ?? StringHandlers.NotAvailable,
      meeting_link: map[VideoCallFieldNames.meeting_link] ?? "",
      farmer_id: map[VideoCallFieldNames.farmer_id] ?? StringHandlers.NotAvailable,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        VideoCallFieldNames.title: title,
        VideoCallFieldNames.meeting_link: meeting_link,
        VideoCallFieldNames.farmer_id: farmer_id,

      };
}

class VideoCallUrls {
  static const String Start_call_meeting = 'vendor/start_call_meeting';
  static const String disconnect_call = 'vendor/disconnect_farmer';
}

class VideoCallFieldNames {
  static const String title = "title";
  static const String meeting_link = "meeting_link";
  static const String farmer_id = "farmer_id";
}
