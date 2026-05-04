import 'package:get/get.dart';

import '../../../app_imports.dart';
import '../../../model/MyStat.dart';
import '../../../model/master_listing_model.dart';
import '../../../model/statistics_filter.dart';
import '../../../providers/master_provider.dart';

class MyStatScreen extends StatefulWidget {
  const MyStatScreen({super.key});

  @override
  State<MyStatScreen> createState() => _MyStatScreenState();
}

class _MyStatScreenState extends State<MyStatScreen> {
  TextEditingController productCategoryController = TextEditingController(), productTypeController = TextEditingController();
  String productCategoryID = "", year = "", month = "", day = "";
  List<MyStatData> myStatList = [];

  @override
  void initState() {
    super.initState();
    getMyStat("", "", "", "");
    getMasterList();
  }

  Future getMasterList() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getMasterListing);
      final data = json.decode(response.body);
      final res = MasterListing.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setMasterData(res.data!);
          productCategoryController.text=res.data?.productCategory?[0].title??"";
          productCategoryID=res.data?.productCategory?[0].id??"";
          year = filterData.value[0].value ?? "";
          getMyStat(productCategoryID, year, month, day);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MasterProvider>(builder: (context, masterProvider, child) {
      return SafeArea(
          child: CustomProgressHandler(
              loadingText: '',
              isLoading: isLoading.value,
              child: DefaultTabController(
                length: 5,
                child: Scaffold( backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0,
                    centerTitle: false,
                    backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
                    title: WidgetUtils.appTextWidget(context: context, title: 'My Statistics'.tr, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
                    iconTheme: const IconThemeData(color: Colors.white),
                    leading: IconButton(
                      icon: const Icon(Icons.keyboard_backspace_sharp),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  body: bodyWeight(masterProvider),
                ),
              )));
    });
  }

  bodyWeight(MasterProvider masterProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          WidgetUtils.appTextWidget(context: context, title: 'Product Category'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
          const SizedBox(height: 08),
          Container(
            width: double.maxFinite,
            height: 58,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16),
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              onTap: () {
                showProductCategory(context);
              },
              controller: productCategoryController,
              keyboardType: TextInputType.text,
              readOnly: true,
              decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  hintText: 'Select Product Category'.tr,
                  border: InputBorder.none,
                  counterText: "",
                  suffixIcon: const Icon(Icons.keyboard_arrow_down)),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 10),
          WidgetUtils.appTextWidget(context: context, title: 'Product Status'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
          const SizedBox(height: 8),
          Container(
              width: double.maxFinite,
              height: 58,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF), width: 1.2), borderRadius: BorderRadius.circular(4)),
              child: ValueListenableBuilder(
                  valueListenable: filterData,
                  builder: (BuildContext context, List<StatisticsFilterData> statsValue, Widget? child) {

                    return statsValue.isNotEmpty
                        ? DropdownButtonHideUnderline(
                            child: DropdownButton(
                                alignment: AlignmentDirectional.topStart,
                                isDense: false,
                                icon: const Icon(Icons.keyboard_arrow_down, size: 13.33),
                                isExpanded: true,
                                value: statType,
                                items: statsValue.map((element) => DropdownMenuItem(child: Text(element.title!), value: element.title!)).toList(),
                                onChanged: (value) async {
                                  setState(() => statType = value!);
                                  isLoading.value = true;
                                  setState(() {});
                                  for (final details in statsValue) {
                                    if (details.title == statType) {
                                      if (details.id == 1) {
                                        year = details.value ?? "";
                                        month = "";
                                        day = "";
                                      } else if (details.id == 2) {
                                        year = "";
                                        month = details.value ?? "";
                                        day = "";
                                      } else {
                                        year = "";
                                        month = "";
                                        day = details.value ?? "";
                                      }
                                      getMyStat(productCategoryID, year, month, day);
                                      break;
                                    }
                                  }
                                  isLoading.value = false;
                                  setState(() {});
                                }),
                          )
                        : Container();
                  })),
          const SizedBox(height: 8),
          myStatList.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'No Data Available'.tr,
                      style: const TextStyle(color: Colors.black, fontFamily: 'Graphik', fontWeight: FontWeight.w500, fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ),
                )
              : Expanded(
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: myStatList.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 100),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return buildStatusWidget(myStatList[index].rowCount ?? "", myStatList[index].statusTitle ?? "");
                    },
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.9, crossAxisCount: 3, mainAxisSpacing: 12.0, crossAxisSpacing: 12),
                  ),
                )
        ],
      ),
    );
  }

  Widget buildStatusWidget(String ticketCount, String statusName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
            alignment: Alignment.center,
            height: 67,
            width: 94,
            child: WidgetUtils.appTextWidget(context: context, title: ticketCount, color: Colors.black, family: 'Graphik', fontSize: 28, fontWeight: FontWeight.w500),
            decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(6))),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: WidgetUtils.appTextWidget(context: context, title: statusName, color: Colors.white, overflow: TextOverflow.ellipsis, family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500),
        )
      ]),
      height: 100,
      width: 100,
      decoration: BoxDecoration(color: const Color(0xFFFDA11E), borderRadius: BorderRadius.circular(8)),
    );
  }

  void showProductCategory(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).masterData?.productCategory ?? [];
          return StatefulBuilder(builder: (ctx, StateSetter setStates) {
            return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 400,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context, title: 'Select Product Category'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: SvgPicture.asset("assets/images/cross.svg", height: 20))
                            ],
                          )),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4, // Change as per your requirement
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5, // Change as per your requirement
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dssModel.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        productCategoryController.text = dssModel[index].title ?? "";
                                        productCategoryID = dssModel[index].id.toString();
                                        getMyStat(productCategoryID, year, month, day);
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: WidgetUtils.appTextWidget(context: context, title: dssModel[index].title ?? "", fontSize: 16, family: 'Graphik'),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                    ));
                              },
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  Future getMyStat(String prod_cat_id, String year, String month, String day) async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.myStats, params: {"buyer_id": userId, "prod_cat_id": prod_cat_id, "year": year, "month": month, "day": day});
      //print( {"buyer_id": userId, "prod_cat_id": prod_cat_id,"year":year,"month":month,"day":day});
      final res = MyStat.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        myStatList = res.data ?? [];
        setState(() {

        });
      }
    } catch (e) {
      print( e);
      isLoading.value = false;
    }
  }
}
