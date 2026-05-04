import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {
  int _currentPage = 0, _page = 0;

  int get page => _page;

  int get currentPage => _currentPage;

  void updateCurrentPage(int index) {
    if (index != currentPage) {
      _currentPage = index;
      notifyListeners();
    }
  }

  void setCallToggle(int index) {
    if (index != page) {
      _page = index;
      notifyListeners();
    }
  }
}
