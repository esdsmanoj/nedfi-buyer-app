import 'package:get/get.dart';

import '../../app_imports.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  TextInputType? keyboardType;
  ValueChanged<String>? getController;
  int? maxLength;
  double? textSize;
  double? borderWidth;
  bool? isLogin;
  bool? isEnabled;

  CommonTextField(
      {Key? key,
      this.isEnabled,
      this.borderWidth = 1,
      this.textSize,
      this.maxLength,
      this.keyboardType,
      this.getController,
      required this.controller,
      required this.hintText,
      this.isLogin = false})
      : super(key: key);

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 58,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(color: Color(int.parse(themeColor.value.iconColor!.color!)), width: widget.borderWidth ?? 2.5),
          borderRadius: (widget.isLogin!) ? const BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)) : BorderRadius.circular(4)),
      // margin: const EdgeInsets.only(right: 16),
      child: TextField(
        enabled: widget.isEnabled,
        maxLength: widget.maxLength,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        onChanged: (value) => widget.getController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey, fontSize: widget.textSize ?? 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
          hintText: widget.hintText.tr,
          border: InputBorder.none,
          counterText: "",
          labelStyle: TextStyle(fontSize: widget.textSize ?? 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400, color: Colors.grey),
        ),
        style: TextStyle(color: Colors.black, fontSize: widget.textSize ?? 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
      ),
    );
  }
}
