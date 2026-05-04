import 'dart:convert';

import 'package:nedfi_seller_common_code/model/DSSCropResponse.dart';
import 'package:nedfi_seller_common_code/model/LandResponse.dart';
import 'package:nedfi_seller_common_code/pages/farms/NewAddFarmScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/help/network_handler.dart';
import '../../components/utils/Constants.dart';
import '../../components/utils/helper_utils.dart';
import '../../components/utils/widget_utils.dart';
import '../../components/widgets/base_widget.dart';
import '../../model/common_model.dart';
import '../../services/api_service.dart';
import '../../singleton/header_singleton.dart';
import 'CropListScreen.dart';

class FarmListScreen extends StatefulWidget {
  AllCrops? dssCropData;

  FarmListScreen({Key? key, this.dssCropData}) : super(key: key);

  @override
  _FarmListScreenState createState() => _FarmListScreenState();
}

class _FarmListScreenState extends State<FarmListScreen> with WidgetsBindingObserver {
  ValueNotifier<bool> isDataNotFound = ValueNotifier(false);
  ValueNotifier<List<CustomData>> farmList = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    fetchFarm();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
        iconTheme: const IconThemeData(color: Colors.white),
        title: WidgetUtils.appTextWidget(context: context, title: 'Farms'.tr, color: Colors.white, family: 'Graphik', fontWeight: FontWeight.w500, fontSize: 18),
      ),
      //  backgroundColor: ColorsConst.backgroundColor,
      child: farmList.value.isEmpty
          ? Center(
              child: WidgetUtils.appTextWidget(context: context, title: 'Farms are not added'.tr, color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14, textAlign: TextAlign.left),
            )
          : ListView(
              children: [
                const SizedBox(height: 24),
                ListView.builder(
                    itemCount: farmList.value.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _landItem(farmList.value[index], index);
                    }),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: InkWell(
          onTap: () async {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewAddFarmScreen(type: "Add")));
            if (result != null) {
              await fetchFarm();
              farmAreaCoordinates = null;
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
                WidgetUtils.appTextWidget(context: context, title: 'Add Farms'.tr, color: Colors.white, family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500),
              ],
            ),
            decoration: BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!)), borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }

  Widget _landItem(CustomData customData, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3),
      child: Card(
        child: Container(
            height: 87,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ClipOval(clipBehavior: Clip.hardEdge, child: Image.asset('assets/images/map_polygon.png', height: 65, width: 65)),
              SizedBox(
                height: 80,
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                      child: WidgetUtils.appTextWidget(
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          context: context,
                          title: customData.farmName!,
                          textAlign: TextAlign.center,
                          color: Colors.black,
                          fontSize: 14.0,
                          family: 'Graphik',
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        WidgetUtils.appTextWidget(
                            context: context, title: 'Farm Size :'.tr, textAlign: TextAlign.center, color: Colors.black, fontSize: 12.0, family: 'Graphik', fontWeight: FontWeight.w400),
                        const SizedBox(width: 5),
                        WidgetUtils.appTextWidget(
                            context: context,
                            title: customData.farmSize! + " " + (HeaderSingleton().local == "en" ? customData.unitName ?? "Acre" : customData.unitNameMr ?? "Acre"),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black,
                            fontSize: 12.0,
                            family: 'Graphik',
                            fontWeight: FontWeight.w400),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CropListScreen(farmName: customData.farmName, landID: customData.landId)));
                      },
                      child: Container(
                        height: 30,
                        width: 64,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WidgetUtils.appTextWidget(
                                context: context,
                                title: 'Crops',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.green,
                                fontSize: 10.0,
                                family: 'Graphik',
                                fontWeight: FontWeight.w500),
                            const Icon(Icons.arrow_forward, color: Colors.green, size: 14)
                          ],
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.green)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 20,
                      child: InkWell(
                        onTap: () async {
                          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewAddFarmScreen(type: "EDIT", customData: customData)));
                          if (result != null) {
                            await fetchFarm();
                            farmAreaCoordinates = null;
                            setState(() {});
                          }
                        },
                        child: Icon(Icons.edit, color: Color(int.parse(themeColor.value.iconColor!.color!))),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    SizedBox(
                      width: 60,
                      height: 20,
                      child: InkWell(
                        onTap: () async {
                          await deleteFarms(customData.landId!);
                          await fetchFarm();
                          farmAreaCoordinates = null;
                          setState(() {});
                        },
                        child: Icon(Icons.delete_outline, color: Color(int.parse(themeColor.value.iconColor!.color!))),
                      ),
                    )
                  ],
                ),
              ),
            ])),
      ),
    );
  }

  Future deleteFarms(String cropID) async {
    return (await HelperUtils().showNormalDialog(
        context: context,
        title: 'Are_you_sure'.tr,
        content: 'Do you want to delete the Farm'.tr,
        onYesTapped: (value) async {
          Navigator.of(value).pop(false);
          await deleteFarm(cropID);
          isLoading.value = false;
          setState(() {});
        }));
  }

  Future deleteFarm(String cropID) async {
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.putAPIMethod(url: ApiURL.deleteLandCrop + "/" + cropID);
        final data = json.decode(response.body);
        CommonModel npkResponse = CommonModel.fromJson(data);
        if (npkResponse.status != 1) {
          WidgetUtils.errorDialog(context, npkResponse.message);
        } else {
          farmList.value.removeWhere((element) => element.landId == cropID);
          // var landCropModel = Provider.of<LandCropProvider>(context, listen: false);
          // landCropModel.deleteFarm(cropID);
        }
      }
    } catch (e) {
      isLoading.value = false;
      setState(() {});
    }
  }

  Future fetchFarm() async {
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.getAPIMethod(url: ApiURL.getMyLandDetail + "/" + HeaderSingleton().paramsMaps!.userId!);
        var data = json.decode(response.body);
        LandResponse npkResponse = LandResponse.fromJson(data);
        if (npkResponse.status != 1) {
          WidgetUtils.successDialog(context, npkResponse.message!);
        } else {
          if (npkResponse.customData!=null && npkResponse.customData!.isNotEmpty) {
            farmList.value = npkResponse.customData!;
          }
        }
      }
      isLoading.value = false;
      setState(() {});
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
