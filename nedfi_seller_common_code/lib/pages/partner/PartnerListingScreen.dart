import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/app_imports.dart';

import '../../components/widgets/base_widget.dart';
import '../../model/CityResponse.dart';
import '../../model/PartnerResponse.dart';
import '../../model/StateResponse.dart';
import 'service_information.dart';

class PartnerListingScreen extends StatefulWidget {
  String catId;
  String catName;

  PartnerListingScreen(this.catId, this.catName, {Key? key}) : super(key: key);

  @override
  _PartnerListingScreenState createState() => _PartnerListingScreenState();
}

class _PartnerListingScreenState extends State<PartnerListingScreen> {
  late final double? elevation = 3.0;

  ValueNotifier<List<PartnerData>> partnerList = ValueNotifier([]);
  String stateName = "Select State", districtName = "Select District", stateId = "", districtId = "";
  List<StateData> searchState = [];
  List<CityData> searchCity = [];
  TextEditingController stateController = TextEditingController(), controller = TextEditingController(), controllerOne = TextEditingController(), districtController = TextEditingController();
  var unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    getPartnerListing();
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          title: WidgetUtils.appTextWidget(context: context, title: widget.catName.tr, color: Colors.white, fontSize: 18),
          leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
        ),
        child: ValueListenableBuilder(
          valueListenable: partnerList,
          builder: (BuildContext context, value, Widget? child) {
            return /*partnerList.value.isEmpty
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/nopartner.png", height: 140, width: 188),
                      const SizedBox(height: 20),
                      WidgetUtils.appTextWidget(context: context, title: 'No Partners found'.tr, fontSize: 16, color: Colors.black),
                    ],
                  ))
                :*/
                ListView(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 58,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16),
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
                  // margin: const EdgeInsets.only(right: 16),
                  child: TextField(
                    onTap: () {
                      searchState.clear();
                      searchCity.clear();
                      controllerOne.clear();
                      controller.clear();
                      showStateFilter(context);
                    },
                    controller: stateController,
                    keyboardType: TextInputType.text,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        hintText: 'Select State'.tr,
                        border: InputBorder.none,
                        counterText: "",
                        suffixIcon: const Icon(Icons.keyboard_arrow_down)),
                    style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: 58,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16),
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
                  // margin: const EdgeInsets.only(right: 16),
                  child: TextField(
                    onTap: () {
                      if (stateController.text.isEmpty) {
                        WidgetUtils.errorDialog(context, 'Please Select State'.tr);
                        setState(() {});
                      } else {
                        searchState.clear();
                        searchCity.clear();
                        controllerOne.clear();
                        controller.clear();
                        showDistrictFilter(context);
                      }
                    },
                    controller: districtController,
                    keyboardType: TextInputType.text,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        hintText: 'Select District'.tr,
                        border: InputBorder.none,
                        counterText: "",
                        suffixIcon: const Icon(Icons.keyboard_arrow_down)),
                    style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  ),
                ),
                partnerList.value.length == 0
                    ? Container(
                        height: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/nopartner.png", height: 140, width: 188),
                            const SizedBox(height: 20),
                            WidgetUtils.appTextWidget(context: context, title: "No Partner is available for selected Location".tr, fontSize: 16, color: Colors.black),
                          ],
                        ))
                    : Padding(
                        padding: const EdgeInsets.only(top: 23.0),
                        child: ListView.builder(
                            itemCount: partnerList.value.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return partnerListItems(partnerList.value[index]);
                            }),
                      ),
              ],
            );
          },
        ));
  }

  Widget partnerListItems(PartnerData partnerDetails) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceInformationScreen(partnerDetails, stateId, districtId, widget.catId)));
      },
      child: Container(
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
                      imageUrl: (HeaderSingleton().configurationDetails?.partner_business_logo ?? "") + "/" + (partnerDetails.profileImage ?? ""),
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
                              title: (partnerDetails.firstName ?? "") + " " + (partnerDetails.lastName ?? ""),
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
                                  title: partnerDetails.address ?? '-',
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
                          data: unescape.convert(partnerDetails.businessDetails ?? ""),
                          style: {
                            'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                            "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                          },
                        ),
                      ),
                      (partnerDetails.businessDetails ?? "").length > 70
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () {
                                  _showCalendarDetail(context, partnerDetails);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: WidgetUtils.appTextWidget(context: context, title: "Read more".tr, color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500, family: 'Graphik'),
                                ),
                              ),
                            )
                          : Container()
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
                      onTap: () {
                        postEnquiry(partnerDetails.userId);
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceInformationScreen(partnerDetails, stateId,districtId, widget.catId)));
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
                            WidgetUtils.appTextWidget(context: context, title: 'Contact'.tr, color: Color(int.parse(themeColor.value.barColor!.color!)), fontWeight: FontWeight.w500, fontSize: 14)
                          ],
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: Color(int.parse(themeColor.value.buttonColor!.color!)))),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future postEnquiry(id) async {
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params1 = {"farmer_id": HeaderSingleton().paramsMaps!.userId, "partner_id": id, /*widget.partnerData.userId,*/ "product_id": ""};
        final response = await APIService.postAPIMethod(url: ApiURL.addUserLeads, params: params1);
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

  List<StateData> _searchResult = [];

  List<CityData> _searchResultOne = [];

  void showStateFilter(BuildContext context) {
    var loanModel = Provider.of<LoanProvider>(context, listen: false);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<LoanProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: MediaQuery.of(context).size.height * 0.52, // Change as per your requirement
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context, title: 'Select State'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
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
                              controller: controller,
                              decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                              onChanged: (text) {
                                _searchResult.clear();
                                if (text.isEmpty) {
                                  setState(() {});
                                  return;
                                }
                                for (var userDetail in loanModel.stateList) {
                                  if (userDetail.name.toUpperCase().contains(text.toUpperCase())) _searchResult.add(userDetail);
                                }

                                setState(() {});
                              },
                            ),
                            trailing: InkWell(
                                child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                onTap: () {
                                  controller.clear();
                                  _searchResult.clear();
                                  if ("".isEmpty) {
                                    setState(() {});
                                    return;
                                  }
                                  for (var userDetail in loanModel.stateList) {
                                    if (userDetail.name.contains("")) _searchResult.add(userDetail);
                                  }
                                  setState(() {});
                                })),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 300,
                        child: _searchResult.isNotEmpty || controller.text.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
                                itemCount: _searchResult.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        var loanModel = Provider.of<LoanProvider>(context, listen: false);
                                        stateController!.text = _searchResult[index].name;
                                        stateId = _searchResult[index].id;
                                        final value = await HelperUtils().getCity(_searchResult[index].id, (value) {}, context);
                                        loanModel.setCity(value!);
                                        districtController!.text = "";
                                        districtId = "";
                                        _searchResultOne = [];
                                        getPartnerListing();
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width - 20,
                                        height: 40,
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                        child: Text(
                                          _searchResult[index].name,
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                      ));
                                },
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
                                shrinkWrap: true,
                                itemCount: loanModel.stateList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      var loanModel = Provider.of<LoanProvider>(context, listen: false);
                                      stateController!.text = loanModel.stateList[index].name;
                                      final value = await HelperUtils().getCity(loanModel.stateList[index].id, (value) {}, context);
                                      loanModel.setCity(value!);
                                      districtController!.text = "";
                                      districtId = "";
                                      _searchResultOne = [];
                                      stateId = loanModel.stateList[index].id;
                                      getPartnerListing();
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 20,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                      child: Text(
                                        loanModel.stateList[index].name,
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ]),
                  ));
            });
          });
        });
  }

  void showDistrictFilter(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<LoanProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: MediaQuery.of(context).size.height * 0.54, // Change as per your requirement
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      SizedBox(height: 8),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context, title: 'Select District'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
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
                                for (var userDetail in loanModel.cityList) {
                                  if (userDetail.name.toUpperCase().contains(text.toUpperCase()) || userDetail.name.toLowerCase().contains(text.toLowerCase())) _searchResultOne.add(userDetail);
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
                                  for (var userDetail in loanModel.cityList) {
                                    if (userDetail.name.contains("")) _searchResultOne.add(userDetail);
                                  }
                                  setState(() {});
                                })),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 300,
                        child: _searchResultOne.isNotEmpty || controllerOne.text.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: _searchResultOne.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        districtController!.text = _searchResultOne[index].name;
                                        districtId = _searchResultOne[index].id;
                                        getPartnerListing();
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 20,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                      child:
                                          WidgetUtils.appTextWidget(context: context, title: _searchResultOne[index].name, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, fontSize: 16.0),
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: loanModel.cityList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        districtController!.text = loanModel.cityList[index].name;
                                        districtId = loanModel.cityList[index].id;
                                        getPartnerListing();
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 20,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                      child: Text(
                                        loanModel.cityList[index].name,
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ]),
                  ));
            });
          });
        });
  }

  Future getPartnerListing() async {
    isLoading.value = true;
    HelperUtils().getState((value) {}, context);
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {'type': widget.catId, 'state': stateId ?? "", 'city': districtId ?? ""};
        final response = await APIService.postAPIMethod(url: ApiURL.getPartners, params: params);
        final data = json.decode(response.body);
        print(data);
        PartnerModel partners = PartnerModel.fromJson(data);
        if (partners.status != 1) {
          partnerList.value = [];
          setState(() {});
          WidgetUtils.errorDialog(context, partners.message!);
        } else {
          List<PartnerData> farmerData = partners.data!;
          if (farmerData.isNotEmpty) {
            partnerList.value = farmerData;
            setState(() {});
          }
        }
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    }
    isLoading.value = false;
    setState(() {});
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
