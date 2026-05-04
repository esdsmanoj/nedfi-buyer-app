import 'package:buyer_common_code/model/MediaResponse.dart';
import 'package:flutter/material.dart';

import '../model/home_page_model.dart';

class MediaProvider extends ChangeNotifier {
  List<Media> mediaList = [];
  List<Media> featuredMediaList = [];
  String baseUrl = "";

  setMediaList(List<Media> list) {
    mediaList = List<Media>.empty();
    mediaList = list;
    notifyListeners();
  }

  setMediaNext(List<Media> list) {
    mediaList.addAll(list);
    notifyListeners();
  }

  setFeaturedMediaList(List<Media> list) {
    featuredMediaList = List<Media>.empty();
    featuredMediaList = list;
    notifyListeners();
  }

  setBaseURl(String url) {
    baseUrl = url;
    notifyListeners();
  }
}
