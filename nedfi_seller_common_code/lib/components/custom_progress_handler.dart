import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/components/utils/widget_utils.dart';

class CustomProgressHandler extends StatefulWidget {
  final String loadingText;
  final Widget child;
  final bool isLoading;

  const CustomProgressHandler({Key? key, required this.loadingText, required this.child, required this.isLoading}) : super(key: key);

  @override
  _CustomProgressHandlerState createState() => _CustomProgressHandlerState();
}

class _CustomProgressHandlerState extends State<CustomProgressHandler> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Stack(children: [
        widget.child,
        BlurryModalProgressHUD(
            inAsyncCall: widget.isLoading,
            blurEffectIntensity: 4,
            progressIndicator: Center(
              child: Container(
                height: 130,
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/images/plant_loader.gif', height: 80, width: 80),
                          WidgetUtils.appTextWidget(context: context, title: 'Loading'.tr + '...', family: 'Graphik', fontWeight: FontWeight.w400),
                        ],
                      ),
                    )),
              ),
            ),
            dismissible: false,
            opacity: 0.4,
            color: Colors.black,
            child: Container()),
      ]);
      // return BlurryModalProgressHUD(
      //     inAsyncCall: widget.isLoading,
      //     blurEffectIntensity: 4,
      //     progressIndicator: const SpinKitFadingCircle(color: Color(0xff27914F), size: 90.0),
      //     dismissible: false,
      //     opacity: 0.4,
      //     color: Colors.transparent,
      //     child: widget.child);
    } else {
      return Stack(
        children: <Widget>[
          widget.child,
        ],
      );
    }
  }
}
