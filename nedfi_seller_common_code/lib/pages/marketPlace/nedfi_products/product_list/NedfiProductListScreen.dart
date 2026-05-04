import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/pages/marketPlace/nedfi_products/add_product/AddProductMainScreen.dart';

import '../../../../app_imports.dart';
import '../../../../components/widgets/bottom_sheet_widget.dart';
import '../../../../components/widgets/interested_button_widget.dart';
import '../../../../components/widgets/trade_button_widget.dart';
import '../../../../components/widgets/trade_content_widget.dart';
import '../../../../model/trade_product_model/master_listing_model.dart';
import '../../../../model/trade_product_model/trade_product_info.dart';
import '../../../../providers/master_provider.dart';
import '../product_bidder/bidder_interest_list.dart';
import '../product_bidder/product_bid_list.dart';
import '../trade_product_details.dart';

class NedfiProductListScreen extends StatefulWidget {
  final String isFrom;
  String? status;

  NedfiProductListScreen({super.key, required this.isFrom, this.status});

  @override
  State<NedfiProductListScreen> createState() => _NedfiProductListScreenState();
}

class _NedfiProductListScreenState extends State<NedfiProductListScreen> {
  TextEditingController productCategoryController = TextEditingController(), productTypeController = TextEditingController(text: "All");
  String productCategoryID = "", productStatusID = "";
  int start = 1;
  bool refreshFlag = false;

