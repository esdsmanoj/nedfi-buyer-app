import 'package:nedfi_seller_common_code/model/trade_product_model/BidChat.dart';
import 'package:nedfi_seller_common_code/model/Chat.dart';
import 'package:flutter/foundation.dart';

class ChatHistoryProvider extends ChangeNotifier {
  List<ChatData> chatHistoryList = List<ChatData>.empty();

  List<ChatData> mobileList = List<ChatData>.empty();
  var notificationFlag = "0";

  List<BidChatData> chatBidHistoryList = [];


  setNotificationFlag(String flag) {
    notificationFlag = flag;
    notifyListeners();
  }

  setChatList(List<ChatData> list) {
    chatHistoryList = List<ChatData>.empty();
    chatHistoryList = list;
    notifyListeners();
  }

  setBidChatList(List<BidChatData> list) {
    chatBidHistoryList = [];
    chatBidHistoryList = list;
    notifyListeners();
  }

  setMobileList(List<ChatData> list) {
    mobileList = List<ChatData>.empty();
    mobileList = list;
    notifyListeners();
  }
}
