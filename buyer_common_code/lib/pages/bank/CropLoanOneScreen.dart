import 'package:buyer_common_code/app_imports.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CropLoanOneScreen extends StatefulWidget {
  const CropLoanOneScreen({Key? key}) : super(key: key);

  @override
  _CropLoanOneScreenState createState() => _CropLoanOneScreenState();
}

class _CropLoanOneScreenState extends State<CropLoanOneScreen> {
  TextEditingController? cropTypeController, agreementController, loanAmountController;

  @override
  void initState() {
    super.initState();
    cropTypeController = TextEditingController();
    agreementController = TextEditingController();
    loanAmountController = TextEditingController();
    setDatas();
  }

  Future setDatas() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      setState(() {
        cropTypeController!.text = loanModel.cropType;
        agreementController!.text = loanModel.tieUpAgreeent;
        loanAmountController!.text = loanModel.loanAmount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => showHarvesterDialog(context, ['Ruby'.tr, 'Soft'.tr], 'crop'),
              child: Container(
                width: double.maxFinite,
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
                // margin: const EdgeInsets.only(right: 16),
                child: TextField(
                  controller: cropTypeController,
                  keyboardType: TextInputType.text,
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Select Crop type'.tr,
                    border: InputBorder.none,
                    counterText: "",
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () => showHarvesterDialog(context, ['Yes'.tr, 'No'.tr], 'agreement'),
              child: Container(
                width: double.maxFinite,
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
                // margin: const EdgeInsets.only(right: 16),
                child: TextField(
                  controller: agreementController,
                  keyboardType: TextInputType.text,
                  enabled: false,
                  decoration: InputDecoration(hintText: 'Select Tie Up Agreement'.tr, border: InputBorder.none, counterText: ""),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: double.maxFinite,
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
              // margin: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: loanAmountController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Loan Amount'.tr,
                  border: InputBorder.none,
                  counterText: "",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 100,
                height: 40,
                child: CustomDarkButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.nextFocus();
                    _validation();
                  },
                  caption: 'Next'.tr,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _validation() {
    if (cropTypeController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Select Crop Type'.tr);
    } else if (agreementController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Select Tie Up Agreement'.tr);
    } else if (loanAmountController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Loan Amount'.tr);
    } else {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      loanModel.setCorpDetails(cropTypeController!.text, agreementController!.text, loanAmountController!.text);
      loanModel.setPageIndex(2);
    }
  }
  void showHarvesterDialog(BuildContext context, final cropType, String type) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(builder: (ctx, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 400,
                width: 328,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 200,
                              child: WidgetUtils.appTextWidget(
                                  overflow: TextOverflow.ellipsis, context: context, title:  type.toLowerCase() == 'agreement' ? 'Select Tie Up Agreement'.tr : "Select Crop Type".tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500)),
                          InkWell(
                              onTap: () {
                                Navigator.pop(ctx);
                              },
                              child:  SvgPicture.asset(
                                "assets/images/cross.svg",
                                height: 20,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: cropType.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if (type.toLowerCase() == 'agreement') {
                                agreementController!.text = cropType[index];
                              } else if (type.toLowerCase() == 'crop') {
                                cropTypeController!.text = cropType[index];
                              }
                              setState(() {});
                              Navigator.pop(ctx);
                            },
                            child: Container(
                              // height: 45,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: SizedBox(width:200,child: WidgetUtils.appTextWidget(context: context, overflow: TextOverflow.ellipsis,title: cropType[index], fontSize: 14, family: 'Graphik', fontWeight: FontWeight.w400)),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                            ),
                          );
                        }),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          });
        });
  }
  void showSelectionDialog(BuildContext buildContext, final cropType, String type) {
    showDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return CupertinoAlertDialog(
              title: WidgetUtils.appTextWidget(context: context, title: type.toLowerCase() == 'agreement' ? 'Select Tie Up Agreement'.tr : "Select Crop Type".tr, color: Colors.black, fontSize: 18),
              actions: List.generate(
                cropType.length,
                (index) {
                  return CupertinoDialogAction(
                      child: WidgetUtils.appTextWidget(context: context, title: cropType[index], fontSize: 16),
                      onPressed: () {
                        if (type.toLowerCase() == 'agreement') {
                          agreementController!.text = cropType[index];
                        } else if (type.toLowerCase() == 'crop') {
                          cropTypeController!.text = cropType[index];
                        }
                        setState(() {});
                        Navigator.pop(ctx);
                      });
                },
              ),
            );
          });
        });
  }
}
