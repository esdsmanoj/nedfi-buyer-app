import 'package:nedfi_seller_common_code/app_imports.dart';
import '../login_screen/LoginScreen.dart';

class WhiteLableSplashScreen extends StatefulWidget {
  final String _image;
  final bool isFrom;

  const WhiteLableSplashScreen(this._image, {Key? key, required this.isFrom}) : super(key: key);

  @override
  _WhiteLableSplashScreenState createState() => _WhiteLableSplashScreenState();
}

class _WhiteLableSplashScreenState extends State<WhiteLableSplashScreen> {
  bool? _isLoading;
  String? _loadingText;
  bool? isLogin;

  @override
  void initState() {
    super.initState();
    getDetails();
    _isLoading = false;
    _loadingText = 'Loading . . .';
    startTime();
  }

  Future getDetails() async {
    isLogin = await WidgetUtils.getUserModel(context);
    imgPlaceHolder = await SharePrefsHelper.getInstance(context)?.getStringValue("whitelable") ?? '';
    image = await SharePrefsHelper.getInstance(context)?.getStringValue("logo") ?? '';
    await HeaderSingleton().getUserModel(context);
  }

  Future startTime() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    if (isLogin == false) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const NavigationHomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
        isLoading: _isLoading!,
        loadingText: _loadingText!,
        child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: (imgPlaceHolder != "" && widget.isFrom)
                ? Image.file(File(imgPlaceHolder), fit: BoxFit.contain, width: MediaQuery.of(context).size.height * 0.6, height: MediaQuery.of(context).size.height * 0.3,
                    errorBuilder: (ctx, obj, st) {
                    return Image.asset(ApiURL.imgPlaceHolder, fit: BoxFit.contain, width: MediaQuery.of(context).size.height * 0.6, height: MediaQuery.of(context).size.height * 0.3);
                  })
                : Container()));
  }
}
