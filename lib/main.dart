import 'package:nedfi_seller_common_code/app_imports.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/components/utils/notification_utils.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  HeaderSingleton().setRoute('nedfi');
  HeaderSingleton().setSplashImage("assets/images/nedfi_logo.png");

/*  try {
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      domainLink = initialLink.link.queryParameters["invite"] ?? "";
    }
  } catch (e) {
    rethrow;
  }*/

  if (!kIsWeb) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    await FirebaseMessaging.instance.requestPermission(alert: true, announcement: true, badge: true, carPlay: false, criticalAlert: true, provisional: false, sound: true);
    NotificationUtils().initialiseValuesAndPermissions();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  runApp(MultiProvider(providers: providerList, child: MaterialApp(debugShowCheckedModeBanner: false, home: MyApp(domainLink))));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  try {
    NotificationUtils().getNotificationBackground(message);
  } catch (e) {
    rethrow;
  }
}

class MyApp extends StatefulWidget {
  String param;

  MyApp(this.param, {Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String local = "en";
  AppUpdateInfo? _updateInfo;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    HelperUtils().getLangLocale(context);
    SharePrefsHelper.getInstance(context)?.saveStringValue("domainInvite", widget.param);
    HelperUtils().getUserModel(context);
    NotificationUtils().listenerEvent(context, () {
      if (!mounted) return;
    }, '', (value) => setState(() {}));
    FirebaseMessaging.instance.getToken().then((value) {});
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
        if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
          startTimeForUpdate();
        }
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  Future startTimeForUpdate() async {
    Future.delayed(const Duration(seconds: 2), () {
      InAppUpdate.performImmediateUpdate().catchError((e) => showSnack(e.toString()));
    });
  }

  void showSnack(String text) {
    if (scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, brightness) {
        return GetMaterialApp(
            translations: LocaleString(),
            locale: local == "en" ? const Locale('en', 'US') : const Locale('hi', 'IN'),
            title: 'NERACE',
            navigatorKey: HeaderSingleton().navigatorKey,
            home: const SplashScreen(route: 'nedfi', splashImagePath: "assets/images/nedfi_logo.png", appDetailsName: 'nerace', domainName: 'nerace'),
            debugShowCheckedModeBanner: false);
      },
    );
  }
}
