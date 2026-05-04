import 'package:nedfi_seller_common_code/components/responsive_ui.dart';
import 'package:flutter/material.dart';

class ButtonStyles {
  static getLinkButtonTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 16.0,
    );
  }

  static getDarkButtonDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      gradient: LinearGradient(
        colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).colorScheme.secondary,
        ],
      ),
    );
  }

  static getLightButtonDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      gradient: LinearGradient(
        colors: [
          Theme.of(context).primaryColorLight,
          Theme.of(context).secondaryHeaderColor,
        ],
      ),
    );
  }

  static getDarkButtonTextStyle(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    double _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    bool _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio);
    bool _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio);
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: _large ? 20 : (_medium ? 18 : 16),
        );
  }

  static getLightButtonTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.w500,
        );
  }
}
