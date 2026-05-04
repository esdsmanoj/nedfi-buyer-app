import 'package:buyer_common_code/app_imports.dart';
import 'package:get/get.dart';

import '../../components/widgets/base_widget.dart';
import '../../components/widgets/common_text_field.dart';
import '../../model/LandResponse.dart';
import '../../model/MasterResponse.dart' as master_response;
import '../../model/MasterResponse.dart';
import 'farm_map_Screen.dart';

class NewAddFarmScreen extends StatefulWidget {
  CustomData? customData;
  String? type;

  NewAddFarmScreen({Key? key, this.type, this.customData}) : super(key: key);

  @override
  _NewAddFarmScreenState createState() => _NewAddFarmScreenState();
}

class _NewAddFarmScreenState extends State<NewAddFarmScreen> {
  TextEditingController? farmNameController = TextEditingController(), surveyNumberController = TextEditingController(), soilTypeController = TextEditingController();
  File? uploadFile;
  List<master_response.Unit> unitList = [master_response.Unit(id: "2", value: "Hector", nameMr: "Hector"), master_response.Unit(id: "2", value: "Acre", nameMr: "Acre")];
  var unitName = "Hector", farmImage = "", isMapEdited = "";

  @override
  void initState() {
    super.initState();
    if (widget.type == "EDIT") {
      farmNameController!.text = widget.customData!.farmName!;
      farmAreaCoordinates = jsonDecode(widget.customData!.farmPolygoanCoordinates.toString());
      surveyNumberController!.text = widget.customData!.farmSize ?? '0';
      //areasss=num.parse(widget.customData!.farmSize ?? '0');
      // if (unitName == 'Acre') {
      //   surveyNumberController!.text = (areasss / 4046.8564224).toStringAsFixed(3);
      // } else {
      //   surveyNumberController!.text = ((areasss / 4046.8564224) * 0.404686011).toStringAsFixed(3);
      // }

      soilTypeController!.text = widget.customData!.unitName ?? 'Acre';
      unitName = widget.customData!.unitName ?? 'Acre';
      if (unitName.toLowerCase() == "acre") {
        unitName = 'Acre';
        unitList = [master_response.Unit(id: "1", value: "Acre", nameMr: "Acre"), master_response.Unit(id: "2", value: "Hector", nameMr: "Hector")];
        areaValue = num.parse(widget.customData!.farmSize ?? '0') * 4046.86011;
        areaCalculation("meeter", 'acre', areaValue);
      } else {
        unitName = 'Hector';
        unitList = [master_response.Unit(id: "2", value: "Hector", nameMr: "Hector"), master_response.Unit(id: "1", value: "Acre", nameMr: "Acre")];
        areaValue = num.parse(widget.customData!.farmSize ?? '0') * 10000;
        areaCalculation("meeter", 'hector', areaValue);
      }
    } else {
      soilTypeController!.text = unitName;
    }
    fetchMaster();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      resizeInsets: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context, "true")),
        iconTheme: const IconThemeData(color: Colors.white),
        title: WidgetUtils.appTextWidget(
            context: context, title: (widget.type == "EDIT" ? 'Edit Farms'.tr : 'Add Farms'.tr), color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500, family: 'Graphik'),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () async {
                    if (widget.customData != null) {
                      farmAreaCoordinates = widget.customData!.farmPolygoanCoordinates;
                    }
                    /* Tuple2<dynamic, dynamic> result = await Navigator.push(context, MaterialPageRoute(builder: (context) => FarmMapScreen(widget.type ?? "NEW")));
                    if (result != null) {
                      if (result.item2 != null) {
                        areaValue = result.item1;
                        // widget.type = "EDIT";
                        isMapEdited = "EDIT";
                        if (unitName == 'Acre') {
                          areaCalculation("meeter", 'acre', areaValue);
                        } else {
                          areaCalculation("meeter", 'hector', areaValue);
                        }
                        setState(() {});
                      }
                    }*/
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: const EdgeInsets.only(top: 24, bottom: 12),
                        width: 157,
                        height: 128,
                        decoration:
                            BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(8)), border: Border.all(color: const Color(0xffcfcfcf), width: 1), color: const Color(0xffffffff)),
                        child: farmAreaCoordinates != null
                            ? Image.asset('assets/images/map_polygon.png', width: 157, height: 128)
                            : Center(child: SvgPicture.asset("assets/images/camera.svg", height: 42))),
                  )),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text("Farm Name".tr,
                  style: const TextStyle(color: Color(0xff111111), fontWeight: FontWeight.w500, fontFamily: "Graphik", fontStyle: FontStyle.normal, fontSize: 18.0), textAlign: TextAlign.start),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                  child: CommonTextField(
                      hintText: 'Farm Name'.tr,
                      controller: farmNameController!,
                      keyboardType: TextInputType.text,
                      textSize: 14,
                      getController: (controller) => setState(() => farmNameController!.text = controller))),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (ctx, constraint) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: constraint.maxWidth / 2.2,
                        child: Text("Farm Size".tr,
                            style: const TextStyle(color: Color(0xff111111), fontWeight: FontWeight.w500, fontFamily: "Graphik", fontStyle: FontStyle.normal, fontSize: 18.0),
                            textAlign: TextAlign.start),
                      ),
                      SizedBox(
                        width: constraint.maxWidth / 2.2,
                        child: Text("Unit".tr,
                            style: const TextStyle(color: Color(0xff111111), fontWeight: FontWeight.w500, fontFamily: "Graphik", fontStyle: FontStyle.normal, fontSize: 18.0),
                            textAlign: TextAlign.start),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              LayoutBuilder(builder: (ctx, constraint) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: CommonTextField(
                            hintText: 'Farm Size'.tr,
                            controller: surveyNumberController!,
                            keyboardType: TextInputType.number,
                            textSize: 14,
                            getController: (controller) => setState(() => surveyNumberController!.text = controller))),
                    Container(
                      width: constraint.maxWidth / 2.2,
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(border: Border.all(color: Color(int.parse(themeColor.value.barColor!.color!)), width: 1.2), borderRadius: BorderRadius.circular(4)),
                      child: unitList.isEmpty
                          ? Container()
                          : DropdownButtonHideUnderline(
                              child: DropdownButton(
                                alignment: AlignmentDirectional.topStart,
                                isDense: false,
                                isExpanded: true,
                                value: unitName,
                                items: unitList.map((e) => DropdownMenuItem(child: Text(e.value), value: e.value)).toList(),
                                onChanged: (value) async {
                                  setState(() {
                                    unitName = value!;
                                    soilTypeController!.text = value;
                                    areaCalculation("meeter", unitName, areaValue);
                                  });
                                },
                              ),
                            ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  if (farmAreaCoordinates == null) {
                    WidgetUtils.errorDialog(context, 'Select Farm co-ordinate'.tr);
                  } else if (surveyNumberController!.text.toString().isEmpty) {
                    WidgetUtils.errorDialog(context, 'Enter Farm Size'.tr);
                  } else if (soilTypeController!.text.toString().isEmpty) {
                    WidgetUtils.errorDialog(context, 'Select unit'.tr);
                  } else if (farmNameController!.text.toString().isEmpty) {
                    WidgetUtils.errorDialog(context, 'Enter Farm Name'.tr);
                  } else {
                    addFarm();
                  }
                },
                child: Container(
                  width: double.maxFinite,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(int.parse(themeColor.value.buttonColor!.color!)), border: Border.all(color: Theme.of(context).primaryColor, width: 1.0), borderRadius: BorderRadius.circular(8)),
                  child: Text("Submit".tr,
                      style:
                          TextStyle(color: Color(int.parse(themeColor.value.buttonTextColor!.color!)), fontWeight: FontWeight.w500, fontFamily: "Graphik", fontStyle: FontStyle.normal, fontSize: 16.0),
                      textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Future addFarm() async {
    try {
      isLoading.value = true;
      setState(() {});
      late final dynamic params;
      if (widget.type == "EDIT") {
        dynamic cordinate;
        if (farmAreaCoordinates is List<List<double>>) {
          cordinate = jsonEncode({'coordinates': farmAreaCoordinates!});
        } else if (farmAreaCoordinates is Map<String, dynamic>) {
          cordinate = jsonEncode(farmAreaCoordinates!);
        } else {
          cordinate = jsonDecode(farmAreaCoordinates)!;
        }
        // //print("${widget.customData!.landId}");
        params = {
          "land_id": widget.customData!.landId,
          'farmer_id': HeaderSingleton().paramsMaps!.userId!,
          'farm_size': double.parse(surveyNumberController!.text).toStringAsFixed(3),
          'unit': unitName.toLowerCase() == 'acre' ? '1' : '2',
          'farm_name': farmNameController!.text.toString(),
          'farm_name_mr': farmNameController!.text.toString(),
          'farm_polygoan_coordinates': jsonEncode(cordinate),
          'btn_submit': "submit"
        };
      } else {
        params = {
          'farmer_id': HeaderSingleton().paramsMaps!.userId!,
          'farm_size': double.parse(surveyNumberController!.text).toStringAsFixed(3),
          'unit': unitName.toLowerCase() == 'acre' ? '1' : '2',
          'farm_name': farmNameController!.text.toString(),
          'farm_name_mr': farmNameController!.text.toString(),
          'farm_polygoan_coordinates': json.encode({'coordinates': farmAreaCoordinates!}),
          'btn_submit': "submit"
        };
      }
      // //print(params.toString());
      final response = await APIService.postAPIMethod(url: widget.type == "EDIT" ? ApiURL.edit_farm_new : ApiURL.add_farm_new, params: params);
      final data = json.decode(response.body);
      // //print(data);
      if (data['success'] == 1) {
        WidgetUtils.successDialog(context, data['message']);
        Navigator.pop(context, "true");
        areaValue = 0;
      } else {
        WidgetUtils.errorDialog(context, data['message']);
        setState(() {});
      }

      isLoading.value = false;
      setState(() {});
    } catch (e) {
      isLoading.value = false;
      setState(() {});
      rethrow;
    }
  }

  fetchMaster() async {
    try {
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.getAPIMethod(url: ApiURL.getMasterData);
        var data = json.decode(response.body);
        MasterResponse masterResponse = MasterResponse.fromJson(data);
        if (masterResponse.status != 1) {
          WidgetUtils.errorDialog(context, masterResponse.message);
        } else {
          var landCropModel = Provider.of<LandCropProvider>(context, listen: false);
          landCropModel.setFarmType(masterResponse.farmType);
          landCropModel.setTopology(masterResponse.topology);
          landCropModel.setSoilType(masterResponse.soilType);
          landCropModel.setUnit(masterResponse.unit);
          landCropModel.setIrriSrc(masterResponse.irriSrc);
          landCropModel.setIrriFaty(masterResponse.irriFaty);
          landCropModel.setCrop(masterResponse.crop);
          landCropModel.setCropType(masterResponse.cropType);
          soilTypeController!.text = masterResponse.soilType[0].value.toString();
          /*  masterResponse.unit.forEach((element) {
            if (element.id == unitID) {
              setState(() {
                unitController!.text = element.value;
              });
            }
          });*/
          setState(() {
            //  unitList = masterResponse.unit;
            // unitName = unitList[0].value;
          });
        }
      }
    } catch (e) {
      // //print(e);
      // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    farmAreaCoordinates = null;
    super.dispose();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  areaCalculation(String firstUnit, String secondUnit, num value) {
    if (firstUnit.toLowerCase() == "meeter" && secondUnit.toLowerCase() == "acre") {
      surveyNumberController!.text = ((value) / 4046.86011).toStringAsFixed(3);
    } else if (firstUnit.toLowerCase() == "meeter" && secondUnit.toLowerCase() == "hector") {
      surveyNumberController!.text = ((value / 10000)).toStringAsFixed(3);
    } else if (firstUnit.toLowerCase() == "acre" && secondUnit.toLowerCase() == "hector") {
      surveyNumberController!.text = ((value / 0.4)).toStringAsFixed(3);
    } else if (firstUnit.toLowerCase() == "hector" && secondUnit.toLowerCase() == "acre") {
      surveyNumberController!.text = ((value / 2.47)).toStringAsFixed(3);
    }
  }
}
