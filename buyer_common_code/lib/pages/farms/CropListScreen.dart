import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/components/widgets/base_widget.dart';
import 'package:buyer_common_code/model/CropMasterResponse.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CropListScreen extends StatefulWidget {
  String? farmName, landID;

  CropListScreen({super.key, this.farmName, this.landID});

  @override
  _CropListScreenState createState() => _CropListScreenState();
}

class _CropListScreenState extends State<CropListScreen> with WidgetsBindingObserver {
  bool isDataNotFound = false;

  @override
  void initState() {
    super.initState();
    var landCropModel = Provider.of<LandCropProvider>(context, listen: false);
    landCropModel.clearCropList();
    fetchCrop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LandCropProvider>(builder: (context, landCropModel, child) {
      return BaseWidget(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            iconTheme: const IconThemeData(color: Colors.white),
            title: WidgetUtils.appTextWidget(context: context, title: 'Crops'.tr, color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500, family: 'Graphik'),
          ),
          child: landCropModel.cropMasterList.isEmpty
              ? Center(child: WidgetUtils.appTextWidget(context: context, title: 'Crops are not added'.tr, color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14, textAlign: TextAlign.left))
              : ListView(
                  children: [
                    ListView.builder(
                        itemCount: landCropModel.cropMasterList.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return cropListItem(landCropModel.cropMasterList[index], index);
                        }),
                  ],
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingButton: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: InkWell(
              onTap: () async {
                var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddCropScreen("ADD", farmName: widget.farmName, landID: widget.landID)));
                if (result != null) {
                  fetchCrop();
                  setState(() {});
                }
              },
              child: Container(
                height: 50,
                width: 150,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.waves, color: Colors.white),
                    WidgetUtils.appTextWidget(context: context, title: 'Add Crop'.tr.tr, color: Colors.white, family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500),
                  ],
                ),
                decoration: BoxDecoration(color: const Color(0xff27914F), borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ));
    });
  }

  Widget cropListItem(CustomData customData, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey), color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  child: CachedNetworkImage(
                    imageUrl: customData.cropImage,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                    ),
                    placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover),
                  ),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: 80),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140,
                    child: Text(customData.cropName, style: const TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 5),
                  Container(width: 200, height: 2, color: Colors.green),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Crop Type :'.tr, style: const TextStyle(color: Colors.black, fontSize: 13.0)),
                      SizedBox(
                        width: 140,
                        child: Text(customData.cropTypeName, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 15.0)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Farm Name :'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 13.0)),
                      SizedBox(width: 120, child: Text(customData.farmName, style: const TextStyle(color: Colors.green, fontSize: 14.0, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Cultivation Area :'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 13.0)),
                      SizedBox(
                        width: 90,
                        child: Text(customData.areaUnderCultivation + " " + customData.unitName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14.0)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Duration From :'.tr, style: const TextStyle(color: Colors.black, fontSize: 13.0)),
                      Text(customData.durationFrom, style: const TextStyle(color: Colors.green, fontSize: 14.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Duration To :'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 13.0)),
                      Text(customData.durationTo, textAlign: TextAlign.center, style: const TextStyle(color: Colors.green, fontSize: 14.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          const Divider(color: Colors.green, thickness: 1),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    visualDensity: VisualDensity.comfortable,
                    onPressed: () {
                      deleteCrops(customData.id);
                    },
                    icon: const Icon(Icons.delete),
                    iconSize: 20),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    visualDensity: VisualDensity.comfortable,
                    onPressed: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddCropScreen("EDIT", customData: customData)));
                      if (result != null) {
                        await fetchCrop();
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.edit),
                    iconSize: 20),
                const SizedBox(width: 10),
                IconButton(
                  visualDensity: VisualDensity.comfortable,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CropCalendarScreen(
                                cropID: customData.cropId, from: "dss", cropName: lanLocale == "en" ? customData.cropName : customData.cropNameMr, image: "", date: customData.durationFrom)));
                  },
                  icon: const Icon(Icons.calendar_month),
                  iconSize: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future deleteCrops(String cropID) async {
    return (await HelperUtils().showNormalDialog(
        context: context,
        title: 'Are_you_sure'.tr,
        content: 'Do you want to delete the Crop'.tr,
        onYesTapped: (value) async {
          Navigator.of(value).pop(false);
          isLoading.value = true;
          await deleteCrop(cropID);
          await fetchCrop();
          isLoading.value = false;
        }));
  }

  Future deleteCrop(String cropID) async {
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.cropDeleteDetails + "/" + cropID);
        final response = await http.put(fetchSchoolsUri, headers: headerParams);
        final data = json.decode(response.body);
        CommonModel npkResponse = CommonModel.fromJson(data);
        if (npkResponse.status != 1) {
          WidgetUtils.errorDialog(context, npkResponse.message);
        } else {
          var landCropModel = Provider.of<LandCropProvider>(context, listen: false);
          landCropModel.deleteCrop(cropID);
          WidgetUtils.successDialog(context, npkResponse.message);
        }
      } else {
        setState(() {
          isDataNotFound = true;
        });
      }
    } catch (e) {
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  Future fetchCrop() async {
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.getAPIMethod(url: ApiURL.getLandDetailNew + "/" + widget.landID!);
        var data = json.decode(response.body);
        CropMasterResponse npkResponse = CropMasterResponse.fromJson(data);
        if (npkResponse.status != 1) {
          WidgetUtils.errorDialog(context, npkResponse.message);
          setState(() {});
        } else {
          if (npkResponse.customData.isNotEmpty) {
            var landCropModel = Provider.of<LandCropProvider>(context, listen: false);
            landCropModel.setCropMasterList(npkResponse.customData);
          }
        }
      }
      isLoading.value = false;
      setState(() {});
      return;
    } catch (e) {
      isLoading.value = false;
      setState(() {});
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
