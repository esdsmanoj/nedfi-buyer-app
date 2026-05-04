import 'package:nedfi_seller_common_code/model/announcements/AnnouncementDetailsResponse.dart';
import 'package:nedfi_seller_common_code/model/announcements/AnnouncementResponse.dart';
import 'package:flutter/material.dart';

class AnnouncementProvider extends ChangeNotifier {
  List<AnnouncementData> announcementList = List<AnnouncementData>.empty();

  setAnnouncementList(List<AnnouncementData> list) {
    announcementList = List<AnnouncementData>.empty();
    announcementList = list;
    notifyListeners();
  }

  AnnouncementDetailData announcementDetailsList = AnnouncementDetailData(title: "", description: "", priorityType: "", createdOn: "", attachedDocument: []);

  setAnnouncementDetailsList(AnnouncementDetailData list) {
    announcementDetailsList = list;
    notifyListeners();
  }
}
