import 'package:get/get.dart';

import '../../app_imports.dart';
import '../../model/PartnerResponse.dart' as pd;
import '../../model/Services.dart';

class ServiceInformationScreen extends StatefulWidget {
  final pd.PartnerData partnerData;
  final String stateId, cityId;
  final String categoryId;

  const ServiceInformationScreen(this.partnerData, this.stateId, this.cityId, this.categoryId, {super.key});

  @override
  _ServiceInformationScreenState createState() => _ServiceInformationScreenState();
}

class _ServiceInformationScreenState extends State<ServiceInformationScreen> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String loadingText = 'Loading..';
  late final double? elevation = 3.0;
  List<ServiceOptions> serviceList = [];

  //late ConfigUrl configUrl;
  var unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    loadingText = 'Loading . . .';
    isLoading.value = true;
    fetchService();
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, title: 'Services'.tr, color: Colors.white, fontSize: 18, family: 'Graphik'),
            leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
          ),
          body: CustomProgressHandler(
              isLoading: isLoading.value,
              loadingText: loadingText,
              child: Column(children: [
                const SizedBox(height: 12),
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE0E0E0))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 76,
                              width: 76,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                              child: Container(
                                  child: CachedNetworkImage(
                                imageUrl: "${HeaderSingleton().configurationDetails?.partner_business_logo ?? ""}/${widget.partnerData.profileImage ?? ""}",
                                imageBuilder: (context, imageProvider) => Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
                                ),
                                placeholder: (context, url) => Image.file(File(image), fit: BoxFit.fill),
                                errorWidget: (context, url, error) => Image.asset("assets/images/user.png", fit: BoxFit.fill),
                              ))),
                          const SizedBox(width: 10),
                          SizedBox(
                            // height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: WidgetUtils.appTextWidget(
                                        context: context,
                                        softWrap: false,
                                        title: "${widget.partnerData.firstName ?? ""} ${widget.partnerData.lastName ?? ""}",
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, color: Color(int.parse(themeColor.value.buttonColor!.color!)), size: 8),
                                    const SizedBox(width: 4),
                                    SizedBox(
                                        width: 200,
                                        child: WidgetUtils.appTextWidget(
                                            context: context,
                                            softWrap: false,
                                            title: widget.partnerData.address ?? '-',
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            color: const Color(0xFF3F3F3F),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10)),
                                  ],
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                SizedBox(
                                  width: 184,
                                  height: 100,
                                  child: Html(
                                    data: unescape.convert(widget.partnerData.businessDetails ?? ""),
                                    style: {
                                      'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                      'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                      'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                      "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                      "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () {
                                      _showCalendarDetail(context, widget.partnerData);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: WidgetUtils.appTextWidget(context: context, title: "Read more".tr, color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500, family: 'Graphik'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      true
                          ? Container()
                          : Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () async {
                                  isLoading.value = true;
                                  await postEnquiry(widget.partnerData.userId, "", "");
                                  isLoading.value = false;
                                  setState(() {});
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  width: 100,
                                  height: 36,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/Enquire.svg',
                                        height: 14,
                                        color: Color(int.parse(themeColor.value.barColor!.color!)),
                                      ),
                                      WidgetUtils.appTextWidget(
                                          context: context, title: 'Contact'.tr, color: Color(int.parse(themeColor.value.barColor!.color!)), fontWeight: FontWeight.w500, fontSize: 14)
                                    ],
                                  ),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: Color(int.parse(themeColor.value.buttonColor!.color!)))),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                    child: WidgetUtils.appTextWidget(
                        context: context,
                        softWrap: false,
                        title: 'Services'.tr,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: 15)),
                const SizedBox(height: 12),
                serviceList.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/nopartner.png", height: 140, width: 188),
                          const SizedBox(height: 20),
                          WidgetUtils.appTextWidget(context: context, title: 'No Partners Services found'.tr, fontSize: 16, color: Colors.black),
                        ],
                      ))
                    : Container(
                        child: Expanded(
                        child: ListView.builder(
                            itemCount: serviceList.length,
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  //  Navigator.push(context, MaterialPageRoute(builder: (newCtx)=>ServiceDetailsScreen(serviceList[index])));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                        // width: MediaQuery.of(context).size.width - 35,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFCFCFCF))),
                                        padding: const EdgeInsets.all(12),
                                        margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                height: 76,
                                                width: 76,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                                child: CachedNetworkImage(
                                                  imageUrl: "${HeaderSingleton().configurationDetails?.serviceImageUrl ?? ""}/${serviceList[index].logo ?? ""}",
                                                  imageBuilder: (context, imageProvider) => Container(
                                                    height: 75,
                                                    width: 75,
                                                    decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
                                                  ),
                                                  placeholder: (context, url) => Image.file(File(image), fit: BoxFit.fill),
                                                  errorWidget: (context, url, error) => Image.asset("assets/images/user.png", fit: BoxFit.fill),
                                                )),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.6,
                                                  child: WidgetUtils.appTextWidget(
                                                      context: context,
                                                      softWrap: false,
                                                      title: lang == 'en' ? (serviceList[index].productServicesName ?? "") : serviceList[index].productServicesNameMr ?? "",
                                                      textAlign: TextAlign.left,
                                                      overflow: TextOverflow.ellipsis,
                                                      color: const Color(0xFF000000),
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(height: 8),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.6,
                                                  height: 100,
                                                  child: Html(
                                                    data: unescape.convert(serviceList[index].overview ?? ""),
                                                    style: {
                                                      'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                      'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                      'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                      "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                      "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                                                    },
                                                  ),
                                                ),
                                                (serviceList[index].overview ?? "").length > 70
                                                    ? Container(
                                                        width: MediaQuery.of(context).size.width * 0.6,
                                                        child: InkWell(
                                                          onTap: () {
                                                            _showServiceDetail(context, serviceList[index]);
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 8.0),
                                                            child: WidgetUtils.appTextWidget(
                                                                context: context, title: "Read more".tr, color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500, family: 'Graphik'),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      isLoading.value = true;
                                                      await postEnquiry(widget.partnerData.userId, serviceList[index].categoryId, serviceList[index].serviceId);
                                                      isLoading.value = false;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                                      width: 100,
                                                      height: 36,
                                                      decoration:
                                                          BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: Color(int.parse(themeColor.value.buttonColor!.color!)))),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/images/Enquire.svg',
                                                            height: 14,
                                                            color: Color(int.parse(themeColor.value.barColor!.color!)),
                                                          ),
                                                          WidgetUtils.appTextWidget(
                                                              context: context,
                                                              title: 'Enquire'.tr,
                                                              color: Color(int.parse(themeColor.value.barColor!.color!)),
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 14)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              );
                            }),
                      ))
              ]))),
    );
  }

  void _showCalendarDetail(BuildContext ctx, final partnerDetails) {
    showDialog(
        context: ctx,
        builder: (BuildContext newCtx) {
          return Consumer<LandCropProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (builderContext, StateSetter setState) {
              return AlertDialog(
                  titlePadding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  contentPadding: const EdgeInsets.only(left: 16, right: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                          color: const Color(0xff27914F)),
                    )
                  ],
                  title: WidgetUtils.appTextWidget(
                      context: context,
                      title: (partnerDetails.firstName ?? "") + " " + (partnerDetails.lastName ?? ""),
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w700,
                      family: 'Graphik',
                      fontSize: 16),
                  content: SizedBox(
                    // height: MediaQuery.of(builderContext).size.height * 0.35, // Change as per your requirement
                    width: 600.0,
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                        Html(
                          data: unescape.convert(partnerDetails.businessDetails ?? ""),
                          style: {
                            'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                          },
                        )
                      ]),
                    ),
                  ));
            });
          });
        });
  }

  void _showServiceDetail(BuildContext ctx, final partnerDetails) {
    showDialog(
        context: ctx,
        builder: (BuildContext newCtx) {
          return Consumer<LandCropProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (builderContext, StateSetter setState) {
              return AlertDialog(
                  titlePadding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  contentPadding: const EdgeInsets.only(left: 16, right: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                          color: const Color(0xff27914F)),
                    )
                  ],
                  title: WidgetUtils.appTextWidget(
                      context: context, title: (partnerDetails.productServicesName ?? ""), textAlign: TextAlign.start, fontWeight: FontWeight.w700, family: 'Graphik', fontSize: 16),
                  content: SizedBox(
                    // height: MediaQuery.of(builderContext).size.height * 0.35, // Change as per your requirement
                    width: 600.0,
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                        Html(
                          data: unescape.convert(partnerDetails.overview ?? ""),
                          style: {
                            'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                          },
                        )
                      ]),
                    ),
                  ));
            });
          });
        });
  }

  Future fetchService() async {
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final params = {'partner_id': widget.partnerData.userId!, 'state': widget.stateId, 'city': widget.cityId};
        final response = await APIService.postAPIMethod(url: ApiURL.getPartnerServices, params: params);
        var data = json.decode(response.body);
        Services services = Services.fromJson(data);
        if (services.success != 1) {
          WidgetUtils.errorDialog(context, data["msg"]);
        } else {
          setState(() {
            List<ServiceOptions>? farmerData = services.serviceOptions;
            if (farmerData != null) {
              serviceList = farmerData;
              // configUrl = services.configUrl!;
            }
          });
        }
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future postEnquiry(id, categoryId, serviceId) async {
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params1 = {"farmer_id": HeaderSingleton().paramsMaps!.userId, "partner_id": id, /*widget.partnerData.userId,*/ "category_id": widget.categoryId, "service_id": serviceId};

        //  final response = await APIService.postAPIMethod(url: ApiURL.addUserLeads, params: params1);
        final response = await APIService.postAPIMethod(url: ApiURL.addServiceLeads, params: params1);
        var data = json.decode(response.body);
        CommonModel services = CommonModel.fromJson(data);
        if (services.success != 1) {
          WidgetUtils.successDialog(context, services.message);
        } else {
          WidgetUtils.errorDialog(context, services.message);
        }
      } else {
        WidgetUtils.informationDialog(context, AppTranslations.of(context)?.text("key_connection_lost") ?? 'key_connection_lost'.tr);
      }
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }
}
