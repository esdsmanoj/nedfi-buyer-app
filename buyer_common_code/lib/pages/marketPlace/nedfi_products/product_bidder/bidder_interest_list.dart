import 'package:buyer_common_code/model/trade_bidders.dart';
import 'package:get/get.dart';

import '../../../../app_imports.dart';

class BidderInterestList extends StatefulWidget {
  final String productName;
  final String productId;

  // final TradeProductData tradeProductDetails;

  const BidderInterestList({super.key, required this.productName, required this.productId});

  @override
  State<BidderInterestList> createState() => _BidderInterestListState();
}

class _BidderInterestListState extends State<BidderInterestList> {
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
          const SizedBox(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetUtils.appTextWidget(
                  context: context,
                  title: productData.value![0].prodCatId == "2" ? "Expected Yield".tr : "Quantity".tr,
                  fontWeight: FontWeight.w400,
                  family: 'Graphik',
                  fontSize: 14,
                  color: const Color(0xff3F3F3F)),
              WidgetUtils.appTextWidget(
                  context: context,
                  title: productData.value![0].prodCatId == "2"
                      ? ((productData.value![0].otherDetails?.yieldFrom ?? "0") +
                          " " +
                          (productData.value![0].otherDetails?.yieldFromUnitText ?? "") +
                          " - " +
                          (productData.value![0].otherDetails?.yieldTo ?? "0") +
                          " " +
                          (productData.value![0].otherDetails?.yieldToUnitText ?? ""))
                      : ((productData.value![0].sellQty ?? "0") + " " + (productData.value![0].priceUnitTitle ?? "")),
                  fontWeight: FontWeight.w400,
                  family: 'Graphik',
                  fontSize: 14,
                  color: const Color(0xff3F3F3F)),
            ],
          ),
          const SizedBox(height: 5),
          const SizedBox(height: 1),
          const Divider(),
          // const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetUtils.appTextWidget(context: context, title: "Product Type".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
              WidgetUtils.appTextWidget(context: context, title: "Produce", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
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
          productData.value![0].prodCatId != 2
              ? productData.value![0].statusTitle!.toLowerCase() != "pending"
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
                  : Container()
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
              child: productData.value![0].buyerInterest != null
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
                      child: Expanded(
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
                                    Container(
                                      child: CachedNetworkImage(
                                        imageUrl: "${HeaderSingleton().configurationDetails!.partnerImgUrl}" "/" + (productData.value![0].buyerInterest![index].profileImage ?? ""),
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
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.570,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        SizedBox(
                                          child: WidgetUtils.appTextWidget(
                                              context: context,
                                              title: (productData.value![0].buyerInterest![index].firstName ?? "") + " " + (productData.value![0].buyerInterest![index].lastName ?? " "),
                                              color: const Color(0xFF000000),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                              family: 'Graphik'),
                                        ),
                                        const Divider(height: 7),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            WidgetUtils.appTextWidget(context: context, title: "Date".tr, color: const Color(0xFF3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                            WidgetUtils.appTextWidget(
                                                context: context,
                                                title: getDateFormat(productData.value![0].buyerInterest![index].interestShownOn!) ?? "",
                                                color: const Color(0xFF3F3F3F),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                family: 'Graphik'),
                                          ],
                                        ),
                                        const Divider(height: 7),
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
                                            SvgPicture.asset("assets/images/IntrestedButton.svg", height: 34),
                                          ],
                                        ),
                                      ]),
                                    )
                                  ]),
                                  SizedBox(height: 12),
                                ],
                              ),
                            );
                            // return Container();
                          },
                          itemCount: productData.value![0].buyerInterest!.length,
                        ),
                      ))
                  : Container())
        ],
      ),
    );
  }
}
