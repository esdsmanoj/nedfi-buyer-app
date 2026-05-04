import '../../app_imports.dart';

/// Trade product Content widget stateless class
class TradeContentWidget extends StatelessWidget {
  final bool isActive;
  bool? isStart;
  final String textTitle, textContent;

  TradeContentWidget({super.key, this.isStart = false, required this.isActive, required this.textTitle, required this.textContent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isStart!
            ? Container()
            : isActive
                ? const SizedBox(height: 1)
                : Container(),
        isStart!
            ? Container()
            : isActive
                ? const Divider(height: 5)
                : Container(),
        isStart!
            ? Container()
            : isActive
                ? const SizedBox(height: 1)
                : Container(),
        isActive
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetUtils.appTextWidget(context: context, title: textTitle, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                  WidgetUtils.appTextWidget(context: context, title: textContent, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                ],
              )
            : Container(),
      ],
    );
  }
}