  /// Getting product master details for Product adding.
  Future getMasterList() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getMasterListing);
      final data = json.decode(response.body);
      final res = MasterListing.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setMasterData(res.data!);
          productCategoryController.text = (res.data?.productCategory?[0].title ?? "");
          productCategoryID = (res.data?.productCategory?[0].id.toString() ?? "");
          if (widget.isFrom == "home") {
            res.data?.tradeStatusList?.forEach((element) {
              if (element.id.toString() == widget.status) {
                productTypeController.text = element.title ?? "";
                productStatusID = element.id.toString();
              }
            });
          }
          getProductList();
        } else {
          getProductList();
        }
      } else {
        getProductList();
      }
    } catch (e) {
      getProductList();
      setState(() {});
    }
  }

  /// Getting all product list from API.
  Future getProductList() async {
    try {
      var param = {"user_id": HeaderSingleton().paramsMaps!.userId, "prod_cat_id": productCategoryID, "trade_status": productStatusID};
      final response = await APIService.postAPIMethod(url: ApiURL.tradeProduct, params: param);
      final data = json.decode(response.body);
      final res = TradeProductInfo.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          setDetails(res.data ?? []);
          setState(() {
            start = start + 1;
          });
        } else {
          setDetails(res.data ?? []);
        }
      } else {
        setDetails(res.data ?? []);
      }
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  /// Setting the provider details as per the trade product.
  void setDetails(dynamic data) {
    var masterProvider = Provider.of<MasterProvider>(context, listen: false);
    masterProvider.setTreadProduct(data);
    productData.value = data;
  }

  /// Refresh trade products whenever page scrolls.
  Future getRefreshProductList() async {
    try {
      if (refreshFlag) {
        return;
      }
      var param = {"user_id": HeaderSingleton().paramsMaps!.userId, "prod_cat_id": productCategoryID, "trade_status": productStatusID, "start": start.toString()};
      // print(param);
      final response = await APIService.postAPIMethod(url: ApiURL.tradeProduct, params: param);
      setState(() {
        refreshFlag = true;
      });
      final data = json.decode(response.body);
      // print(data);
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
      // print(e);
      rethrow;
      //setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getMasterList();
    // getProductList();
  }

  /// Whenever user taps on the device back button it will call the same.
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
                  body: productListBody(masterProvider),
                  floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: InkWell(
                      onTap: () async {
                        var loanModel = Provider.of<MasterProvider>(context, listen: false);
                        loanModel.setProductCurrentIndex(1);
                        loanModel.setItemId("");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductMainScreen(type: "NEW"))).then((value) {
                          getProductList();
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 150,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.add, color: Colors.white),
                            WidgetUtils.appTextWidget(context: context, title: 'Add Product'.tr, color: Colors.white, family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500),
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

  /// Product Body UI widget.
  productListBody(MasterProvider masterProvider) {
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
            height: 58,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16),
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
                  suffixIcon: const Icon(Icons.keyboard_arrow_down)),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 10),
          WidgetUtils.appTextWidget(context: context, title: 'Product Status'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
          const SizedBox(height: 08),
          Container(
            width: double.maxFinite,
            height: 58,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16),
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
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  )),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 10),
          masterProvider.treadProductList.isEmpty
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
                      getRefreshProductList();
                    }
                    return true;
                  },
                  child: Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: masterProvider.treadProductList.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 100),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return productItem(masterProvider.treadProductList[index], masterProvider.treadProductList[index].prodCatId == "2" ? true : false);
                      },
                    ),
                  )),
        ],
      ),
    );
  }

  /// Getting product Item ui widget.
  productItem(TradeProductData item, bool upComingProduct) {
    bool isPending = item.statusTitle?.toLowerCase() != "pending";
    bool isRejected = item.statusTitle?.toLowerCase() != "rejected";
    bool isSold = item.statusTitle?.toLowerCase() == "sold";
    bool isCompleted = item.statusTitle?.toLowerCase() == "completed";
    return GestureDetector(
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (ctx) => TradeProductDetails(productId: item.id!, productTitle: item.productTitle!))).then((value) async {
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
                        WidgetUtils.statusTextWidget(title: item.statusTitle ?? ""),
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
              TradeContentWidget(isStart: true, isActive: true, textTitle: "Variety -".tr + (item.productVarietyTitle ?? ""), textContent: "Type".tr + " - " + (item.productTypeTitle ?? "")),
              TradeContentWidget(isActive: true, textTitle: "Category".tr, textContent: (item.productCategoryTitle ?? "")),
              TradeContentWidget(
                  isActive: true,
                  textTitle: item.prodCatId == "2" ? "Expected Yield".tr : "Quantity".tr,
                  textContent: item.prodCatId == "2"
                      ? ((item.otherDetails?.yieldFrom ?? "0") +
                          " " +
                          (item.otherDetails?.yieldFromUnitText ?? "") +
                          " - " +
                          (item.otherDetails?.yieldTo ?? "0") +
                          " " +
                          (item.otherDetails?.yieldToUnitText ?? ""))
                      : ((item.sellQty ?? "0") + " " + (item.priceUnitTitle ?? ""))),
              TradeContentWidget(isActive: item.prodCatId == "2", textTitle: "Availability".tr, textContent: (item.otherDetails!.availableFrom ?? "") + " - " + (item.otherDetails!.availableTo ?? "")),
              TradeContentWidget(isActive: item.prodCatId == "2", textTitle: "Product Type".tr, textContent: (item.prod_details_title ?? "")),
              TradeContentWidget(isActive: true, textTitle: "Added".tr, textContent: getDateFormat(item.addedDate!)),
              isPending
                  ? item.prodCatId == "2"
                      ? Container()
                      : isSold
                          ? Container()
                          : isCompleted
                              ? Container()
                              :item.statusTitle?.toLowerCase() == "live"?
                                  TradeContentWidget(
                                    isActive: true,
                                    textTitle:item.statusTitle?.toLowerCase() == "expired"?"Expired".tr:"Expires".tr,
                                    textContent: getDateFormat(item.expiryDate!),
                                  )
                                : TradeContentWidget(
                                                isActive: !isRejected,
                                                textTitle:item.statusTitle?.toLowerCase() == "expired"?"Expired".tr:"Expires".tr,
                                                textContent: getDateFormat(item.expiryDate!),
                                              )
                  : Container(),
              !isRejected ? TradeContentWidget(isActive: !isRejected, textTitle: "Rejected".tr, textContent: getDateFormat(item.rejectedDate)) : Container(),
              TradeContentWidget(isActive: isSold || isCompleted, textTitle: "Sold to".tr, textContent: item.soldTO ?? ""),
              TradeContentWidget(isActive: isSold || isCompleted, textTitle: "Sold on".tr, textContent: getDateFormat(item.soldOn ?? "")),
              TradeContentWidget(
                  isActive: isSold || isCompleted, textTitle: "Bid Amount".tr, textContent: "₹" + ((item.tradeProductBidding?.length)! > 0 ? (item.tradeProductBidding?[0].bidPrice ?? "") : "")),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isPending && isRejected
                      ? (int.parse(item.tradeProductBiddingCount!.toString()) != 0 || int.parse(item.buyerInterestCount!.toString()) != 0)
                          ? GestureDetector(
                              onTap: () {
                                item.prodCatId == "2"
                                    ? Navigator.push(context, MaterialPageRoute(builder: (ctx) => BidderInterestList(productName: item.productTitle ?? "", productId: item.id ?? "")))
                                        .then((value) async {
                                        setState(() => isLoading.value = true);
                                        await getProductList();
                                        setState(() => isLoading.value = false);
                                      })
                                    : Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProductBiddingList(productName: item.productTitle ?? "", productId: item.id ?? "")))
                                        .then((value) async {
                                        setState(() => isLoading.value = true);
                                        await getProductList();
                                        setState(() => isLoading.value = false);
                                      });
                              },
                              child: upComingProduct && int.parse(item.buyerInterestCount.toString()) != 0
                                  ? InterestedButtonWidget(
                                      upComingProduct: upComingProduct, isActive: int.parse(item.buyerInterestCount.toString()) != 0 ? true : false, count: item.buyerInterestCount.toString())
                                  : !upComingProduct && int.parse(item.tradeProductBiddingCount.toString()) != 0
                                      ? InterestedButtonWidget(
                                          upComingProduct: upComingProduct,
                                          isActive: int.parse(item.tradeProductBiddingCount.toString()) != 0 ? true : false,
                                          count: item.tradeProductBiddingCount.toString())
                                      : Container(),
                            )
                          : Container(width: isPending || isRejected ? 83 : 64)
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      isSold || isCompleted
                          ? Container()
                          : int.parse(item.buyerInterestCount.toString()) > 0
                              ? Container()
                              : int.parse(item.tradeProductBiddingCount.toString()) > 0
                                  ? Container()
                                  :item.statusTitle?.toLowerCase()=="self sold"?Container(): TradeButtonWidget(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductMainScreen(type: "EDIT", id: item.id))).then((value) {
                                          getProductList();
                                        });
                                      },
                                      buttonName: "Edit".tr,
                                      imagePath: 'edit.svg',
                                      colorCode: 0xffFDA11E,
                                    ),
                      const SizedBox(
                        width: 10,
                      ),
                      isSold || isCompleted
                          ? Container()
                          : int.parse(item.buyerInterestCount.toString()) > 0
                              ? Container()
                              : int.parse(item.tradeProductBiddingCount.toString()) > 0
                                  ? Container()
                                  :item.statusTitle?.toLowerCase()=="self sold"?Container(): TradeButtonWidget(
                                      onTap: () {
                                        if (item.statusTitle?.toLowerCase() != "completed") {
                                          bottomSheetWidget(
                                            ctx: context,
                                            title: 'Are_you_sure'.tr,
                                            imagePath: "delete_bid.svg",
                                            content: 'Do you want to delete Product'.tr,
                                            onTap: (value) async {
                                              Navigator.pop(value);
                                              isLoading.value = true;
                                              setState(() {});
                                              await deleteTradeProduct(context, item.id!, "listing");
                                              await getProductList();
                                              isLoading.value = false;
                                              setState(() {});
                                            },
                                          );
                                        }
                                      },
                                      buttonName: "Delete".tr,
                                      imagePath: 'deleteicon.svg',
                                      colorCode: 0xffE70000,
                                    ),
                      /*isSold || isCompleted*/
                          false? TradeButtonWidget(
                              onTap: () {
                                showRatingSheet(context, (value) async {
                                  isLoading.value = true;
                                  setState(() {});
                                  await addRating(
                                      item.id!,
                                      item.sold_to_buyer_id!,
                                      value == "Happy"
                                          ? "1"
                                          : value == "partial happy"
                                              ? "2"
                                              : "3", () {
                                    setState(() {});
                                  }, context);
                                  Navigator.pop(context);
                                  isLoading.value = false;
                                  setState(() {});
                                },setState);
                              },
                              buttonName: "Rate".tr,
                              imagePath: 'rating.svg',
                              colorCode: 0xffFDA11E,
                            )
                          : Container()
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }

  /// showing product category on dialog.
  void showProductCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final dssModel = Provider.of<MasterProvider>(context, listen: true).masterData?.productCategory ?? [];

        return StatefulBuilder(
          builder: (ctx, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(
                          context: context,
                          title: 'Select Product Category'.tr,
                          color: Colors.black,
                          fontSize: 18,
                          family: 'Graphik',
                          fontWeight: FontWeight.w500,
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(ctx),
                          child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// Product Category List
                    dssModel.isNotEmpty
                        ? SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: dssModel.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = dssModel[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              // Call the outer setState if this method is inside a stateful widget
                              // Otherwise update using your state management logic
                              start = 1;
                              productCategoryController.text = item.title ?? "";
                              productCategoryID = item.id.toString();
                              getProductList();

                              if (productCategoryID == "2") {
                                productTypeController.text = "";
                                productStatusID = "";
                              }
                            },
                            child: Container(

                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(width: 1, color: Colors.grey.shade300),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: WidgetUtils.appTextWidget(
                                  context: context,
                                  title: item.title ?? "",
                                  fontSize: 16,
                                  family: 'Graphik',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: WidgetUtils.appTextWidget(
                        context: context,
                        title: 'No Product Category Available'.tr,
                        color: Colors.black,
                        fontSize: 18,
                        family: 'Graphik',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  /// showing product type on dialog.
  void showProductType(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        List<TradeStatusList> dssModel = [];

        final tradeList = Provider.of<MasterProvider>(context, listen: true).masterData?.tradeStatusList ?? [];

        if (productCategoryID != "2") {
          dssModel = tradeList;
        } else {
          // Exclude IDs 4, 5, 6, 7
          dssModel = tradeList.where((element) => !(element.id == 4 || element.id == 5 || element.id == 6 || element.id == 7)).toList();
        }

        return StatefulBuilder(builder: (ctx, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetUtils.appTextWidget(
                        context: context,
                        title: 'Select Product Status'.tr,
                        color: Colors.black,
                        fontSize: 18,
                        family: 'Graphik',
                        fontWeight: FontWeight.w500,
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(ctx),
                        child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// Product Type List
                  dssModel.isNotEmpty
                      ? SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: dssModel.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = dssModel[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            // Call the outer setState or update state variables
                            start = 1;
                            productTypeController.text = item.title ?? "";
                            productStatusID = item.id.toString();
                            getProductList();
                          },
                          child: Container(

                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 1, color: Colors.grey.shade300),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: WidgetUtils.appTextWidget(
                                context: context,
                                title: item.title ?? "",
                                fontSize: 16,
                                family: 'Graphik',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: WidgetUtils.appTextWidget(
                      context: context,
                      title: 'No Product Type Available'.tr,
                      color: Colors.black,
                      fontSize: 18,
                      family: 'Graphik',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

}
