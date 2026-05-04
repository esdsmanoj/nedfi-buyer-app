import 'package:flutter/cupertino.dart';

import '../help/SharePrefsHelper.dart';
class Utilities {
  static String INTERVAL_FIFTEEN = "fifteen";
  static String INTERVAL_HOURLY = "hourly";
  static String INTERVAL_DAILY = "daily";
  static String INTERVAL_WEEKLY = "weekly";
  static String INTERVAL_MONTHLY = "monthly";
  static String INTERVAL_YEARLY = "yearly";

  static bool isListEmpty(List<dynamic> list) {
    if (list == null || list.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  static bool isEmpty(String string) {
    if (string == null || string.trim().isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static bool isIntEmpty(int string) {
    if (string == null) {
      return true;
    } else {
      return false;
    }
  }

/*  static void showSmallToast(BuildContext context, String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        textColor: Colors.white,
        backgroundColor: Colors.grey[700]);
  }

  static void showLongToast(BuildContext context, String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        textColor: Colors.white,
        backgroundColor: Colors.grey[700]);
  }*/

  static String capitalise(String string) {
    String text = "";
    if (!Utilities.isEmpty(string)) {
      text = string[0].toUpperCase() + string.substring(1);
    }
    return text;
  }

  static String removeStringNull(String string) {
    if (string == null) {
      return "";
    }
    return string;
  }

  static int removeIntNull(int string) {
    if (string == null) {
      return 0;
    }
    return string;
  }

  static final colorList = [
    const Color(0xffB7950B),
    const Color(0xffB03A2E),
    const Color(0xff1E8449),
    const Color(0xffAF601A),
    const Color(0xff6C3483),
    const Color(0xff1E8449),
    const Color(0xff76448A),
    const Color(0xff239B56),
    const Color(0xff283747),
    const Color(0xff922B21),
    const Color(0xff1F618D),
    const Color(0xffcbb55f),
    const Color(0xff842d24),
    const Color(0xff066c31),
    const Color(0xff6a492c),
    const Color(0xffbd5be5),
    const Color(0xff4db378),
    const Color(0xffaf12ee),
    const Color(0xff267146),
    const Color(0xff4a92de),
    const Color(0xffa35e58),
    const Color(0xff8bacc2),
    const Color(0xff71a9e5),
    const Color(0xff8e3930),
    const Color(0xff38a9f5),
    const Color(0xfffdd63d),
    const Color(0xff4c3432),
    const Color(0xff1db35c),
    const Color(0xff6a492c),
    const Color(0xffbd5be5),
    const Color(0xff4db378),
    const Color(0xffaf12ee),
    const Color(0xff267146),
    const Color(0xff4a92de),
    const Color(0xffa35e58),
    const Color(0xff8bacc2),
    const Color(0xff71a9e5),
    const Color(0xff8e3930),
    const Color(0xff38a9f5),
    const Color(0xfffdd63d),
    const Color(0xff4c3432),
    const Color(0xff1db35c),
    const Color(0xff6a492c),
    const Color(0xffbd5be5),
    const Color(0xff4db378),
    const Color(0xffaf12ee),
    const Color(0xff267146),
    const Color(0xff4a92de),
    const Color(0xffa35e58),
    const Color(0xff8bacc2),
    const Color(0xffB7950B),
    const Color(0xffB03A2E),
    const Color(0xff1E8449),
    const Color(0xffAF601A),
    const Color(0xff6C3483),
    const Color(0xff1E8449),
    const Color(0xff76448A),
    const Color(0xff239B56),
    const Color(0xff283747),
    const Color(0xff922B21),
    const Color(0xff1F618D),
    const Color(0xffcbb55f),
    const Color(0xff842d24),
    const Color(0xff066c31),
    const Color(0xff6a492c),
    const Color(0xffbd5be5),
    const Color(0xff4db378),
    const Color(0xffaf12ee),
    const Color(0xff267146),
    const Color(0xff4a92de),
    const Color(0xffa35e58),
    const Color(0xff8bacc2),
    const Color(0xff71a9e5),
    const Color(0xff8e3930),
    const Color(0xff38a9f5),
    const Color(0xfffdd63d),
    const Color(0xff4c3432),
    const Color(0xff1db35c),
    const Color(0xff6a492c),
    const Color(0xffbd5be5),
    const Color(0xff4db378),
    const Color(0xffaf12ee),
    const Color(0xff267146),
    const Color(0xff4a92de),
    const Color(0xffa35e58),
    const Color(0xff8bacc2),
    const Color(0xff71a9e5),
    const Color(0xff8e3930),
    const Color(0xff38a9f5),
    const Color(0xfffdd63d),
    const Color(0xff4c3432),
    const Color(0xff1db35c),
    const Color(0xff6a492c),
    const Color(0xffbd5be5),
    const Color(0xff4db378),
    const Color(0xffaf12ee),
    const Color(0xff267146),
    const Color(0xff4a92de),
    const Color(0xffa35e58),
    const Color(0xff8bacc2),
  ];

  Future<String?> getDomain(BuildContext context) async {
    return (await SharePrefsHelper.getInstance(context)?.getStringValue("domain"));
  }
}
