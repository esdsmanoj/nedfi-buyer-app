import 'package:buyer_common_code/model/trade_bidders.dart';
import 'package:get/get.dart';

import '../../../../app_imports.dart';
import '../../../../model/trade_product_info.dart';
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

  Future performSellerAction(final params) async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.buyerAction, params: params);
      final result = jsonDecode(response.body);
      if (result['success'] == 1) {
        if (result['data'] != null) {
          WidgetUtils.successDialog(context, result['message']);
        }
      }
    } catch (e) {
      setState(() => isLoading.value = false);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    addedDate = getDateFormat(productData.value![0].addedDate!);
    expiredDate = getDateFormat(productData.value![0].expiryDate!);

    return CustomProgressHandler(
      loadingText: '',
      isLoading: isLoading.value,
      child: SafeArea(
        child: Scaffold( backgroundColor: Colors.white,
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
                      children: [
                        buildBidderData(),
                        const Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: SizedBox(
                              // color: Colors.grey.withOpacity(0.4),
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: SizedBox(),
                            ))
                      ],
                    ),
                  )
                : buildBidderData()),
      ),
    );
  }

  Widget buildBidderData() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    WidgetUtils.appTextWidget(context: context, title: productData.value![0].productTitle!, color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20, family: 'Graphik'),
                    const SizedBox(width: 4),
                    Container(
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color(statusColor!)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: WidgetUtils.appTextWidget(context: context, title: productData.value![0].statusTitle!, fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12, family: 'Graphik'),
                    )
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
                        context: context, title: productData.value![0].productVarietyTitle!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
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
            // const SizedBox(height: 1),
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
                WidgetUtils.appTextWidget(context: context, title: "Quantity".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                WidgetUtils.appTextWidget(
                    context: context,
                    title: (productData.value?[0].sellQty ?? "0") + " " + (productData.value?[0].priceUnitTitle! ?? ""),
                    color: const Color(0xff3F3F3F),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    family: 'Graphik'),
              ],
            ),
            // const SizedBox(height: 1),
            const Divider(),
            // const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils.appTextWidget(context: context, title: "Added".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                WidgetUtils.appTextWidget(context: context, title: addedDate!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
              ],
            ),
            // productData.value![0].statusTitle!.toLowerCase() != "pending" ? const SizedBox(height: 1) : Container(),
            productData.value![0].statusTitle!.toLowerCase() != "pending" ? const Divider() : Container(),
            // productData.value![0].statusTitle!.toLowerCase() != "pending" ? const SizedBox(height: 3) : Container(),
            productData.value![0].statusTitle!.toLowerCase() != "pending"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetUtils.appTextWidget(
                          context: context,
                          title: productData.value![0].statusTitle!.toLowerCase() == "rejected" ? "Rejected".tr : "Expires".tr,
                          color: const Color(0xff3F3F3F),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          family: 'Graphik'),
                      WidgetUtils.appTextWidget(context: context, title: expiredDate!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                    ],
                  )
                : Container(),
            // productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
            productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const Divider() : Container(),
            // productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
            productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetUtils.appTextWidget(context: context, title: "Sold to".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                      WidgetUtils.appTextWidget(
                          context: context, title: productData.value![0].soldTO ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                    ],
                  )
                : Container(),
            // productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
            productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const Divider() : Container(),
            // productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
            productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetUtils.appTextWidget(context: context, title: "Sold on".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                      WidgetUtils.appTextWidget(
                          context: context, title: productData.value![0].soldOn ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                    ],
                  )
                : Container(),
            const SizedBox(height: 12),
            Container(
                child: productData.value![0].tradeProductBidding != null
                    ? Expanded(
                        child: NotificationListener<ScrollNotification>(
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
                              itemBuilder: (ctx, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 1, color: const Color(0xFFCFCFCF))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                            (productData.value![0].tradeProductBidding![index].bidStatusTitle == null
                                                    ? false
                                                    : productData.value![0].tradeProductBidding![index].bidStatusTitle!.toLowerCase() != "pending")
                                                ? Container(
                                                    height: 16,
                                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(4),
                                                        border: Border.all(
                                                            color:
                                                                productData.value![0].tradeProductBidding![index].bidStatusTitle!.toLowerCase() == "rejected" ? Colors.red : const Color(0xff27914F))),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset("assets/images/ellipse.svg",
                                                            color:
                                                                productData.value![0].tradeProductBidding![index].bidStatusTitle!.toLowerCase() == "rejected" ? Colors.red : const Color(0xff27914F)),
                                                        const SizedBox(width: 4),
                                                        WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "null",
                                                            color: productData.value![0].tradeProductBidding![index].bidStatusTitle!.toLowerCase() == "rejected" ? Colors.red : const Color(0xff27914F),
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 8,
                                                            family: 'Graphik'),
                                                      ],
                                                    ))
                                                : Container()
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
                                                    title:
                                                        (productData.value![0].tradeProductBidding![index].qty ?? "0") + " " + (productData.value![0].tradeProductBidding![index].qtyUnitTitle ?? ""),
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
                                          // const SizedBox(width: 12),
                                          (productData.value![0].prodCatId ?? "0") != "2"
                                              ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      if (productData.value![0].statusTitle!.toLowerCase() != "expired") {
                                                        if ((productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "pending" ||
                                                            productData.value![0].statusTitle!.toLowerCase() == "expired") {
                                                          showBottomSheet(
                                                              ctx, "Confirm Bid Accept".tr, "Are you sure you want to accept this bid?".tr, productData.value![0].tradeProductBidding![index], "1");
                                                        } else {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (chatCTX) => ChatScreen(
                                                                       buyerId:  productData.value![0].tradeProductBidding![index].buyerId!,
                                                                        productData.value![0].tradeProductBidding![index].buyerName ?? "",
                                                                        "bid",
                                                                        tradeProductBiddingId: productData.value![0].tradeProductBidding![index].id,
                                                                      )));
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
                                                          SvgPicture.asset(
                                                              (productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "pending"
                                                                  ? "assets/images/accept.svg"
                                                                  : "assets/images/chat.svg",
                                                              height: 16),
                                                          const SizedBox(width: 6),
                                                          WidgetUtils.appTextWidget(
                                                              context: context,
                                                              title:
                                                                  (productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "pending" ? "Accept".tr : "Chat".tr,
                                                              color: ((productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "pending")
                                                                  ? const Color(0xff27914F)
                                                                  : const Color(0xffFDA11E),
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 14,
                                                              family: 'Graphik'),
                                                        ],
                                                      ),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(4),
                                                          border: Border.all(
                                                              color: ((productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "pending")
                                                                  ? const Color(0xff27914F)
                                                                  : const Color(0xffFDA11E))),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  !productData.value![0].tradeProductBidding![index].revokeExpire!
                                                      ? productData.value![0].statusTitle!.toLowerCase() != "expired"
                                                          ? ((productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "pending" ||
                                                                  (productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "expired")
                                                              ? Container()
                                                              : InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (ctxRoute) => UploadDocument(
                                                                                bidDate: productData.value![0].tradeProductBidding![index].bidDate!,
                                                                                productId: productData.value![0].id!,
                                                                                bidderId: productData.value![0].bidderId ?? "1",
                                                                                buyerName: productData.value![0].tradeProductBidding![index].buyerName!)));
                                                                  },
                                                                  child: Container(
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
                                                                        WidgetUtils.appTextWidget(
                                                                            context: context,
                                                                            title: "Upload".tr,
                                                                            color: const Color(0xffFDA11E),
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 14,
                                                                            family: 'Graphik'),
                                                                      ],
                                                                    ),
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffFDA11E))),
                                                                  ),
                                                                )
                                                          : Container()
                                                      : Container(),
                                                  productData.value![0].tradeProductBidding![index].revokeExpire!
                                                      ? productData.value![0].statusTitle!.toLowerCase() != "completed" &&
                                                              (productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() != "rejected"
                                                          ? InkWell(
                                                              onTap: () {
                                                                if (productData.value![0].statusTitle!.toLowerCase() != "expired") {
                                                                  if ((productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "pending" ||
                                                                      (productData.value![0].tradeProductBidding![index].bidStatusTitle ?? "pending").toLowerCase() == "expired") {
                                                                    showBottomSheet(ctx, "Confirm Bid Reject".tr, "Are you sure you want to Reject this bid?".tr,
                                                                        productData.value![0].tradeProductBidding![index], "3");
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
                                                                        context: context,
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
                                                          : Container()
                                                      : Container()
                                                ])
                                              : (productData.value![0].prodCatId ?? "0") == "1"
                                                  ? Container(
                                                      height: 34,
                                                      width: 34,
                                                      alignment: Alignment.center,
                                                      child: const Icon(Icons.thumb_up_alt, color: Color(0xff27914F)),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(4),
                                                        border: Border.all(color: const Color(0xff27914F)),
                                                      ),
                                                    )
                                                  : Container(),
                                        ],
                                      ),
                                      (productData.value![0].tradeProductBidding![index].bidStatusTitle == null ? false : true)
                                          ? productData.value![0].tradeProductBidding![index].bidStatusTitle!.toString().toLowerCase() == "sold"
                                              ? const SizedBox(height: 12)
                                              : Container()
                                          : Container(),
                                      productData.value![0].tradeProductBidding![index].revokeExpire!
                                          ? (productData.value![0].tradeProductBidding![index].bidStatusTitle == null ? false : true)
                                              ? productData.value![0].tradeProductBidding![index].bidStatusTitle!.toString().toLowerCase() == "sold"
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        if (productData.value![0].statusTitle!.toLowerCase() != "expired") {
                                                          showBottomSheet(
                                                              ctx, "Confirm Bid Revoke".tr, "Are you sure you want to revoke this bid?".tr, productData.value![0].tradeProductBidding![index], "2");
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 36,
                                                        width: double.maxFinite,
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
                                    ],
                                  ),
                                );
                              },
                              itemCount: productData.value![0].tradeProductBidding!.length,
                            )),
                      )
                    : Container())
          ],
        ));
  }

  showBottomSheet(BuildContext ctx, String title, String message, ProductBidder bidder, String action) {
    showModalBottomSheet(
        context: ctx,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(14.0))),
        builder: (newCtx) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.264,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                          final params = {'id': bidder.id!, 'status': action, 'product_id': productData.value![0].id!, 'seller_id': bidder.sellerId!, 'buyer_id': bidder.buyerId!};
                          await performSellerAction(params);
                          await getProductInformation(context, widget.productId, () {
                            isLoading.value = false;
                            setState(() {});
                          });
                          changeStatusColor();
                          setState(() => isLoading.value = false);
                          Navigator.pop(newCtx);
                          setState(() {});
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
}
