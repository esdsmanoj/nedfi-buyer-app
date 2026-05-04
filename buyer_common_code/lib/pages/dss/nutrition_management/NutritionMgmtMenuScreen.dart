import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/model/nutrition_mgmt_model.dart';
import 'package:get/get.dart';

class NutritionMgmtMenuScreen extends StatefulWidget {
  String? cropID, from, cropName, n, p, k, s, image;

  NutritionMgmtMenuScreen({Key? key, this.cropID, this.from, this.cropName, this.n, this.p, this.k, this.s, this.image}) : super(key: key);

  @override
  _NutritionMgmtMenuScreenState createState() => _NutritionMgmtMenuScreenState();
}

class _NutritionMgmtMenuScreenState extends State<NutritionMgmtMenuScreen> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<NutritionManagementModel?> nutritionDetails = ValueNotifier(null);
  List<bool> isexpanded = [];
  List<SeasonData> seasonData = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchNutritionManagement();
    fetchSeason();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: isLoading.value,
      loadingText: "",
      child: SafeArea(
          child: Scaffold( backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
                title: WidgetUtils.appTextWidget(context: context, title: 'Nutrition Management'.tr, color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500, family: 'Graphik'),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              //  backgroundColor: ColorsConst.backgroundColor,
              body: Container(
                margin: const EdgeInsets.only(top: 20),
                child: ValueListenableBuilder(
                  valueListenable: nutritionDetails,
                  builder: (BuildContext context, NutritionManagementModel? value, Widget? child) {
                    return value != null && value.data != null
                        ? ToggleList(
                            trailing: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(Icons.keyboard_arrow_down_sharp, color: Color(int.parse(themeColor.value.iconColor!.color!))),
                            ),
                            children: List.generate(
                                value.data!.length,
                                (index) => ToggleListItem(
                                      headerDecoration: BoxDecoration(color: const Color(0xFFE7F3EB), borderRadius: BorderRadius.circular(4)),
                                      itemDecoration: BoxDecoration(
                                          color: Colors.transparent, border: Border.all(color: Color(int.parse(themeColor.value.barColor!.color!))), borderRadius: BorderRadius.circular(4)),
                                      expandedHeaderDecoration: BoxDecoration(color: const Color(0xFFE7F3EB), borderRadius: BorderRadius.circular(4)),
                                      content: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: value.data![index].data!.option!.length,
                                            itemBuilder: (ctx, listIndex) {
                                              return InkWell(
                                                onTap: () {
                                                  if (value.data![index].data!.option![listIndex].mapKey!.toLowerCase().contains("_sh") ||
                                                      value.data![index].data!.option![listIndex].mapKey!.toLowerCase() == "soil_health_card_url") {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => SoilHealthNPKCalculaterScreen(
                                                                  seasonData: seasonData,
                                                                  cropType: widget.cropID,
                                                                  cropName: widget.cropName,
                                                                  n: widget.n,
                                                                  p: widget.p,
                                                                  k: widget.k,
                                                                  s: widget.s,
                                                                  image: widget.image,
                                                                  title: value.data![index].data!.value!.toLowerCase(),
                                                                  type: (listIndex + 1).toString(),
                                                                  typeName: value.data![index].data!.option![listIndex].value,
                                                                )));
                                                  } else {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => NPKCalculatorScreen(
                                                                seasonData: seasonData,
                                                                cropType: widget.cropID,
                                                                cropName: widget.cropName,
                                                                n: widget.n,
                                                                p: widget.p,
                                                                k: widget.k,
                                                                s: widget.s,
                                                                image: widget.image,
                                                                typeName: value.data![index].data!.option![listIndex].value,
                                                                type: value.data![index].data!.option![listIndex].id)));
                                                  }
                                                },
                                                child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    height: 40,
                                                    width: double.maxFinite,
                                                    child: WidgetUtils.appTextWidget(
                                                        family: 'Graphik',
                                                        fontSize: 16,
                                                        context: context,
                                                        title: value.data![index].data!.option![listIndex].value!,
                                                        fontWeight: FontWeight.w400,
                                                        color: Colors.black)),
                                              );
                                            }),
                                      ),
                                      title: InkWell(
                                        onTap: () {
                                          if (value.data![index].data!.mapKey!.toLowerCase().contains("nutrition_deficiency")) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => CropDiseaseScreen(
                                                        title: 'Nutrition Deficiency'.tr,
                                                        logo: widget.image ?? "",
                                                        cropID: widget.cropID,
                                                        from: "nutrition_deficiency",
                                                        cropName: widget.cropName,
                                                        componentId: "")));
                                          }
                                        },
                                        child: Container(
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            alignment: Alignment.centerLeft,
                                            child: WidgetUtils.appTextWidget(
                                                color: const Color(0xFF0F853B),
                                                context: context,
                                                title: value.data![index].data!.value!,
                                                family: 'Graphik',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                      ),
                                    )))
                        : Container();
                  },
                ),
              ))),
    );
  }

  void _expansionChangedCallback(int index, bool newValue) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Changed expansion status of item  no.${index + 1} to ${newValue ? "expanded" : "shrunk"}.',
        ),
      ),
    );
  }

  Future fetchNutritionManagement() async {
    try {
      isLoading.value = true;
      final response = await APIService.getAPIMethod(url: ApiURL.getNutritionManagement);
      // //print(json.decode(response.body));
      NutritionManagementModel nutritionManagementModel = NutritionManagementModel.fromJson(json.decode(response.body));
      if (nutritionManagementModel.status == 1) {
        nutritionDetails.value = nutritionManagementModel;
        isexpanded = List.generate(nutritionManagementModel.data!.length, (index) => false);
        isLoading.value = false;
        setState(() {});
      }
    } catch (e) {
      isLoading.value = false;
      setState(() {});
      rethrow;
    }
  }

  Future fetchSeason() async {
    try {
      isLoading.value = true;
      final response = await APIService.getAPIMethod(url: "${ApiURL.getSeasonList}/${widget.cropID}");
      // //print(json.decode(response.body));
      final seasonModel = SeasonModel.fromJson(json.decode(response.body));
      if (seasonModel.status == 1) {
        seasonData = seasonModel.data!;
        setState(() {});
      }
    } catch (e) {
      isLoading.value = false;
      setState(() {});
      rethrow;
    }
  }
}
