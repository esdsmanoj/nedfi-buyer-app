import 'package:buyer_common_code/pages/marketPlace/nedfi_products/upload_document.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../app_imports.dart';
import 'buyer_manage_product.dart';

class TradeProductDetails extends StatefulWidget {
  final String productId;
  String? productTitle;
  final String isFrom;

  TradeProductDetails({super.key, required this.productId, this.productTitle, required this.isFrom});

  @override
  State<TradeProductDetails> createState() => _TradeProductDetailsState();
}

class _TradeProductDetailsState extends State<TradeProductDetails> {
  String? addedDate, expiredDate, title;
  TextEditingController quantityController = TextEditingController(), priceController = TextEditingController(), quantityUnitController = TextEditingController();
  var controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  void initState() {
    isLoading.value = true;
    if (widget.productTitle != null) {
      title = widget.productTitle;
    }
    getProductInformation(context, widget.productId, () {
      title = widget.productTitle ?? "";
      isLoading.value = false;
      setState(() {});
    }, prodCatId: productData.value?[0].prodCatId, prodCatStatus: productData.value?[0].prodCatId == "2" ? true : false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (productData.value != null && (productData.value?.isNotEmpty ?? false)) {
      addedDate = getDateFormat(productData.value?[0].addedDate ?? "");
      expiredDate = getDateFormat(productData.value?[0].expiryDate ?? "");
    }

    return SafeArea(
        child: CustomProgressHandler(
      isLoading: isLoading.value,
      loadingText: '',
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          title: WidgetUtils.appTextWidget(context: context, title: title ?? "", fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20, family: 'Graphik'),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ValueListenableBuilder(
              builder: (ctx, value, child) {
                bool interettflag = false;

                int? statusColor;
                List<String>? splitString;
                if (value != null && value.isNotEmpty) {
                  if (value[0].buyerInterest != null && value[0].buyerInterest!.isNotEmpty) {
                    for (var element in value[0].buyerInterest!) {
                      if (element.buyerId == userId) {
                        interettflag = true;
                      }
                    }
                  }
                  splitString = value[0].seasonText!.split(",");
                  statusColor = value[0].statusTitle != null
                      ? value[0].statusTitle!.toLowerCase() == "pending"
                          ? 0xffE8C600
                          : value[0].statusTitle!.toLowerCase() == "live"
                              ? 0xff27914F
                              : value[0].statusTitle!.toLowerCase() == "bid"
                                  ? 0xff27914F
                                  : value[0].statusTitle!.toLowerCase() == "rejected"
                                      ? 0xffE70000
                                      : value[0].statusTitle!.toLowerCase() == "completed"
                                          ? 0xff0074E8
                                          : value[0].statusTitle!.toLowerCase() == "expired"
                                              ? 0xFF808080
                                              : value[0].statusTitle!.toLowerCase() == "sold"
                                                  ? 0xffE88700
                                                  : 0xffffffff
                      : 0xffffffff;
                }
                return value != null && value.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            productData.value![0].prodImages != null ? buildProductImages() : Container(),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    WidgetUtils.appTextWidget(
                                        context: context, title: productData.value![0].productTitle!, color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20, family: 'Graphik'),
                                    const SizedBox(width: 4),
                                    /* Container(
                                    height: 20,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color(statusColor!)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: WidgetUtils.appTextWidget(
                                        context: context, title: value[0].statusTitle ?? "", fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12, family: 'Graphik'),
                                  )*/
                                  ],
                                ),
                                WidgetUtils.appTextWidget(
                                    context: context,
                                    title: "₹${productData.value![0].price!}/${productData.value![0].priceUnitTitle!}",
                                    color: const Color(0xffFDA11E),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    family: 'Graphik'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    WidgetUtils.appTextWidget(context: context, title: "Variety -".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                    const SizedBox(width: 4),
                                    WidgetUtils.appTextWidget(
                                        context: context,
                                        title: productData.value![0].productVarietyTitle!,
                                        color: const Color(0xff3F3F3F),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        family: 'Graphik'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    WidgetUtils.appTextWidget(context: context, title: "Type -".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                    const SizedBox(width: 4),
                                    WidgetUtils.appTextWidget(
                                        context: context, title: productData.value![0].productTypeTitle!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 1),
                            const Divider(),
                            // const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetUtils.appTextWidget(context: context, title: "Category".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                WidgetUtils.appTextWidget(
                                    context: context, title: productData.value![0].productCategoryTitle!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                              ],
                            ),
                            const SizedBox(height: 1),
                            const Divider(),
                            // const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetUtils.appTextWidget(
                                    context: context,
                                    title: productData.value![0].prodCatId == "2" ? "Expected Yield".tr : "Quantity".tr,
                                    color: const Color(0xff3F3F3F),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    family: 'Graphik'),
                                WidgetUtils.appTextWidget(
                                    context: context,
                                    title: productData.value![0].prodCatId == "2"
                                        ? ((productData.value?[0].otherDetails?.yieldFrom ?? "0") +
                                            " " +
                                            (productData.value?[0].otherDetails?.yieldFromUnitText ?? "") +
                                            " - " +
                                            (productData.value?[0].otherDetails?.yieldTo ?? "0") +
                                            " " +
                                            (productData.value?[0].otherDetails?.yieldToUnitText ?? ""))
                                        : ((productData.value?[0].sellQty ?? "0") + " " + (productData.value?[0].priceUnitTitle ?? "")),
                                    color: const Color(0xff3F3F3F),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    family: 'Graphik'),
                              ],
                            ),
                            const SizedBox(height: 1),
                            const Divider(),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetUtils.appTextWidget(context: context, title: "Added".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                WidgetUtils.appTextWidget(context: context, title: addedDate!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                              ],
                            ),
                            value[0].statusTitle!.toLowerCase() != "pending"
                                ? value[0].prodCatId == "2"
                                    ? Container()
                                    : const SizedBox(height: 1)
                                : Container(),
                            value[0].statusTitle!.toLowerCase() != "pending"
                                ? value[0].prodCatId == "2"
                                    ? Container()
                                    : const Divider()
                                : Container(),
                            // value[0].statusTitle!.toLowerCase() != "pending" ? const SizedBox(height: 3) : Container(),
                            value[0].statusTitle!.toLowerCase() != "pending"
                                ? value[0].prodCatId == "2"
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          WidgetUtils.appTextWidget(
                                              context: context,
                                              title: value[0].statusTitle!.toLowerCase() == "rejected" ? "Rejected".tr : "Expires".tr,
                                              color: const Color(0xff3F3F3F),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              family: 'Graphik'),
                                          WidgetUtils.appTextWidget(
                                              context: context, title: expiredDate!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                        ],
                                      )
                                : Container(),
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed" ? const Divider() : Container(),
                            // value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      WidgetUtils.appTextWidget(context: context, title: "Sold to".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                      WidgetUtils.appTextWidget(
                                          context: context, title: value[0].soldTO ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                    ],
                                  )
                                : Container(),
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed" ? const Divider() : Container(),
                            // value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      WidgetUtils.appTextWidget(context: context, title: "Sold on".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                      WidgetUtils.appTextWidget(
                                          context: context, title: value[0].soldOn ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                    ],
                                  )
                                : Container(),
                            const SizedBox(height: 8),
                            value[0].statusTitle!.toLowerCase() == "rejected"
                                ? Container(
                                    height: 30,
                                    width: double.maxFinite,
                                    alignment: Alignment.center,
                                    child: WidgetUtils.appTextWidget(
                                        context: context,
                                        title: "Rejected due to incorrect information".tr,
                                        color: const Color(0xffE70000),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        family: 'Graphik'),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xffFFF2F2)),
                                  )
                                : Container(),
                            const SizedBox(height: 13),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        SvgPicture.asset("assets/images/Happy.svg", height: 20),
                                        WidgetUtils.appTextWidget(
                                            context: context,
                                            title: productData.value![0].ratingDetails?.happyCount.toString() ?? "0",
                                            color: const Color(0xFF000000),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            family: 'Graphik'),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      children: [
                                        SvgPicture.asset("assets/images/partial_happy.svg", height: 20),
                                        WidgetUtils.appTextWidget(
                                            context: context,
                                            title: productData.value![0].ratingDetails?.averageCount.toString() ?? "0",
                                            color: const Color(0xFF000000),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            family: 'Graphik'),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      children: [
                                        SvgPicture.asset("assets/images/sad.svg", height: 20),
                                        WidgetUtils.appTextWidget(
                                            context: context,
                                            title: productData.value![0].ratingDetails?.poorCount.toString() ?? "0",
                                            color: const Color(0xFF000000),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            family: 'Graphik'),
                                      ],
                                    ),
                                  ],
                                ),
                                productData.value![0].statusTitle!.toLowerCase() != "pending" || productData.value![0].statusTitle!.toLowerCase() != "rejected"
                                    ? (int.parse(productData.value![0].tradeProductBiddingCount?.toString() ?? "0") != 0)
                                        ? GestureDetector(
                                            onTap: () {
                                              //   productData.value![0].prodCatId == "2"
                                              //       ? Navigator.push(
                                              //       context, MaterialPageRoute(builder: (ctx) => BidderInterestList(productName: widget.productTitle ?? "", productId: widget.productId ?? "")))
                                              //       : Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProductBiddingList(productName: widget.productTitle, productId: widget.productId)));
                                            },
                                            child: productData.value![0].prodCatId == "2" && int.parse(productData.value![0].buyerInterestCount.toString()) != 0
                                                ? buildContainerWidget(
                                                    productData.value![0].prodCatId == "2" ? true : false, int.parse(productData.value![0].buyerInterestCount.toString()) != 0 ? true : false)
                                                : !(productData.value![0].prodCatId == "2") && int.parse(productData.value![0].tradeProductBiddingCount.toString()) != 0
                                                    ? buildContainerWidget(
                                                        productData.value![0].prodCatId == "2" ? true : false, int.parse(productData.value![0].tradeProductBiddingCount.toString()) != 0 ? true : false)
                                                    : Container(),
                                          )
                                        : Container(width: productData.value![0].statusTitle!.toLowerCase() != "pending" || productData.value![0].statusTitle!.toLowerCase() != "rejected" ? 83 : 64)
                                    : Container(),
                                productData.value![0].prodCatId != "2"
                                    ? productData.value![0].statusTitle!.toLowerCase() != "completed" || productData.value![0].statusTitle!.toLowerCase() != "sold"
                                        ? productData.value![0].statusTitle!.toLowerCase() != "completed"
                                            ? const SizedBox(width: 6)
                                            : Container()
                                        : Container()
                                    : Container(),
                                productData.value![0].prodCatId != "2"
                                    ? productData.value![0].statusTitle!.toLowerCase() != "completed" || productData.value![0].statusTitle!.toLowerCase() != "sold"
                                        ? productData.value![0].statusTitle!.toLowerCase() != "completed"
                                            ? InkWell(
                                                onTap: () {
                                                  if (productData.value![0].statusTitle!.toLowerCase() != "sold" && widget.isFrom != "manage_product") {
                                                    quantityController.text = productData.value![0].sellQty ?? "0";
                                                    quantityUnitController.text = productData.value![0].sellQtyUnitTitle ?? "";
                                                    showBiddingBottomSheet(productData.value![0].id!, productData.value![0].highestBid ?? "",
                                                        TextEditingController(text: "₹/" + quantityUnitController.text), productData.value![0].sellQtyUnit ?? "0");
                                                  }
                                                },
                                                child: Container(
                                                    height: 36,
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: const Color(0xffFDA11E))),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            widget.isFrom == "manage_product"
                                                                ? "assets/images/rating.svg"
                                                                : productData.value![0].statusTitle!.toLowerCase() == "sold"
                                                                    ? "assets/images/rating.svg"
                                                                    : "assets/images/PlaceBidIcon.svg",
                                                            height: 17,
                                                            color: const Color(0xffFDA11E)),
                                                        const SizedBox(width: 4),
                                                        WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: widget.isFrom == "manage_product"
                                                                ? "Rate"
                                                                : productData.value![0].statusTitle!.toLowerCase() == "sold"
                                                                    ? "Rate".tr
                                                                    : "Bid".tr,
                                                            color: const Color(0xffFDA11E),
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            family: 'Graphik'),
                                                      ],
                                                    )),
                                              )
                                            : Container()
                                        : Container()
                                    : InkWell(
                                        onTap: () {
                                          HelperUtils().showNormalDialog(
                                              context: context,
                                              title: 'Are_you_sure'.tr,
                                              imagePath: "add_bid.svg",
                                              content: 'Do you want to add interest'.tr,
                                              onYesTapped: (value) async {
                                                Navigator.of(value).pop(false);
                                                isLoading.value = true;
                                                setState(() {});
                                                await addInterest(productData.value![0].id!);
                                                isLoading.value = false;
                                                setState(() {});
                                              });
                                        },
                                        child: Container(
                                            height: 36,
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.green), color: interettflag ? Colors.green : Colors.transparent),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/images/InterestIcon.svg",
                                                  height: 17,
                                                  color: interettflag ? Colors.white : Colors.green,
                                                ),
                                                const SizedBox(width: 4),
                                                WidgetUtils.appTextWidget(
                                                    context: context,
                                                    title: productData.value![0].buyerInterestCount.toString() ?? "",
                                                    color: interettflag ? Colors.white : Colors.green,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    family: 'Graphik'),
                                              ],
                                            )),
                                      ),
                                // const SizedBox(width: 6),
                              ],
                            ),
                            const SizedBox(height: 11),
                            widget.isFrom == "manage_product"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      productData.value![0].statusTitle!.toLowerCase() == "sold"
                                          ? InkWell(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (ctx) => ServicesScreen(services: homeConfigurableModel.value!.data!.services!)));
                                              },
                                              child: Container(
                                                  height: 36,
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: const Color(0xffFDA11E))),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset("assets/images/services.svg", height: 17, color: const Color(0xffFDA11E)),
                                                      const SizedBox(width: 4),
                                                      WidgetUtils.appTextWidget(
                                                          context: context, title: "Services".tr, color: const Color(0xffFDA11E), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                                                    ],
                                                  )),
                                            )
                                          : Container(),
                                      const SizedBox(width: 6),
                                      productData.value![0].statusTitle!.toLowerCase() == "sold"
                                          ? InkWell(
                                              onTap: () {
                                                if (productData.value![0].tradeProductBidding != null) {
                                                  for (int i = 0; i < productData.value![0].tradeProductBidding!.length; i++) {
                                                    if (productData.value![0].bidderId == productData.value![0].tradeProductBidding![i].id) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (ctxRoute) => UploadDocument(
                                                                  bidDate: productData.value![0].soldBidDate ?? "",
                                                                  productId: productData.value![0].id!,
                                                                  bidderId: productData.value![0].tradeProductBidding![i].id ?? "",
                                                                  buyerName: productData.value![0].soldTO ?? "",
                                                                  isFrom: "view")));
                                                      return;
                                                    }
                                                  }
                                                }
                                              },
                                              child: Container(
                                                  height: 36,
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: const Color(0xffFDA11E))),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset("assets/images/receipt.vg", height: 17, color: const Color(0xffE70000)),
                                                      const SizedBox(width: 4),
                                                      WidgetUtils.appTextWidget(
                                                          context: context, title: "View Receipt".tr, color: const Color(0xffE70000), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                                                    ],
                                                  )),
                                            )
                                          : Container(),
                                      const SizedBox(width: 6),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (chatCTX) => ChatScreen(
                                                        buyerId: productData.value![0].userId!,
                                                        (HeaderSingleton().profileDetails.value?.data[0].firstName ?? "") + " " + (HeaderSingleton().profileDetails.value?.data[0].lastName ?? "") ??
                                                            "",
                                                        "bid",
                                                        tradeProductBiddingId: productData.value![0].bidderId,
                                                      )));
                                        },
                                        child: Container(
                                            height: 36,
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: const Color(0xffFDA11E))),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset("assets/images/chat.svg", height: 17, color: const Color(0xffFDA11E)),
                                                const SizedBox(width: 4),
                                                WidgetUtils.appTextWidget(
                                                    context: context, title: "Chat".tr, color: const Color(0xffFDA11E), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                                              ],
                                            )),
                                      ),
                                    ],
                                  )
                                : Container(),
                            widget.isFrom == "manage_product" ? const SizedBox(height: 11) : const SizedBox(),
                            WidgetUtils.appTextWidget(context: context, title: "Other Details".tr, color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                            const SizedBox(height: 8),
                            value[0].prodCatId == "2"
                                ? Container(
                                    height: 42,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffCFCFCF))),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 123,
                                          child: WidgetUtils.appTextWidget(
                                              context: context, title: "Product Type".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                        ),
                                        const SizedBox(width: 24),
                                        WidgetUtils.appTextWidget(
                                            context: context, title: (value[0].prodDetailsTitle ?? "0"), color: const Color(0xff575757), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                                      ],
                                    ),
                                  )
                                : Container() /*Container(
                            height: 42,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffCFCFCF))),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 123,
                                  child: WidgetUtils.appTextWidget(
                                      context: context, title: "Marketable Surplus".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                ),
                                const SizedBox(width: 24),
                                WidgetUtils.appTextWidget(
                                    context: context,
                                    title: (value[0].surplus ?? "0") + " " + (value[0].surplusUnitTitle ?? "Quintal"),
                                    color: const Color(0xff575757),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    family: 'Graphik'),
                              ],
                            ),
                          )*/
                            ,
                            const SizedBox(height: 8),
                            value[0].prodCatId == "2"
                                ? Container(
                                    height: 60,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffCFCFCF))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 123,
                                          child: WidgetUtils.appTextWidget(
                                              context: context, title: "Availability".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                        ),
                                        const SizedBox(width: 24),
                                        Text("${value[0].otherDetails?.availabilityFrom ?? ""} \n${value[0].otherDetails?.availabilityTo ?? ""}",
                                            maxLines: 2, style: const TextStyle(color: Color(0xff575757), fontWeight: FontWeight.w400, fontSize: 12, fontFamily: 'Graphik')),
                                      ],
                                    ),
                                  )
                                : value[0].prodCatId == "3"
                                    ? Container()
                                    : Container(
                                        height: 60,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffCFCFCF))),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 123,
                                              child: WidgetUtils.appTextWidget(
                                                  context: context, title: "Season".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                            ),
                                            const SizedBox(width: 24),
                                            Text("${splitString![0]}\n${splitString![1].trim()}",
                                                maxLines: 2, style: const TextStyle(color: Color(0xff575757), fontWeight: FontWeight.w400, fontSize: 12, fontFamily: 'Graphik')),
                                          ],
                                        ),
                                      ),
                            const SizedBox(height: 8),
                            Container(
                              height: 42,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffCFCFCF))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 123,
                                    child:
                                        WidgetUtils.appTextWidget(context: context, title: "Logistic".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                  ),
                                  const SizedBox(width: 24),
                                  WidgetUtils.appTextWidget(
                                      context: context, title: value[0].logisticText!, color: const Color(0xff575757), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 42,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffCFCFCF))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 123,
                                    child: WidgetUtils.appTextWidget(
                                        context: context, title: "Packaging".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                  ),
                                  const SizedBox(width: 24),
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: value[0].withPackging == "t" ? (value[0].packagingTitle ?? "-") : "-",
                                      color: const Color(0xff575757),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      family: 'Graphik'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 42,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffCFCFCF))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 123,
                                    child: WidgetUtils.appTextWidget(
                                        context: context, title: "Storage Type".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                  ),
                                  const SizedBox(width: 24),
                                  WidgetUtils.appTextWidget(
                                      context: context, title: value[0].storageTypeTitle ?? "-", color: const Color(0xff575757), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              // height: 42,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffCFCFCF))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 123,
                                    child: WidgetUtils.appTextWidget(
                                        context: context, title: "Pickup Location".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                  ),
                                  const SizedBox(width: 24),
                                  Flexible(
                                    child: WidgetUtils.appTextWidget(
                                        context: context,
                                        title: (value[0].pickupLocation ?? "-") + ", " + value[0].cityName + ", " + value[0].stateName,
                                        color: const Color(0xff575757),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        family: 'Graphik'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffCFCFCF))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 123,
                                    child: WidgetUtils.appTextWidget(
                                        context: context,
                                        title: "Distance of location of produce from highway".tr,
                                        color: const Color(0xff3F3F3F),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        family: 'Graphik'),
                                  ),
                                  const SizedBox(width: 24),
                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.43,
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          WidgetUtils.appTextWidget(
                                              context: context,
                                              title: "${value[0].produceToHighwayDistance} Km" ?? "-",
                                              color: const Color(0xFF575757),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              family: 'Graphik'),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              WidgetUtils.appTextWidget(
                                                  context: context, title: "Railway Station".tr, color: const Color(0xFF575757), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                                              WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: (value[0].otherDistance?.railway.toString() ?? "-") + " Km",
                                                  color: const Color(0xff575757),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  family: 'Graphik'),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              WidgetUtils.appTextWidget(
                                                  context: context, title: "Airport".tr, color: const Color(0xFF575757), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                                              WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: (value[0].otherDistance?.airport.toString() ?? "-") + " Km",
                                                  color: const Color(0xff575757),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  family: 'Graphik'),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              WidgetUtils.appTextWidget(
                                                  context: context, title: "Post Office".tr, color: const Color(0xFF575757), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                                              WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: (value[0].otherDistance?.postOffice.toString() ?? "-") + " Km",
                                                  color: const Color(0xff575757),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  family: 'Graphik'),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              WidgetUtils.appTextWidget(
                                                  context: context, title: "Storage".tr, color: const Color(0xFF575757), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                                              WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: (value[0].otherDistance?.godown!.toString() ?? "-") + " Km",
                                                  color: const Color(0xff575757),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  family: 'Graphik'),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              WidgetUtils.appTextWidget(
                                                  context: context, title: "National Highway".tr, color: const Color(0xFF575757), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                                              WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: (value[0].otherDistance?.nationalHighway.toString() ?? "-") + " Km",
                                                  color: const Color(0xff575757),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  family: 'Graphik'),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              WidgetUtils.appTextWidget(
                                                  context: context, title: "State Highway".tr, color: const Color(0xFF575757), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                                              WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: (value[0].otherDistance?.stateHighway.toString() ?? "-") + " Km",
                                                  color: const Color(0xff575757),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  family: 'Graphik'),
                                            ],
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 42,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffCFCFCF))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 123,
                                    child: WidgetUtils.appTextWidget(
                                        context: context, title: "Advanced Payment".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                  ),
                                  const SizedBox(width: 24),
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: (value[0].advancePayment ?? "0") /*+ "%"*/,
                                      color: const Color(0xff575757),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      family: 'Graphik'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 42,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffCFCFCF))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 123,
                                    child: WidgetUtils.appTextWidget(
                                        context: context, title: 'Negotiable?'.tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                  ),
                                  const SizedBox(width: 24),
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: value[0].negotiations == "t" ? "key_yes".tr : "key_no".tr,
                                      color: const Color(0xff575757),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      family: 'Graphik'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 42,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffCFCFCF))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 123,
                                    child: WidgetUtils.appTextWidget(
                                        context: context, title: "Certifications".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                  ),
                                  const SizedBox(width: 24),
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: value[0].certifcations == "t" ? "key_yes".tr : "key_no".tr,
                                      color: const Color(0xff575757),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      family: 'Graphik'),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Container();
              },
              valueListenable: productData,
            )),
      ),
    ));
  }

  buildContainerWidget(bool upComingProduct, bool isActive) {
    return isActive
        ? Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: const Color(0xff27914F))),
            child: Row(
              children: [
                SvgPicture.asset(productData.value![0].prodCatId == "2" ? "assets/images/InterestIcon.svg" : "assets/images/bids.svg", height: 17, color: const Color(0xff27914F)),
                const SizedBox(width: 4),
                WidgetUtils.appTextWidget(
                    context: context,
                    title: productData.value![0].prodCatId == "2"
                        ? ("${productData.value![0].buyerInterestCount!} " + "Interested".tr)
                        : ("${productData.value![0].tradeProductBiddingCount!} " + "BIDS".tr),
                    color: const Color(0xff27914F),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    family: 'Graphik'),
              ],
            ))
        : Container();
  }

  Widget buildProductImages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          (productData.value![0].allProdImages?.isNotEmpty) ?? false
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.23,
                  width: double.maxFinite,
                  child: CarouselSlider.builder(
                    itemCount: productData.value![0].allProdImages!.length,
                    options: CarouselOptions(
                      // enlargeCenterPage: true,
                      padEnds: true,
                      height: (MediaQuery.of(context).size.height * 0.23),
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      reverse: false,
                      aspectRatio: 1000 / 400,
                      viewportFraction: 2,
                      onPageChanged: (index, reason) async {
                        controller = PageController(viewportFraction: 0.8, keepPage: true, initialPage: index);
                        setState(() {});
                      },
                    ),
                    itemBuilder: (ctx, i, id) {
                      return productData.value![0].allProdImages! != null
                          ? Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: NetworkImage("${HeaderSingleton().configurationDetails!.tradeProducts}/${productData.value![0].allProdImages![i]}"),
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.white)),
                            )
                          : Container();
                    },
                  ))
              : Container(),
          const SizedBox(height: 5),
          SmoothPageIndicator(
            controller: controller,
            count: productData.value![0].allProdImages!.length,
            axisDirection: Axis.horizontal,
            effect: ExpandingDotsEffect(
              dotWidth: 10.0,
              dotHeight: 10.0,
              /*  spacing: 8.0,
              radius: 4.0,

              paintStyle: PaintingStyle.stroke,
              strokeWidth: 1.5,*/
              dotColor: Colors.grey,
              activeDotColor: Color(int.parse(themeColor.value.barColor!.color!)),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Future addInterest(String id) async {
    try {
      var param = {"buyer_id": HeaderSingleton().paramsMaps!.userId, "trade_product_id": id};
      final response = await APIService.postAPIMethod(url: ApiURL.addInterest, params: param);
      final data = json.decode(response.body);
      if (data["status"].toString() == "1") {
        WidgetUtils.successDialog(context, data['message']);
        setState(() {});
        Navigator.pop(context);
        /* getProductInformation(context, widget.productId, () {
          isLoading.value = false;
          setState(() {});
        });*/
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
        Navigator.pop(context);
        /*getProductInformation(context, widget.productId, () {
          isLoading.value = false;
          setState(() {});
        });*/
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
          return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
            return Padding(
              padding: EdgeInsets.only(bottom: isKeyboardVisible ? 300 : 0),
              child: Container(
                  height: 352,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(context: context, title: "Highest Bid".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: Colors.black, fontSize: 16),
                        highestBidAmt == ""
                            ? Container()
                            : WidgetUtils.appTextWidget(context: context, title: "₹$highestBidAmt".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: Colors.black, fontSize: 16),
                      ],
                    ),
                    const SizedBox(height: 12),
                    WidgetUtils.appTextWidget(context: context, title: "Quantity".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: Colors.black, fontSize: 16),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width - 135),
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              readOnly: true,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(hintText: 'Enter Value'.tr, border: InputBorder.none, counterText: ""),
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(color: Colors.grey.shade300, height: 58, width: 1),
                          ),
                          Container(
                            width: 90,
                            height: 58,
                            alignment: Alignment.center,
                            child: TextField(
                              onTap: () {
                                // showUnit(context, "marketable");
                              },
                              controller: quantityUnitController,
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintText: ''.tr,
                                  counterText: "",
                                  border: InputBorder.none,
                                  suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    WidgetUtils.appTextWidget(context: context, title: "Price".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: Colors.black, fontSize: 16),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width - 135),
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              // readOnly: true,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(hintText: 'Enter Value'.tr, border: InputBorder.none, counterText: ""),
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(color: Colors.grey.shade300, height: 58, width: 1),
                          ),
                          Container(
                            width: 90,
                            height: 58,
                            alignment: Alignment.center,
                            child: TextField(
                              onTap: () {
                                // showUnit(context, "marketable");
                              },
                              controller: priceQTYController,
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintText: ''.tr,
                                  counterText: "",
                                  border: InputBorder.none,
                                  suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
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
                            WidgetUtils.errorDialog(context, "Please Enter Price".tr);
                            setState(() {});
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
                                  await addBid(productId, quantityController.text, unitId, priceController.text);
                                  isLoading.value = false;
                                  setState(() {});
                                  Navigator.pop(ctx);
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const BuyerManageProductList(isFrom: ''))).then((value) async {});
                                });
                          }
                        },
                        textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                        color: Color(int.parse(themeColor.value.buttonColor!.color!))),
                  ])),
            );
          });
        });
  }
}
