import 'package:get/get.dart';

import '../../app_imports.dart';

/**
 * @Author: Ajinkya Aher, Bhushan Lambole
 * @Date: 13-12-2023
 */

bottomSheetWidget({required String title, required String content, required String imagePath, Function(dynamic)? onTap, required BuildContext ctx}) {
  showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14.0))),
      builder: (newCtx) {
        return SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/$imagePath", height: MediaQuery.of(ctx).size.height * 0.108, width: MediaQuery.of(ctx).size.height * 0.108),
                const SizedBox(height: 8),
                WidgetUtils.appTextWidget(context: ctx, title: title, color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                const SizedBox(height: 8),
                WidgetUtils.appTextWidget(context: ctx, title: content, color: const Color(0xFF516971), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        onTap?.call(newCtx);
                      },
                      child: Container(
                        height: 36,
                        width: 86,
                        alignment: Alignment.center,
                        child: WidgetUtils.appTextWidget(context: ctx, title: "key_yes".tr, color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFDA11E)),
                      ),
                    ),
                    const SizedBox(width: 69),
                    InkWell(
                      onTap: () {
                        Navigator.pop(newCtx);
                      },
                      child: Container(
                        height: 36,
                        width: 86,
                        alignment: Alignment.center,
                        child: WidgetUtils.appTextWidget(context: ctx, title: "key_no".tr, color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFDA11E)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ));
      });
}

showRatingSheet(BuildContext ctx, Function(String) onTap,setState) {
  ValueNotifier<int> index=ValueNotifier(0);
  showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14.0))),
      builder: (newCtx) {
  return StatefulBuilder(
  builder: (BuildContext context, StateSetter setState /*You can rename this!*/)
  {
    return Container(
        height: MediaQuery
            .of(ctx)
            .size
            .height * 0.264,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(onTap: () {
                  setState(() {
                    index.value = 1;
                  });
                }, child: Container(decoration: BoxDecoration(
                    color: index.value == 1
                        ? Color(int.parse(themeColor.value.buttonColor!.color!))
                        .withOpacity(0.3)
                        : Colors.transparent,
                    border: Border.all(
                      color: index.value == 1 ? Color(int.parse(
                          themeColor.value.buttonColor!.color!)) : Colors
                          .transparent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                          "assets/images/Happy.svg", height: 50),
                    ))),
                const SizedBox(width: 10),
                InkWell(onTap: () {
                  setState(() {
                    index.value = 2;
                  });
                }, child: Container(decoration: BoxDecoration(
                    color: index.value == 2
                        ? Color(int.parse(themeColor.value.buttonColor!.color!))
                        .withOpacity(0.3)
                        : Colors.transparent,
                    border: Border.all(
                      color: index.value == 2 ? Color(int.parse(
                          themeColor.value.buttonColor!.color!)) : Colors
                          .transparent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                          "assets/images/partial_happy.svg", height: 50),
                    ))),
                const SizedBox(width: 10),
                InkWell(onTap: () {
                  setState(() {
                    index.value = 3;
                  });
                }, child: Container(decoration: BoxDecoration(
                    color: index.value == 3
                        ? Color(int.parse(themeColor.value.buttonColor!.color!))
                        .withOpacity(0.3)
                        : Colors.transparent,

                    border: Border.all(
                      color: index.value == 3 ? Color(int.parse(
                          themeColor.value.buttonColor!.color!)) : Colors
                          .transparent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                          "assets/images/sad.svg", height: 50),
                    ))),
              ],
            ),
            const SizedBox(height: 20),
            WidgetUtils.buttonWidget(
                context: newCtx,
                radius: 8,
                title: "Rate".tr,
                size: 18,
                family: 'Graphik',
                weight: FontWeight.w500,
                callback: () {
  if(index.value==0){
  WidgetUtils.errorDialog(context, "Please select Smaily");
  }else {
    if (index.value == 1) {
      onTap.call("Happy");
    } else if (index.value == 2) {
      onTap.call("partial happy");
    } else {
      onTap.call("sad");
    }
  }
                },
                textColor: Color(
                    int.parse(themeColor.value.buttonTextColor!.color!)),
                color: Color(int.parse(themeColor.value.buttonColor!.color!))),
          ],
        ));
  });
      });
}
