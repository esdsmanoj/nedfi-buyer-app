import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../app_imports.dart';
import '../../../../model/CityResponse.dart';
import '../../../../model/NedfiProductType.dart';
import '../../../../model/NedfiProductVariety.dart';
import '../../../../model/ProductType.dart';
import '../../../../model/StateResponse.dart';
import '../../../../model/master_listing_model.dart';
import '../../../../model/trade_product_info.dart';
import '../../../../providers/master_provider.dart';
import '../buyer_manage_product.dart';
import '../trade_product_details.dart';

class NedfiProductListScreen extends StatefulWidget {
  final String isFrom;

  const NedfiProductListScreen({super.key, required this.isFrom});

  @override
  State<NedfiProductListScreen> createState() => _NedfiProductListScreenState();
}

class _NedfiProductListScreenState extends State<NedfiProductListScreen> {
  TextEditingController productCategoryController = TextEditingController(),
      quantityController = TextEditingController(),
      priceController = TextEditingController(),
      quantityUnitController = TextEditingController(),
      productSearchController = TextEditingController(),
      productTypeController = TextEditingController();
  String productCategoryID = "", productStatusID = "";
  int start = 1;
  bool refreshFlag = false;
  List<TradeProductData> tradeProductDataResult = [];

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
          getProductList();
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  Future getProductList() async {
    try {
      var param = {
        "buyer_id": HeaderSingleton().paramsMaps!.userId,
        "prod_cat_id": productCategoryID,
        "trade_status": productStatusID,
        "start": "1",
        "prod_name": productController!.text.toString(),
        "prod_variety": productVarietyID,
        "state": stateID,
        "city": district,
        "exp_date_from": fromDateController!.text.toString(),
        "exp_date_to": toDateController!.text.toString(),
        "price_from": priceRangeTo!.text.toString(),
        "price_to": priceRangeFrom!.text.toString(),
        "certifcations": (productVarietyID == "" ? "" : packaging_flag.toString()),
        "prod_type_id": productTypeID,
        "negotiations":logisticPartner_flag.toString()
      };

      final response = await APIService.postAPIMethod(url: ApiURL.getTradeProducts, params: param);
      final data = json.decode(response.body);
      print(response.body);
      final res = TradeProductInfo.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setTreadProduct(res.data!);
          productData.value = res.data;
          setState(() {
            start = start + 1;
          });
        }
      } else if (res.success == 0) {
        if (res.data != null || res.data!.isEmpty) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setTreadProduct(res.data ?? []);
          productData.value = res.data;
        }
      }
    } catch (e) {
      print(e);
      setState(() {});
    }
  }

  Future getRefreshProductList() async {
    try {
      if (refreshFlag) {
        return;
      }
      var param = {
        "buyer_id": HeaderSingleton().paramsMaps!.userId,
        "prod_cat_id": productCategoryID,
        "trade_status": productStatusID,
        "start": start.toString(),
        "prod_name": productController!.text.toString(),
        "prod_variety": productVarietyID,
        "state": stateID,
        "city": district,
        "exp_date_from": fromDateController!.text.toString(),
        "exp_date_to": toDateController!.text.toString(),
        "price_from": priceRangeTo!.text.toString(),
        "price_to": priceRangeFrom!.text.toString(),
        "certifcations": (productVarietyID == "" ? "" : packaging_flag.toString()),
        "prod_type_id": productTypeID,
        "negotiations":logisticPartner_flag.toString()
      };
      final response = await APIService.postAPIMethod(url: ApiURL.getTradeProducts, params: param);
      setState(() {
        refreshFlag = true;
      });
      final data = json.decode(response.body);
      final res = TradeProductInfo.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.addTreadProduct(res.data!);
          productData.value = res.data;
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
   // getProductList();
    getProduct("", "1");
    getProductType();
    getState();
  }

  getState() async {
    await HelperUtils().getState((value) {}, context);
  }

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

  Future<bool> onWillPop() async {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
    return true;
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
            child: DefaultTabController(
              length: 5,
              child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0,
                    centerTitle: false,
                    backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
                    title: WidgetUtils.appTextWidget(context: context, title: 'Products'.tr, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
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
                  body: bodyWeight(masterProvider),
                  floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const BuyerManageProductList(isFrom: ''))).then((value) async {
                          //if (value == "true") {
                          setState(() => isLoading.value = true);
                          await getProductList();
                          setState(() => isLoading.value = false);
                          // }
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 170,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.add, color: Colors.white),
                            Flexible(child: WidgetUtils.appTextWidget(context: context, title: 'Manage Product'.tr, color: Colors.white, family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        decoration: BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!)), borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  )),
            ),
          ),
        ),
      );
    });
  }

  bodyWeight(MasterProvider masterProvider) {
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
            padding: const EdgeInsets.only(/*top: 16,*/ bottom: 6, left: 16),
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              onTap: () {
                showProductCategory(context);
              },
              controller: productCategoryController,
              keyboardType: TextInputType.text,
              readOnly: true,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  hintText: 'Select Product Category'.tr,
                  border: InputBorder.none,
                  counterText: "",
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Icon(Icons.keyboard_arrow_down, size: MediaQuery.of(context).size.height * 0.024),
                  )),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 10),
          WidgetUtils.appTextWidget(context: context, title: 'Products'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
          const SizedBox(height: 08),
          Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.058,
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(/*top: 12, */ bottom: 6, left: 16),
                  width: ((MediaQuery.of(context).size.width) * 0.74),
                  child: TextField(
                    onTap: () {},
                    controller: productSearchController,
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      tradeProductDataResult = [];
                      if (text.isEmpty) {
                        setState(() {
                          tradeProductDataResult = [];
                        });
                        return;
                      }
                      for (var userDetail in masterProvider.treadProductList) {
                        if (userDetail.productTitle!.toUpperCase().contains(text.toUpperCase())) {
                          tradeProductDataResult.add(userDetail);
                        } else {}
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        hintText: 'Search Product Name'.tr,
                        border: InputBorder.none,
                        counterText: "",
                        suffixIcon: Padding(padding: const EdgeInsets.only(top: 8.0), child: Icon(Icons.search, color: Colors.grey, size: MediaQuery.of(context).size.height * 0.024))),
                    style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  width: 58,
                  height: MediaQuery.of(context).size.height * 0.058,
                  decoration: const BoxDecoration(border: Border(left: BorderSide(color: Colors.grey, width: 1.0))),
                  alignment: Alignment.center,
                  child: InkWell(
                      onTap: () {
                        showSheet(context);
                      },
                      child: Icon(Icons.filter_list, size: MediaQuery.of(context).size.height * 0.024)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          masterProvider.treadProductList.isEmpty || (tradeProductDataResult.isEmpty && productSearchController.text.isNotEmpty)
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
                    //  getRefreshProductList();
                    }
                    return true;
                  },
                  child: Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: tradeProductDataResult.isEmpty ? masterProvider.treadProductList.length : tradeProductDataResult.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 100),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return productItem(tradeProductDataResult.isEmpty ? masterProvider.treadProductList[index] : tradeProductDataResult[index],
                            (tradeProductDataResult.isEmpty ? masterProvider.treadProductList[index].prodCatId : tradeProductDataResult[index].prodCatId) == "2" ? true : false);
                      },
                    ),
                  )),
        ],
      ),
    );
  }

  buildContainerWidget(TradeProductData item, bool upComingProduct, bool isActive) {
    return isActive
        ?upComingProduct?Container(): Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: const Color(0xff27914F))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(upComingProduct ? "assets/images/InterestIcon.svg" : "assets/images/bids.svg", height: 17, color: const Color(0xff27914F)),
                const SizedBox(width: 4),
                WidgetUtils.appTextWidget(
                    context: context,
                    title: upComingProduct ? ("${item.buyerInterestCount!} " + "Interested".tr) : ("${item.tradeProductBiddingCount!} " + "BIDS".tr),
                    color: const Color(0xff27914F),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    family: 'Graphik'),
                // WidgetUtils.appTextWidget(
                //     context: context,
                //     title: upComingProduct ? ("${item.buyerInterestCount!} " + "Interested".tr) : ("${item.tradeProductBiddingCount!} " + "BIDS".tr),
                //     color: const Color(0xff27914F),
                //     fontWeight: FontWeight.w500,
                //     fontSize: 14,
                //     family: 'Graphik'),
              ],
            ))
        : Container();
  }

  productItem(TradeProductData item, bool upComingProduct) {
    bool interettflag = false;
    if (item.buyerInterest != null && item.buyerInterest!.isNotEmpty) {
      for (var element in item.buyerInterest!) {
        if (element.buyerId == userId) {
          interettflag = true;
        }
      }
    }
    return GestureDetector(
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (ctx) => TradeProductDetails(productId: item.id!, productTitle: item.productTitle!, isFrom: ''))).then((value) async {
            //if (value == "true") {
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
                  imageUrl: (item.prodThumbnail ?? ""),
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
                        /* WidgetUtils.statusTextWidget(
                            title: item.statusTitle ?? ""),*/
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
                  WidgetUtils.appTextWidget(context: context, title: "Category".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                  WidgetUtils.appTextWidget(context: context, title: item.productCategoryTitle!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
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
              item.prodCatId == "2" ? Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)) : Container(),
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
              item.prodCatId == "2" ? const SizedBox(height: 5) : Container(),
              Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetUtils.appTextWidget(context: context, title: "Added".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                  WidgetUtils.appTextWidget(context: context, title: getDateFormat(item.addedDate!), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                ],
              ),
              const SizedBox(height: 5),
              // item.statusTitle!.toLowerCase() != "sold" || item.statusTitle!.toLowerCase() != "completed"
              //     ?Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)):Container(),
              const SizedBox(height: 5),
              item.statusTitle!.toLowerCase() != "pending" ? const SizedBox(height: 1) : Container(),
              item.statusTitle!.toLowerCase() != "pending" ? Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)) : Container(),
              item.statusTitle!.toLowerCase() != "pending" ? const SizedBox(height: 3) : Container(),
              item.statusTitle!.toLowerCase() != "pending"
                  ? item.prodCatId == "2"
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetUtils.appTextWidget(
                                context: context,
                                title: item.statusTitle!.toLowerCase() == "rejected" ? "Rejected".tr : "Expires".tr,
                                color: const Color(0xff3F3F3F),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                family: 'Graphik'),
                            WidgetUtils.appTextWidget(
                                context: context, title: getDateFormat(item.expiryDate!), color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                          ],
                        )
                  : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed"
                  ? Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3))
                  : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed"
                  ? Row(
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
                  ? Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3))
                  : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
              item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(context: context, title: "Sold on".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                        WidgetUtils.appTextWidget(context: context, title: item.soldOn ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   item.statusTitle!.toLowerCase() != "pending" || item.statusTitle!.toLowerCase() != "rejected"
                      ? (int.parse(item.tradeProductBiddingCount!.toString()) != 0 || int.parse(item.buyerInterestCount!.toString()) != 0)
                      ? GestureDetector(
                    onTap: () {
                      // productData.value![0].prodCatId == "2"
                      //     ? Navigator.push(context, MaterialPageRoute(builder: (ctx) => BidderInterestList(productName: item.productTitle ?? "", productId: item.id ?? "")))
                      //     : Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProductBiddingList(productName: item.productTitle ?? "", productId: item.id ?? "")));
                    },
                    child: upComingProduct && int.parse(item.buyerInterestCount.toString()) != 0
                        ? buildContainerWidget(item, upComingProduct, int.parse(item.buyerInterestCount.toString()) != 0 ? true : false)
                        : !upComingProduct && int.parse(item.tradeProductBiddingCount.toString()) != 0
                        ? buildContainerWidget(item, upComingProduct, int.parse(item.tradeProductBiddingCount.toString()) != 0 ? true : false)
                        : Container(),
                  )
                      : Container(width: item.statusTitle!.toLowerCase() != "pending" || item.statusTitle!.toLowerCase() != "rejected" ? 83 : 64)
                      : Container(),
                  const SizedBox(width: 6),
                  item.statusTitle!.toLowerCase() == "sold" || item.statusTitle!.toLowerCase() == "completed"
                      ? Container()
                      : InkWell(
                          onTap: () {
                            quantityController.text = item.sellQty ?? "0";
                            quantityUnitController.text = item.sellQtyUnitTitle ?? "";
                            item.prodCatId != "2" && item.statusTitle!.toLowerCase() != "bid"
                                ? showBiddingBottomSheet(item.id!, item.highestBid ?? "", TextEditingController(text: "₹/" + quantityUnitController.text), item.sellQtyUnit ?? "0")
                                : HelperUtils().showNormalDialog(
                                    context: context,
                                    title: 'Are_you_sure'.tr,
                                    imagePath: interettflag ? "delete_bid" : "add_bid.svg",
                                    content: interettflag ? 'Do you wan to revoke interest?'.tr : 'Do you want to add interest'.tr,
                                    onYesTapped: (value) async {
                                      Navigator.of(value).pop(false);
                                      isLoading.value = true;
                                      setState(() {});
                                      await addInterest(item.id!);
                                      isLoading.value = false;
                                      setState(() {});
                                      //await getProductList();
                                      // Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const BuyerManageProductList(isFrom: ''))).then((value) async {
                                        //if (value == "true") {
                                        setState(() => isLoading.value = true);
                                        await getProductList();
                                        setState(() => isLoading.value = false);
                                        // }
                                      });
                                    });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                            decoration: BoxDecoration(
                                border: Border.all(color: item.prodCatId != "2" ? Colors.orange : Colors.green),
                                borderRadius: BorderRadius.circular(4),
                                color: interettflag ? Colors.green : Colors.transparent),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  item.prodCatId != "2" && item.statusTitle!.toLowerCase() != "bid" ? "assets/images/PlaceBidIcon.svg" : "assets/images/InterestIcon.svg",
                                  color: item.prodCatId != "2" ? Colors.orange : Colors.green,
                                ),
                                const SizedBox(width: 4),
                                item.prodCatId != "2"
                                    ? WidgetUtils.appTextWidget(
                                        context: context, title: "Bid".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: (item.prodCatId != "2") ? Colors.orange : Colors.green, fontSize: 14)
                                    : Container(),
                                (item.prodCatId == "2" && item.buyerInterestCount != "0")
                                    ? WidgetUtils.appTextWidget(context: context, title: item.buyerInterestCount!, fontWeight: FontWeight.w500, family: 'Graphik', color: Colors.green, fontSize: 14)
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                ],
              )
            ],
          ),
        ));
  }

  Future addInterest(String id) async {
    try {
      var param = {"buyer_id": HeaderSingleton().paramsMaps!.userId, "trade_product_id": id};
      final response = await APIService.postAPIMethod(url: ApiURL.addInterest, params: param);
      final data = json.decode(response.body);
      if (data["status"].toString() == "1") {
        WidgetUtils.successDialog(context, data['message']);
        setState(() {});
        await getProductList();
      } else {
        WidgetUtils.errorDialog(context, data['message']);
      }
    } catch (e) {
      setState(() {});
    }
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
        setState(() {});
        await getProductList();
      } else {
        WidgetUtils.successDialog(context, data['message']);
      }
    } catch (e) {
      setState(() {});
    }
  }

  showBiddingBottomSheet(String productId, String highestBidAmt, TextEditingController priceQTYController, String unitId) {
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
                                        controller: priceController,
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
                                    if (priceController.text.isEmpty) {
                                      WidgetUtils.errorDialog(
                                          context, "Please Enter Price".tr);
                                      setState((){});
                                    } else {
                                      HelperUtils().showNormalDialog(
                                          context: context,
                                          title: 'Are_you_sure'.tr,
                                          imagePath: "add_bid.svg",
                                          content: 'Do you want to add bid'.tr,
                                          onYesTapped: (value) async {
                                            Navigator.of(value).pop(false);
                                            isLoading.value = true;
                                            setState(() {});
                                            await addBid(
                                                productId,
                                                quantityController.text,
                                                unitId, priceController.text);
                                            // await getProductList();
                                            isLoading.value = false;
                                            Navigator.pop(ctx);
                                            Navigator.push(
                                                context, MaterialPageRoute(
                                                builder: (ctx) =>
                                                const BuyerManageProductList(
                                                    isFrom: '')))
                                                .then((value) async {
                                              //if (value == "true") {
                                              setState(() =>
                                              isLoading.value = true);
                                              await getProductList();
                                              setState(() =>
                                              isLoading.value = false);
                                              // }
                                            });
                                            setState(() {});
                                            // Navigator.pop(ctx);
                                          });
                                    }
                                    // Navigator.pop(ctx);
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

  void showProductType(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).productTypeList ?? [];
          return StatefulBuilder(builder: (ctx, StateSetter setState) {
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
                              WidgetUtils.appTextWidget(context: context, title: 'Select Product Type'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/cross.svg",
                                    height: 20,
                                  ))
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
                                        productTypeController.text = dssModel[index].title ?? "";
                                        productTypeID = dssModel[index].id.toString();

                                        productController!.text = "";
                                        productID = "";
                                        productVarietyController!.text = "";
                                        productVarietyID = "";

                                        getProduct(productCategoryID, productTypeID);
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

  TextEditingController? productController = TextEditingController();
  TextEditingController? productVarietyController = TextEditingController();
  TextEditingController? fromDateController = TextEditingController();
  TextEditingController? toDateController = TextEditingController();
  TextEditingController? priceRangeTo = TextEditingController();
  TextEditingController? priceRangeFrom = TextEditingController();
  TextEditingController? stateController = TextEditingController();
  TextEditingController? districtController = TextEditingController();
  String productID = "";
  String productVarietyID = "";
  String productTypeID = "";
  bool packaging_flag = false;
  bool logisticPartner_flag = false;
  String stateID = "";
  String district = "";

  void showSheet(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
            return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
              return Padding(
                padding: EdgeInsets.only(bottom: isKeyboardVisible ? 300 : 0),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height * 0.085,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: () {
                                productTypeController.text = "";
                                productController!.text = "";
                                productVarietyController!.text = "";
                                fromDateController!.text = "";
                                toDateController!.text = "";
                                priceRangeTo!.text = "";
                                priceRangeFrom!.text = "";
                                stateController!.text = "";
                                districtController!.text = "";
                                productID = "";
                                productVarietyID = "";
                                productTypeID = "";
                                packaging_flag = true;
                                logisticPartner_flag = true;
                                stateID = "";
                                district = "";
                                setState(() {
                                  getProductList();
                                });
                                Navigator.pop(context);
                              },
                              child: WidgetUtils.appTextWidget(context: context, title: 'Clear Filter'.tr, family: 'Graphik', fontSize: 14, color: Colors.blue)),
                        ),
                        const SizedBox(height: 10),
                        WidgetUtils.appTextWidget(context: context, title: 'Product Type'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                        const SizedBox(height: 08),
                        Container(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * 0.058,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10,bottom:4),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                          // margin: const EdgeInsets.only(right: 16),
                          child: TextField(
                            onTap: () {
                              showProductType(context);
                            },
                            controller: productTypeController,
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                hintText: 'Select Product Type'.tr,
                                border: InputBorder.none,
                                counterText: "",
                                suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(height: 10),
                        WidgetUtils.appTextWidget(context: context, title: 'Product'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                        const SizedBox(height: 08),
                        Container(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * 0.058,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10,bottom:4),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                          // margin: const EdgeInsets.only(right: 16),
                          child: TextField(
                            onTap: () {
                              /*  if (productTypeID == "") {
                          WidgetUtils.errorDialog(
                              context, 'Please Select Product Type'.tr);
                        } else {*/
                              showProduct(context);
                              //}
                            },
                            controller: productController,
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                hintText: 'Select Product'.tr,
                                border: InputBorder.none,
                                counterText: "",
                                suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(height: 10),
                        WidgetUtils.appTextWidget(context: context, title: 'Product Variety'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                        Row(
                          children: [
                            Container(
                              width: (MediaQuery.of(context).size.width) - 20,
                              height: MediaQuery.of(context).size.height * 0.058,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 10,bottom:4),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                              // margin: const EdgeInsets.only(right: 16),
                              child: TextField(
                                onTap: () {
                                  if (productID == "") {
                                    WidgetUtils.errorDialog(context, 'Please Select Product'.tr);
                                  } else {
                                    showProductVariety(context);
                                  }
                                },
                                controller: productVarietyController,
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    hintText: 'Variety'.tr,
                                    border: InputBorder.none,
                                    counterText: "",
                                    suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                                style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: (MediaQuery.of(context).size.width / 2) - 15,
                              height: MediaQuery.of(context).size.height * 0.058,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 10,bottom:4),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                              // margin: const EdgeInsets.only(right: 16),
                              child: TextField(
                                onTap: () {
                                  showStateFilter(context);
                                },
                                controller: stateController,
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    hintText: 'State'.tr,
                                    border: InputBorder.none,
                                    counterText: "",
                                    suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                                style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: (MediaQuery.of(context).size.width / 2) - 15,
                              height: MediaQuery.of(context).size.height * 0.058,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 10,bottom:4),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                              // margin: const EdgeInsets.only(right: 16),
                              child: TextField(
                                onTap: () {
                                  if (stateID == "") {
                                    WidgetUtils.errorDialog(context, 'Please Select State'.tr);
                                  } else {
                                    showDistrictFilter(context);
                                  }
                                },
                                controller: districtController,
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    hintText: 'District'.tr,
                                    border: InputBorder.none,
                                    counterText: "",
                                    suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                                style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        WidgetUtils.appTextWidget(context: context, title:/* Expiration */'Date'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                        const SizedBox(height: 08),
                        Row(
                          children: [
                            Container(
                              width: (MediaQuery.of(context).size.width / 2) - 15,
                              height: MediaQuery.of(context).size.height * 0.058,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 10,bottom:4),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                              // margin: const EdgeInsets.only(right: 16),
                              child: TextField(
                                onTap: () {
                                  dialogSelectDate("from");
                                },
                                controller: fromDateController,
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    hintText: 'From'.tr,
                                    border: InputBorder.none,
                                    counterText: "",
                                    suffixIcon: Icon(Icons.calendar_month_outlined, size:MediaQuery.of(context).size.height*0.024,color: Color(int.parse(themeColor.value.buttonColor!.color!)))),
                                style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: (MediaQuery.of(context).size.width / 2) - 15,
                              height: MediaQuery.of(context).size.height * 0.058,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 10,bottom:4),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                              // margin: const EdgeInsets.only(right: 16),
                              child: TextField(
                                onTap: () {
                                  if (fromDateController!.text.isEmpty) {
                                    WidgetUtils.errorDialog(context, "Please Select From date");
                                  } else {
                                    dialogSelectDate("to");
                                  }
                                },
                                controller: toDateController,
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    hintText: 'To'.tr,
                                    border: InputBorder.none,
                                    counterText: "",
                                    suffixIcon: Icon(Icons.calendar_month_outlined,size:MediaQuery.of(context).size.height*0.02, color: Color(int.parse(themeColor.value.buttonColor!.color!)))),
                                style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        WidgetUtils.appTextWidget(context: context, title: 'Price Range'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                        const SizedBox(height: 08),
                        Row(
                          children: [
                            Container(
                              width: (MediaQuery.of(context).size.width / 2) - 15,
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                children: [
                                  Container(
                                    width: ((MediaQuery.of(context).size.width / 2) * 0.65),
                                    height: MediaQuery.of(context).size.height * 0.058,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(left: 10,bottom:4),
                                    // margin: const EdgeInsets.only(right: 16),
                                    child: TextField(
                                      controller: priceRangeTo,
                                      keyboardType: TextInputType.number,
                                      maxLength: 7,
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                      decoration: InputDecoration(
                                        hintText: 'Min'.tr,
                                        border: InputBorder.none,
                                        counterText: "",
                                      ),
                                      style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey.shade300,
                                    height: MediaQuery.of(context).size.height * 0.058,
                                    width: 1,
                                  ),
                                  Container(
                                    width: ((MediaQuery.of(context).size.width / 2) * 0.25),
                                    height: MediaQuery.of(context).size.height * 0.058,
                                    alignment: Alignment.center,
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                          hintText: '₹'.tr,
                                          counterText: "",
                                          border: InputBorder.none),
                                      style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10
                            ),
                            Container(
                              width: (MediaQuery.of(context).size.width / 2) - 15,
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                children: [
                                  Container(
                                    width: ((MediaQuery.of(context).size.width / 2) * 0.65),
                                    height: MediaQuery.of(context).size.height * 0.058,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(left: 10,bottom:4),
                                    // margin: const EdgeInsets.only(right: 16),
                                    child: TextField(
                                      controller: priceRangeFrom,
                                      keyboardType: TextInputType.number,
                                      maxLength: 7,
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                      decoration: InputDecoration(
                                        hintText: 'Max'.tr,
                                        border: InputBorder.none,
                                        counterText: "",
                                      ),
                                      style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey.shade300,
                                    height: MediaQuery.of(context).size.height * 0.058,
                                    width: 1
                                  ),
                                  Container(
                                    width: ((MediaQuery.of(context).size.width / 2) * 0.25),
                                    height: MediaQuery.of(context).size.height * 0.058,
                                    alignment: Alignment.center,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                          hintText: '₹'.tr,
                                          counterText: "",
                                          border: InputBorder.none),
                                      style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: logisticPartner_flag,
                                  activeColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                                  onChanged: (bool? value) {
                                    state(() {
                                      if (logisticPartner_flag == true) {
                                        logisticPartner_flag = false;
                                      } else {
                                        logisticPartner_flag = true;
                                      }
                                    });
                                  },
                                ),
                                WidgetUtils.appTextWidget(context: context, title: 'Negotiable'.tr, fontSize: 14, fontWeight: FontWeight.w400, family: 'Graphik', textAlign: TextAlign.start),
                              ],
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: packaging_flag,
                                  activeColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                                  onChanged: (bool? value) {
                                    state(() {
                                      if (packaging_flag == true) {
                                        packaging_flag = false;
                                      } else {
                                        packaging_flag = true;
                                      }
                                    });
                                  },
                                ),
                                Container(
                                  child: WidgetUtils.appTextWidget(
                                      context: context, title: 'Quality Certifications'.tr, fontSize: 14, fontWeight: FontWeight.w400, family: 'Graphik', textAlign: TextAlign.start),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        WidgetUtils.buttonWidget(
                            context: context,
                            radius: 8,
                            title: "Apply Filter".tr,
                            size: 18,
                            family: 'Graphik',
                            weight: FontWeight.w500,
                            callback: () {
                              /*  if(productTypeController.text.toString().isEmpty){
                              WidgetUtils.errorDialog(context, 'Please Select product Type'.tr);
                            }else if(productController!.text.toString().isEmpty){
                              WidgetUtils.errorDialog(context, 'Please Enter product name'.tr);
                            }else if(productVarietyController!.text.toString().isEmpty){
                              WidgetUtils.errorDialog(context, 'Please Select product Variety'.tr);
                            }else if(stateController!.text.toString().isEmpty){
                              WidgetUtils.errorDialog(context, 'Please Select State'.tr);
                            }
                            else if(stateController!.text.toString().isEmpty){
                              WidgetUtils.errorDialog(context, 'Please Select State'.tr);
                            }else if(districtController!.text.toString().isEmpty){
                              WidgetUtils.errorDialog(context, 'Please Select District'.tr);
                            }*/
                              if (priceRangeTo!.text.toString().isNotEmpty || priceRangeFrom!.text.toString().isNotEmpty) {
                                if (double.parse(priceRangeTo!.text.toString()) > double.parse(priceRangeFrom!.text.toString())) {
                                  WidgetUtils.errorDialog(context, 'Max prise should be grater than Min Price'.tr);
                                  return;
                                }
                              }
                              getProductList();
                              Navigator.pop(context);
                            },
                            textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                            color: Color(int.parse(themeColor.value.buttonColor!.color!)))
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  ),
                ),
              );
            });
          });
        });
  }

  Future getProduct(String categoryID, String productID) async {
    try {
      var params = {
        /*"product_category": categoryID,*/
        "product_type": productID
      };
      final response = await APIService.postAPIMethod(url: ApiURL.productData, params: params);
      final data = json.decode(response.body);
      final res = NedfiProductType.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setProductData(res.data ?? []);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  void showProduct(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).productList ?? [];
          return StatefulBuilder(builder: (ctx, StateSetter setState) {
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
                              WidgetUtils.appTextWidget(context: context, title: 'Select Product'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/cross.svg",
                                    height: 20,
                                  ))
                            ],
                          )),
                      const SizedBox(height: 10),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4, // Change as per your requirement
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: dssModel.isNotEmpty
                              ? ListView(shrinkWrap: true, children: <Widget>[
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    // Change as per your requirement
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dssModel.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                productController!.text = dssModel[index].title ?? "";
                                                productID = dssModel[index].id ?? "";
                                                productVarietyController!.text = "";
                                                productVarietyID = "";
                                                getProductVariety(productID);
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
                                ])
                              : Center(
                                  child:
                                      WidgetUtils.appTextWidget(context: context, title: 'No Product Available'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                                )),
                    ],
                  ),
                ));
          });
        });
  }

  Future getProductVariety(String productID) async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.productVariety + "/" + productID);
      final data = json.decode(response.body);
      final res = NedfiProductVariety.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setProductVarietyData(res.data ?? []);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  void showProductVariety(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).productVarietyList ?? [];
          return StatefulBuilder(builder: (ctx, StateSetter setState) {
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
                              WidgetUtils.appTextWidget(context: context, title: 'Select Product'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/cross.svg",
                                    height: 20,
                                  ))
                            ],
                          )),
                      const SizedBox(height: 10),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4, // Change as per your requirement
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: dssModel.isNotEmpty
                              ? ListView(shrinkWrap: true, children: <Widget>[
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    // Change as per your requirement
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dssModel.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                productVarietyController!.text = dssModel[index].title ?? "";
                                                productVarietyID = dssModel[index].id ?? "";
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
                                ])
                              : Center(
                                  child: WidgetUtils.appTextWidget(
                                      context: context, title: 'No Product Variety Available'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                                )),
                    ],
                  ),
                ));
          });
        });
  }

  Future dialogSelectDate(String type) async {
    DateTime newDate = DateTime.now();
    DateTime newDates = newDate.subtract(const Duration(days: 350));
    if (type == "to") {
      newDate = DateFormat('yyyy-MM-dd').parse(fromDateController!.text);
      newDates = DateFormat('yyyy-MM-dd').parse(fromDateController!.text);
    }
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime(newDate.year, newDate.month, newDate.day + 1),
      firstDate: DateTime(newDates.year, newDate.month, newDate.day + 1),
      //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(newDate.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(int.parse(themeColor.value.buttonColor!.color!)),
              onPrimary: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
              // <-- SEE HERE
              onSurface: Colors.black87, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color(int.parse(themeColor.value.buttonColor!.color!)), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        if (type == "from") {
          fromDateController!.text = formattedDate;
        } else {
          toDateController!.text = formattedDate;
        }
      });
    } else {}
  }

  TextEditingController controller = TextEditingController();
  TextEditingController controllerOne = TextEditingController();

  List<StateData> _searchResult = [];

  List<CityData> _searchResultOne = [];

  void showStateFilter(BuildContext context) {
    var loanModel = Provider.of<LoanProvider>(context, listen: false);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<LoanProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5, // Change as per your requirement
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context, title: 'Select State'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/cross.svg",
                                    height: 20,
                                  ))
                            ],
                          )),
                      Card(
                        child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.search),
                            title: TextField(
                              controller: controller,
                              decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                              onChanged: (text) {
                                _searchResult.clear();
                                if (text.isEmpty) {
                                  setState(() {});
                                  return;
                                }
                                for (var userDetail in loanModel.stateList) {
                                  if (userDetail.name.toUpperCase().contains(text.toUpperCase())) _searchResult.add(userDetail);
                                }

                                setState(() {});
                              },
                            ),
                            trailing: InkWell(
                                child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                onTap: () {
                                  controller.clear();
                                  _searchResult.clear();
                                  if ("".isEmpty) {
                                    setState(() {});
                                    return;
                                  }
                                  for (var userDetail in loanModel.stateList) {
                                    if (userDetail.name.contains("")) _searchResult.add(userDetail);
                                  }
                                  setState(() {});
                                })),
                      ),
                      SizedBox(
                        height: 350.0, // Change as per your requirement
                        width: 550.0,
                        child: _searchResult.isNotEmpty || controller.text.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: _searchResult.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);

                                        stateController!.text = _searchResult[index].name;
                                        stateID = _searchResult[index].id;
                                        final value = await HelperUtils().getCity(_searchResult[index].id, (value) {}, context);
                                        loanModel.setCity(value!);
                                        districtController!.text = "";
                                        district = "";
                                      },
                                      child: Card(
                                        elevation: 0,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width - 20,
                                                    height: 40,
                                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                    margin: const EdgeInsets.only(bottom: 10),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                                    child: Text(
                                                      _searchResult[index].name,
                                                      textAlign: TextAlign.start,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: 16.0),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ]),
                                      ));
                                },
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: loanModel.stateList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        var loanModel = Provider.of<LoanProvider>(context, listen: false);
                                        stateController!.text = loanModel.stateList[index].name;
                                        final value = await HelperUtils().getCity(loanModel.stateList[index].id, (value) {}, context);
                                        loanModel.setCity(value!);
                                        districtController!.text = "";
                                        district = "";

                                        stateID = loanModel.stateList[index].id;
                                      },
                                      child: Card(
                                        elevation: 0,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width - 20,
                                                    height: 40,
                                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                    margin: const EdgeInsets.only(bottom: 10),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                                    child: Text(
                                                      loanModel.stateList[index].name,
                                                      textAlign: TextAlign.start,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: 16.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ));
                                },
                              ),
                      ),
                    ]),
                  ));
            });
          });
        });
  }

  void showDistrictFilter(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<LoanProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5, // Change as per your requirement
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context, title: 'Select District'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/cross.svg",
                                    height: 20,
                                  ))
                            ],
                          )),
                      Card(
                        child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.search),
                            title: TextField(
                              controller: controllerOne,
                              decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                              onChanged: (text) {
                                _searchResultOne.clear();
                                if (text.isEmpty) {
                                  setState(() {});
                                  return;
                                }
                                for (var userDetail in loanModel.cityList) {
                                  if (userDetail.name.toUpperCase().contains(text.toUpperCase()) || userDetail.name.toLowerCase().contains(text.toLowerCase())) _searchResultOne.add(userDetail);
                                }

                                setState(() {});
                              },
                            ),
                            trailing: InkWell(
                                child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                onTap: () {
                                  controllerOne.clear();
                                  _searchResultOne.clear();
                                  if ("".isEmpty) {
                                    setState(() {});
                                    return;
                                  }
                                  for (var userDetail in loanModel.cityList) {
                                    if (userDetail.name.contains("")) _searchResultOne.add(userDetail);
                                  }
                                  setState(() {});
                                })),
                      ),
                      SizedBox(
                        height: 350.0, // Change as per your requirement
                        width: 550.0,
                        child: _searchResultOne.isNotEmpty || controllerOne.text.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: _searchResultOne.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          districtController!.text = _searchResultOne[index].name;
                                          district = _searchResultOne[index].id;
                                        });
                                      },
                                      child: Card(
                                        elevation: 0,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width - 20,
                                                    height: 40,
                                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                    margin: const EdgeInsets.only(bottom: 10),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                                    child: WidgetUtils.appTextWidget(
                                                        context: context, title: _searchResultOne[index].name, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, fontSize: 16.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ));
                                },
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: loanModel.cityList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          districtController!.text = loanModel.cityList[index].name;
                                          district = loanModel.cityList[index].id;
                                        });
                                      },
                                      child: Card(
                                        elevation: 0,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width - 20,
                                                    height: 40,
                                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                    margin: const EdgeInsets.only(bottom: 10),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                                    child: Text(
                                                      loanModel.cityList[index].name,
                                                      textAlign: TextAlign.start,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: 16.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ));
                                },
                              ),
                      ),
                    ]),
                  ));
            });
          });
        });
  }
}
