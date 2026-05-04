import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';

import '../../model/SplashResponse.dart';
import '../../services/api_service.dart';
import '../../singleton/header_singleton.dart';
import '../dialog_component/animated_snack_bar.dart';
import '../dialog_component/type.dart';
import '../help/SharePrefsHelper.dart';
import 'Constants.dart';

extension AadharNumberValidator on String {
  bool isValidAadharNumber() {
    return RegExp(r'^[0-9]{12}$').hasMatch(this);
  } // r'^[2-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$')}
}

extension PanCardValidator on String {
  bool isValidPanCardNo() {
    return RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(this);
  }
}

extension DrivingLicenseValidator on String {
  bool isValidLicenseNo() {
    return RegExp(r'^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}$').hasMatch(this);
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(this);
  }
}

class WidgetUtils {
  static Widget statusTextWidget({required String title}) {
    Color backColor = const Color(0xffE8C600);
    if (title.toLowerCase() == "pending") {
      backColor = const Color(0xffE8C600);
    } else if (title.toLowerCase() == "live") {
      backColor = const Color(0xff27914F);
    } else if (title.toLowerCase() == "expired") {
      backColor = const Color(0xff808080);
    } else if (title.toLowerCase() == "sold") {
      backColor = const Color(0xffE88700);
    }else if (title.toLowerCase() == "self sold") {
      backColor = const Color(0xffE88700);
    } else if (title.toLowerCase() == "completed") {
      backColor = const Color(0xff0074E8);
    } else if (title.toLowerCase() == "rejected") {
      backColor = const Color(0xffE70000);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: backColor, borderRadius: BorderRadius.circular(4)),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: const TextStyle(fontFamily: 'Graphik', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  static Widget appTextWidget(
      {required String title,
      required BuildContext context,
      bool? softWrap = true,
      double? fontSize = 12,
      String? family,
      Color? color,
      TextOverflow? overflow,
      TextAlign? textAlign,
      FontWeight? fontWeight,
      int? maxLines}) {
    return Text(
      title,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      // textScaleFactor: 1.0,
      maxLines: (softWrap ?? false) ? 2 : 1,
      style: TextStyle(fontFamily: family ?? 'Poppins', fontSize: fontSize ?? 14 * MediaQuery.of(context).textScaleFactor, color: color, fontWeight: fontWeight),
    );
  }

  static Widget buttonWidget(
      {double? radius,
      double? height,
      double? borderWidth,
      required BuildContext context,
      required String title,
      required VoidCallback callback,
      Color? textColor = Colors.black,
      FontWeight? weight,
      double? size,
      Color? color = Colors.white,
      String? family}) {
    return GestureDetector(
      onTap: () {
        callback.call();
      },
      child: Container(
        width: double.maxFinite,
        height: height ?? 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border.all(width: borderWidth ?? 0.5, color: Colors.black12), color: color, borderRadius: BorderRadius.circular(radius ?? 16)),
        child: WidgetUtils.appTextWidget(context: context, title: title, fontSize: size ?? 20, family: family ?? 'Poppins', fontWeight: weight, color: textColor),
      ),
    );
  }

  static void successDialog(BuildContext context, String title) {
    final dialog = AnimatedSnackBar.material(title,
            type: AnimatedSnackBarType.success,
            mobileSnackBarPosition: MobileSnackBarPosition.top,
            snackBarStrategy: RemoveSnackBarStrategy(),
            desktopSnackBarPosition: DesktopSnackBarPosition.topRight)
        .show(context);
    dialog.whenComplete(() {});
  }

  static void errorDialog(BuildContext context, String title) {
    AnimatedSnackBar.material(title,
            type: AnimatedSnackBarType.error,
            duration: const Duration(milliseconds: 500),
            mobileSnackBarPosition: MobileSnackBarPosition.top,
            snackBarStrategy: RemoveSnackBarStrategy(),
            desktopSnackBarPosition: DesktopSnackBarPosition.topRight)
        .show(context);
  }

  static void informationDialog(BuildContext context, String title) {
    AnimatedSnackBar.material(title,
            type: AnimatedSnackBarType.info,
            duration: const Duration(milliseconds: 500),
            mobileSnackBarPosition: MobileSnackBarPosition.top,
            snackBarStrategy: RemoveSnackBarStrategy(),
            desktopSnackBarPosition: DesktopSnackBarPosition.topRight)
        .show(context);
  }

  static void warningDialog(BuildContext context, String title) {
    AnimatedSnackBar.material(title,
            type: AnimatedSnackBarType.warning,
            duration: const Duration(milliseconds: 500),
            mobileSnackBarPosition: MobileSnackBarPosition.top,
            snackBarStrategy: RemoveSnackBarStrategy(),
            desktopSnackBarPosition: DesktopSnackBarPosition.topRight)
        .show(context);
  }

  static Future<Tuple2<String, String>?> getSplash({required Function(bool) callBack, required BuildContext context}) async {
    callBack.call(true);
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.splashScreen);
      final res = SplashResponse.fromJson(json.decode(response.body));
      if (res.success == 1) {
        final filePath = await WidgetUtils.splashFromImageUrl(res.image);
        final logoFile = await WidgetUtils.logoFromImageUrl(res.logo);
        HeaderSingleton().image = logoFile.path;
        imgPlaceHolder = filePath.path;
        image = logoFile.path;
        SharePrefsHelper.getInstance(context)?.saveStringValue("whitelable", filePath.path);
        SharePrefsHelper.getInstance(context)?.saveStringValue("logo", logoFile.path);

        return Tuple2<String, String>(filePath.path, logoFile.path);
      }
      callBack.call(false);
    } on SocketException {
      rethrow;
    } catch (e) {
      callBack.call(false);
      rethrow;
    }
  }

  static Future<File> splashFromImageUrl(String splash) async {
    final response = await http.get(Uri.parse(splash));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(path.join(documentDirectory.path, 'splash.png'));
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  static Future<File> logoFromImageUrl(String logo) async {
    final response = await http.get(Uri.parse(logo));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(path.join(documentDirectory.path, 'logo.png'));
    file.writeAsBytesSync(response.bodyBytes);
    // setState(() {
    //   imgPlaceHolder = file.path;
    // });
    return file;
  }

  static Future getDomain(BuildContext context) async {
    return (await SharePrefsHelper.getInstance(context)!.getStringValue("domain"));
    // HeaderModel().setDomain(domain);
    // return domain;
  }

  static Future getAppName(BuildContext context) async {
    return (await SharePrefsHelper.getInstance(context)!.getStringValue("appname"));
  }

  static Future<bool?> getUserModel(BuildContext context) async {
    return (await SharePrefsHelper.getInstance(context)!.getBoolValue("isLogin")) ?? false;
    // return isLogin;
  }

  static Future getIsFarmer(BuildContext context) async {
    final isFarmer = (await SharePrefsHelper.getInstance(context)?.getIntValue("Is_farmer"));
    return isFarmer ?? 0;
  }
}
