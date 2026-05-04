import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/model/ProductType.dart';
import 'package:nedfi_seller_common_code/model/trade_product_model/master_listing_model.dart';
import 'package:nedfi_seller_common_code/pages/marketPlace/nedfi_products/add_product/AddProductStepTwoScreen.dart';

import '../../../../app_imports.dart';
import '../../../../model/trade_product_model/BuyerDemand.dart';
import '../../../../providers/master_provider.dart';
import 'AddProductStepOneScreen.dart';
import 'AddProductStepThreeScreen.dart';

class AddProductMainScreen extends StatefulWidget {
  String? type, id, from;
  BuyerDemandData? item;

  AddProductMainScreen({super.key, this.type, this.id, this.from, this.item});

  @override
  State<AddProductMainScreen> createState() => _AddProductMainScreenState();
}

class _AddProductMainScreenState extends State<AddProductMainScreen> {
  int currentIndex = 0;
  var screenArray = [];

  /// Whenever user taps on the device back button it will call the same.
  Future<bool> onWillPop() async {
    var masterProvider = Provider.of<MasterProvider>(context, listen: false);
    if (masterProvider.productCurrentIndex == 3) {
      return (await HelperUtils().showNormalDialog(
              context: context,
              title: 'Are_you_sure'.tr,
              content: 'Do you want to go to step 2'.tr,
              onYesTapped: (value) async {
                Navigator.pop(value);
                masterProvider.setProductCurrentIndex(2);
                isLoading.value = false;
                setState(() {});
              })) ??
          false;
    } else if (masterProvider.productCurrentIndex == 2) {
      return (await HelperUtils().showNormalDialog(
              context: context,
              title: 'Are_you_sure'.tr,
              content: 'Do you want to go to step 1'.tr,
              onYesTapped: (value) async {
                Navigator.pop(value);
                masterProvider.setProductCurrentIndex(1);
                isLoading.value = false;
                setState(() {});
              })) ??
          false;
    } else {
      return (await HelperUtils().showNormalDialog(
              context: context,
              title: 'Are_you_sure'.tr,
              content: 'Do you want to exit from add product'.tr,
              onYesTapped: (value) async {
                masterProvider.setItemId("");
                Navigator.pop(value);
                Navigator.pop(context, true);
              })) ??
          false;
    }
  }

  @override
  void initState() {
    super.initState();
    screenArray = [
      AddProductStepOneScreen(id: widget.id, onPressed: (value) => setState(() {}), from: widget.from, item: widget.from != null ? widget.item : null),
      AddProductStepTwoScreen(id: widget.id, onPressed: (value) => setState(() {})),
      AddProductStepThreeScreen(id: widget.id, buttonText: widget.type == "EDIT" ? "Update Product" : "Add Product")
    ];
    getMasterList();
    getProductType();
    var masterProvider = Provider.of<MasterProvider>(context, listen: false);
    masterProvider.setType(widget.type ?? "");
  }

  ///Getting the product master details from the API.
  Future getMasterList() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getMasterListing);
      final data = json.decode(response.body);
      final res = MasterListing.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setMasterData(res.data!);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  ///Getting the product type details from the API.
  Future getProductType() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.productType);
      final data = json.decode(response.body);
      final res = ProductType.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setProductTypeData(res.data ?? []);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MasterProvider>(builder: (context, masterProvider, child) {
      return WillPopScope(
          onWillPop: onWillPop,
          child: SafeArea(
              child: CustomProgressHandler(
            loadingText: '',
            isLoading: isLoading.value,
            child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 0,
                centerTitle: false,
                backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
                title: WidgetUtils.appTextWidget(context: context, title: widget.type == "EDIT" ? 'Edit Product'.tr : 'Add Product'.tr, color: Colors.white, fontSize: 18),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Column(
                children: [stepCountWidget(masterProvider.productCurrentIndex), Expanded(child: screenArray[masterProvider.productCurrentIndex - 1])],
              ),
            ),
          )));
    });
  }

  /// Step counter widget UI design.
  Widget stepCountWidget(int currentIndex) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(5),
      color: Color(int.parse(themeColor.value.barColor!.color!)),
      child: Column(
        children: [
          const SizedBox(height: 35),
          SizedBox(
            width: 228,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 70,
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: currentIndex > 0 ? Colors.white : Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "1",
                            style: TextStyle(color: currentIndex > 0 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 0),
                      currentIndex == 1
                          ? const RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: currentIndex > 1 ? Colors.white : Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "2",
                            style: TextStyle(color: currentIndex > 1 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 0,
                      ),
                      currentIndex == 2
                          ? const RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: currentIndex > 2 ? Colors.white : Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "3",
                            style: TextStyle(color: currentIndex > 2 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 0,
                      ),
                      currentIndex == 3
                          ? const RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
