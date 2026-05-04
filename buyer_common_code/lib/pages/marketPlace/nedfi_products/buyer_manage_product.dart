import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../../../app_imports.dart';
import '../../../../model/master_listing_model.dart';
import '../../../../model/trade_product_info.dart';
import '../../../../providers/master_provider.dart';
import 'manage_trade_product_details.dart';

class BuyerManageProductList extends StatefulWidget {
  final String isFrom;

  const BuyerManageProductList({super.key, required this.isFrom});

  @override
  State<BuyerManageProductList> createState() => _BuyerManageProductListState();
}

class _BuyerManageProductListState extends State<BuyerManageProductList> {
  TextEditingController productCategoryController = TextEditingController(),
      quantityController = TextEditingController(),
      priceController = TextEditingController(),
      quantityUnitController = TextEditingController(),
      productTypeController = TextEditingController(text: "All".tr);
  String productCategoryID = "", productStatusID = "";
  int start = 1;
  bool refreshFlag = false;
  var preventCall = false;
  ValueNotifier<List<TradeProductData>?> tradeDetails = ValueNotifier(null);

  Future getMasterList() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getMasterListing);
      final data = json.decode(response.body);
      final res = MasterListing.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setMasterData(res.data!);
          productCategoryController.text = res.data!.productCategory?[0].title ?? "";
          productCategoryID = res.data!.productCategory?[0].id.toString() ?? "";
          await getProductList();
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  Future getProductList() async {
    try {
      var param = {"buyer_id": HeaderSingleton().paramsMaps!.userId, "prod_cat_id": productCategoryID, "trade_status": productStatusID};
      final response = await APIService.postAPIMethod(url: ApiURL.getManageProducts, params: param);
      final data = json.decode(response.body);
      final res = TradeProductInfo.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          tradeDetails.value = res.data;
          setState(() {
            start = start + 1;
          });
        } else {
          tradeDetails.value = res.data ?? [];
        }
      } else if (res.success == 0) {
        if (res.data != null || res.data!.isEmpty) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setTreadProduct(res.data ?? []);
          tradeDetails.value = res.data;
        }
      }
    } catch (e) {
      //print(e);
      setState(() {});
    }
  }

  Future getRefreshProductList() async {
    try {
      if (refreshFlag) {
        return;
      }
      var param = {"buyer_id": HeaderSingleton().paramsMaps!.userId, "prod_cat_id": productCategoryID, "trade_status": productStatusID, "start": start.toString()};
      //print(param);
      final response = await APIService.postAPIMethod(url: ApiURL.getManageProducts, params: param);
      setState(() {
        refreshFlag = true;
      });
      final data = json.decode(response.body);
      final res = TradeProductInfo.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          // var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          // masterProvider.addTreadProduct(res.data!);
          tradeDetails.value!.addAll(res.data as List<TradeProductData>);
          setState(() {
            start = start + 1;
          });
        }
      } else {}
      setState(() {
        refreshFlag = false;
      });
    } catch (e) {
      //print(e);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getMasterList();
  }

  Future<bool> onWillPop() async {
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
          child: CustomProgressHandler(
        loadingText: '',
        isLoading: isLoading.value,
        child: DefaultTabController(
          length: 5,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(context: context, title: 'Manage Products'.tr, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.keyboard_backspace_sharp),
                onPressed: () {
                  if (widget.isFrom == "incentive") {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => const NavigationHomeScreen()), (route) => false);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            body: bodyWeight(),
          ),
        ),
      )),
    );
  }

  bodyWeight() {
    return ValueListenableBuilder(
      valueListenable: tradeDetails,
      builder: (BuildContext context, masterProvider, Widget? child) {
        var listss = masterProvider?.toSet().toList() ?? [];
        return Container(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              WidgetUtils.appTextWidget(context: context, title: 'Product Category'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
              const SizedBox(height: 08),
              Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.058,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(/*top: 12, */ bottom: 6, left: 16),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
                // margin: const EdgeInsets.only(right: 16),
                child: TextField(
                  onTap: () {
                    showProductCategory(context);
                  },
                  controller: productCategoryController,
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintText: 'Select Product Category'.tr,
                      border: InputBorder.none,
                      counterText: "",
                      suffixIcon: Icon(Icons.keyboard_arrow_down, size: MediaQuery.of(context).size.height * 0.024)),
                  style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 10),
              productCategoryID != "2" ? WidgetUtils.appTextWidget(context: context, title: 'Product Status'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16) : Container(),
              productCategoryID != "2" ? const SizedBox(height: 08) : Container(),
              productCategoryID != "2"
                  ? Container(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 0.058,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(/*top: 12, */ bottom: 6, left: 16),
                      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
                      // margin: const EdgeInsets.only(right: 16),
                      child: TextField(
                        onTap: () {
                          showProductType(context);
                        },
                        controller: productTypeController,
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            hintText: 'Select Product Status'.tr,
                            border: InputBorder.none,
                            counterText: "",
                            suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: MediaQuery.of(context).size.height * 0.024)),
                        style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 10),
              masterProvider?.isEmpty ?? true
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'No Data Available'.tr,
                          style: const TextStyle(color: Colors.black, fontFamily: 'Graphik', fontWeight: FontWeight.w500, fontSize: 15),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                          if (!preventCall) {
                            //getRefreshProductList().then((_) => preventCall = false);
                            preventCall = true;
                          }
                        }
                        return true;
                      },
                      child: Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: listss.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 100),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return productItem(listss[index], listss[index].prodCatId == "2" ? true : false);
                          },
                        ),
                      )),
            ],
          ),
        );
      },
    );
  }

  productItem(TradeProductData item, bool upComingProduct) {
    return GestureDetector(
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (ctx) => ManageTradeProductDetails(productId: item.id!, productTitle: item.productTitle!, isFrom: 'manage_product')))
              .then((value) async {
            //if (value == "true") {
            preventCall = false;
            setState(() => isLoading.value = true);
            await getProductList();
            setState(() => isLoading.value = false);
            // }
          });
        },
        child: Container(
          width: double.maxFinite,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                width: double.maxFinite,
                height: 130,
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: "${(item.prodThumbnail ?? "")}",
                  //${HeaderSingleton().configurationDetails!.tradeProducts}/
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.contain), borderRadius: BorderRadius.circular(4)),
                  ),
                  placeholder: (context, url) => Image.file(File(image), fit: BoxFit.fitHeight),
                  errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.fitHeight),
                ),
              ),
              const SizedBox(height: 9),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        SizedBox(child: WidgetUtils.appTextWidget(context: context, title: item.productTitle ?? "", fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 20)),
                        const SizedBox(width: 4),
                        item.manageProductStatus == null ? Container() : WidgetUtils.statusTextWidget(title: item.statusTitle!.toLowerCase() == "self sold" ? "Sold" : item.manageProductStatus ?? ""),
                      ],
                    ),
                  ),
                  WidgetUtils.appTextWidget(
                      context: context,
                      title: "₹" + (item.price ?? "") + "/" + (item.priceUnitTitle ?? ""),
                      fontWeight: FontWeight.w500,
                      family: 'Graphik',
                      color: Color(int.parse(themeColor.value.buttonColor!.color!)),
                      fontSize: 14),
                ],
              ),
              const SizedBox(height: 9),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetUtils.appTextWidget(
                      context: context, title: "Variety -".tr + (item.productVarietyTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                  WidgetUtils.appTextWidget(
                      context: context, title: "Type".tr + " - " + (item.productTypeTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                ],
              ),
              const SizedBox(height: 5),
              Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetUtils.appTextWidget(context: context, title: "Category".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                  WidgetUtils.appTextWidget(context: context, title: ((item.productCategoryTitle ?? "")), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                ],
              ),
              const SizedBox(height: 5),
              Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetUtils.appTextWidget(
                      context: context,
                      title: item.prodCatId == "2" ? "Expected Yield".tr : "Quantity".tr,
                      fontWeight: FontWeight.w400,
                      family: 'Graphik',
                      fontSize: 14,
                      color: const Color(0xff3F3F3F)),
                  WidgetUtils.appTextWidget(
                      context: context,
                      title: item.prodCatId == "2"
                          ? ((item.otherDetails?.yieldFrom ?? "0") +
                              " " +
                              (item.otherDetails?.yieldFromUnitText ?? "") +
                              " - " +
                              (item.otherDetails?.yieldTo ?? "0") +
                              " " +
                              (item.otherDetails?.yieldToUnitText ?? ""))
                          : ((item.sellQty ?? "0") + " " + (item.priceUnitTitle ?? "")),
                      fontWeight: FontWeight.w400,
                      family: 'Graphik',
                      fontSize: 14,
                      color: const Color(0xff3F3F3F)),
                ],
              ),
              item.prodCatId == "2" ? const SizedBox(height: 5) : Container(),
              item.prodCatId == "2" ? Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)) : Container(),
              item.prodCatId == "2" ? const SizedBox(height: 5) : Container(),
              item.prodCatId == "2"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(context: context, title: "Availability".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                        WidgetUtils.appTextWidget(
                            context: context,
                            title: (item.otherDetails?.availabilityFrom ?? "") + " - " + (item.otherDetails?.availabilityTo ?? ""),
                            fontWeight: FontWeight.w400,
                            family: 'Graphik',
                            fontSize: 14,
                            color: const Color(0xff3F3F3F)),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 5),
              item.prodCatId == "2"
                  ? Container(
                      width: double.maxFinite,
                      height: 0.5,
                      color: Colors.black.withOpacity(0.3),
                    )
                  : Container(),
              item.prodCatId == "2" ? const SizedBox(height: 5) : Container(),
              item.prodCatId == "2"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(context: context, title: "Product Type".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                        WidgetUtils.appTextWidget(context: context, title: (item.prodDetailsTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                      ],
                    )
                  : Container(),
              item.prodCatId == "2"
                  ? const SizedBox(height: 5)
                  : item.statusTitle!.toLowerCase() == "completed"
                      ? Container()
                      : Container(),
              item.statusTitle!.toLowerCase() == "completed" ? Container() : Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
              item.statusTitle!.toLowerCase() == "completed" ? Container() : const SizedBox(height: 5),
              item.statusTitle!.toLowerCase() == "completed"
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(context: context, title: "Added".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                        WidgetUtils.appTextWidget(
                            context: context, title: getDateFormat(item.addedDate!), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                      ],
                    ),

              // item.statusTitle!.toLowerCase() != "sold" || item.statusTitle!.toLowerCase() != "completed"
              //     ?Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)):Container(),
              const SizedBox(height: 5),
              item.statusTitle!.toLowerCase() != "pending"
                  ? item.prodCatId == "2"
                      ? Container()
                      : item.statusTitle!.toLowerCase() == "completed" || item.statusTitle!.toLowerCase() == "sold"
                          ? Container()
                          : const SizedBox(height: 1)
                  : Container(),
              item.statusTitle!.toLowerCase() != "pending"
                  ? item.prodCatId == "2"
                      ? Container()
                      : item.statusTitle!.toLowerCase() == "completed" || item.statusTitle!.toLowerCase() == "sold"
                          ? Container()
                          : Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3))
                  : Container(),
              item.statusTitle!.toLowerCase() != "pending"
                  ? item.prodCatId == "2"
                      ? Container()
                      : item.statusTitle!.toLowerCase() == "completed" || item.statusTitle!.toLowerCase() == "sold"
                          ? Container()
                          : const SizedBox(height: 3)
                  : Container(),
              item.statusTitle!.toLowerCase() != "pending"
                  ? item.prodCatId == "2"
                      ? Container()
                      : item.statusTitle!.toLowerCase() == "completed" || item.statusTitle!.toLowerCase() == "sold"
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetUtils.appTextWidget(
                                    context: context,
                                    title: /*(item.manageProductStatus ?? "").toLowerCase() == "rejected" ? "Rejected".tr :*/ "Expires".tr,
                                    color: const Color(0xff3F3F3F),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    family: 'Graphik'),
                                WidgetUtils.appTextWidget(
                                    context: context,
                                    title: getDateFormat(/*(item.manageProductStatus ?? "").toLowerCase() == "rejected" ? item.rejectedDate ?? "" :*/ item.expiryDate ?? ""),
                                    color: const Color(0xff3F3F3F),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    family: 'Graphik'),
                              ],
                            )
                  : Container(),
              item.statusTitle!.toLowerCase() != "pending"
                  ? item.prodCatId == "2"
                  ? Container()
                  : item.statusTitle!.toLowerCase() == "completed" || item.statusTitle!.toLowerCase() == "sold"
                  ? Container()
                  : item.manageProductStatus!.toLowerCase() == "rejected"
                  ? const SizedBox(height: 5)
                  : Container()
                  : Container(),
              item.statusTitle!.toLowerCase() != "pending"
                  ? item.prodCatId == "2"
                      ? Container()
                      : item.statusTitle!.toLowerCase() == "completed" || item.statusTitle!.toLowerCase() == "sold"
                          ? Container()
                          : item.manageProductStatus!.toLowerCase() == "rejected"
                              ? Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3))
                              : Container()
                  : Container(),
              item.statusTitle!.toLowerCase() != "pending"
                  ? item.prodCatId == "2"
                      ? Container()
                      : item.statusTitle!.toLowerCase() == "completed" || item.statusTitle!.toLowerCase() == "sold"
                          ? Container()
                          : item.manageProductStatus!.toLowerCase() == "rejected"
                              ? const SizedBox(height: 5)
                              : Container()
                  : Container(),
              item.statusTitle!.toLowerCase() != "pending"
                  ? item.prodCatId == "2"
                      ? Container()
                      : item.statusTitle!.toLowerCase() == "completed" || item.statusTitle!.toLowerCase() == "sold"
                          ? Container()
                          : item.manageProductStatus!.toLowerCase() == "rejected"
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    WidgetUtils.appTextWidget(context: context, title: "Bid Date".tr, color:  Colors.black, fontSize: 14, family: 'Graphik'),
                                    WidgetUtils.appTextWidget(
                                        context: context, title: getDateFormat(item.bidPlaceDate ?? ""), color: Colors.black, fontSize: 14, family: 'Graphik'),
                                  ],
                                )
                              : Container()
                  : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed"
                  ? Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3))
                  : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed"
                  ? item.soldTO == null
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetUtils.appTextWidget(context: context, title: "Sold to".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                            WidgetUtils.appTextWidget(context: context, title: item.soldTO ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                          ],
                        )
                  : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 5) : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed"
                  ? item.soldTO == null
                      ? Container()
                      : Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3))
                  : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed"
                  ? item.soldOn == null
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetUtils.appTextWidget(context: context, title: "Sold on".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                            WidgetUtils.appTextWidget(
                                context: context, title: getDateFormat(item.soldOn ?? ""), color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                          ],
                        )
                  : Container(),
              item.bidPlaceDate == null
                  ? Container()
                  : item.manageProductStatusId == "3"
                      ? Container()
                      : const SizedBox(height: 5),
              item.bidPlaceDate == null
                  ? Container()
                  : item.manageProductStatusId == "3"
                      ? Container()
                      : Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
              item.bidPlaceDate == null
                  ? Container()
                  : item.manageProductStatusId == "3"
                      ? Container()
                      : const SizedBox(height: 3),
              item.bidPlaceDate == null
                  ? Container()
                  : item.manageProductStatusId == "3"
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetUtils.appTextWidget(context: context, title: "Bid Date".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                            WidgetUtils.appTextWidget(
                                context: context, title: getDateFormat(item.bidPlaceDate ?? ""), color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                          ],
                        ),
              const SizedBox(height: 1),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" || item.statusTitle!.toLowerCase() == "expired"
                  ? Container()
                  : item.bidPrice == null
                      ? Container()
                      : item.manageProductStatusId == "3" || item.manageProductStatusId == "2"
                          ? Container()
                          : const SizedBox(height: 1),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" || item.statusTitle!.toLowerCase() == "expired"
                  ? Container()
                  : item.bidPrice == null
                      ? Container()
                      : item.manageProductStatusId == "3" || item.manageProductStatusId == "2"
                          ? Container()
                          : Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" || item.statusTitle!.toLowerCase() == "expired"
                  ? Container()
                  : item.bidPrice == null
                      ? Container()
                      : item.manageProductStatusId == "3" || item.manageProductStatusId == "2"
                          ? Container()
                          : const SizedBox(height: 3),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" || item.statusTitle!.toLowerCase() == "expired"
                  ? Container()
                  : item.bidPrice == null
                      ? Container()
                      : item.manageProductStatusId == "3" || item.manageProductStatusId == "2"
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetUtils.appTextWidget(context: context, title: "Bid Amount".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                WidgetUtils.appTextWidget(
                                    context: context, title: "₹ " + (item.bidPrice ?? " "), color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                              ],
                            ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  item.statusTitle!.toLowerCase() != "pending" || item.statusTitle!.toLowerCase() != "rejected"
                      ? (int.parse(item.tradeProductBiddingCount == "null" ? "0" : (item.tradeProductBiddingCount ?? "0")) != 0 || int.parse(item.buyerInterestCount ?? "0") != 0)
                          ? upComingProduct && int.parse(item.buyerInterestCount.toString()) != 0
                              ? buildContainerWidget(item, upComingProduct, int.parse(item.buyerInterestCount.toString()) != 0 ? true : false)
                              : !upComingProduct && int.parse(item.tradeProductBiddingCount.toString()) != 0
                                  ? buildContainerWidget(item, upComingProduct, int.parse(item.tradeProductBiddingCount.toString()) != 0 ? true : false)
                                  : Container()
                          : Container(width: item.statusTitle!.toLowerCase() != "pending" || item.statusTitle!.toLowerCase() != "rejected" ? 83 : 64)
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      item.statusTitle!.toLowerCase() != "sold" || item.statusTitle!.toLowerCase() != "completed"
                          ? Container()
                          :(userId == item.soldToBuyerId) ? InkWell(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                decoration: BoxDecoration(border: Border.all(color: Colors.orange), borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/images/rating.svg"),
                                    const SizedBox(width: 4),
                                    WidgetUtils.appTextWidget(context: context, title: "Rate".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: Colors.orange, fontSize: 14),
                                  ],
                                ),
                              ),
                            ):Container(),
                      const SizedBox(
                        width: 10,
                      ),
                      item.status?.toLowerCase() == "3" && item.prodCatId != "2"
                          ? InkWell(
                              onTap: () {
                                quantityUnitController.text = item.sellQtyUnitTitle ?? "";
                                quantityController.text = item.sellQty ?? "";
                                if (item.tradeProductBidding!.isNotEmpty) {
                                  priceController.text = item.tradeProductBidding?.last.bidPrice ?? "";
                                } else {
                                  priceController.text = "";
                                }

                                showBiddingBottomSheet(
                                    priceController, item.id!, item.tradeProductBidding?[0].bidPrice ?? "", TextEditingController(text: "₹/" + quantityUnitController.text), item.sellQtyUnit ?? "0");
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                decoration: BoxDecoration(border: Border.all(color: Colors.orange), borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/images/edit.svg", color: Colors.orange),
                                    const SizedBox(width: 4),
                                    WidgetUtils.appTextWidget(context: context, title: "Edit Bid".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: Colors.orange, fontSize: 14),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" ? const SizedBox(width: 6) : Container(),
                      item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed"
                          ? (userId == item.soldToBuyerId) ?InkWell(
                              onTap: () {
                                showRatingSheet(context, item.tradeProductBidding![0].sellerId!, item.id!);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                decoration: BoxDecoration(border: Border.all(color: Colors.orange), borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/images/rating.svg", color: Colors.orange),
                                    const SizedBox(width: 4),
                                    WidgetUtils.appTextWidget(context: context, title: "Rate".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: Colors.orange, fontSize: 14),
                                  ],
                                ),
                              ),
                            )
                          : Container():Container(),
                      /* item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed"
                          ? Container()
                          : InkWell(
                              onTap: () async {
                                if (item.statusTitle!.toLowerCase() != "completed") {
                                  HelperUtils().showNormalDialog(
                                      context: context,
                                      title: 'Are_you_sure'.tr,
                                      content: 'Do you want to delete Product'.tr,
                                      onYesTapped: (valueCtx) async {
                                        Navigator.pop(valueCtx);
                                        isLoading.value = true;
                                        setState(() {});
                                        await deleteTradeProduct(context, item.id!, "listing");
                                        await getProductList();
                                        isLoading.value = false;
                                        setState(() {});
                                      });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                decoration: BoxDecoration(border: Border.all(color: Color(int.parse(themeColor.value.buttonColor!.color!))), borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/images/deleteicon.svg", height: 17),
                                    const SizedBox(width: 4),
                                    WidgetUtils.appTextWidget(context: context, title: "Delete".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: Colors.red, fontSize: 14),
                                  ],
                                ),
                              ),
                            )*/
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }

  void showProductCategory(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).masterData?.productCategory ?? [];
          return StatefulBuilder(builder: (ctx, StateSetter setStates) {
            return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 400,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context, title: 'Select Product Category'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: SvgPicture.asset("assets/images/cross.svg", height: 20))
                            ],
                          )),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4, // Change as per your requirement
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5, // Change as per your requirement
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dssModel.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        setState(() {
                                          start = 1;
                                        });
                                        productCategoryController.text = dssModel[index].title ?? "";
                                        productCategoryID = dssModel[index].id.toString();
                                        print(productCategoryID);
                                        getProductList();
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: WidgetUtils.appTextWidget(context: context, title: dssModel[index].title ?? "", fontSize: 16, family: 'Graphik'),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                    ));
                              },
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  showRatingSheet(BuildContext ctx, String bidderId, String productId) {
    int index=0;
    showModalBottomSheet(
        context: ctx,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14.0))),
        builder: (newCtx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/)
          {
            return Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.264,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                            onTap: () async {
                              setState(() {
                                index = 1;
                              });
                            },
                            child: Container(decoration: BoxDecoration(
                                color: index == 1
                                    ? Color(int.parse(
                                    themeColor.value.buttonColor!.color!))
                                    .withOpacity(0.3)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: index == 1
                                      ? Color(int.parse(
                                      themeColor.value.buttonColor!.color!))
                                      : Colors
                                      .transparent,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    20))
                            ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.asset(
                                      "assets/images/Happy.svg", height: 50),
                                ))),
                        const SizedBox(width: 10),
                        InkWell(
                            onTap: () async {
                              setState(() {
                                index = 2;
                              });
                            },
                            child: Container(decoration: BoxDecoration(
                                color: index == 2
                                    ? Color(int.parse(
                                    themeColor.value.buttonColor!.color!))
                                    .withOpacity(0.3)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: index == 2
                                      ? Color(int.parse(
                                      themeColor.value.buttonColor!.color!))
                                      : Colors
                                      .transparent,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    20))
                            ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.asset(
                                      "assets/images/partial_happy.svg",
                                      height: 50),
                                ))),
                        const SizedBox(width: 10),
                        InkWell(
                            onTap: () async {
                              setState(() {
                                index = 3;
                              });
                            },
                            child: Container(decoration: BoxDecoration(
                                color: index == 3
                                    ? Color(int.parse(
                                    themeColor.value.buttonColor!.color!))
                                    .withOpacity(0.3)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: index == 3
                                      ? Color(int.parse(
                                      themeColor.value.buttonColor!.color!))
                                      : Colors
                                      .transparent,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    20))
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
                        context: context,
                        radius: 8,
                        title: "Rate".tr,
                        size: 18,
                        family: 'Graphik',
                        weight: FontWeight.w500,
                        callback: () async {
                          if (index == 0) {
                            WidgetUtils.errorDialog(
                                context, "Please select Smaily");
                          } else {
                            isLoading.value = true;
                            setState(() {});
                            await addRating(productId, bidderId, index
                                .toString(), () {
                              setState(() {});
                            }, context);
                            Navigator.pop(context);
                            isLoading.value = false;
                            setState(() {});
                          }
                        },
                        textColor: Color(int.parse(
                            themeColor.value.buttonTextColor!.color!)),
                        color: Color(
                            int.parse(themeColor.value.buttonColor!.color!))),
                  ],
                ));
          });
        });
  }

  Future addRating(String productId, String buyerId, String ratingId, Function callback, BuildContext context) async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.productRating, params: {
        'buyer_id': userId,
        'trade_product_id': productId,
        'rating_id': ratingId, /*'seller_id': userId*/
      });
      final result = jsonDecode(response.body);
      if (result['status'].toString() == '1') {
        WidgetUtils.successDialog(context, result['message'].toString());
      } else {
        WidgetUtils.errorDialog(context, result['message'].toString());
      }
      callback.call();
    } catch (e) {
      callback.call();
      rethrow;
    }
  }

  void showProductType(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).masterData?.buyerTradeStatus ?? [];
          return StatefulBuilder(builder: (ctx, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 420,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context, title: 'Select Product Status'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: SvgPicture.asset("assets/images/cross.svg", height: 20))
                            ],
                          )),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.420, // Change as per your requirement
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.420, // Change as per your requirement
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dssModel.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        setState(() {
                                          start = 1;
                                        });
                                        productTypeController.text = dssModel[index].title ?? "";
                                        productStatusID = dssModel[index].id.toString();
                                        getProductList();
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: WidgetUtils.appTextWidget(context: context, title: dssModel[index].title ?? "", fontSize: 16, family: 'Graphik'),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                    ));
                              },
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  showBiddingBottomSheet(TextEditingController bidAmt, String productId, String highestBidAmt, TextEditingController priceQTYController, String unitId) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14.0))),
        builder: (ctx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/)
          {
            return KeyboardVisibilityBuilder(
                builder: (context, isKeyboardVisible) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: isKeyboardVisible ? 300 : 0),
                    child: Container(
                        height: 352,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  WidgetUtils.appTextWidget(context: context,
                                      title: "Highest Bid".tr,
                                      fontWeight: FontWeight.w500,
                                      family: 'Graphik',
                                      color: Colors.black,
                                      fontSize: 16),
                                  highestBidAmt == ""
                                      ? Container()
                                      : WidgetUtils.appTextWidget(
                                      context: context,
                                      title: "₹$highestBidAmt".tr,
                                      fontWeight: FontWeight.w500,
                                      family: 'Graphik',
                                      color: Colors.black,
                                      fontSize: 16),
                                ],
                              ),
                              const SizedBox(height: 12),
                              WidgetUtils.appTextWidget(context: context,
                                  title: "Quantity".tr,
                                  fontWeight: FontWeight.w500,
                                  family: 'Graphik',
                                  color: Colors.black,
                                  fontSize: 16),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(border: Border.all(
                                    color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width - 135),
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.058,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(left: 10),
                                      // margin: const EdgeInsets.only(right: 16),
                                      child: TextField(
                                        controller: quantityController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 5,
                                        readOnly: true,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                            hintText: 'Enter Value'.tr,
                                            border: InputBorder.none,
                                            counterText: ""),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Graphik',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0),
                                      child: Container(
                                          color: Colors.grey.shade300,
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height * 0.058,
                                          width: 1),
                                    ),
                                    Container(
                                      width: 90,
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.058,
                                      alignment: Alignment.center,
                                      child: TextField(
                                        onTap: () {
                                          // showUnit(context, "marketable");
                                        },
                                        controller: quantityUnitController,
                                        keyboardType: TextInputType.text,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                            labelStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontFamily: 'Graphik',
                                                fontWeight: FontWeight.w400),
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontFamily: 'Graphik',
                                                fontWeight: FontWeight.w400),
                                            hintText: ''.tr,
                                            counterText: "",
                                            border: InputBorder.none,
                                            suffixIcon: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.grey)),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Graphik',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              WidgetUtils.appTextWidget(context: context,
                                  title: "Price".tr,
                                  fontWeight: FontWeight.w500,
                                  family: 'Graphik',
                                  color: Colors.black,
                                  fontSize: 16),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(border: Border.all(
                                    color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    Container(
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width - 135),
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.058,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(left: 10),
                                      // margin: const EdgeInsets.only(right: 16),
                                      child: TextField(
                                        controller: bidAmt,
                                        keyboardType: TextInputType.number,
                                        maxLength: 5,
                                        // readOnly: true,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                            hintText: 'Enter Value'.tr,
                                            border: InputBorder.none,
                                            counterText: ""),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Graphik',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0),
                                      child: Container(
                                          color: Colors.grey.shade300,
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height * 0.058,
                                          width: 1),
                                    ),
                                    Container(
                                      width: 90,
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.058,
                                      alignment: Alignment.center,
                                      child: TextField(
                                        onTap: () {
                                          // showUnit(context, "marketable");
                                        },
                                        controller: priceQTYController,
                                        keyboardType: TextInputType.text,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                            labelStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontFamily: 'Graphik',
                                                fontWeight: FontWeight.w400),
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontFamily: 'Graphik',
                                                fontWeight: FontWeight.w400),
                                            hintText: ''.tr,
                                            counterText: "",
                                            border: InputBorder.none,
                                            suffixIcon: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.grey)),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Graphik',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              WidgetUtils.buttonWidget(
                                  context: context,
                                  radius: 8,
                                  title: "Place Bid".tr,
                                  size: 18,
                                  family: 'Graphik',
                                  weight: FontWeight.w500,
                                  callback: () async {
                                    if (bidAmt.text.isEmpty) {
                                      setState(() {
                                        WidgetUtils.errorDialog(
                                            context, "Please Enter Price".tr);
                                      });
                                    } else {
                                      isLoading.value = true;
                                      setState(() {});
                                      await addBid(
                                          productId, quantityController.text,
                                          unitId, bidAmt.text);
                                      await getProductList();
                                      isLoading.value = false;
                                      setState(() {});
                                      Navigator.pop(context);
                                    }
                                  },
                                  textColor: Color(int.parse(themeColor.value
                                      .buttonTextColor!.color!)),
                                  color: Color(int.parse(themeColor.value
                                      .buttonColor!.color!))),
                            ])),
                  );
                });
          });
        });
  }

  Future addBid(String productId, String qty, String qtyUnit, String biddingAmt) async {
    try {
      var param = {"product_id": productId, "buyer_id": HeaderSingleton().paramsMaps!.userId, "qty": qty, "qty_unit": qtyUnit, "bid_price": biddingAmt};
      final response = await APIService.postAPIMethod(url: ApiURL.addBidding, params: param);
      final data = json.decode(response.body);
      priceController.text = "";
      if (data["success"].toString() == "1") {
        WidgetUtils.successDialog(context, data['message']);
        priceController.text = "";
        preventCall = false;
        setState(() {});
        await getProductList();
      } else {
        WidgetUtils.errorDialog(context, data['message']);
      }
    } catch (e) {
      setState(() {});
    }
  }

  Future addInterest(String id) async {
    try {
      var param = {"buyer_id": HeaderSingleton().paramsMaps!.userId, "trade_product_id": id};
      final response = await APIService.postAPIMethod(url: ApiURL.addInterest, params: param);
      final data = json.decode(response.body);
      if (data["status"] == 1) {
        WidgetUtils.successDialog(context, data['message']);
        setState(() {});
        getManageProductInformation(context, id, () {
          isLoading.value = false;
          setState(() {});
        });
      } else {
        WidgetUtils.errorDialog(context, data['message']);
      }
    } catch (e) {
      setState(() {});
    }
  }

  buildContainerWidget(TradeProductData item, bool upComingProduct, bool isActive) {
    return isActive
        ? InkWell(
            onTap: () {
              if (upComingProduct) {
                HelperUtils().showNormalDialog(
                    context: context,
                    title: 'Are_you_sure'.tr,
                    imagePath: "delete_bid.svg",
                    content: 'Do you want to revoke interest'.tr,
                    onYesTapped: (values) async {
                      Navigator.of(values).pop(false);
                      isLoading.value = true;
                      setState(() {});
                      await addInterest(item.id!);
                      isLoading.value = false;
                      setState(() {});
                      Navigator.pop(context);
                    });
              }
            },
            child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                decoration:
                    upComingProduct ? BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xff27914F), border: Border.all(width: 1, color: const Color(0xff27914F))) : null,
                child: Row(
                  children: [
                    SvgPicture.asset(upComingProduct ? "assets/images/InterestIcon.svg" : "assets/images/bids.svg", height: 17, color: upComingProduct ? Colors.white : const Color(0xff27914F)),
                    const SizedBox(width: 4),
                    WidgetUtils.appTextWidget(
                        context: context,
                        title: upComingProduct ? ("${item.buyerInterestCount!} ") : ("${item.tradeProductBiddingCount!} " + "BIDS"),
                        color: upComingProduct ? Colors.white : const Color(0xff27914F),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        family: 'Graphik'),
                  ],
                )),
          )
        : Container();
  }
}
