import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/components/widgets/base_widget.dart';
import 'package:buyer_common_code/model/MarketResponse.dart' as mr;

import '../../model/home_page_model.dart';
import '../../model/state_list_model.dart';

class CommodityScreen extends StatefulWidget {
  const CommodityScreen({Key? key}) : super(key: key);

  @override
  _CommodityScreenState createState() => _CommodityScreenState();
}

class _CommodityScreenState extends State<CommodityScreen> {
  TextEditingController controllers = TextEditingController(),
      searchStateController = TextEditingController(),
      apmcController = TextEditingController(),
      dateController = TextEditingController(),
      stateController = TextEditingController(),
      productController = TextEditingController(),
      productVarietyController = TextEditingController();
  List<mr.MarketData> searchResults = [];
  List<StateListModelData> searchStateResults = [];
  ValueNotifier<List<NewCommoditydata>> ratesList = ValueNotifier([]);
  List<NewCommoditydata> listDetails = [], tempCommodityList = [];
  String cityName = "", cityId = "", selectedStateName = "";
  int page = 1;
  bool nextFlag = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // cityName = HeaderSingleton().cityName;
    isLoading.value = true;
    fetchCommodity(cityId);
    // getMarket();
    getStateList();
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          title: WidgetUtils.appTextWidget(context: context, title: "Commodity".tr, color: Colors.white, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
          iconTheme: const IconThemeData(color: Colors.white),
          /*bottom: PreferredSize(
                preferredSize: Size.fromHeight(HeaderSingleton().domain.value.toLowerCase() != 'icar' ? 60.0 : 0),
                child: Theme(
                  data: Theme.of(context).copyWith(hintColor: Colors.white),
                  child: Container(
                      color: Color(int.parse(themeColor.value.barColor!.color!)),
                      width: double.maxFinite,
                      height: 55,
                      margin: const EdgeInsets.only(bottom: 15),
                      alignment: Alignment.center,
                      child: Container(
                        width: double.maxFinite,
                        height: 43,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        // margin: const EdgeInsets.only(right: 16),
                        child: TextField(
                          // enabled: false,
                          controller: searchController,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            List<CommodityRateUpdates> searchList = [];
                            if (value.isNotEmpty) {
                              for (final commodityRates in tempCommodityList) {
                                if (commodityRates.commodityTitle!.toLowerCase().contains(value.toLowerCase())) {
                                  searchList.add(commodityRates);
                                }
                              }
                              if (searchList.isNotEmpty) {
                                ratesList.value = searchList;
                              }
                            } else {
                              searchList = [];
                              ratesList.value = tempCommodityList;
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search, size: 22, color: Colors.grey),
                            hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Graphik', fontSize: 14, fontWeight: FontWeight.w400),
                            hintText: 'Search anything..'.tr,
                            border: InputBorder.none,
                            counterText: "",
                            labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          ),
                          style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        ),
                      )),
                ))*/
        ),
        child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                if (!nextFlag) {
                  page += 1;
                  nextFlag = true;
                  fetchCommodity(cityId);
                }
                setState(() {});
              }
              return true;
            },
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                /*  const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 15 ,
                        child: WidgetUtils.appTextWidget(context: context,
                            title: 'Select Crop'.tr,
                            fontWeight: FontWeight.w500,
                            family: 'Graphik',
                            fontSize: 16),
                      ),
                      SizedBox(
                        width:  10,
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 15 ,
                        child: WidgetUtils.appTextWidget(context: context,
                            title: 'Select Variety'.tr,
                            fontWeight: FontWeight.w500,
                            family: 'Graphik',
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 08),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 15 ,
                        height: 58,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                        // margin: const EdgeInsets.only(right: 16),
                        child: TextField(
                          onTap: () {
                             // showProductVariety(context);
                          },
                          controller: productController,
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              hintText: 'Select Crop'.tr,
                              border: InputBorder.none,
                              counterText: "",
                              suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        width:  10,
                      ),
                     Container(
                        width: (MediaQuery.of(context).size.width / 2) - 15,
                        height: 58,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                        // margin: const EdgeInsets.only(right: 16),
                        child: TextField(
                          onTap: () {

                             // dialogSelectDate();

                          },
                          controller: productVarietyController,
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                              hintText: 'Select Variety'.tr,
                              border: InputBorder.none,
                              counterText: "",
                              suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        ),
                      )
                         ,
                    ],
                  ),
                ),*/

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: WidgetUtils.appTextWidget(context: context, title: 'Select State'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                ),
                const SizedBox(height: 08),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: double.maxFinite,
                    height: 58,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                    // margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      onTap: () {
                        var loanModel = Provider.of<CommodityProvider>(context, listen: false);
                        if (loanModel.stateList.isEmpty) {
                          WidgetUtils.errorDialog(context, "No State Available".tr);
                        } else {
                          showDialogState(context);
                        }
                      },
                      controller: stateController,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          hintText: 'Select State'.tr,
                          border: InputBorder.none,
                          counterText: "",
                          suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: WidgetUtils.appTextWidget(context: context, title: 'Select Market'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                        ),
                        const SizedBox(height: 08),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            width: dateController.text.isEmpty?MediaQuery.of(context).size.width / 1.6 - 30:MediaQuery.of(context).size.width / 1.75 - 20,
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              onTap: () {
                                var loanModel = Provider.of<CommodityProvider>(context, listen: false);
                                if(cityName.isEmpty){
                                  WidgetUtils.errorDialog(context, "Please Select State First".tr);
                                }else if (loanModel.marketList.isEmpty) {
                                  WidgetUtils.errorDialog(context, "No Market Available".tr);
                                } else {
                                  showDialogCommodity(context);
                                }
                              },
                              controller: apmcController,
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintText: 'Select Market'.tr,
                                  border: InputBorder.none,
                                  counterText: "",
                                  suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: WidgetUtils.appTextWidget(context: context, title: 'Select Date'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                        ),
                        const SizedBox(height: 08),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            width: dateController.text.isEmpty?MediaQuery.of(context).size.width / 3:MediaQuery.of(context).size.width / 2.32-22,
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              onTap: () {
                                selectDate(context);
                              },
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintText: 'Date'.tr,
                                  border: InputBorder.none,
                                  counterText: "",
                                  suffixIcon: const Icon(Icons.calendar_month_outlined, color: Color(0xffFDA11E),size:20)),
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // homeConfigurableModel != null && homeConfigurableModel.value!.data!.commodityRateUpdates!.isNotEmpty
                //     ? Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: WidgetUtils.appTextWidget(context:context,
                //     title: 'Your Selected Crop'.tr,
                //     fontSize: 16,
                //     family: 'Graphik',
                //     fontWeight: FontWeight.w700,
                //     textAlign: TextAlign.start,
                //   ),
                // )
                //     : Container(),
                /*   (homeConfigurableModel != null && homeConfigurableModel.value != null) && homeConfigurableModel.value!.data!.commodityRateUpdates!=null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          height: 119,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: homeConfigurableModel.value!.data!.commodityRateUpdates!.length,
                              itemBuilder: (ctx, index) {
                                final data = homeConfigurableModel.value!.data!.commodityRateUpdates![index].arrivalDate!.split("-");
                                DateTime now = DateTime(int.parse(data[0]), int.parse(data[1]), int.parse(data[2]));
                                String formattedDate = DateFormat('dd-MM-yyyy').format(now.toLocal());
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context, MaterialPageRoute(builder: (ctx) => CommodityDetailsScreen(commodityList: homeConfigurableModel.value!.data!.commodityRateUpdates![index]))),
                                    child: Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                      boxShadow: [BoxShadow(blurRadius: 0.7, color: Colors.grey, spreadRadius: 0.3)],
                                                    ),
                                                    height: MediaQuery.of(context).size.height * 0.036,
                                                    width: MediaQuery.of(context).size.height * 0.036,
                                                    child: CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                        HeaderSingleton().configurationDetails!.cropImageUrl! + homeConfigurableModel.value!.data!.commodityRateUpdates![index].logo!,
                                                      ),
                                                      onBackgroundImageError: (obj, stc) => Image.file(File(image), fit: BoxFit.cover, height: 36, width: 36),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset("assets/images/marker.svg", height: 8),
                                                      const SizedBox(width: 2),
                                                      WidgetUtils.appTextWidget(
                                                          context: context,
                                                          title: homeConfigurableModel.value!.data!.commodityRateUpdates![index].market!,
                                                          fontWeight: FontWeight.w400,
                                                          color: const Color(0xff272727),
                                                          family: 'Graphik',
                                                          fontSize: 12)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 6.0, left: 6),
                                              child: WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: homeConfigurableModel.value!.data!.commodityRateUpdates![index].commodityTitle!,
                                                  fontWeight: FontWeight.w500,
                                                  family: 'Graphik',
                                                  color: const Color(0xff272727),
                                                  fontSize: 12),
                                            ),
                                            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                                            Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: RichText(
                                                    text: TextSpan(
                                                  children: <TextSpan>[
                                                    const TextSpan(
                                                      text: 'Min : ₹ ',
                                                      style: TextStyle(fontSize: 12.0, color: Color(0xFF6F6F6F), fontWeight: FontWeight.w300, fontFamily: 'Graphik'),
                                                    ),
                                                    TextSpan(
                                                        text: homeConfigurableModel.value!.data!.commodityRateUpdates![index].minPrice!,
                                                        style: const TextStyle(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: 12, color: Colors.orange)),
                                                  ],
                                                ))),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: RichText(
                                                  text: TextSpan(
                                                children: <TextSpan>[
                                                  const TextSpan(
                                                    text: 'Max : ₹ ',
                                                    style: TextStyle(fontSize: 12.0, color: Color(0xFF575757), fontWeight: FontWeight.w300, fontFamily: 'Graphik'),
                                                  ),
                                                  TextSpan(
                                                      text: homeConfigurableModel.value!.data!.commodityRateUpdates![index].maxPrice!,
                                                      style: const TextStyle(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: 12, color: Colors.green)),
                                                ],
                                              )),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: RichText(
                                                    text: TextSpan(
                                                  children: <TextSpan>[
                                                    const TextSpan(
                                                      text: 'Date: ',
                                                      style: TextStyle(fontSize: 11.0, color: Colors.black, fontWeight: FontWeight.w300, fontFamily: 'Graphik'),
                                                    ),
                                                    TextSpan(text: formattedDate, style: const TextStyle(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: 11, color: Colors.black)),
                                                  ],
                                                ))),
                                          ],
                                        ),
                                        // height: 112,
                                        width: 119,
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFCFCFCF), width: 1.2))),
                                  ),
                                );
                              }),
                        ))
                    : Container(),*/
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      WidgetUtils.appTextWidget(
                        context: context,
                        title: 'Market Views'.tr,
                        fontSize: 18,
                        family: 'Graphik',
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.start,
                      ),
                      /*Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade500)),
                        child: WidgetUtils.appTextWidget(
                            context: context, title: 'T= Tonnes \nQ= Quintals', fontSize: 12, color: Colors.red, family: 'Graphik', fontWeight: FontWeight.w200, textAlign: TextAlign.start),
                      )*/
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!)), borderRadius: BorderRadius.circular(4)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      SizedBox(
                          width: 90,
                          child: WidgetUtils.appTextWidget(
                              context: context, title: 'Product'.tr, fontSize: 12, family: 'Graphik', color: Colors.white, fontWeight: FontWeight.w500, textAlign: TextAlign.left)),
                      WidgetUtils.appTextWidget(context: context, title: "", fontSize: 12, family: 'Graphik', color: Colors.white, fontWeight: FontWeight.w500, textAlign: TextAlign.start),
                      SizedBox(
                        width: 70,
                        child: WidgetUtils.appTextWidget(
                          context: context,
                          textAlign: TextAlign.right,
                          title: "Modal Price\n(Rs/Quintal)".tr,
                          fontSize: 12,
                          softWrap: true,
                          family: 'Graphik',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                          width: 70,
                          child: WidgetUtils.appTextWidget(
                              context: context, title: 'Min/Max\n(Rs/Quintal)'.tr, fontSize: 12, color: Colors.white, family: 'Graphik', fontWeight: FontWeight.w500, textAlign: TextAlign.right))
                    ])),
                buildListRate(),
              ]),
            )));
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101),builder:(context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Color(int.parse(themeColor.value.buttonColor!.color!)),
            onPrimary: Color(int.parse(themeColor.value.buttonTextColor!.color!)), // <-- SEE HERE
            onSurface: Colors.black87,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Color(int.parse(themeColor.value.buttonColor!.color!)),
            ),
          ),
        ),
        child: child!,
      );
    },);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        final DateFormat formatter = DateFormat('dd-MMM-yyyy');
        final String formatted = formatter.format(selectedDate);
        dateController.text = formatted;
      });
      await fetchCommodity(cityId, isFrom: true);
    }
  }

  Widget buildListRate() {
    return ValueListenableBuilder(
      valueListenable: ratesList,
      builder: (BuildContext context, List<NewCommoditydata> snapshot, child) {
        dynamic url = HeaderSingleton().configurationDetails != null ? HeaderSingleton().configurationDetails! : Provider.of<HomeDashboardProvider>(context, listen: false).configUrl;
        return snapshot.isNotEmpty
            ? ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            /*   if(snapshot[index].arrivals!.isNotEmpty){
                    final arrivalDate = snapshot[index].arrivals!.split("-");
                    final predictionDate = DateTime(int.parse(arrivalDate[0]), int.parse(arrivalDate[1]), int.parse(arrivalDate[2]));
                    final currentDate = DateTime.now();
                    final difference = predictionDate.difference(currentDate).inDays;
                  }*/
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => CommodityDetailsScreen(commodityList: snapshot[index]))),
              child: Container(
                  height: 100,
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: 12,
                          width: 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.green,
                                size: 15,
                              ),
                              const SizedBox(width: 5),
                              WidgetUtils.appTextWidget(
                                  context: context,
                                  title: snapshot[index].marketwiseapmcpricedate!,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 10),
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 55,
                            height: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: /* (url.cropImageUrl ?? "") +*/ (snapshot[index].logo ?? ""),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(height: 40, width: 40, decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.fill))),
                                  placeholder: (context, url) => Image.file(File(image), fit: BoxFit.fill, height: 40, width: 40),
                                  errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.fill, height: 40, width: 40),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              SizedBox(
                                  width: 80,
                                  child: WidgetUtils.appTextWidget(
                                      context: context,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      title: snapshot[index].productName!,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.start,
                                      color: const Color(0xFF272727),
                                      fontSize: 12)),
                              SizedBox(
                                  width: 80,
                                  child: WidgetUtils.appTextWidget(
                                      context: context,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      title: snapshot[index].variety!,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.start,
                                      color: const Color(0xFF656565),
                                      fontSize: 10)),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: 70,
                                  child: WidgetUtils.appTextWidget(
                                      textAlign: TextAlign.left,
                                      context: context,
                                      title: '₹${snapshot[index].modalprices!}',
                                      color: Color(int.parse(themeColor.value.buttonColor!.color!)),
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12)),
                            ],
                          ),
                          SizedBox(
                            width: 70,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 55,
                                  child: WidgetUtils.appTextWidget(
                                      context: context,
                                      textAlign: TextAlign.right,
                                      title: '₹${snapshot[index].minimumprices!}/${snapshot[index].maximumprices!}',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          /* SizedBox(
                                    width: 40,
                                    child: WidgetUtils.appTextWidget(
                                        context: context, title: '${snapshot[index].arrivals!} T', color: Colors.black, fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis, fontSize: 12)),*/
                        ],
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 0.2))),
            );
          },
        )
            : Column(
          children: [
            const SizedBox(height: 20),
            Center(child: WidgetUtils.appTextWidget(context: context, title: 'No data found'.tr)),
          ],
        );
      },
    );
  }

  Future<List<NewCommoditydata>> fetchCommodity(String city, {bool isFrom = false}) async {
    try {
      if (isFrom) {
        listDetails.clear();
      }
      final param = {"apmc_market": city, 'lat': HeaderSingleton().lat, 'long': HeaderSingleton().lng, 'state': stateController.text,'market_date':dateController.text};
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.postAPIMethod(url: ApiURL.commodityPrice, params: param);
        final data = json.decode(response.body);
        if (data['success'] != 1) {
          WidgetUtils.errorDialog(context, data["msg"]);
          nextFlag = true;
        } else {
          if (data['data'].isEmpty) {
            nextFlag = true;
          } else {
            final tempList = listDetails;
            for (final commodityData in data['data']) {
              tempList.add(NewCommoditydata.fromJson(commodityData));
            }
            listDetails = tempList;
            ratesList.value = tempList;
            tempCommodityList = tempList;
            nextFlag = false;
          }

          if (isFrom) {
            if (mounted) setState(() {});
          }
        }
      }
    } catch (e) {
      // print(e);
      isLoading.value = false;
    }
    return ratesList.value;
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future getMarket() async {
    try {
      final param = {'state': stateController.text, 'lat': HeaderSingleton().lat, 'long': HeaderSingleton().lng};

      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.getMarketsList), body: param, headers: headerParams);
      var data = json.decode(response.body);
      // print(data);
      var res = mr.MarketResponse.fromJson(data);
      if (res.success == 1) {
        var loanModel = Provider.of<CommodityProvider>(context, listen: false);
        loanModel.setMarket(res.data);
      }
    } catch (e) {
      // print(e.toString());
      isLoading.value = false;
    }
  }

  Future getStateList() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getStateList);
      var data = json.decode(response.body);
      var res = StateListModel.fromJson(data);
      if (res.success == 1) {
        var loanModel = Provider.of<CommodityProvider>(context, listen: false);
        loanModel.setStateDetails(res.data);
      }
    } catch (e) {
      // print(e.toString());
      isLoading.value = false;
    }
  }

  void showDialogCommodity(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<CommodityProvider>(//                    <--- Consumer
              builder: (ctx, loanModel, child) {
                return StatefulBuilder(builder: (context, StateSetter setState) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      height: 400,
                      width: 328,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                            child: ListTile(
                                dense: true,
                                leading: const Icon(Icons.search),
                                title: TextField(
                                  controller: controllers,
                                  decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                                  onChanged: (text) {
                                    searchResults = [];
                                    if (text.isEmpty) {
                                      setState(() {});
                                      return;
                                    }
                                    for (var userDetail in loanModel.marketList) {
                                      if (userDetail.apmcMarket!.toLowerCase().contains(text.toLowerCase())) {
                                        searchResults.add(userDetail);
                                      }
                                    }
                                    setState(() {});
                                  },
                                ),
                                trailing: InkWell(
                                    child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                    onTap: () {
                                      controllers.clear();
                                      searchResults.clear();
                                      if ("".isEmpty) {
                                        setState(() {});
                                        return;
                                      }
                                      for (var userDetail in loanModel.marketList) {
                                        if (userDetail.apmcMarket!.contains("")) {
                                          searchResults.add(userDetail);
                                        }
                                      }
                                      setState(() {});
                                    })),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 300.0, // Change as per your requirement
                            // width: 550.0,
                            child: searchResults.isNotEmpty
                                ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: searchResults.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      var dSSModel = Provider.of<CommodityProvider>(context, listen: false);
                                      dSSModel.setCommodityListClear([]);
                                      nextFlag = false;
                                      cityName = searchResults[index].apmcMarket ?? "";
                                      cityId = searchResults[index].id ?? "";
                                      apmcController.text = cityName;
                                      await fetchCommodity(cityId, isFrom: true);
                                      controllers.clear();
                                      searchResults.clear();
                                      isLoading.value = false;
                                    },
                                    child: Container(
                                      height: 40,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: WidgetUtils.appTextWidget(context: context, title: searchResults[index].apmcMarket ?? "", fontSize: 16, family: 'Graphik'),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                                    ));
                              },
                            )
                                : ListView.builder(
                              shrinkWrap: true,
                              itemCount: loanModel.marketList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      var dSSModel = Provider.of<CommodityProvider>(context, listen: false);
                                      dSSModel.setCommodityListClear([]);
                                      nextFlag = false;
                                      cityName = loanModel.marketList[index].apmcMarket ?? "";
                                      apmcController.text = cityName;
                                      cityId = loanModel.marketList[index].id ?? "";
                                      await fetchCommodity(cityId, isFrom: true);
                                      isLoading.value = false;
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: WidgetUtils.appTextWidget(context: context, title: loanModel.marketList[index].apmcMarket ?? "", fontSize: 16, family: 'Graphik'),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                                    ));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
              });
        });
  }

  void showDialogState(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<CommodityProvider>(//                    <--- Consumer
              builder: (ctx, loanModel, child) {
                return StatefulBuilder(builder: (context, StateSetter setState) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      height: 400,
                      width: 328,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                            child: ListTile(
                                dense: true,
                                leading: const Icon(Icons.search),
                                title: TextField(
                                  controller: searchStateController,
                                  decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                                  onChanged: (text) {
                                    searchStateResults = [];
                                    if (text.isEmpty) {
                                      setState(() {});
                                      return;
                                    }
                                    for (var userDetail in loanModel.stateList) {
                                      if (userDetail.stateName!.toLowerCase().contains(text.toLowerCase())) {
                                        searchStateResults.add(userDetail);
                                      }
                                    }
                                    setState(() {});
                                  },
                                ),
                                trailing: InkWell(
                                    child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                    onTap: () {
                                      searchStateController.clear();
                                      searchStateResults.clear();
                                      if ("".isEmpty) {
                                        setState(() {});
                                        return;
                                      }
                                      for (var userDetail in loanModel.stateList) {
                                        if (userDetail.stateName!.contains("")) {
                                          searchStateResults.add(userDetail);
                                        }
                                      }
                                      setState(() {});
                                    })),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 300.0, // Change as per your requirement
                            // width: 550.0,
                            child: searchStateResults.isNotEmpty
                                ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: searchStateResults.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      var dSSModel = Provider.of<CommodityProvider>(context, listen: false);
                                      dSSModel.setCommodityListClear([]);
                                      nextFlag = false;
                                      cityName = searchStateResults[index].stateName ?? "";
                                      // cityId = searchStateResults[index].id ?? "";
                                      stateController.text = cityName;
                                      apmcController.text = "";
                                      searchStateResults.clear();
                                      searchStateController.text = "";
                                      await fetchCommodity(cityId, isFrom: true);
                                      await getMarket();
                                      isLoading.value = false;
                                    },
                                    child: Container(
                                      height: 40,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: WidgetUtils.appTextWidget(context: context, title: searchStateResults[index].stateName ?? "", fontSize: 16, family: 'Graphik'),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                                    ));
                              },
                            )
                                : ListView.builder(
                              shrinkWrap: true,
                              itemCount: loanModel.stateList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      var dSSModel = Provider.of<CommodityProvider>(context, listen: false);
                                      dSSModel.setCommodityListClear([]);
                                      nextFlag = false;
                                      cityName = loanModel.stateList[index].stateName ?? "";
                                      stateController.text = cityName;
                                      apmcController.text = "";
                                      // cityId = loanModel.stateList[index].id ?? "";
                                      await fetchCommodity(cityId, isFrom: true);
                                      await getMarket();
                                      isLoading.value = false;
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: WidgetUtils.appTextWidget(context: context, title: loanModel.stateList[index].stateName ?? "", fontSize: 16, family: 'Graphik'),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                                    ));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
              });
        });
  }
}
