import 'dart:convert';

import 'package:nedfi_seller_common_code/model/user_model/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/menu_model.dart';
import '../utils/Utilities.dart';

class SharePrefsHelper {
  static const String USER_MODEL = "USER_MODEL";
  static const String USER_COMPANIES = "USER_COMPANIES";
  static const String USER_TYPE = "USER_TYPE";
  static const String USER_ID = "USER_ID";
  static const String DARK_MODE = "DARK_MODE";
  static const String CART_COUNT = "CART_COUNT";

  BuildContext? context;
  static SharePrefsHelper? instance;

  SharePrefsHelper(BuildContext? context) {
    this.context = context!;
  }

  static SharePrefsHelper? getInstance(BuildContext context) {
    instance ??= SharePrefsHelper(context);
    return instance;
  }

  Future<void> clearAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    //EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
    //encryptedSharedPreferences.clear();
  }

  Future<void> saveStringValue(String prefsKey, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(prefsKey, value);
    //EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
    //encryptedSharedPreferences.setString(prefsKey, value);
  }

  Future<void> saveBoolValue(String prefsKey, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(prefsKey, value);
    //EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
    //encryptedSharedPreferences.setBool(prefsKey, value);
  }

  Future<void> saveIntValue(String prefsKey, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(prefsKey, value);
    //EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
    //encryptedSharedPreferences.setInt(prefsKey, value);
  }

  Future<String?> getStringValue(String prefsKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(prefsKey);
    // EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
    //return encryptedSharedPreferences.getString(prefsKey);
  }

  Future<bool?> getBoolValue(String prefsKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(prefsKey);
    //EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
    //return encryptedSharedPreferences.getBool(prefsKey);
  }

  Future<int?> getIntValue(String prefsKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(prefsKey);
    //EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
    // return encryptedSharedPreferences.getInt(prefsKey);
  }

  Future<void> saveUserModel(UserData userModel) async {
    try {
      String jsonString = json.encode(userModel.toJson());
      saveStringValue(USER_MODEL, jsonString);
    } catch (e) {
      // print(e);
    }
  }

  Future<int?> getCartCount() async {
    int? cartCount = 0;
    try {
      cartCount = await getIntValue(CART_COUNT);
      if (Utilities.isIntEmpty(cartCount!)) {
        return cartCount = 0;
      }
      return cartCount;
    } catch (e) {
      // print(e);
    }
    return cartCount;
  }

  Future<UserData> getUserModel() async {
    String? jsonString = "";
    UserData userModel = UserData();
    try {
      jsonString = await getStringValue(USER_MODEL);

      var model = json.decode(jsonString!);

      userModel = UserData.fromJson(model);
    } catch (e) {
      // print(e);
    }
    return userModel;
  }

  Future<void> saveMenu(List<Menu> userModel) async {
    try {
      var json = jsonEncode(userModel.map((e) => e.toJson()).toList());
      //String jsonString = json.encode(userModel.toJson());
      saveStringValue(USER_COMPANIES, json);
    } catch (e) {
      // print(e);
    }
  }

  Future<List<Menu>> getMenu() async {
    String? jsonString = "";
    List<Menu> userModel = [];
    try {
      jsonString = await getStringValue(USER_COMPANIES);
      userModel = (json.decode(jsonString!) as List<dynamic>).map<Menu>((item) => Menu.fromJson(item)).toList();
      // var model = json.decode(jsonString).cast<CompanyList>();

      // userModel = model;
    } catch (e) {
      // print(e);
    }
    return userModel;
  }
}
