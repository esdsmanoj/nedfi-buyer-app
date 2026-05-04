import 'package:flutter/material.dart';

class CustomTextLableField extends StatelessWidget {
  final String? labelText;
  final int? hintMaxLines;
  final double? fontsize;

  const CustomTextLableField({Key? key, this.labelText, this.hintMaxLines, this.fontsize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400, fontSize: fontsize), hintMaxLines: hintMaxLines ?? 1, hintText: labelText, enabled: false),
    );
  }
}

class CustomText extends StatelessWidget {
  final String? labelText;
  final double? fontsize;

  const CustomText({Key? key, this.labelText, this.fontsize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        labelText!,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: fontsize),
      ),
    );
  }
}
