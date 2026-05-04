import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/pages/marketPlace/nedfi_products/product_bidder/bidder_interest_list.dart';
import 'package:nedfi_seller_common_code/pages/marketPlace/nedfi_products/product_bidder/product_bid_list.dart';
import 'package:nedfi_seller_common_code/pages/marketPlace/nedfi_products/upload_document.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../app_imports.dart';
import '../../../components/widgets/bottom_sheet_widget.dart';
import '../../../components/widgets/interested_button_widget.dart';
import '../../../components/widgets/trade_button_widget.dart';
import '../../../components/widgets/trade_content_widget.dart';
import '../../../model/trade_product_model/trade_product_info.dart';
import 'add_product/AddProductMainScreen.dart';

class TradeProductDetails extends StatefulWidget {
  final String productId;
  String? productTitle;

  TradeProductDetails({super.key, required this.productId, this.productTitle});

  @override
  State<TradeProductDetails> createState() => _TradeProductDetailsState();
}

class _TradeProductDetailsState extends State<TradeProductDetails> {
  String? addedDate, expiredDate, title;
  var controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  void initState() {
    isLoading.value = true;
    if (widget.productTitle != null) {
      title = widget.productTitle;
    }
    getProductInformation(context, widget.productId, () {
      title = productData.value?[0].productTitle ?? "";
      isLoading.value = false;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (productData.value != null) {
      addedDate = getDateFormat(productData.value![0].addedDate!);
      expiredDate = getDateFormat(productData.value![0].expiryDate!);
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
              builder: (ctx, List<TradeProductData>? value, child) {
                int? statusColor;
                List<String>? splitString;
                bool isPending = false, isSold = false, isCompleted = false, isRejected = false, isLive = false, isExpired = false;

                if (value != null) {
                  isPending = value[0].statusTitle!.toLowerCase() != "pending";
                  isSold = value[0].statusTitle!.toLowerCase() == "sold";
                  isCompleted = value[0].statusTitle!.toLowerCase() == "completed";
                  isRejected = value[0].statusTitle!.toLowerCase() == "rejected";
                  isLive = value[0].statusTitle!.toLowerCase() == "live";
                  isExpired = value[0].statusTitle!.toLowerCase() == "expired";
                  splitString = value[0].seasonText!.split(",");
                  statusColor = value[0].statusTitle != null
                      ? value[0].statusTitle!.toLowerCase() == "pending"
                          ? 0xffE8C600
                          : value[0].statusTitle!.toLowerCase() == "live"
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
                return value != null
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
                                    WidgetUtils.statusTextWidget(title: productData.value![0].statusTitle ?? ""),
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
                            TradeContentWidget(
                                isStart: true,
                                isActive: true,
                                textTitle: "Variety -".tr + " " + productData.value![0].productVarietyTitle!,
                                textContent: "Type -".tr + " " + productData.value![0].productTypeTitle!),
                            TradeContentWidget(isActive: true, textTitle: "Category".tr, textContent: productData.value![0].productCategoryTitle!),
                            TradeContentWidget(
                                isActive: true,
                                textTitle: value[0].prodCatId == "2" ? "Expected Yield".tr : "Quantity".tr,
                                textContent: productData.value![0].prodCatId == "2"
                                    ? ((value[0].otherDetails?.yieldFrom ?? "0") +
                                        " " +
                                        (value[0].otherDetails?.yieldFromUnitText ?? "") +
                                        " - " +
                                        (value[0].otherDetails?.yieldTo ?? "0") +
                                        " " +
                                        (value[0].otherDetails?.yieldToUnitText ?? ""))
                                    : ((value[0].sellQty ?? "0") + " " + (value[0].priceUnitTitle ?? ""))),
                            TradeContentWidget(isActive: true, textTitle: "Added".tr, textContent: getDateFormat(value[0].addedDate ?? "")),
                            isPending
                                ? isSold
                                    ? Container()
                                    : isCompleted /*|| isRejected*/
                                        ? Container()
                                        : TradeContentWidget(isActive: value[0].prodCatId != "2", textTitle:value[0].statusTitle?.toLowerCase() == "expired"?"Expired".tr:"Expires".tr, textContent: getDateFormat(value[0].expiryDate!))
                                : Container(),
                            isPending
                                ? TradeContentWidget(
                                    isActive: isRejected, textTitle: isRejected ? "Rejected".tr : "Expires".tr, textContent: getDateFormat(isRejected ? value[0].rejectedDate : value[0].expiryDate!))
                                : Container(),
                            TradeContentWidget(isActive: isSold || isCompleted, textTitle: "Sold to ".tr, textContent: value[0].soldTO ?? ""),
                            TradeContentWidget(isActive: isSold || isCompleted, textTitle: "Sold on ".tr, textContent: getDateFormat(value[0].soldOn ?? "")),
                            TradeContentWidget(
                                isActive: isSold || isCompleted,
                                textTitle: "Bid Amount ".tr,
                                textContent: "₹" + ((value[0].tradeProductBidding?.length)! > 0 ? (value[0].tradeProductBidding?[0].bidPrice ?? "") : "")),
                            const SizedBox(height: 8),
                            isRejected
                                ? Container(
                                    height: 30,
                                    width: double.maxFinite,
                                    alignment: Alignment.center,
                                    child: WidgetUtils.appTextWidget(
                                        context: context, title: value[0].reason.toString(), color: const Color(0xffE70000), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xffFFF2F2)),
                                  )
                                : Container(),
                            const SizedBox(height: 13),
                            Container(
                                // height: 80,
                                // width:double.maxFinite,
                                child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    productData.value![0].statusTitle!.toLowerCase() != "pending" || productData.value![0].statusTitle!.toLowerCase() != "rejected"
                                        ? (productData.value![0].prodCatId != "2"
                                                ? (int.parse(productData.value![0].tradeProductBiddingCount!.toString()) != 0)
                                                : (int.parse(productData.value![0].buyerInterestCount!.toString()) != 0))
                                            ? GestureDetector(
                                                onTap: () {
                                                  productData.value![0].prodCatId == "2"
                                                      ? Navigator.push(context, MaterialPageRoute(builder: (ctx) => BidderInterestList(productName: (title ?? ""), productId: widget.productId ?? "")))
                                                      : Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProductBiddingList(productId: widget.productId, productName: title ?? "")));
                                                },
                                                child: productData.value![0].prodCatId == "2" && int.parse(productData.value![0].buyerInterestCount.toString()) != 0
                                                    ? InterestedButtonWidget(
                                                        upComingProduct: productData.value![0].prodCatId == "2",
                                                        isActive: int.parse(productData.value![0].buyerInterestCount.toString()) != 0 ? true : false,
                                                        count: productData.value![0].buyerInterestCount!.toString())
                                                    : !(productData.value![0].prodCatId == "2") && int.parse(productData.value![0].tradeProductBiddingCount.toString()) != 0
                                                        ? InterestedButtonWidget(
                                                            upComingProduct: (productData.value![0].prodCatId == "2"),
                                                            isActive: int.parse(productData.value![0].tradeProductBiddingCount.toString()) != 0 ? true : false,
                                                            count: productData.value![0].tradeProductBiddingCount.toString())
                                                        : Container(),
                                              )
                                            : Container(width: productData.value![0].statusTitle!.toLowerCase() != "pending" || productData.value![0].statusTitle!.toLowerCase() != "rejected" ? 0 : 0)
                                        : Container(),
                                    const SizedBox(width: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        productData.value![0].prodCatId != "2"
                                            ? (/*isSold ||*/ isLive /*|| isCompleted*/)
                                                ? TradeButtonWidget(
                                                    onTap: () {
                                                      if (isLive) {
                                                        HelperUtils().showNormalDialog(
                                                            context: context,
                                                            title: 'Are_you_sure'.tr,
                                                            content: 'Do you want to Sold Product?'.tr,
                                                            onYesTapped: (valueCtx) async {
                                                              Navigator.pop(valueCtx);
                                                              setState(() => isLoading.value = true);
                                                              final params = {'status': "8", 'product_id': productData.value![0].id!, 'seller_id': userId};
                                                              await HelperUtils().performSellerAction(params, () => setState(() {}), context, selfSold: true);
                                                              await getProductInformation(context, widget.productId, () {
                                                                isLoading.value = false;
                                                                setState(() {});
                                                              });
                                                              setState(() => isLoading.value = false);
                                                            });
                                                      } else if (isSold || isCompleted) {
                                                        showRatingSheet(ctx, (value) async {
                                                          isLoading.value = true;
                                                          setState(() {});
                                                          await addRating(
                                                              productData.value![0].id!,
                                                              productData.value![0].sold_to_buyer_id!,
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
                                                      }
                                                    },
                                                    imagePath: isSold || isCompleted ? "rating.svg" : "sold.svg",
                                                    buttonName: isSold || isCompleted ? "Rate".tr : "Sold".tr,
                                                    colorCode: 0xffFDA11E,
                                                  )
                                                : Container()
                                            : Container(),
                                        productData.value![0].statusTitle!.toLowerCase() != "completed" || productData.value![0].statusTitle!.toLowerCase() != "sold"
                                            ? productData.value![0].statusTitle!.toLowerCase() != "completed"
                                                ? int.parse(productData.value![0].tradeProductBiddingCount.toString()) > 0
                                                    ? Container()
                                                    : int.parse(productData.value![0].buyerInterestCount.toString()) > 0
                                                        ? Container()
                                                        : const SizedBox(width: 6)
                                                : Container()
                                            : Container(),
                                        productData.value![0].statusTitle!.toLowerCase() != "completed" || productData.value![0].statusTitle!.toLowerCase() != "sold"
                                            ? productData.value![0].statusTitle!.toLowerCase() != "completed"
                                                ? int.parse(productData.value![0].tradeProductBiddingCount.toString()) > 0
                                                    ? Container()
                                                    : int.parse(productData.value![0].buyerInterestCount.toString()) > 0
                                                        ? Container()
                                                        : productData.value![0].statusTitle?.toLowerCase()=="self sold"?Container(): TradeButtonWidget(
                                                            onTap: () {
                                                              if (isSold) {
                                                              } else {
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductMainScreen(type: "EDIT", id: productData.value![0].id)))
                                                                    .then((value) {
                                                                  isLoading.value = true;
                                                                  getProductInformation(context, productData.value![0].id!, () {
                                                                    isLoading.value = false;
                                                                    setState(() {});
                                                                  });
                                                                });
                                                              }
                                                            },
                                                            buttonName: "Edit".tr,
                                                            imagePath: 'edit.svg',
                                                            colorCode: 0xffFDA11E,
                                                          )
                                                : Container()
                                            : Container(),
                                        (!isCompleted && !isSold)
                                            ? int.parse(productData.value![0].buyerInterestCount.toString()) > 0
                                                ? Container()
                                                : int.parse(productData.value![0].tradeProductBiddingCount.toString()) > 0
                                                    ? Container()
                                                    : const SizedBox(width: 6)
                                            : Container(),
                                        (!isCompleted && !isSold)
                                            ? int.parse(productData.value![0].buyerInterestCount.toString()) > 0
                                                ? Container()
                                                : int.parse(productData.value![0].tradeProductBiddingCount.toString()) > 0
                                                    ? Container()
                                                    : productData.value![0].statusTitle?.toLowerCase()=="self sold"?Container():TradeButtonWidget(
                                                        onTap: () => bottomSheetWidget(
                                                          ctx: context,
                                                          imagePath: "delete_bid.svg",
                                                          title: "Confirm Product Deletion".tr,
                                                          content: "Are you sure you want to delete this product?".tr,
                                                          onTap: (value) async {
                                                            isLoading.value = true;
                                                            setState(() {});
                                                            await deleteTradeProduct(ctx, widget.productId, "details");
                                                            isLoading.value = false;
                                                            Navigator.pop(value);
                                                            setState(() {});
                                                          },
                                                        ),
                                                        buttonName: "Delete".tr,
                                                        imagePath: 'deleteicon.svg',
                                                        colorCode: 0xffE70000,
                                                      )
                                            : Container(),
                                        const SizedBox(width: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            !(value[0].revokeExpire ?? true)
                                                ? isCompleted || isSold
                                                    ? !isCompleted
                                                        ? TradeButtonWidget(
                                                            onTap: () {
                                                              if (isSold) {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (ctxRoute) => UploadDocument(
                                                                            bidDate: productData.value![0].soldBidDate ?? "",
                                                                            productId: productData.value![0].id!,
                                                                            bidderId: productData.value![0].tradeProductBidding?[0].id ?? "",
                                                                            incentiveId: productData.value![0].tradeProductBidding?[0].incentiveId ?? "",
                                                                            buyerName: productData.value![0].soldTO ?? "")));
                                                              }
                                                            },
                                                            buttonName: "Upload".tr,
                                                            imagePath: 'file_upload.svg',
                                                            colorCode: 0xffFDA11E,
                                                          )
                                                        : Container()
                                                    : Container()
                                                : Container(),
                                            /*     const SizedBox(height: 6),
                                    productData.value![0].statusTitle!.toLowerCase() == "completed" || productData.value![0].statusTitle!.toLowerCase() == "sold"
                                        ? TradeButtonWidget(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (chatCTX) => ChatScreen(
                                                            buyerId: productData.value![0].sold_to_buyer_id!,
                                                            productData.value![0].soldTO ?? "",
                                                            "bid",
                                                            prodId: widget.productId,
                                                            tradeProductBiddingId: productData.value![0].bidderId,
                                                          )));
                                            },
                                            buttonName: "Chat".tr,
                                            imagePath: 'chat.svg',
                                            colorCode: 0xffFDA11E,
                                          )
                                        : Container(),*/
                                            (isCompleted) ? const SizedBox(width: 6) : Container(),
                                            (isCompleted)
                                                ? TradeButtonWidget(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (ctxRoute) => UploadDocument(
                                                                  bidDate: productData.value![0].soldBidDate ?? "",
                                                                  productId: productData.value![0].id!,
                                                                  bidderId: productData.value![0].tradeProductBidding?[0].id ?? "",
                                                                  incentiveId: productData.value![0].tradeProductBidding?[0].incentiveId ?? "",
                                                                  buyerName: productData.value![0].soldTO ?? "",
                                                                  isFrom: "view")));
                                                    },
                                                    buttonName: "View Receipt".tr,
                                                    imagePath: 'receipt.svg',
                                                    colorCode: 0xffE70000,
                                                  )
                                                : Container(),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            )),
                            const SizedBox(height: 11),
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
                                            context: context,
                                            title: (value[0].prod_details_title ?? "0"),
                                            color: const Color(0xff575757),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            family: 'Graphik'),
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
                                        Text("${value[0].otherDetails!.availableFrom} \n${value[0].otherDetails!.availableTo}",
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
                                            Text("${splitString![0]}\n${splitString[1].trim()}",
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
                                        title: (value[0].pickupLocation ?? "-") + ", " + (value[0].cityName ?? "") + ", " + (value[0].stateName ?? "-"),
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
                                      title: (value[0].advancePayment ?? "0") + (value[0].advancePayment == "Payment after delivery" ? "" : "%"),
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
              dotColor: Colors.grey,
              activeDotColor: Color(int.parse(themeColor.value.barColor!.color!)),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
