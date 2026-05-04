import 'package:buyer_common_code/model/AnnouncementDetailsResponse.dart';
import 'package:buyer_common_code/model/AnnouncementResponse.dart';
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
