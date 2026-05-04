import 'package:nedfi_seller_common_code/components/utils/Constants.dart';
import 'package:nedfi_seller_common_code/components/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class CustomDarkButton extends StatelessWidget {
  final String caption;
  final VoidCallback onPressed;

  const CustomDarkButton({
    Key? key,
    required this.caption,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size;
    size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onPressed,
      child: Container(
          width: double.maxFinite,
          height: size.width * 0.15,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Color(int.parse(themeColor.value.buttonColor!.color!)), borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: WidgetUtils.appTextWidget(context:context,title: caption, fontSize: 20,fontWeight: FontWeight.w400, color: Color(int.parse(themeColor.value.buttonTextColor!.color!)),family: 'Graphik')),
    );
  }
}
