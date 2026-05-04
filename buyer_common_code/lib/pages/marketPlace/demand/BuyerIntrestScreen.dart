import 'package:buyer_common_code/model/BuyerInterest.dart';
import 'package:get/get.dart';

import '../../../app_imports.dart';
import '../../../model/UpcomingProduct.dart';
import '../../../model/trade_product_info.dart';
import '../../../providers/master_provider.dart';

class BuyerIntrestScreen extends StatefulWidget {
  const BuyerIntrestScreen({super.key});

  @override
  State<BuyerIntrestScreen> createState() => _BuyerIntrestScreenState();
}

class _BuyerIntrestScreenState extends State<BuyerIntrestScreen> {
  String? addedDate, expiredDate;

  int? statusColor;
  String statusTitle = "";
  int page = 1;
  bool nextFlag = false, isDataLoad = false;
  String productId = "";
  List<ProdInterestData> buyerInterestlist = [];
  List<BidderInterest> bidderData = [];
  TextEditingController? cropController = TextEditingController();

  @override
  void initState() {
    isLoading.value = true;

    changeStatusColor();
    isLoading.value = false;
    super.initState();
  }

  Future getUpcomingProduct() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.upcomingProductList + "/" + userId);
      final data = json.decode(response.body);
      final res = UpcomingProduct.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setUpcomingProduct(res.data!);
        }
      }
      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }

  Future getProductInformation() async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.buyersInterestProductList, params: {'seller_id': userId, 'trade_product_id': productId});
      final result = BuyerInterest.fromJson(jsonDecode(response.body));
      if (result.success == 1) {
        buyerInterestlist = result.data?.prodInterestData ?? [];
        changeStatusColor();
      }
    } catch (e) {
      rethrow;
    }
  }

  changeStatusColor() {
    statusColor = buyerInterestlist.isNotEmpty
        ? buyerInterestlist[0].status_title!.toLowerCase() == "pending"
            ? 0xffE8C600
            : buyerInterestlist[0].status_title!.toLowerCase() == "live"
                ? 0xff27914F
                : buyerInterestlist[0].status_title!.toLowerCase() == "rejected"
                    ? 0xffE70000
                    : buyerInterestlist[0].status_title!.toLowerCase() == "completed"
                        ? 0xff0074E8
                        : buyerInterestlist[0].status_title!.toLowerCase() == "expired"
                            ? 0xFF808080
                            : buyerInterestlist[0].status_title!.toLowerCase() == "sold"
                                ? 0xffE88700
                                : 0xffffffff
        : 0xffffffff;

    statusTitle = buyerInterestlist.isNotEmpty ? buyerInterestlist[0].status_title.toString() : "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (buyerInterestlist.isNotEmpty) {
      addedDate = getDateFormat(buyerInterestlist[0].addedDate!);
      expiredDate = getDateFormat(buyerInterestlist[0].expiryDate!);
    }

    return CustomProgressHandler(
        loadingText: '',
        isLoading: isLoading.value,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: buildBidderData(),
          ),
        ));
  }

  Widget buildBidderData() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width) - 15,
            height: 58,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              onTap: () {
                showProductFilter(context);
              },
              controller: cropController,
              keyboardType: TextInputType.text,
              readOnly: true,
              decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  hintText: 'Product'.tr,
                  border: InputBorder.none,
                  counterText: "",
                  suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          buyerInterestlist.isEmpty
              ? Container()
              : Column(
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            WidgetUtils.appTextWidget(context: context, title: buyerInterestlist[0].productTitle!, color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20, family: 'Graphik'),
                            const SizedBox(width: 4),
                            Container(
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color(statusColor!)),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: WidgetUtils.appTextWidget(context: context, title: statusTitle, fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12, family: 'Graphik'),
                            )
                          ],
                        ),
                        WidgetUtils.appTextWidget(
                            context: context,
                            title: "₹${buyerInterestlist[0].price!}/${buyerInterestlist[0].priceUnitTitle!}",
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
                                context: context, title: buyerInterestlist[0].productVarietyTitle!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                          ],
                        ),
                        Row(
                          children: [
                            WidgetUtils.appTextWidget(context: context, title: "Type -".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                            const SizedBox(width: 4),
                            WidgetUtils.appTextWidget(
                                context: context, title: buyerInterestlist[0].productTypeTitle!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
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
                            context: context, title: buyerInterestlist[0].productCategoryTitle!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
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
                            title: (buyerInterestlist?[0].sellQty ?? "0") + " " + (buyerInterestlist?[0].priceUnitTitle! ?? ""),
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
                    buyerInterestlist[0].status_title!.toLowerCase() != "pending" ? const Divider() : Container(),
                    buyerInterestlist[0].status_title!.toLowerCase() != "pending"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(
                                  context: context,
                                  title: buyerInterestlist[0].status_title!.toLowerCase() == "rejected" ? "Rejected".tr : "Expires".tr,
                                  color: const Color(0xff3F3F3F),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  family: 'Graphik'),
                              WidgetUtils.appTextWidget(context: context, title: expiredDate!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                            ],
                          )
                        : Container(),

                    const SizedBox(height: 12),
                    Container(
                        child: bidderData.length > 0
                            ? ListView.builder(
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
                                              imageUrl: "${HeaderSingleton().configurationDetails!.partnerImgUrl}" "/" + (bidderData[index].profileImage ?? ""),
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
                                                    title: (bidderData[index].firstName ?? "") + " " + (bidderData[index].lastName ?? " "),
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
                                                  WidgetUtils.appTextWidget(
                                                      context: context, title: "Date".tr, color: const Color(0xFF3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                                  WidgetUtils.appTextWidget(
                                                      context: context,
                                                      title: getDateFormat(bidderData[index].interestShownOn!) ?? "",
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
                                                              context: context, title: "10", color: const Color(0xFF000000), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Column(
                                                        children: [
                                                          SvgPicture.asset("assets/images/partial_happy.svg", height: 20),
                                                          WidgetUtils.appTextWidget(
                                                              context: context, title: "10", color: const Color(0xFF000000), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Column(
                                                        children: [
                                                          SvgPicture.asset("assets/images/sad.svg", height: 20),
                                                          WidgetUtils.appTextWidget(
                                                              context: context, title: "10", color: const Color(0xFF000000), fontWeight: FontWeight.w500, fontSize: 12, family: 'Graphik'),
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
                                        const SizedBox(height: 12),
                                      ],
                                    ),
                                  );
                                  // return Container();
                                },
                                itemCount: bidderData.length,
                              )
                            : Container(
                                height: 350,
                                child: Center(
                                    child: Text("No one shown interest yet with this product".tr,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(int.parse(themeColor.value.barColor!.color!)),
                                        )))))
                  ],
                ),
        ],
      ),
    );
  }

  TextEditingController controllerOne = TextEditingController();

  List<UpcomingProductData> _searchResultOne = [];

  void showProductFilter(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<MasterProvider>(//                    <--- Consumer
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
                              WidgetUtils.appTextWidget(context: context, title: 'Select Product'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
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
                                for (var userDetail in loanModel.upcomingProductList) {
                                  if (userDetail.productTitle!.toUpperCase().contains(text.toUpperCase()) || userDetail.productTitle!.toLowerCase().contains(text.toLowerCase()))
                                    _searchResultOne.add(userDetail);
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
                                  for (var userDetail in loanModel.upcomingProductList) {
                                    if (userDetail.productTitle!.contains("")) _searchResultOne.add(userDetail);
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
                                          cropController!.text = _searchResultOne[index].productTitle ?? "";
                                          productId = _searchResultOne[index].id ?? "";
                                          getProductInformation();
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
                                                        context: context,
                                                        title: _searchResultOne[index].id.toString() + " " + _searchResultOne[index].productTitle!,
                                                        textAlign: TextAlign.start,
                                                        overflow: TextOverflow.ellipsis,
                                                        fontSize: 16.0),
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
                                itemCount: loanModel.upcomingProductList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          cropController!.text = loanModel.upcomingProductList[index].productTitle ?? "";
                                          productId = loanModel.upcomingProductList[index].id ?? "";
                                          getProductInformation();
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
                                                      (loanModel.upcomingProductList[index].id.toString() ?? "") + " " + (loanModel.upcomingProductList[index].productTitle ?? ""),
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
