import 'package:buyer_common_code/pages/marketPlace/nedfi_products/product_list/NedfiProductListScreen.dart';
import 'package:buyer_common_code/pages/marketPlace/nedfi_products/upload_document.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../app_imports.dart';
import '../../../model/trade_product_info.dart';

class ManageTradeProductDetails extends StatefulWidget {
  final String productId;
  String? productTitle;
  final String isFrom;

  ManageTradeProductDetails({super.key, required this.productId, this.productTitle, required this.isFrom});

  @override
  State<ManageTradeProductDetails> createState() => _TradeProductDetailsState();
}

class _TradeProductDetailsState extends State<ManageTradeProductDetails> {
  String? addedDate, expiredDate, title;
  TextEditingController quantityController = TextEditingController(), priceController = TextEditingController(), quantityUnitController = TextEditingController();
  var controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  void initState() {
    isLoading.value = true;
    if (widget.productTitle != null) {
      title = widget.productTitle;
    }
    getManageProductInformation(context, widget.productId, () {
      title = productData.value?[0].productTitle ?? "";
      isLoading.value = false;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              builder: (ctx, List<TradeProductData>? value, child) {
                int? statusColor;
                List<String>? splitString;
                if (value != null && (value?.isNotEmpty ?? false)) {
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

                  addedDate = getDateFormat(value[0].addedDate!);
                  expiredDate = getDateFormat(value[0].expiryDate!);
                }
                return value != null && (value?.isNotEmpty ?? false)
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            value[0].prodImages != null ? buildProductImages(value) : Container(),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    WidgetUtils.appTextWidget(context: context, title: value[0].productTitle!, color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20, family: 'Graphik'),
                                    const SizedBox(width: 4),
                                    value[0].manageProductStatus == null
                                        ? Container()
                                        : WidgetUtils.statusTextWidget(title: value[0].statusTitle!.toLowerCase() == "self sold" ? "Sold" : value[0].manageProductStatus ?? ""),
                                  ],
                                ),
                                WidgetUtils.appTextWidget(
                                    context: context,
                                    title: "₹${value[0].price!}/${value[0].priceUnitTitle!}",
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
                                        context: context, title: value[0].productVarietyTitle!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    WidgetUtils.appTextWidget(context: context, title: "Type -".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                    const SizedBox(width: 4),
                                    WidgetUtils.appTextWidget(
                                        context: context, title: value[0].productTypeTitle!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 1),
                            const Divider(),
                            const SizedBox(height: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetUtils.appTextWidget(context: context, title: "Category".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                WidgetUtils.appTextWidget(
                                    context: context, title: value[0].productCategoryTitle!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                              ],
                            ),
                            const SizedBox(height: 1),
                            const Divider(),
                            const SizedBox(height: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetUtils.appTextWidget(
                                    context: context,
                                    title: value[0].prodCatId == "2" ? "Expected Yield".tr : "Quantity".tr,
                                    color: const Color(0xff3F3F3F),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    family: 'Graphik'),
                                WidgetUtils.appTextWidget(
                                    context: context,
                                    title: value[0].prodCatId == "2"
                                        ? ((value[0].otherDetails?.yieldFrom ?? "0") +
                                            " " +
                                            (value[0].otherDetails?.yieldFromUnitText ?? "") +
                                            " - " +
                                            (value[0].otherDetails?.yieldTo ?? "0") +
                                            " " +
                                            (value[0].otherDetails?.yieldToUnitText ?? ""))
                                        : ((value[0].sellQty ?? "0") + " " + (value[0].priceUnitTitle ?? "")),
                                    color: const Color(0xff3F3F3F),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    family: 'Graphik'),
                              ],
                            ),
                            const SizedBox(height: 1),
                            const Divider(),
                            const SizedBox(height: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetUtils.appTextWidget(context: context, title: "Added".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                WidgetUtils.appTextWidget(context: context, title: addedDate!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                              ],
                            ),
                            value[0].statusTitle!.toLowerCase() != "pending"
                                ? value[0].statusTitle!.toLowerCase() == "completed"
                                    ? Container()
                                    : value[0].statusTitle!.toLowerCase() == "sold"
                                        ? Container()
                                        : const SizedBox(height: 1)
                                : Container(),
                            value[0].statusTitle!.toLowerCase() != "pending"
                                ? value[0].statusTitle!.toLowerCase() == "completed"
                                    ? Container()
                                    : value[0].statusTitle!.toLowerCase() == "sold"
                                        ? Container()
                                        : const Divider(height: 3)
                                : Container(),
                            value[0].statusTitle!.toLowerCase() != "pending"
                                ? value[0].statusTitle!.toLowerCase() == "completed"
                                    ? Container()
                                    : value[0].statusTitle!.toLowerCase() == "sold"
                                        ? Container()
                                        : const SizedBox(height: 1)
                                : Container(),
                            value[0].statusTitle!.toLowerCase() != "pending" && value[0].prodCatId != '2'
                                ? value[0].statusTitle!.toLowerCase() == "completed" || value[0].statusTitle!.toLowerCase() == "sold"
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          WidgetUtils.appTextWidget(
                                              context: context,
                                              title: /*value[0].manageProductStatus?.toLowerCase() == "rejected" ? "Rejected".tr :*/ "Expires".tr,
                                              color: const Color(0xff3F3F3F),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              family: 'Graphik'),
                                          WidgetUtils.appTextWidget(
                                              context: context, title: expiredDate!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                        ],
                                      )
                                : Container(),
                            /*value[0].statusTitle!.toLowerCase() != "pending"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      WidgetUtils.appTextWidget(
                                          context: context,
                                          title: "Bid Amount".tr,
                                          color: const Color(0xff3F3F3F),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          family: 'Graphik'),
                                      WidgetUtils.appTextWidget(context: context, title: value[0].tradeProductBidding?[0].bidPrice??"", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                    ],
                                  )
                                : Container(),*/
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed"
                                ? /*userId == value[0].soldToBuyerId
                                    ? */
                                const SizedBox(height: 1)
                                /*  : Container()*/
                                : Container(),
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed"
                                ? /*userId == value[0].soldToBuyerId
                                    ?*/
                                const Divider()
                                /*    : Container()*/
                                : Container(),
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed"
                                ? /*userId == value[0].soldToBuyerId
                                    ?*/
                                const SizedBox(height: 1)
                                /* : Container()*/
                                : Container(),
                            // value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed"
                                ? value[0].soldTO == null
                                    ? Container()
                                    : /*userId == value[0].soldToBuyerId
                                        ?*/
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          WidgetUtils.appTextWidget(
                                              context: context, title: "Sold to".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                          WidgetUtils.appTextWidget(
                                              context: context, title: value[0].soldTO ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                        ],
                                      )
                                /*: Container()*/
                                : Container(),
                            value[0].statusTitle!.toLowerCase() == "self sold" ? const SizedBox(height: 1) : Container(),
                            value[0].statusTitle!.toLowerCase() == "self sold" ? const Divider() : Container(),
                            // value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
                            value[0].statusTitle!.toLowerCase() == "self sold"
                                ? userId == value[0].soldToBuyerId
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          WidgetUtils.appTextWidget(
                                              context: context, title: "Sold to".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                          WidgetUtils.appTextWidget(
                                              context: context, title: "Sold out of system", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                        ],
                                      )
                                : Container(),
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed"
                                ? value[0].soldOn == null
                                    ? Container()
                                    : /*userId == value[0].soldToBuyerId
                                        ?*/
                                    const Divider()
                                /* : Container()*/
                                : Container(),
                            // value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
                            value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed"
                                ? value[0].soldOn == null
                                    ? Container()
                                    : /*userId == value[0].soldToBuyerId
                                        ?*/
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          WidgetUtils.appTextWidget(
                                              context: context, title: "Sold on".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                          WidgetUtils.appTextWidget(
                                              context: context,
                                              title: getDateFormat(value[0].soldOn ?? ""),
                                              color: const Color(0xff3F3F3F),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              family: 'Graphik'),
                                        ],
                                      )
                                /*: Container()*/
                                : Container(),
                            value[0].statusTitle?.toLowerCase() == "self sold" || value[0].statusTitle?.toLowerCase() == "sold" || value[0].statusTitle?.toLowerCase() == "completed"
                                ? Container()
                                : (value[0].manageProductStatusId != "3" && value[0].manageProductStatusId != "2") && value[0].manageProductStatusId != "null"
                                    ? const SizedBox(height: 1)
                                    : value[0].manageProductStatusId == "3" && value[0].manageProductStatusId != "null"
                                        ? const SizedBox(height: 1)
                                        : Container(),
                            value[0].statusTitle?.toLowerCase() == "self sold" || value[0].statusTitle?.toLowerCase() == "sold" || value[0].statusTitle?.toLowerCase() == "completed"
                                ? Container()
                                : (value[0].manageProductStatusId != "3" && value[0].manageProductStatusId != "2") && value[0].manageProductStatusId != "null"
                                    ? const Divider(height: 3)
                                    : value[0].manageProductStatusId == "3" && value[0].manageProductStatusId != "null"
                                        ? const Divider(height: 3)
                                        : Container(),
                            value[0].statusTitle?.toLowerCase() == "self sold" || value[0].statusTitle?.toLowerCase() == "sold" || value[0].statusTitle?.toLowerCase() == "completed"
                                ? Container()
                                : (value[0].manageProductStatusId != "3" && value[0].manageProductStatusId != "2") && value[0].manageProductStatusId != "null"
                                    ? const SizedBox(height: 1)
                                    : value[0].manageProductStatusId == "3" && value[0].manageProductStatusId != "null"
                                        ? const SizedBox(height: 1)
                                        : Container(),
                            value[0].statusTitle?.toLowerCase() == "self sold" || value[0].statusTitle?.toLowerCase() == "sold" || value[0].statusTitle?.toLowerCase() == "completed"
                                ? Container()
                                : (value[0].manageProductStatusId != "3" && value[0].manageProductStatusId != "2") && value[0].manageProductStatusId != "null"
                                    ? value[0].manageProductStatusId == "1"
                                        ? Container()
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              WidgetUtils.appTextWidget(
                                                  context: context, title: "Rejected date".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                              WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: getDateFormat(value[0].bid_rejected_date ?? ""),
                                                  color: const Color(0xff3F3F3F),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  family: 'Graphik'),
                                            ],
                                          )
                                    : (value[0].manageProductStatusId == "3" && value[0].prodId != "2") && value[0].manageProductStatusId != "null"
                                        ? value[0].manageProductStatusId == "1"
                                            ? Container()
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  WidgetUtils.appTextWidget(
                                                      context: context, title: "Rejected date".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                                  WidgetUtils.appTextWidget(
                                                      context: context,
                                                      title: getDateFormat(value[0].bid_rejected_date ?? ""),
                                                      color: const Color(0xff3F3F3F),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 14,
                                                      family: 'Graphik'),
                                                ],
                                              )
                                        : Container(),
                            value[0].statusTitle?.toLowerCase() == "self sold"
                                ? Container()
                                : value[0].manageProductStatusId == "3"
                                    ? const SizedBox(height: 1)
                                    : Container(),
                            value[0].statusTitle?.toLowerCase() == "self sold"
                                ? Container()
                                : value[0].manageProductStatusId == "2"
                                    ? const Divider(height: 3)
                                    : Container(),
                            value[0].statusTitle?.toLowerCase() == "self sold"
                                ? Container()
                                : value[0].manageProductStatusId == "2"
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          WidgetUtils.appTextWidget(
                                              context: context, title: "Revoked date".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                          WidgetUtils.appTextWidget(
                                              context: context,
                                              title: getDateFormat(value[0].bid_revoked_date ?? ""),
                                              color: const Color(0xff3F3F3F),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              family: 'Graphik'),
                                        ],
                                      )
                                    : Container(),
                            const SizedBox(height: 12),
                            value[0].manageProductStatusId == "2" ? const SizedBox(height: 5) : Container(height: 5),
                            /*  (value[0].bidStatus == "2") ? Container() : const Divider(),
                            (value[0].bidStatus == "2") ? const SizedBox(height: 5) : Container(),
                            (value[0].bidStatus == "2")
                                ? Container()
                                : value[0].bidPlaceDate != null && value[0].prodCatId != "2"
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          WidgetUtils.appTextWidget(
                                              context: context, title: "Bid Date".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                          WidgetUtils.appTextWidget(
                                              context: context,
                                              title: getDateFormat(value[0].bidPlaceDate ?? ""),
                                              color: const Color(0xff3F3F3F),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              family: 'Graphik')
                                        ],
                                      )
                                    : Container(),
                            const SizedBox(height: 12),*/
                            /* value[0].statusTitle!.toLowerCase() == "bid"
                                ?*/

                            Stack(
                              children: [
                                productData.value![0].statusTitle!.toLowerCase() != "sold" || productData.value![0].statusTitle!.toLowerCase() != "completed"
                                    ? Row(
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
                                      )
                                    : Container(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    value[0].statusTitle!.toLowerCase() != "pending" || value[0].statusTitle!.toLowerCase() != "rejected"
                                        ? ((value[0].tradeProductBiddingCount != null && value[0].tradeProductBiddingCount != "null")
                                                    ? (int.parse(value[0].tradeProductBiddingCount?.toString() ?? "0") != 0)
                                                    : false) ||
                                                ((value[0].buyerInterestCount != null && value[0].buyerInterestCount != "null")
                                                    ? (int.parse(value[0].buyerInterestCount?.toString() ?? "0") != 0)
                                                    : false)
                                            ? GestureDetector(
                                                onTap: () {},
                                                child: value[0].prodCatId == "2" && int.parse(value[0].buyerInterestCount.toString()) != 0
                                                    ? Container()
                                                    : !(value[0].prodCatId == "2") && int.parse(value[0].tradeProductBiddingCount.toString()) != 0
                                                        ? buildContainerWidget(
                                                            value, value[0].prodCatId == "2" ? true : false, int.parse(value[0].tradeProductBiddingCount.toString()) != 0 ? true : false)
                                                        : Container(width: 10),
                                              )
                                            : Container(width: value[0].statusTitle!.toLowerCase() != "pending" || value[0].statusTitle!.toLowerCase() != "rejected" ? 83 : 64)
                                        : Container(),
                                    const SizedBox(width: 6),
                                    value[0].status?.toLowerCase() == "3" && value[0].prodCatId != "2"
                                        ? InkWell(
                                            onTap: () {
                                              quantityUnitController.text = value[0].sellQtyUnitTitle ?? "";
                                              quantityController.text = value[0].sellQty ?? "";
                                              if (value[0].tradeProductBidding!.isNotEmpty) {
                                                priceController.text = value[0].tradeProductBidding?.last.bidPrice ?? "";
                                              } else {
                                                priceController.text = "";
                                              }

                                              showBiddingBottomSheet(
                                                  value[0].id!, value[0].highestBid ?? "0", TextEditingController(text: "₹/" + quantityUnitController.text), value[0].sellQtyUnit ?? "0");
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                              decoration: BoxDecoration(border: Border.all(color: Colors.orange), borderRadius: BorderRadius.circular(4)),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset("assets/images/edit.svg"),
                                                  const SizedBox(width: 4),
                                                  WidgetUtils.appTextWidget(context: context, title: "Edit Bid".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: Colors.orange, fontSize: 14),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    const SizedBox(width: 6),

                                    value[0].prodCatId != "2"
                                        ? (value[0].manageProductStatusId == "3" || value[0].manageProductStatusId == "1" || value[0].manageProductStatusId == "2")
                                            ? Container()
                                            : value[0].statusTitle!.toLowerCase() != "completed" || value[0].statusTitle!.toLowerCase() != "sold"
                                                ? value[0].statusTitle!.toLowerCase() != "completed"
                                                    ? (userId == value[0].soldToBuyerId)
                                                        ? const SizedBox(width: 6)
                                                        : Container()
                                                    : Container()
                                                : Container()
                                        : Container(),
                                    value[0].prodCatId != "2"
                                        ? (value[0].manageProductStatusId == "3" || value[0].manageProductStatusId == "1" || value[0].manageProductStatusId == "2")
                                            ? Container()
                                            : /*value[0].statusTitle!.toLowerCase() != "completed" || value[0].statusTitle!.toLowerCase() != "sold"
                                                ?*/
                                            value[0].statusTitle!.toLowerCase() == "completed" || value[0].statusTitle!.toLowerCase() == "sold"
                                                ? (userId == value[0].soldToBuyerId)
                                                    ? InkWell(
                                                        onTap: () {
                                                          if (value[0].statusTitle!.toLowerCase() != "sold" && widget.isFrom != "manage_product") {
                                                            quantityController.text = value[0].sellQty ?? "0";
                                                            quantityUnitController.text = value[0].sellQtyUnitTitle ?? "";
                                                            showBiddingBottomSheet(
                                                                value[0].id!, value[0].highestBid ?? "", TextEditingController(text: "₹/" + quantityUnitController.text), value[0].sellQtyUnit ?? "0");
                                                          } else if (value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed") {
                                                            showRatingSheet(ctx, value[0].tradeProductBidding![0].sellerId!, value[0].id!);
                                                          }
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                            height: 36,
                                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: const Color(0xffFDA11E))),
                                                            child: Row(
                                                              children: [
                                                                SvgPicture.asset(
                                                                    value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed"
                                                                        ? "assets/images/rating.svg"
                                                                        : "assets/images/PlaceBidIcon.svg",
                                                                    height: 17,
                                                                    color: const Color(0xffFDA11E)),
                                                                const SizedBox(width: 4),
                                                                WidgetUtils.appTextWidget(
                                                                    context: context,
                                                                    title: value[0].statusTitle!.toLowerCase() == "sold" || value[0].statusTitle!.toLowerCase() == "completed" ? "Rate".tr : "Bid".tr,
                                                                    color: const Color(0xffFDA11E),
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 14,
                                                                    family: 'Graphik'),
                                                              ],
                                                            )),
                                                      )
                                                    : Container()
                                                : Container()
                                        //: Container()
                                        : InkWell(
                                            onTap: () {
                                              HelperUtils().showNormalDialog(
                                                  context: context,
                                                  title: 'Are_you_sure'.tr,
                                                  imagePath: "delete_bid.svg",
                                                  content: 'Do you want to revoke interest'.tr,
                                                  onYesTapped: (values) async {
                                                    Navigator.of(values).pop(false);
                                                    isLoading.value = true;
                                                    setState(() {});
                                                    await addInterest(value[0].id!);
                                                    isLoading.value = false;
                                                    setState(() {});
                                                  });
                                            },
                                            child: Container(
                                                height: 36,
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xff27914F), border: Border.all(width: 1, color: Colors.green)),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset("assets/images/InterestIcon.svg", height: 17, color: Colors.white),
                                                    const SizedBox(width: 4),
                                                    WidgetUtils.appTextWidget(
                                                        context: context,
                                                        title: value[0].buyerInterestCount.toString() ?? "",
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14,
                                                        family: 'Graphik'),
                                                  ],
                                                )),
                                          ),
                                    // const SizedBox(width: 6),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            widget.isFrom == "manage_product"
                                ? (value[0].manageProductStatusId == "3" || value[0].manageProductStatusId == "1" || value[0].manageProductStatusId == "2")
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          value[0].statusTitle!.toLowerCase() == "sold"
                                              ? (userId == value[0].soldToBuyerId)
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
                                                  : Container()
                                              : Container(),
                                          const SizedBox(width: 6),
                                          (userId == value[0].soldToBuyerId)
                                              ? /*value[0].statusTitle!.toLowerCase() == "sold" ||*/ value[0].statusTitle!.toLowerCase() == "completed"
                                                  ? InkWell(
                                                      onTap: () {
                                                        if (value[0].tradeProductBidding != null) {
                                                          for (int i = 0; i < value[0].tradeProductBidding!.length; i++) {
                                                            if (value[0].bidderId == value[0].tradeProductBidding![i].id) {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (ctxRoute) => UploadDocument(
                                                                          bidDate: value[0].soldBidDate ?? "",
                                                                          productId: value[0].id!,
                                                                          bidderId: value[0].tradeProductBidding![i].id ?? "",
                                                                          buyerName: value[0].soldTO ?? "",
                                                                          isFrom: "view")));
                                                              return;
                                                            }
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                          height: 36,
                                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: const Color(0xffE70000))),
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset("assets/images/receipt.svg", height: 17, color: const Color(0xffE70000)),
                                                              const SizedBox(width: 4),
                                                              WidgetUtils.appTextWidget(
                                                                  context: context,
                                                                  title: "View Receipt".tr,
                                                                  color: const Color(0xffE70000),
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 14,
                                                                  family: 'Graphik'),
                                                            ],
                                                          )),
                                                    )
                                                  : Container()
                                              : Container(),
                                          const SizedBox(width: 6),
                                          (userId == productData.value?[0].soldToBuyerId)
                                              ? InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (chatCTX) => ChatScreen(
                                                                  buyerId: value[0].userId!,
                                                                  (HeaderSingleton().profileDetails.value?.data[0].firstName ?? "") +
                                                                          " " +
                                                                          (HeaderSingleton().profileDetails.value?.data[0].lastName ?? "") ??
                                                                      "",
                                                                  "bid",
                                                                  /* isManage: 'manage',*/
                                                                  prodId: widget.productId,
                                                                  tradeProductBiddingId: value[0].bidderId,
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
                                                )
                                              : Container(),
                                        ],
                                      )
                                : Container(),
                            widget.isFrom == "manage_product" ? const SizedBox(height: 11) : const SizedBox(),
                            (value[0].statusTitle?.toLowerCase() == "expired")
                                ? Container()
                                : ((value[0].tradeProductBidding?.isNotEmpty ?? false) &&
                                        (value[0].manageProductStatusId == "3" ||
                                            value[0].manageProductStatusId == "2" ||
                                            value[0].manageProductStatusId == "1" ||
                                            value[0].manageProductStatusId == "4" ||
                                            value[0].manageProductStatusId == "5"))
                                    ? Container(
                                        // height: MediaQuery.of(context).size.height * 0.2,
                                        width: double.maxFinite,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                WidgetUtils.appTextWidget(
                                                    context: context, title: "Bid Amount".tr, color: const Color(0xffFDA11E), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                                                WidgetUtils.appTextWidget(
                                                    context: context,
                                                    title: "₹${value[0].tradeProductBidding?[0].bidPrice ?? " "}/${value[0].priceUnitTitle}".tr,
                                                    color: const Color(0xffFDA11E),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    family: 'Graphik'),
                                              ],
                                            ),
                                            value[0].prodCatId == "2"
                                                ? const SizedBox(height: 12)
                                                : value[0].manageProductStatusId == "3"
                                                    ? Container()
                                                    : value[0].bidPlaceDate == null
                                                        ? Container()
                                                        : const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                WidgetUtils.appTextWidget(
                                                    context: context,
                                                    title: value[0].prodCatId == "2" ? "Expected Yield".tr : "Quantity".tr,
                                                    color: const Color(0xffFDA11E),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    family: 'Graphik'),
                                                WidgetUtils.appTextWidget(
                                                    context: context,
                                                    title: value[0].prodCatId == "2"
                                                        ? ("₹" +
                                                            (value[0].otherDetails?.yieldFrom ?? "0") +
                                                            " " +
                                                            (value[0].otherDetails?.yieldFromUnitText ?? "") +
                                                            " - " +
                                                            (value[0].otherDetails?.yieldTo ?? "0") +
                                                            " " +
                                                            (value[0].otherDetails?.yieldToUnitText ?? ""))
                                                        : ((value[0].sellQty ?? "0") + " " + (value[0].priceUnitTitle ?? "")),
                                                    color: const Color(0xffFDA11E),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    family: 'Graphik'),
                                              ],
                                            ),
                                            value[0].prodCatId == "2" && value[0].bidPlaceDate == null
                                                ? Container()
                                                : value[0].manageProductStatusId == "3"
                                                    ? Container()
                                                    : const SizedBox(height: 12),
                                            value[0].prodCatId == "2" && value[0].bidPlaceDate == null
                                                ? Container()
                                                : /*value[0].manageProductStatusId == "3"
                                                    ? Container()
                                                    :*/
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      WidgetUtils.appTextWidget(
                                                          context: context, title: "Bid Date".tr, color: const Color(0xffFDA11E), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                                                      WidgetUtils.appTextWidget(
                                                          context: context,
                                                          title: getDateFormat(value[0].bidPlaceDate ?? ""),
                                                          color: const Color(0xffFDA11E),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                          family: 'Graphik'),
                                                    ],
                                                  ),
                                            const SizedBox(height: 8),
                                            userId == value[0].soldToBuyerId
                                                ? (value[0].manageProductStatusId == "2" || value[0].manageProductStatusId == "5")
                                                    ? Container()
                                                    : !value[0].revokeExpire!
                                                        ? Container()
                                                        : InkWell(
                                                            onTap: () async {
                                                              showBidBottomSheet(
                                                                  imagePath: "delete_bid.svg",
                                                                  ctx,
                                                                  "Confirm Bid Revoke".tr,
                                                                  "Are you sure you want to revoke this bid?".tr,
                                                                  value[0].tradeProductBidding![0],
                                                                  "2",
                                                                  value);
                                                            },
                                                            child: Container(
                                                                width: double.maxFinite,
                                                                height: 36,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFE70000))),
                                                                child: SizedBox(
                                                                  width: 90,
                                                                  child: Row(children: [
                                                                    SvgPicture.asset("assets/images/cross_icon_button.svg", height: 16),
                                                                    const SizedBox(width: 8),
                                                                    WidgetUtils.appTextWidget(
                                                                        context: context,
                                                                        title: "Revoked".tr,
                                                                        color: const Color(0xFFE70000),
                                                                        family: 'Graphik',
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w500),
                                                                  ]),
                                                                )),
                                                          )
                                                : Container(),
                                            userId == value[0].soldToBuyerId
                                                ? Container()
                                                : value[0].manageProductStatusId == "3" || value[0].manageProductStatusId == "4" || value[0].manageProductStatusId == "5"
                                                    ? Container()
                                                    : value[0].manageProductStatusId == "2"
                                                        ? Container()
                                                        : InkWell(
                                                            onTap: () async {
                                                              showBidBottomSheet(
                                                                  imagePath: "delete_bid.svg",
                                                                  ctx,
                                                                  "Confirm Bid cancellation".tr,
                                                                  "Are you sure you want to cancel this bid?".tr,
                                                                  value[0].tradeProductBidding![0],
                                                                  "3",
                                                                  value);
                                                            },
                                                            child: Container(
                                                                width: double.maxFinite,
                                                                height: 36,
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFE70000))),
                                                                child: SizedBox(
                                                                  width: 90,
                                                                  child: Row(children: [
                                                                    SvgPicture.asset("assets/images/cross_icon_button.svg", height: 16),
                                                                    const SizedBox(width: 8),
                                                                    WidgetUtils.appTextWidget(
                                                                        context: context,
                                                                        title: "Cancel".tr,
                                                                        color: const Color(0xFFE70000),
                                                                        family: 'Graphik',
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.w500),
                                                                  ]),
                                                                )),
                                                          ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.5, color: const Color(0xffFDA11E)), color: const Color(0xffFDA11E).withOpacity(0.2)),
                                      )
                                    : Container(),
                            const SizedBox(height: 13),
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
                                        title: (value[0].pickupLocation ?? "-") + ", " + (value[0].cityName ?? "") + ", " + (value[0].stateName ?? ""),
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
                                      title: (value[0].advancePayment ?? "0") + ((value[0].advancePayment.toString().toLowerCase() == "payment after delivery") ? "" : "%" ?? ""),
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

  buildContainerWidget(value, bool upComingProduct, bool isActive) {
    return isActive
        ? Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
            decoration: value[0].prodCatId == "2"
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(4), color: const Color(0xff27914F), border: Border.all(width: 1, color: value[0].prodCatId == "2" ? Colors.white : const Color(0xff27914F)))
                : null,
            child: Row(
              children: [
                SvgPicture.asset(value[0].prodCatId == "2" ? "assets/images/InterestIcon.svg" : "assets/images/bids.svg", height: 17, color: const Color(0xff27914F)),
                const SizedBox(width: 4),
                WidgetUtils.appTextWidget(
                    context: context,
                    title: value[0].prodCatId == "2" ? ("${value[0].buyerInterestCount!} ") : ("${value[0].tradeProductBiddingCount!} " + "BIDS".tr),
                    color: value[0].prodCatId == "2" ? Colors.white : const Color(0xff27914F),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    family: 'Graphik'),
              ],
            ))
        : Container();
  }

  showBidBottomSheet(BuildContext ctx, String title, String message, ProductBidder bidder, String action, value, {String? imagePath}) {
    showModalBottomSheet(
        context: ctx,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14.0))),
        builder: (newCtx) {
          return SizedBox(
              height: imagePath != null ? MediaQuery.of(context).size.height * 0.364 : MediaQuery.of(context).size.height * 0.264,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  imagePath == null ? Container() : SvgPicture.asset("assets/images/$imagePath", height: 108, width: 108),
                  WidgetUtils.appTextWidget(context: context, title: title.tr, color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                  const SizedBox(height: 8),
                  WidgetUtils.appTextWidget(context: context, title: message.tr, color: const Color(0xFF516971), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() => isLoading.value = true);
                          final params = {'id': bidder.id!, 'status': action, 'product_id': value[0].id!, 'seller_id': bidder.sellerId!, 'buyer_id': userId};
                          await performBuyerAction(params, newCtx);
                          // changeStatusColor();
                          isLoading.value = false;
                          setState(() {});
                          Navigator.pop(newCtx);
                          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const NedfiProductListScreen(isFrom: '')));
                        },
                        child: Container(
                          height: 36,
                          width: 86,
                          alignment: Alignment.center,
                          child: WidgetUtils.appTextWidget(context: context, title: "key_yes".tr, color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFDA11E)),
                        ),
                      ),
                      const SizedBox(width: 69),
                      InkWell(
                        onTap: () => Navigator.pop(newCtx),
                        child: Container(
                          height: 36,
                          width: 86,
                          alignment: Alignment.center,
                          child: WidgetUtils.appTextWidget(context: context, title: "key_no".tr, color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFFFDA11E)),
                        ),
                      )
                    ],
                  )
                ],
              ));
        });
  }

  Widget buildProductImages(value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          (value[0].allProdImages?.isNotEmpty) ?? false
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.23,
                  width: double.maxFinite,
                  child: CarouselSlider.builder(
                    itemCount: value[0].allProdImages!.length,
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
                      return value[0].allProdImages! != null
                          ? Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: NetworkImage("${HeaderSingleton().configurationDetails!.tradeProducts}/${value[0].allProdImages![i]}"),
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
            count: value[0].allProdImages!.length,
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

  showRatingSheet(BuildContext ctx, String bidderId, String productId) {
    int index = 0;
    showModalBottomSheet(
        context: ctx,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14.0))),
        builder: (newCtx) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.264,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            child: Container(
                                decoration: BoxDecoration(
                                    color: index == 1 ? Color(int.parse(themeColor.value.buttonColor!.color!)).withOpacity(0.3) : Colors.transparent,
                                    border: Border.all(
                                      color: index == 1 ? Color(int.parse(themeColor.value.buttonColor!.color!)) : Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.asset("assets/images/Happy.svg", height: 50),
                                ))),
                        const SizedBox(width: 10),
                        InkWell(
                            onTap: () async {
                              setState(() {
                                index = 2;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: index == 2 ? Color(int.parse(themeColor.value.buttonColor!.color!)).withOpacity(0.3) : Colors.transparent,
                                    border: Border.all(
                                      color: index == 2 ? Color(int.parse(themeColor.value.buttonColor!.color!)) : Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.asset("assets/images/partial_happy.svg", height: 50),
                                ))),
                        const SizedBox(width: 10),
                        InkWell(
                            onTap: () async {
                              setState(() {
                                index = 3;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: index == 3 ? Color(int.parse(themeColor.value.buttonColor!.color!)).withOpacity(0.3) : Colors.transparent,
                                    border: Border.all(
                                      color: index == 3 ? Color(int.parse(themeColor.value.buttonColor!.color!)) : Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.asset("assets/images/sad.svg", height: 50),
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
                            WidgetUtils.errorDialog(context, "Please select Smaily");
                          } else {
                            isLoading.value = true;
                            setState(() {});
                            await addRating(productId, bidderId, index.toString(), () {
                              setState(() {});
                            }, context)
                                .then((value) {
                              getManageProductInformation(context, widget.productId, () {
                                title = productData.value?[0].productTitle ?? "";
                                isLoading.value = false;
                                setState(() {});
                              });
                            });
                            Navigator.pop(context);
                            isLoading.value = false;
                            setState(() {});
                          }
                        },
                        textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                        color: Color(int.parse(themeColor.value.buttonColor!.color!))),
                  ],
                ));
          });
        });
  }

  Future addRating(String productId, String buyerId, String ratingId, Function callback, BuildContext context) async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.productRating, params: {'buyer_id': userId, 'trade_product_id': productId, 'rating_id': ratingId, 'seller_id': buyerId});
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

  Future addInterest(String id) async {
    try {
      var param = {"buyer_id": HeaderSingleton().paramsMaps!.userId, "trade_product_id": id};
      final response = await APIService.postAPIMethod(url: ApiURL.addInterest, params: param);
      final data = json.decode(response.body);
      if (data["success"].toString() == "1") {
        WidgetUtils.successDialog(context, data['message']);
        setState(() {});
        getManageProductInformation(context, widget.productId, () {
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
        getManageProductInformation(context, widget.productId, () {
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

  Future performBuyerAction(final params, BuildContext sheetContext) async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.buyerAction, params: params);
      final result = jsonDecode(response.body);
      if (result['success'].toString() == "1") {
        if (result['data'] != null) {
          WidgetUtils.successDialog(context, result['message']);
        }
      } else {
        WidgetUtils.errorDialog(context, result['message']);
      }
    } catch (e) {
      setState(() => isLoading.value = false);
      Navigator.pop(sheetContext);
      rethrow;
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
                            HelperUtils().showNormalDialog(
                                context: context,
                                title: 'Are_you_sure'.tr,
                                imagePath: "add_bid.svg",
                                content: 'Do you want to add bid'.tr,
                                onYesTapped: (value) async {
                                  if (priceController.text.isEmpty) {
                                    WidgetUtils.errorDialog(context, "Please Enter Price".tr);
                                  } else {
                                    Navigator.of(value).pop(false);
                                    isLoading.value = true;
                                    setState(() {});
                                    await addBid(productId, quantityController.text, unitId, priceController.text);
                                    isLoading.value = false;
                                    setState(() {});
                                    Navigator.pop(ctx);
                                  }
                                });
                          },
                          textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                          color: Color(int.parse(themeColor.value.buttonColor!.color!))),
                    ])));
          });
        });
  }
}
