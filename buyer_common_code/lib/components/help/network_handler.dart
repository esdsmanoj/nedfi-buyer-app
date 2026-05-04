import 'package:connectivity_plus/connectivity_plus.dart';

import 'internet_connection.dart';

class NetworkHandler {
  static Uri? getUri(String url, Map<String, dynamic> params) {
    try {
      params.addAll({
        'UserType': 'Vendor',
        'ApplicationType': 'Vendor',
      });
      Uri uri = Uri.parse(url);
      return uri.replace(queryParameters: params);
    } catch (e) {
      return null;
    }
  }

  static Future<String> checkInternetConnection() async {
    String status;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a mobile network.
        status = InternetConnection.CONNECTED;
      } else {
        // I am connected to no network.
        status = InternetConnection.NOT_CONNECTED;
      }
    } catch (e) {
      status = InternetConnection.NOT_CONNECTED;
      status = 'Exception: ' + e.toString();
    }
    return status;
  }

  static String getServerWorkingUrl() {
    // String connectionStatus = await NetworkHandler.checkInternetConnection();
    /* if (connectionStatus == InternetConnection.CONNECTED) {
      return  "key_connected";
    } else {
      return "key_check_internet";
    }*/
    return "key_connected";
  }

  static Future<String> getServerWorkingUrlss() async {
    String connectionStatus = await NetworkHandler.checkInternetConnection();
    if (connectionStatus == InternetConnection.CONNECTED) {
      return "key_connected";
    } else {
      return "key_check_internet";
    }
  }
}
