import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/model/CropMasterResponse.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../components/widgets/base_widget.dart';
import '../../components/widgets/common_text_field.dart';
import '../../model/MasterResponse.dart';

class AddCropScreen extends StatefulWidget {
  String type;
  String? farmName, landID;
  CustomData? customData;

  AddCropScreen(this.type, {super.key, this.customData, this.farmName, this.landID});

  @override
  _AddCropScreenState createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  TextEditingController? farmNameController;
  TextEditingController cropController = TextEditingController(),
      cropTypeController = TextEditingController(),
      seedingDateController = TextEditingController(),
      harvestingDateController = TextEditingController(),
      areaUnderCultivationController = TextEditingController(),
      unitController = TextEditingController();
  DateTime selectedDate = DateTime.now(), selectedDateTwo = DateTime.now();
  File? imageFileOne;
  String? cropId, cropTypeID, unit, cropImage;
  TextEditingController controllerThree = TextEditingController();
  List<dynamic> searchResultThree = [];

  @override
  void initState() {
    super.initState();
    fetchMaster();
    farmNameController = TextEditingController();
    if (widget.type == "EDIT") {
      farmNameController!.text = widget.customData!.farmName;
      cropController.text = widget.customData!.cropName;
      cropTypeController.text = widget.customData!.cropTypeName;
      seedingDateController.text = widget.customData!.durationFrom;
      harvestingDateController.text = widget.customData!.durationTo;
      areaUnderCultivationController.text = widget.customData!.areaUnderCultivation;
      unitController.text = widget.customData!.unitName;
      cropId = widget.customData!.cropId;
      cropTypeID = widget.customData!.cropType;
      cropImage = widget.customData!.cropImage;
      unit = widget.customData!.unit;
      setState(() {});
    } else {
      farmNameController!.text = widget.farmName ?? "";
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        final DateFormat formatter = DateFormat('dd-MMM-yyyy');
        final String formatted = formatter.format(selectedDate);
        seedingDateController.text = formatted;

        selectedDateTwo = picked;
        String duration = "40";
        var landCropModel = Provider.of<LandCropProvider>(context, listen: false);
        var cropList = landCropModel.crop;
        for (int i = 0; i < cropList.length; i++) {
          if (cropList[i].cropId == cropId) {
            duration = cropList[i].durationDays ?? "40";
            break;
          }
        }
        DateTime selectedTwo = selectedDateTwo.add(Duration(days: int.parse(duration)));
        final DateFormat formatters = DateFormat('dd-MMM-yyyy');
        final String twoFormat = formatters.format(selectedTwo);
        harvestingDateController.text = twoFormat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xff27914F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: WidgetUtils.appTextWidget(context: context, title: '${widget.type} Crop'.tr, color: Colors.white, fontSize: 18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            Center(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  InkWell(
                    onTap: () => (cropImage != null || imageFileOne != null) ? null : selectImage(),
                    child: Container(
                        width: 129,
                        height: 129,
                        decoration: BoxDecoration(
                            color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(6.0), boxShadow: const [BoxShadow(color: Colors.blueAccent)]),
                        child: cropImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: CachedNetworkImage(
                                  imageUrl: cropImage!,
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                                  ),
                                  placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                                  errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover),
                                ))
                            : imageFileOne != null
                                ? ClipRRect(borderRadius: BorderRadius.circular(6.0), child: Image(image: FileImage(imageFileOne!), fit: BoxFit.cover))
                                : Center(child: SvgPicture.asset("assets/images/camera.svg", height: 42))),
                  ),
                  (imageFileOne != null || cropImage != null)
                      ? Positioned(
                          bottom: -8,
                          right: -8,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: const Color(0xff27914F),
                            child: IconButton(
                              onPressed: () {
                                selectImage();
                              },
                              icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                            ),
                          ))
                      : const Positioned(child: SizedBox(height: 10, width: 10))
                ],
              ),
            ),
            const SizedBox(height: 20),
            CommonTextField(
                hintText: 'Farm Name'.tr,
                controller: farmNameController!,
                keyboardType: TextInputType.text,
                textSize: 14,
                getController: (controller) => setState(() => farmNameController!.text = controller)),
            const SizedBox(height: 20),
            InkWell(
                onTap: () => dialogCropFilter(context),
                child: CommonTextField(
                    isEnabled: false,
                    hintText: 'Crops'.tr,
                    controller: cropController,
                    keyboardType: TextInputType.text,
                    textSize: 14,
                    getController: (controller) => setState(() => cropController.text = controller))),
            const SizedBox(height: 20),
            InkWell(
                onTap: () => dialogCropTypeFilter(context),
                child: CommonTextField(
                    hintText: 'Crop Type'.tr,
                    isEnabled: false,
                    controller: cropTypeController,
                    keyboardType: TextInputType.text,
                    textSize: 14,
                    getController: (controller) => setState(() => farmNameController!.text = controller))),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () => _selectDate(context),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        child: CommonTextField(
                            hintText: 'Date of Seeding'.tr,
                            isEnabled: false,
                            controller: seedingDateController,
                            keyboardType: TextInputType.text,
                            textSize: 14,
                            getController: (controller) => setState(() => seedingDateController.text = controller)))),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: CommonTextField(
                        hintText: 'Date of Harvesting'.tr,
                        isEnabled: false,
                        controller: harvestingDateController,
                        keyboardType: TextInputType.text,
                        textSize: 14,
                        getController: (controller) => setState(() => harvestingDateController.text = controller))),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 60,
                child: CommonTextField(
                    hintText: 'Area Under Cultivation'.tr,
                    controller: areaUnderCultivationController,
                    keyboardType: TextInputType.number,
                    textSize: 14,
                    getController: (controller) => setState(() => areaUnderCultivationController.text = controller))),
            const SizedBox(height: 20),
            InkWell(
                onTap: () => dialogUnitFilter(context),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: CommonTextField(
                        hintText: 'Unit'.tr,
                        isEnabled: false,
                        controller: unitController,
                        keyboardType: TextInputType.text,
                        textSize: 14,
                        getController: (controller) => setState(() => unitController.text = controller)))),
            const SizedBox(height: 20),
            SizedBox(
              // margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.maxFinite,
              height: 50,
              child: CustomDarkButton(
                onPressed: () {
                  if (farmNameController!.text.isEmpty) {
                    WidgetUtils.errorDialog(context, 'Enter Farm Name'.tr);
                  } else if (cropController.text.isEmpty) {
                    WidgetUtils.errorDialog(context, 'Select Crop'.tr);
                  } else if (cropTypeController.text.isEmpty) {
                    WidgetUtils.errorDialog(context, 'Select Crop Type'.tr);
                  } else if (seedingDateController.text.isEmpty) {
                    WidgetUtils.errorDialog(context, 'Select Date of Seeding'.tr);
                  } else if (harvestingDateController.text.isEmpty) {
                    WidgetUtils.errorDialog(context, 'Select Date of Harvesting'.tr);
                  } else if (areaUnderCultivationController.text.isEmpty) {
                    WidgetUtils.errorDialog(context, 'Enter Area Under Cultivation'.tr);
                  } else if (unitController.text.isEmpty) {
                    WidgetUtils.errorDialog(context, 'Select Unit'.tr);
                  } else {
                    _submit();
                  }
                },
                caption: 'Submit'.tr,
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    HelperUtils().showNormalDialog(
        context: context,
        title: 'Are_you_sure'.tr,
        content: 'Do you want to ${widget.type == "EDIT" ? "Update" : "Add"} this Crop?'.tr,
        onYesTapped: (valueCtx) async {
          Navigator.of(valueCtx).pop(false);
          addFarmDetails();
        });
  }

  Future addFarmDetails() async {
    setState(() {
      isLoading.value = true;
    });
    try {
      // var headerModel = Provider.of<HeaderModel>(context, listen: false);
      var request = widget.type == "EDIT" ? http.MultipartRequest('POST', Uri.parse(baseURL + ApiURL.updateCropDetails)) : http.MultipartRequest('POST', Uri.parse(baseURL + ApiURL.addCropDetails));

      if (imageFileOne?.path != "") {
        if (imageFileOne?.path != null) {
          request.files.add(await http.MultipartFile.fromPath('crop_image', imageFileOne!.path));
        }
      }
      request.headers["client-type"] = "buyer";
      request.headers["X-API-KEY"] = HeaderSingleton().xAPIKey.value;
      request.headers["domain"] = HeaderSingleton().domain.value;
      request.headers["appname"] = HeaderSingleton().appName.value;
      request.fields["land_id"] = widget.customData?.landId ?? widget.landID!;
      request.fields["id"] = widget.customData?.id ?? "";
      request.fields["farm_name"] = farmNameController!.text.toString();
      request.fields["crop"] = cropId!;
      request.fields["crop_type"] = cropTypeID!;
      request.fields["duration_from"] = seedingDateController.text.toString();
      request.fields["duration_to"] = harvestingDateController.text.toString();
      request.fields["area_under_cultivation"] = areaUnderCultivationController.text.toString();
      request.fields["unit"] = unit!;
      request.fields["user_id"] = HeaderSingleton().paramsMaps!.userId!;
      request.fields["client_id"] = HeaderSingleton().paramsMaps!.userId!;
      request.fields["btn_submit"] = "submit";

      // //print(request.fields);
      await request.send().then((response) async {
        // listen for response
        response.stream.transform(utf8.decoder).listen((value) {
          final data = json.decode(value);
          final res = CommonModel.fromJson(data);
          if (res.success == 1) {
            fetchCrop();
            setState(() {});
            WidgetUtils.successDialog(context, res.message);
            Navigator.of(context).pop(true);
          } else {
            WidgetUtils.errorDialog(context, res.message);
          }
        });
      }).catchError((e) {
        // //print(e);
      });
      setState(() {
        isLoading.value = false;
      });
    } catch (e) {
      // //print(e.toString());
      setState(() {
        isLoading.value = false;
      });
    }
    //   }
  }

  Future fetchCrop() async {
    try {
      setState(() {
        isLoading.value = true;
      });
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.getAPIMethod(url: ApiURL.getLandDetailNew + "/" + widget.landID!);
        var data = json.decode(response.body);
        CropMasterResponse npkResponse = CropMasterResponse.fromJson(data);
        if (npkResponse.status != 1) {
          WidgetUtils.errorDialog(context, npkResponse.message);
        } else {
          if (npkResponse.customData.isEmpty) {
          } else {
            var landCropModel = Provider.of<LandCropProvider>(context, listen: false);
            landCropModel.setCropMasterList(npkResponse.customData);
            setState(() {});
          }
        }
      }
    } catch (e) {
      rethrow;
    }
    setStateIfMounted(() {
      isLoading.value = false;
    });
  }

  void selectImage() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 250,
              width: 328,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WidgetUtils.appTextWidget(context: context, title: 'Camera'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                          InkWell(
                              onTap: () {
                                Navigator.pop(ctx);
                              },
                              child: SvgPicture.asset("assets/images/cross.svg", height: 20))
                        ],
                      )),
                  InkWell(
                      onTap: () async {
                        final filePath = await HelperUtils().getFromCamera(ctx, 0);
                        if (filePath != null) {
                          setState(() {
                            cropImage = null;
                            imageFileOne = File(filePath.path);
                            Navigator.pop(ctx);
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.camera_alt),
                            const SizedBox(width: 20),
                            WidgetUtils.appTextWidget(context: context, title: 'Take A New Picture'.tr, fontSize: 16, family: 'Graphik'),
                          ],
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                      )),
                  InkWell(
                      onTap: () async {
                        final filePath = await HelperUtils().getFromGallery(ctx, 1);
                        if (filePath != null) {
                          setState(() {
                            cropImage = null;
                            imageFileOne = File(filePath.path);
                            Navigator.pop(ctx);
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.photo),
                            const SizedBox(width: 20),
                            WidgetUtils.appTextWidget(context: context, title: 'Pick From Gallery'.tr, fontSize: 16, family: 'Graphik'),
                          ],
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                      )),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  TextEditingController controllerFour = TextEditingController();
  List<dynamic> searchResultFour = [];

  void dialogUnitFilter(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Consumer<LandCropProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  height: 250,
                  width: 328,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context, title: 'Select Unit'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: SvgPicture.asset("assets/images/cross.svg", height: 20))
                            ],
                          )),
                      const SizedBox(height: 20),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: loanModel.unit.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    unitController.text = loanModel.unit[index].value;
                                    //cityName = listOne[index].name;
                                    unit = loanModel.unit[index].id;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.agriculture),
                                      const SizedBox(width: 20),
                                      WidgetUtils.appTextWidget(context: context, title: loanModel.unit[index].value, fontSize: 16, family: 'Graphik', fontWeight: FontWeight.w400),
                                    ],
                                  ),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                                ));
                          })
                    ],
                  ),
                ),
              );
            });
          });
        });
  }

  TextEditingController controllerOne = TextEditingController();
  List<dynamic> searchResultOne = [];

  void dialogCropFilter(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Consumer<LandCropProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
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
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            child: ListTile(
                                dense: true,
                                leading: const Icon(Icons.search),
                                title: TextField(
                                  controller: controllerOne,
                                  decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                                  onChanged: (text) {
                                    searchResultOne.clear();
                                    if (text.isEmpty) {
                                      setState(() {});
                                      return;
                                    }
                                    for (var userDetail in loanModel.crop) {
                                      if (userDetail.name.toUpperCase().contains(text.toUpperCase()) || userDetail.name.toLowerCase().contains(text.toLowerCase())) searchResultOne.add(userDetail);
                                    }
                                    setState(() {});
                                  },
                                ),
                                trailing: InkWell(
                                    child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                    onTap: () {
                                      controllerOne.clear();
                                      searchResultOne.clear();
                                      if ("".isEmpty) {
                                        setState(() {});
                                        return;
                                      }
                                      for (var userDetail in loanModel.crop) {
                                        if (userDetail.name.contains("")) searchResultOne.add(userDetail);
                                      }
                                      setState(() {});
                                    })),
                          )),
                      SizedBox(
                        height: 300.0, // Change as per your requirement
                        // width: 550.0,
                        child: searchResultOne.isNotEmpty || controllerOne.text.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchResultOne.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        setState(() {
                                          cropController.text = searchResultOne[index].name;
                                          cropId = loanModel.crop[index].cropId;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        margin: const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        child: WidgetUtils.appTextWidget(context: context, title: searchResultOne[index].name, fontSize: 16, family: 'Graphik'),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                                      ));
                                },
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: loanModel.crop.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        setState(() {
                                          cropController.text = loanModel.crop[index].name;
                                          cropId = loanModel.crop[index].cropId;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: WidgetUtils.appTextWidget(context: context, title: loanModel.crop[index].name, fontSize: 16, family: 'Graphik'),
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

  void dialogCropTypeFilter(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Consumer<LandCropProvider>(builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  height: 300,
                  width: 328,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context, title: 'Select Crop Type'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: SvgPicture.asset("assets/images/cross.svg", height: 20))
                            ],
                          )),
                      SizedBox(
                        height: 200.0, // Change as per your requirement
                        // width: 550.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: loanModel.cropType.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    cropTypeController.text = loanModel.cropType[index].value;
                                    cropTypeID = loanModel.cropType[index].id;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: WidgetUtils.appTextWidget(context: context, title: loanModel.cropType[index].value, fontSize: 16, family: 'Graphik'),
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

  Future fetchMaster() async {
    try {
      setState(() {
        isLoading.value = true;
      });
      // var headerModel = Provider.of<HeaderModel>(context, listen: false);
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.getAPIMethod(url: ApiURL.getMasterData);
        var data = json.decode(response.body);
        MasterResponse masterResponse = MasterResponse.fromJson(data);
        if (masterResponse.status != 1) {
          WidgetUtils.errorDialog(context, data["msg"] ?? "");
        } else {
          final landCropModel = Provider.of<LandCropProvider>(context, listen: false);
          landCropModel.setFarmType(masterResponse.farmType);
          landCropModel.setTopology(masterResponse.topology);
          landCropModel.setSoilType(masterResponse.soilType);
          landCropModel.setUnit(masterResponse.unit);
          landCropModel.setIrriSrc(masterResponse.irriSrc);
          landCropModel.setIrriFaty(masterResponse.irriFaty);
          landCropModel.setCrop(masterResponse.crop);
          landCropModel.setCropType(masterResponse.cropType);
        }
      }
    } catch (e) {
      // //print(e);
      // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
    }
    setStateIfMounted(() {
      isLoading.value = false;
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
