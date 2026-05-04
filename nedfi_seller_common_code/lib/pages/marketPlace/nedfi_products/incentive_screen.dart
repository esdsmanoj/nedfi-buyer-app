import 'package:get/get.dart';
import 'package:getwidget/components/radio/gf_radio.dart';
import 'package:nedfi_seller_common_code/pages/marketPlace/nedfi_products/product_list/NedfiProductListScreen.dart';

import '../../../app_imports.dart';
import '../../../model/trade_product_model/trade_incentive.dart';

class IncentiveScreen extends StatefulWidget {
  final String buyerName;
  final String bidderId;
  final String bidderDate;

  const IncentiveScreen({super.key, required this.buyerName, required this.bidderId, required this.bidderDate});

  @override
  State<IncentiveScreen> createState() => _IncentiveScreenState();
}

class _IncentiveScreenState extends State<IncentiveScreen> {
  int? statusColor, selectedIndex;
  String? addedDate, expiredDate;
  var unescape = HtmlUnescape();
  dynamic params;
  ValueNotifier<List<IncentiveData>> incentiveData = ValueNotifier([]);

  @override
  void initState() {
    selectedIndex = -1;
    isLoading.value = true;
    changeStatusColor();
    getIncentiveList();
    isLoading.value = false;
    super.initState();
  }

  changeStatusColor() {
    statusColor = productData.value![0].statusTitle!.toLowerCase() == "pending"
        ? 0xffE8C600
        : productData.value![0].statusTitle!.toLowerCase() == "live"
            ? 0xff27914F
            : productData.value![0].statusTitle!.toLowerCase() == "rejected"
                ? 0xffE70000
                : productData.value![0].statusTitle!.toLowerCase() == "completed"
                    ? 0xff0074E8
                    : productData.value![0].statusTitle!.toLowerCase() == "sold"
                        ? 0xffE88700
                        : 0xffffffff;
  }

