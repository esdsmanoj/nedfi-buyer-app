import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../components/utils/Constants.dart';
import '../singleton/header_singleton.dart';

class APIService {
  static final headerModel = HeaderSingleton();

  static Future getAPIMethod({required String url}) async {
    headerParams["client-type"] = "seller";
    try {
      http.Response response = await http.get(Uri.parse(baseURL + url), headers: headerParams).timeout(const Duration(minutes: 1));
      if (response.statusCode == 200) {
        if (kDebugMode){
          print(baseURL + url);
          print(response.body);
        }
        return response;
      }
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future postAPIMethod({required String url, required Map<String, dynamic> params}) async {
    headerParams["client-type"] = "seller";
    try {
      http.Response response = await http.post(Uri.parse(baseURL + url), body: params, headers: headerParams).timeout(const Duration(minutes: 1));
      if (response.statusCode == 200) {
        if (kDebugMode){
          print(params);
          print(baseURL + url);
          print(response.body);
        }
        return response;
      }else{
        if (kDebugMode){
          print(params);
          print(baseURL + url);
          print(response.body);
        }
      }
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future putAPIMethod({required String url}) async {
    headerParams["client-type"] = "seller";
    try {
      http.Response response = await http.put(Uri.parse(baseURL + url), headers: headerParams).timeout(const Duration(minutes: 1));
      if (response.statusCode == 200) {
        return response;
      }
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
