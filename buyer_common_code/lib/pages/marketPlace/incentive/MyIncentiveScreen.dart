import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app_imports.dart';
import '../../../model/Insentive.dart';
import '../demand/BuyerDemandMainScreen.dart';

class MyIncentiveScreen extends StatefulWidget {
  const MyIncentiveScreen({super.key});

  @override
  State<MyIncentiveScreen> createState() => _MyIncentiveScreenState();
}

class _MyIncentiveScreenState extends State<MyIncentiveScreen> {
  int tab_flag = 0;
  List<Awardeddata> awardeddataList = [];
  List<Redeemdata> redeemdataList = [];
  var unescape = HtmlUnescape();

  Future getMyInsentive() async {
    try {
      var param = {"farmer_id": "3"};
      final response = await APIService.postAPIMethod(url: ApiURL.incentiveBeneficiariesList, params: param);
      final data = json.decode(response.body);
      //print(data);
      final res = Insentive.fromJson(data);
      if (res.success == 1) {
        setState(() {
          if (res.awardeddata != null) {
            awardeddataList = res.awardeddata ?? [];
          }
          if (res.redeemdata != null) {
            redeemdataList = res.redeemdata ?? [];
          }
        });
      }
      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getMyInsentive();
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
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
                title: WidgetUtils.appTextWidget(context: context, title: 'My Incentive'.tr, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
                iconTheme: const IconThemeData(color: Colors.white),
                leading: IconButton(
                  icon: const Icon(Icons.keyboard_backspace_sharp),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    // width: lang=='en'?(MediaQuery.of(context).size.width) - 30:double.maxFinite - 330,
                    width: double.maxFinite,
                    height: 60,
                    child: AnimatedToggleNew(
                      initialPosition: tab_flag,
                      values: ['AWARDED'.tr, 'REDEEMED'.tr],
                      onToggleCallback: (value) {
                        setState(() {
                          tab_flag = value;
                        });
                      },
                      buttonColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                      backgroundColor: const Color(0xFFFFFFFF),
                      textColor: const Color(0xFFFFFFFF),
                      borderColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                    ),
                  ),
                  Expanded(child: tab_flag == 0 ? awardedScreen() : redeemScreen()),
                ],
              ))),
    );
  }

  awardedScreen() {
    return Container(
      child: awardeddataList.isNotEmpty
          ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: awardeddataList.length,
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
                DateTime dateTime = dateFormat.parse(awardeddataList[index].incentiveAwardedOn ?? "");
                DateFormat dateFormat2 = DateFormat("dd MMM yyyy hh:mm a");
                var date = dateFormat2.format(dateTime);
                return InkWell(
                  onTap: () {
                    //selectedIndex = index;
                    //  params = {'incentive_id': value[index].serviceId, 'trade_bidding_id': widget.bidderId, 'user_id': userId};
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      width: double.maxFinite,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xffCFCFCF))),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(color: Color(int.parse(themeColor.value.buttonColor!.color!)).withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                              child: CachedNetworkImage(
                                imageUrl: "${HeaderSingleton().configurationDetails!.serviceImageUrl}" "/" + (awardeddataList[index].logo ?? ""),
                                imageBuilder: (context, imageProvider) => Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Color(int.parse(themeColor.value.buttonColor!.color!)).withOpacity(0.5),
                                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(6))),
                                placeholder: (context, url) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.asset("assets/images/umrella.png", fit: BoxFit.contain, height: 25, width: 25),
                                ),
                                errorWidget: (context, url, error) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.asset("assets/images/umrella.png", fit: BoxFit.contain, height: 25, width: 25),
                                ),
                              ),
                            ),
                            WidgetUtils.appTextWidget(
                                context: context, title: awardeddataList[index].incentiveName ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                            WidgetUtils.appTextWidget(context: context, title: date ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Html(
                                data: unescape.convert(awardeddataList[index].overview ?? ""),
                                style: {
                                  'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize:  FontSize(14), letterSpacing: 0.0),
                                  'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize:  FontSize(14), letterSpacing: 0.0),
                                  'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize:  FontSize(14), letterSpacing: 0.0),
                                  "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize:  FontSize(14), letterSpacing: 0.0),
                                  "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                                },
                              ),
                            ),
                          ],
                        ),

                        // SizedBox(height: 8),
                        // WidgetUtils.appTextWidget(
                        //     context: context, title: value[index].overview ?? "", color: const Color(0xff575757), fontWeight: FontWeight.w400, fontSize: 10, family: 'Graphik'),
                      ]),
                    ),
                  ),
                );
              })
          : Container(),
    );
  }

  redeemScreen() {
    return Container(
      child: redeemdataList.isNotEmpty
          ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: redeemdataList.length,
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
                DateTime dateTime2 = dateFormat.parse(redeemdataList[index].incentiveRedeemedDate ?? "");
                DateTime dateTime = dateFormat.parse(redeemdataList[index].incentiveAwardedOn ?? "");
                DateFormat dateFormat2 = DateFormat("dd MMM yyyy hh:mm a");
                var date = dateFormat2.format(dateTime);
                var date2 = dateFormat2.format(dateTime2);
                return InkWell(
                  onTap: () {
                    //selectedIndex = index;
                    //  params = {'incentive_id': value[index].serviceId, 'trade_bidding_id': widget.bidderId, 'user_id': userId};
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      width: double.maxFinite,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xffCFCFCF))),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(color: Color(int.parse(themeColor.value.buttonColor!.color!)).withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                              child: CachedNetworkImage(
                                imageUrl: "${HeaderSingleton().configurationDetails!.serviceImageUrl}" "/" + (redeemdataList[index].logo ?? ""),
                                imageBuilder: (context, imageProvider) => Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Color(int.parse(themeColor.value.buttonColor!.color!)).withOpacity(0.5),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(6))),
                                placeholder: (context, url) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.asset("assets/images/umrella.png", fit: BoxFit.contain, height: 25, width: 25),
                                ),
                                errorWidget: (context, url, error) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.asset("assets/images/umrella.png", fit: BoxFit.contain, height: 25, width: 25),
                                ),
                              ),
                            ),
                            WidgetUtils.appTextWidget(
                                context: context, title: redeemdataList[index].incentiveName ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                            WidgetUtils.appTextWidget(
                                context: context,
                                title: getDateFormat(awardeddataList[index].incentiveAwardedOn ?? ""),
                                color: const Color(0xff3F3F3F),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                family: 'Graphik'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Html(
                                data: unescape.convert(redeemdataList[index].overview ?? ""),
                                style: {
                                  'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize:  FontSize(14), letterSpacing: 0.0),
                                  'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize:  FontSize(14), letterSpacing: 0.0),
                                  'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize:  FontSize(14), letterSpacing: 0.0),
                                  "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize:  FontSize(14), letterSpacing: 0.0),
                                  "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                                },
                              ),
                            ),
                          ],
                        ),
                        WidgetUtils.appTextWidget(
                            context: context, title: "Redeem Date - " + (date2 ?? ""), color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                        // SizedBox(height: 8),
                        // WidgetUtils.appTextWidget(
                        //     context: context, title: value[index].overview ?? "", color: const Color(0xff575757), fontWeight: FontWeight.w400, fontSize: 10, family: 'Graphik'),
                      ]),
                    ),
                  ),
                );
              })
          : Container(),
    );
  }
}
