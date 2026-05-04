import 'package:get/get.dart';

import '../../app_imports.dart';

class BaseWidget extends StatefulWidget {
  Widget? child;
  Widget? bottomNavBar;
  Widget? floatingButton;
  bool? resizeInsets;
  String? isFromHome;
  Widget? drawer;
  PreferredSizeWidget? appBar;
  FloatingActionButtonLocation? floatingActionButtonLocation;

  BaseWidget({Key? key, this.appBar, this.drawer, this.isFromHome = "none", this.child, this.resizeInsets, this.bottomNavBar, this.floatingButton, this.floatingActionButtonLocation})
      : super(key: key);

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  AppUpdateInfo? _updateInfo;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.isFromHome == "home") {
      checkForUpdate();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
          child: Scaffold(
            appBar: widget.appBar,
            key: widget.isFromHome == "home" ? scaffoldKey : null,
            resizeToAvoidBottomInset: widget.resizeInsets,
            backgroundColor: Colors.white,
            drawer: widget.drawer,
            body: CustomProgressHandler(
              isLoading: isLoading.value,
              loadingText: "Please wait...",
              child: widget.child ?? Container()
            ),
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            floatingActionButton: widget.floatingButton,
            bottomNavigationBar: widget.bottomNavBar,
          ),
        ));
  }

  Future<bool> onWillPop() async {
    if (widget.isFromHome == "home") {
      if (pageNumber != 0) {
        pageController.jumpToPage(0);
        return false;
      } else if (scaffoldKey.currentState!.isDrawerOpen) {
        scaffoldKey.currentState!.openEndDrawer();
        return false;
      } else {
        return (await HelperUtils().showNormalDialog(
                context: context,
                title: 'Are_you_sure'.tr,
                content: 'Do you want to exit an App'.tr,
                onYesTapped: (value) async {
                  Navigator.pop(value);
                  SystemNavigator.pop();
                })) ??
            false;
      }
    } else if(widget.isFromHome == "none"){
      Navigator.pop(context);
      return false;
    }else {
      return false;
    }
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
      // showSnack(e.toString());
    });
  }

  Future startTimeForUpdate() async {
    var _duration = const Duration(seconds: 1);
    return Timer(_duration, () {
      InAppUpdate.performImmediateUpdate().catchError((e) {
        // showSnack(e.toString());
      });
    });
  }

  void showSnack(String text) {
    if (scaffoldKey.currentContext != null) {
     // ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }
}