  Future getIncentiveList() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.tradeIncentives);
      final result = TradeIncentive.fromJson(json.decode(response.body));
      if (result.success == 1) {
        incentiveData.value = result.data ?? [];
        if (result.data!.isNotEmpty) {
          params = {'incentive_id': result.data![0].serviceId, 'trade_bidding_id': widget.bidderId, 'user_id': userId};
        }
        setState(() {});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> onWillPop() async {
    return (await HelperUtils().showNormalDialog(
            context: context,
            title: 'Are_you_sure'.tr,
            content: 'Important: Please select the incentive before navigating back.\n No incentive will be granted if you leave without submitting.'.tr,
            onYesTapped: (value) async {
              Navigator.pop(value);
            })) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    addedDate = getDateFormat(productData.value![0].addedDate!);
    expiredDate = getDateFormat(productData.value![0].expiryDate!);

    return /*WillPopScope(
      onWillPop: onWillPop,
      child:*/
        SafeArea(
            child: CustomProgressHandler(
      loadingText: '',
      isLoading: isLoading.value,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          title: WidgetUtils.appTextWidget(context: context, title: widget.buyerName, fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20, family: 'Graphik'),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                          child:
                              WidgetUtils.appTextWidget(context: context, title: productData.value![0].statusTitle!, fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12, family: 'Graphik'),
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
                    WidgetUtils.appTextWidget(context: context, title: "Quantity".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                    WidgetUtils.appTextWidget(
                        context: context,
                        title: (productData.value?[0].sellQty ?? "0")! + " " + (productData.value?[0].priceUnitTitle! ?? ""),
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
                // productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
                productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const Divider() : Container(),
                // productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
                productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed"
                    ? widget.bidderDate != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context, title: "Bid Date".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                              WidgetUtils.appTextWidget(
                                  context: context, title: getDateFormat(widget.bidderDate ?? ""), color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
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
                          WidgetUtils.appTextWidget(context: context, title: "Sold on".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                          WidgetUtils.appTextWidget(
                              context: context, title: getDateFormat(productData.value![0].soldOn ?? ""), color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                        ],
                      )
                    : Container(),
                const SizedBox(height: 12),
                Container(
                    child: ValueListenableBuilder(
                  valueListenable: incentiveData,
                  builder: (BuildContext context, value, Widget? child) {
                    return value.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.length,
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  selectedIndex = index;
                                  params = {'incentive_id': value[index].serviceId, 'trade_bidding_id': widget.bidderId, 'user_id': userId};
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  height: 116,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xffCFCFCF))),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GFRadio(
                                          size: 20,
                                          value: 0,
                                          radioColor: Color(int.parse(themeColor.value.barColor!.color!)),
                                          groupValue: (selectedIndex == index) ? 0 : 1,
                                          onChanged: (value) {},
                                          inactiveIcon: null,
                                          activeBorderColor: Color(int.parse(themeColor.value.barColor!.color!)),
                                        ),
                                        const SizedBox(width: 12),
                                        WidgetUtils.appTextWidget(
                                            context: context,
                                            title: value[index].productServicesName ?? "",
                                            color: const Color(0xff3F3F3F),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            family: 'Graphik'),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.7,
                                            child: Html(
                                              data: unescape.convert(value[index].overview ?? ""),
                                              style: {
                                                'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xff9F9F9F)),
                                            onPressed: () {
                                              showDescriptionDialog(ctx, value[index]);
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                    // SizedBox(height: 8),
                                    // WidgetUtils.appTextWidget(
                                    //     context: context, title: value[index].overview ?? "", color: const Color(0xff575757), fontWeight: FontWeight.w400, fontSize: 10, family: 'Graphik'),
                                  ]),
                                ),
                              );
                            })
                        : Container();
                  },
                ))
              ],
            ),
          ),
        ),
        bottomNavigationBar: selectedIndex == -1
            ? Container(
                height: 1,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: WidgetUtils.buttonWidget(
                    context: context,
                    radius: 8,
                    title: 'Submit'.tr,
                    size: 16,
                    family: 'Graphik',
                    weight: FontWeight.w500,
                    callback: () {
                      setState(() => isLoading.value = true);
                      submitIncentiveReport();
                      setState(() => isLoading.value = false);
                    },
                    textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                    color: Color(int.parse(themeColor.value.buttonColor!.color!))),
              ),
      ),
    ));
    /*  ,
    );*/
  }

  showDescriptionDialog(BuildContext ctx, IncentiveData details) {
    showDialog(
        context: ctx,
        builder: (BuildContext newCtx) {
          return AlertDialog(
              titlePadding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              content: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WidgetUtils.appTextWidget(
                              context: context, title: details.productServicesName ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 16, family: 'Graphik'),
                          InkWell(
                              onTap: () {
                                Navigator.pop(newCtx);
                              },
                              child: SvgPicture.asset("assets/images/cross.svg", height: 20))
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        // width: MediaQuery.of(context).size.width * 0.7,
                        child: Html(
                          data: unescape.convert(details.overview ?? ""),
                          style: {
                            'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                          },
                        ),
                      ),
                    ],
                  )),
              actions: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: WidgetUtils.buttonWidget(
                      context: context,
                      height: 45,
                      borderWidth: 0.2,
                      radius: 8,
                      title: "Ok".tr,
                      size: 16,
                      family: 'Graphik',
                      weight: FontWeight.w500,
                      callback: () {
                        Navigator.pop(newCtx);
                      },
                      textColor: Colors.white,
                      color: Color(int.parse(themeColor.value.barColor!.color!)),
                    ))
              ]);
        });
  }

  Future submitIncentiveReport() async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.applyIncentive, params: params);
      final result = json.decode(response.body);
      if (result["success"] == 1) {
        WidgetUtils.successDialog(context, result['message']);
        setState(() {});
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (buildRoute) => NedfiProductListScreen(isFrom: "incentive")));
      }
    } catch (e) {
      rethrow;
    }
  }
}
