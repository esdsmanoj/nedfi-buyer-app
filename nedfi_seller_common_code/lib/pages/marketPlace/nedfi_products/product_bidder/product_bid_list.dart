import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/model/trade_product_model/trade_bidders.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../app_imports.dart';
import '../../../../components/widgets/bottom_sheet_widget.dart';
import '../../../../components/widgets/trade_button_widget.dart';
import '../../../../components/widgets/trade_content_widget.dart';
import '../../../../model/trade_product_model/trade_product_info.dart';
import '../upload_document.dart';

class ProductBiddingList extends StatefulWidget {
  final String productName;
  final String productId;

  // final TradeProductData tradeProductDetails;

  const ProductBiddingList({super.key, required this.productName, required this.productId});

  @override
  State<ProductBiddingList> createState() => _ProductBiddingListState();
}

class _ProductBiddingListState extends State<ProductBiddingList> {
  String? addedDate, expiredDate;
  ValueNotifier<List<BidderData>?> bidderData = ValueNotifier(null);
  int? statusColor;
  int page = 1;
  bool nextFlag = false, isDataLoad = false;

  @override
  void initState() {
    isLoading.value = true;
    getProductInformation(context, widget.productId, () {
      isLoading.value = false;
      setState(() {});
    });
    changeStatusColor();
    isLoading.value = false;
    super.initState();
  }

