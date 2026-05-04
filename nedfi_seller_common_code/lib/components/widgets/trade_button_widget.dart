import '../../app_imports.dart';

class TradeButtonWidget extends StatelessWidget {
  Function? onTap;
  String? buttonName, imagePath;
  dynamic colorCode;

  TradeButtonWidget({super.key, this.onTap, this.buttonName, this.imagePath, this.colorCode});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
          height: 36,
          // width: 90,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Color(colorCode))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset("assets/images/$imagePath", height: 17, color: Color(colorCode!)),
              const SizedBox(width: 4),
              WidgetUtils.appTextWidget(context: context, title: buttonName ?? "", color: Color(colorCode), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
            ],
          )),
    );
  }
}
