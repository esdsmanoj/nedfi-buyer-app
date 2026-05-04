import 'package:get/get.dart';

import '../../app_imports.dart';

/// Interested button widget as per the interests are added to the prodcuts.
class InterestedButtonWidget extends StatelessWidget {
  final bool upComingProduct, isActive;
  final String count;

  const InterestedButtonWidget({super.key, required this.upComingProduct, required this.isActive, required this.count});

  @override
  Widget build(BuildContext context) {
    return buildContainerWidget(context);
  }

  buildContainerWidget(BuildContext context) {
    return isActive
        ? Container(
            height: 36,
            // width: 120,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: const Color(0xff27914F))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(upComingProduct ? "assets/images/InterestIcon.svg" : "assets/images/bids.svg", height: 17, color: const Color(0xff27914F)),
                const SizedBox(width: 4),
                WidgetUtils.appTextWidget(
                    context: context,
                    title: upComingProduct ? ("$count " + "Interested".tr) : ("$count " + "BIDS".tr),
                    color: const Color(0xff27914F),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    family: 'Graphik'),
              ],
            ))
        : Container();
  }
}