  changeStatusColor() {
    statusColor = productData.value != null
        ? productData.value![0].statusTitle!.toLowerCase() == "pending"
            ? 0xffE8C600
            : productData.value![0].statusTitle!.toLowerCase() == "live"
                ? 0xff27914F
                : productData.value![0].statusTitle!.toLowerCase() == "rejected"
                    ? 0xffE70000
                    : productData.value![0].statusTitle!.toLowerCase() == "completed"
                        ? 0xff0074E8
                        : productData.value![0].statusTitle!.toLowerCase() == "expired"
                            ? 0xFF808080
                            : productData.value![0].statusTitle!.toLowerCase() == "sold"
                                ? 0xffE88700
                                : 0xffffffff
        : 0xffffffff;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (productData.value != null) {
      addedDate = getDateFormat(productData.value![0].addedDate!);
      expiredDate = getDateFormat(productData.value![0].expiryDate!);
    }

    return CustomProgressHandler(
      loadingText: '',
      isLoading: isLoading.value,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(context: context, title: widget.productName, fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20, family: 'Graphik'),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: productData.value![0].statusTitle!.toLowerCase() == "expired"
                ? Container(
                    color: Colors.grey.withOpacity(0.4),
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: Stack(
                      children: [buildBidderData(), const Positioned(top: 0, bottom: 0, left: 0, right: 0, child: SizedBox(height: double.maxFinite, width: double.maxFinite, child: SizedBox()))],
                    ),
                  )
                : buildBidderData()),
      ),
    );
  }

  var controller = PageController(viewportFraction: 0.8, keepPage: true);

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
                      return productData.value![0].allProdImages != null
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

  Widget buildBidderData() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              productData.value![0].prodImages != null ? buildProductImages() : Container(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      WidgetUtils.appTextWidget(context: context, title: productData.value![0].productTitle!, color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20, family: 'Graphik'),
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
                  textTitle: "Variety -".tr + (productData.value![0].productVarietyTitle ?? ""),
                  textContent: "Type".tr + " - " + (productData.value![0].productTypeTitle ?? "")),
              TradeContentWidget(isActive: true, textTitle: "Category".tr, textContent: productData.value![0].productCategoryTitle!),
              TradeContentWidget(isActive: true, textTitle: "Quantity".tr, textContent: (productData.value?[0].sellQty ?? "0") + " " + (productData.value?[0].priceUnitTitle! ?? "")),
              TradeContentWidget(isActive: true, textTitle: "Added".tr, textContent: getDateFormat(productData.value![0].addedDate ?? "")),
              // TradeContentWidget(
              //     isActive: productData.value![0].statusTitle!.toLowerCase() != "pending",
              //     textTitle: productData.value![0].statusTitle!.toLowerCase() == "rejected" ? "Rejected".tr : "Expires".tr,
              //     textContent: getDateFormat(productData.value![0].statusTitle!.toLowerCase() == "rejected" ? productData.value![0].rejectedDate : productData.value![0].expiryDate)),
              TradeContentWidget(
                  isActive: productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed",
                  textTitle: "Sold to".tr,
                  textContent: productData.value![0].soldTO ?? ""),
              TradeContentWidget(
                  isActive: productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed",
                  textTitle: "Sold on".tr,
                  textContent: getDateFormat(productData.value![0].soldOn ?? "")),
              TradeContentWidget(
                isActive: productData.value![0].statusTitle!.toLowerCase() == "live"|| productData.value![0].statusTitle!.toLowerCase() == "expired",
                textTitle:productData.value![0].statusTitle!.toLowerCase() == "expired"?"Expired".tr:"Expires".tr ,
                textContent: getDateFormat(productData.value![0].expiryDate!),
              ),
              const SizedBox(height: 12),
              Container(
                  child: productData.value![0].tradeProductBidding != null
                      ? NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            if (!isDataLoad) {
                              isDataLoad = true;
                            }
                            if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent && isDataLoad) {
                              if (!nextFlag) {
                                page += 1;
                                nextFlag = true;
                                getProductInformation(context, widget.productId, () {
                                  setState(() {
                                    isDataLoad = false;
                                    nextFlag = false;
                                  });
                                });
                              }
                              setState(() {});
                            }
                            return true;
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                            //  print( "revokeExpire" );
                            //  print( productData.value![0].tradeProductBidding![index].revokeExpire );
                              return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 1, color: const Color(0xFFCFCFCF))),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Column(
                                        children: [
                                          Container(
                                            child: CachedNetworkImage(
                                              imageUrl: "${HeaderSingleton().configurationDetails!.partnerImgUrl}" "/" + (productData.value![0].tradeProductBidding![index].buyerProfileImage ?? ""),
                                              imageBuilder: (context, imageProvider) => Container(
                                                  height: MediaQuery.of(context).size.height * 0.09,
                                                  width: MediaQuery.of(context).size.height * 0.09,
                                                  decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover), borderRadius: BorderRadius.circular(6))),
                                              placeholder: (context, url) => Image.asset("assets/images/user.png",
                                                  fit: BoxFit.contain, height: MediaQuery.of(context).size.height * 0.09, width: MediaQuery.of(context).size.height * 0.09),
                                              errorWidget: (context, url, error) => Image.asset("assets/images/user.png",
                                                  fit: BoxFit.contain, height: MediaQuery.of(context).size.height * 0.09, width: MediaQuery.of(context).size.height * 0.09),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                              height: 16,
                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(
                                                      color: (/*productData.value![0].status == "3" &&*/ productData.value![0].tradeProductBidding![index].bidStatus == "3")
                                                          ? Colors.red
                                                          : (/*productData.value![0].status == "3" && */ productData.value![0].tradeProductBidding![index].bidStatus == "2")
                                                              ? Colors.red
                                                              : (/*productData.value![0].status == "4" &&*/ productData.value![0].tradeProductBidding![index].bidStatus == "4" ||
                                                                      productData.value![0].tradeProductBidding![index].bidStatus == "5")
                                                                  ? const Color(0xff27914F)
                                                                  : const Color(0xff27914F))),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset("assets/images/ellipse.svg",
                                                      color: (/*productData.value![0].status == "3" &&*/ productData.value![0].tradeProductBidding![index].bidStatus == "3")
                                                          ? Colors.red
                                                          : (/*productData.value![0].status == "3" &&*/ productData.value![0].tradeProductBidding![index].bidStatus == "2")
                                                              ? Colors.red
                                                              : (/*productData.value![0].status == "4" && */ productData.value![0].tradeProductBidding![index].bidStatus == "4" ||
                                                                      productData.value![0].tradeProductBidding![index].bidStatus == "5")
                                                                  ? const Color(0xff27914F)
                                                                  : const Color(0xff27914F)),
                                                  const SizedBox(width: 4),
                                                  WidgetUtils.appTextWidget(
                                                      context: context,
                                                      title: (productData.value![0].tradeProductBidding![index].trade_product_status != null)
                                                          ? productData.value![0].tradeProductBidding![index].trade_product_status ?? ""
                                                          : (/*productData.value![0].status == "4" &&*/ productData.value![0].tradeProductBidding![index].bidStatus == "4" ||
                                                                  productData.value![0].tradeProductBidding![index].bidStatus == "5")
                                                              ? "Bid Accepted".tr
                                                              : (/*productData.value![0].status == "3" &&*/ productData.value![0].tradeProductBidding![index].bidStatus == "3")
                                                                  ? "Bid Rejected".tr
                                                                  : (/*productData.value![0].status == "3" && */ productData.value![0].tradeProductBidding![index].bidStatus == "2")
                                                                      ? "Bid Revoked".tr
                                                                      : "Bid Placed".tr /*productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "null"*/,
                                                      color: (productData.value![0].tradeProductBidding![index].trade_product_status != null)
                                                          ? Colors.red
                                                          : (/*productData.value![0].status == "3" &&*/ productData.value![0].tradeProductBidding![index].bidStatus == "3")
                                                              ? Colors.red
                                                              : (/*productData.value![0].status == "3" &&*/ productData.value![0].tradeProductBidding![index].bidStatus == "2")
                                                                  ? Colors.red
                                                                  : (/*productData.value![0].status == "4" &&*/ productData.value![0].tradeProductBidding![index].bidStatus == "4" ||
                                                                          productData.value![0].tradeProductBidding![index].bidStatus == "5")
                                                                      ? const Color(0xff27914F)
                                                                      : const Color(0xff27914F),
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 8,
                                                      family: 'Graphik'),
                                                ],
                                              ))
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.570,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: SizedBox(
                                                  width: 100,
                                                  child: WidgetUtils.appTextWidget(
                                                      context: context,
                                                      title: productData.value![0].tradeProductBidding![index].buyerName ?? "nulll",
                                                      color: const Color(0xFF000000),
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16,
                                                      overflow: TextOverflow.ellipsis,
                                                      family: 'Graphik'),
                                                ),
                                              ),
                                              WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: "₹" +
                                                      (productData.value![0].tradeProductBidding![index].bidPrice ?? "nulll") +
                                                      " " +
                                                      (productData.value![0].tradeProductBidding![index].qtyUnitTitle ?? ""),
                                                  color: const Color(0xFFFDA11E),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  family: 'Graphik'),
                                            ],
                                          ),
                                          const Divider(height: 7),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              WidgetUtils.appTextWidget(
                                                  context: context, title: "Date".tr, color: const Color(0xFF3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                              WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: getDateFormat(productData.value![0].tradeProductBidding![index].bidDate!) ?? "",
                                                  color: const Color(0xFF3F3F3F),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  family: 'Graphik'),
                                            ],
                                          ),
                                          const Divider(height: 7),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              WidgetUtils.appTextWidget(
                                                  context: context, title: "Quantity".tr, color: const Color(0xFF3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                              WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: (productData.value![0].tradeProductBidding![index].qty ?? "0") + " " + (productData.value![0].tradeProductBidding![index].qtyUnitTitle ?? ""),
                                                  color: const Color(0xFF3F3F3F),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  family: 'Graphik'),
                                            ],
                                          ),
                                          const Divider(height: 7),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              WidgetUtils.appTextWidget(
                                                  context: context, title: "Bids Number".tr, color: const Color(0xFF000000), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                              WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: (productData.value![0].tradeProductBidding![index].bidCount ?? "0"),
                                                  color: const Color(0xFF3F3F3F),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  family: 'Graphik'),
                                            ],
                                          ),
                                          const Divider(height: 5),
                                        ]),
                                      )
                                    ]),
                                    const SizedBox(height: 12),
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
                                                    title: productData.value![0].tradeProductBidding![index].ratingDetails?.happyCount.toString() ?? "0",
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
                                                    title: productData.value![0].tradeProductBidding![index].ratingDetails?.averageCount.toString() ?? "0",
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
                                                    title: productData.value![0].tradeProductBidding![index].ratingDetails?.poorCount.toString() ?? "0",
                                                    color: const Color(0xFF000000),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    family: 'Graphik'),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(width: 12),
                                            if (productData.value![0].tradeProductBidding![index].revokeExpire ?? (productData.value![0].tradeProductBidding![index].revokeExpire == null))
                                              ((productData.value![0].status == "5" || productData.value![0].status == "4") && productData.value![0].tradeProductBidding![index].bidStatus == "5")
                                                  ? Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                          buildChatWidget(index),
                                                          productData.value![0].tradeProductBidding![index].bidStatus == "5" || productData.value![0].tradeProductBidding![index].bidStatus == "4"
                                                              ? const SizedBox(width: 6)
                                                              : Container(),
                                                          productData.value![0].tradeProductBidding![index].bidStatus == "5" || productData.value![0].tradeProductBidding![index].bidStatus == "4"
                                                              ? buildUploadDocumentWidget(index, "complete")
                                                              : Container(),
                                                        ]),
                                                        productData.value![0].tradeProductBidding![index].bidStatus == "5" || productData.value![0].tradeProductBidding![index].bidStatus == "4"
                                                            ? const SizedBox(height: 6)
                                                            : Container(),
                                                        productData.value![0].tradeProductBidding![index].bidStatus == "5" || productData.value![0].tradeProductBidding![index].bidStatus == "4"
                                                            ? buildRateWidget(index)
                                                            : Container()
                                                      ],
                                                    )
                                                  : ((productData.value![0].status == "5" || productData.value![0].status == "4") && productData.value![0].tradeProductBidding![index].bidStatus == "4")
                                                      ? Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                              buildChatWidget(index),
                                                              productData.value![0].tradeProductBidding![index].bidStatus == "5" || productData.value![0].tradeProductBidding![index].bidStatus == "4"
                                                                  ? const SizedBox(width: 6)
                                                                  : Container(),
                                                              productData.value![0].tradeProductBidding![index].bidStatus == "5" || productData.value![0].tradeProductBidding![index].bidStatus == "4"
                                                                  ? buildUploadDocumentWidget(index, "live")
                                                                  : Container(),
                                                            ]),
                                                            productData.value![0].tradeProductBidding![index].bidStatus == "5" || productData.value![0].tradeProductBidding![index].bidStatus == "4"
                                                                ? const SizedBox(height: 6)
                                                                : Container(),
                                                            productData.value![0].tradeProductBidding![index].bidStatus == "5" || productData.value![0].tradeProductBidding![index].bidStatus == "4"
                                                                ? buildRateWidget(index)
                                                                : Container()
                                                          ],
                                                        )
                                                      : Container(),
                                            if ((productData.value![0].prodCatId ?? "0") != "2")
                                              (productData.value![0].status == "3" && productData.value![0].tradeProductBidding![index].bidStatus == "1")
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (productData.value![0].statusTitle!.toLowerCase() != "expired") {
                                                              if ((productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "pending" ||
                                                                  productData.value![0].statusTitle!.toLowerCase() == "expired") {
                                                                bottomSheetWidget(
                                                                  ctx: context,
                                                                  imagePath: "add_bid.svg",
                                                                  title: "Confirm Bid Accept".tr,
                                                                  content: "Are you sure you want to accept this bid?".tr,
                                                                  onTap: (value) async => performAction(productData.value![0].tradeProductBidding![index], '9'/*"1"*/, ctx),
                                                                );
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 36,
                                                            // width: 98,
                                                            alignment: Alignment.center,
                                                            padding: const EdgeInsets.all(8),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                SvgPicture.asset("assets/images/accept.svg", height: 16),
                                                                const SizedBox(width: 6),
                                                                WidgetUtils.appTextWidget(
                                                                    context: context,
                                                                    title: "Accept".tr,
                                                                    color: const Color(0xff27914F) /*: const Color(0xffFDA11E)*/,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 14,
                                                                    family: 'Graphik'),
                                                              ],
                                                            ),
                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xff27914F))),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 6),
                                                        (productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "pending"
                                                            ? InkWell(
                                                                onTap: () {
                                                                  if (productData.value![0].statusTitle!.toLowerCase() != "expired") {
                                                                    if ((productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "pending" ||
                                                                        (productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "expired") {
                                                                      bottomSheetWidget(
                                                                        ctx: ctx,
                                                                        imagePath: "bid_reject.svg",
                                                                        title: "Confirm Bid Reject".tr,
                                                                        content: "Are you sure you want to Reject this bid?".tr,
                                                                        onTap: (value) async => performAction(productData.value![0].tradeProductBidding![index], "3", ctx),
                                                                      );
                                                                    }
                                                                  }
                                                                },
                                                                child: Container(
                                                                  height: 36,
                                                                  // width: 98,
                                                                  alignment: Alignment.center,
                                                                  padding: const EdgeInsets.all(8),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      SvgPicture.asset("assets/images/reject.svg", height: 16, color: const Color(0xffE70000)),
                                                                      const SizedBox(width: 6),
                                                                      WidgetUtils.appTextWidget(
                                                                          context: ctx,
                                                                          title: "Reject".tr,
                                                                          color: (productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "pending"
                                                                              ? const Color(0xffE70000)
                                                                              : productData.value![0].statusTitle!.toLowerCase() == "expired"
                                                                                  ? const Color(0xFFCFCFCF)
                                                                                  : const Color(0xffE70000),
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: 14,
                                                                          family: 'Graphik'),
                                                                    ],
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(4),
                                                                      border: Border.all(
                                                                        color: (productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "pending"
                                                                            ? const Color(0xffE70000)
                                                                            : productData.value![0].statusTitle!.toLowerCase() == "expired"
                                                                                ? const Color(0xFFCFCFCF)
                                                                                : const Color(0xffE70000),
                                                                      )),
                                                                ))
                                                            : Container(),
                                                      ],
                                                    )
                                                  : Container(),
                                          ],
                                        )
                                      ],
                                    ),
                                    (productData.value![0].tradeProductBidding![index].bidStatusTitle == null ? false : true)
                                        ? productData.value![0].tradeProductBidding![index].bidStatusTitle!.toString().toLowerCase() == "bid locked"/*"sold"*/
                                            ? const SizedBox(height: 12)
                                            : Container()
                                        : Container(),
                                    (productData.value![0].revokeExpire==false) ?? true
                                        ? (productData.value![0].tradeProductBidding![index].bidStatusTitle == null ? false : true)
                                            ? productData.value![0].tradeProductBidding![index].bidStatusTitle!.toString().toLowerCase() == "bid locked"/*"sold"*/
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      if (productData.value![0].statusTitle!.toLowerCase() != "expired") {
                                                        bottomSheetWidget(
                                                          ctx: ctx,
                                                          imagePath: "bid_reject.svg",
                                                          title: "Confirm Bid Revoke".tr,
                                                          content: "Are you sure you want to revoke this bid?".tr,
                                                          onTap: (value) async => performAction(productData.value![0].tradeProductBidding![index], "2", ctx),
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 36,
                                                      // width: double.maxFinite,
                                                      alignment: Alignment.center,
                                                      // margin: const EdgeInsets.symmetric(horizontal: 12),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          SvgPicture.asset("assets/images/revoke.svg", height: 16),
                                                          const SizedBox(width: 6),
                                                          WidgetUtils.appTextWidget(
                                                              context: context, title: "Revoke".tr, color: const Color(0xffE70000), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                                                        ],
                                                      ),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffE70000))),
                                                    ),
                                                  )
                                                : Container()
                                            : Container()
                                        : Container()
                                  ]));
                            },
                            itemCount: productData.value![0].tradeProductBidding!.length,
                          ))
                      : Container())
            ],
          ),
        ));
  }

  buildRateWidget(int index) {
    return TradeButtonWidget(
      onTap: () {
        showRatingSheet(context, (value) async {
          isLoading.value = true;
          setState(() {});
          await addRating(
              productData.value![0].prodId!,
              productData.value![0].tradeProductBidding![index].buyerId!,
              value == "Happy"
                  ? "1"
                  : value == "partial happy"
                      ? "2"
                      : "3",
              () => setState(() {}),
              context);
          Navigator.pop(context);
          await getProductInformation(context, widget.productId, () {});
          isLoading.value = false;
          setState(() {});
        },setState);
      },
      imagePath: "rating.svg",
      buttonName: "Rate".tr,
      colorCode: 0xffFDA11E,
    );
  }

  buildUploadDocumentWidget(int index, String type) {
    return (productData.value![0].revokeExpire ?? false) == false
        ? InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctxRoute) => UploadDocument(
                          isFrom: type == "live" ? "" : 'view',
                          bidDate: productData.value![0].tradeProductBidding![index].bidDate!,
                          productId: productData.value![0].id!,
                          bidderId: productData.value![0].tradeProductBidding?[index].id ?? "",
                          incentiveId: productData.value![0].tradeProductBidding?[index].incentiveId ?? "",
                          buyerName: productData.value![0].tradeProductBidding![index].buyerName!)));
            },
            child: type == "live"
                ? Container(
                    height: 36,
                    // width: 98,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/upload.svg",
                          height: 16,
                          color: productData.value![0].statusTitle!.toLowerCase() == "expired" ? const Color(0xFFCFCFCF) : null,
                        ),
                        const SizedBox(width: 6),
                        WidgetUtils.appTextWidget(context: context, title: "Upload".tr, color: const Color(0xffFDA11E), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                      ],
                    ),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffFDA11E))),
                  )
                : Container(
                    height: 36,
                    // width: 98,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/receipt.svg",
                          height: 16,
                          color: const Color(0xffE70000),
                        ),
                        const SizedBox(width: 6),
                        WidgetUtils.appTextWidget(context: context, title: "View Receipt".tr, color: const Color(0xffE70000), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                      ],
                    ),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffE70000))),
                  ),
          )
        : Container();
  }

  buildChatWidget(int index) {
    return GestureDetector(
      onTap: () async {
        if (productData.value![0].statusTitle!.toLowerCase() != "expired") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (chatCTX) => ChatScreen(farmerName: productData.value![0].tradeProductBidding![index].buyerName ?? "",
                        prodId: productData.value![0].id,
                        buyerId: productData.value![0].tradeProductBidding![index].buyerId!,
                        from:"bid",
                        tradeProductBiddingId: productData.value![0].tradeProductBidding![index].id,
                      )));
        }
      },
      child: Container(
        height: 36,
        // width: 98,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/chat.svg" /*  : "assets/images/chat.svg"*/, height: 16),
            const SizedBox(width: 6),
            WidgetUtils.appTextWidget(context: context, title: "Chat".tr, color: const Color(0xffFDA11E) /*: const Color(0xffFDA11E)*/, fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
          ],
        ),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffFDA11E))),
      ),
    );
  }

  Future performAction(ProductBidder bidder, String action, BuildContext newCtx) async {
    setState(() => isLoading.value = true);
    final params = {'id': bidder.id!, 'status': action, 'product_id': productData.value![0].id!, 'seller_id': bidder.sellerId!, 'buyer_id': bidder.buyerId!};
    await HelperUtils().performSellerAction(params, () => setState(() {}), context, selfSold: false);
    await getProductInformation(context, widget.productId, () {
      isLoading.value = false;
      setState(() {});
    });
    changeStatusColor();
    setState(() => isLoading.value = false);
    Navigator.pop(newCtx);
    setState(() {});
  }
}
