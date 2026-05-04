import 'package:get/get.dart';
import 'package:buyer_common_code/app_imports.dart';

class VarietyMasterScreen extends StatefulWidget {
  String? cropID, from, cropName;

  VarietyMasterScreen({super.key, this.cropID, this.from, this.cropName});

  @override
  _VarietyMasterScreenState createState() => _VarietyMasterScreenState();
}

class _VarietyMasterScreenState extends State<VarietyMasterScreen> {
  bool? _isLoading;
  late String _loadingText;
  late final double? elevation = 3.0;
  bool isDataNotFound = false;
  String stateID = "";
  late List<TextEditingController> listController;
  late VarietyFormDetails formDetails;

  @override
  void initState() {
    listController = [];
    formDetails = VarietyFormDetails();
    super.initState();
    _isLoading = false;
    _loadingText = 'Loading . . .';
    getVarietiesMaster();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DSSProvider>(builder: (context, dSSModel, child) {
      return SafeArea(
        child: CustomProgressHandler(
          isLoading: _isLoading!,
          loadingText: _loadingText,
          child: Scaffold( backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(context: context, title: widget.cropName! + " " + 'Variety'.tr, color: Colors.white, fontSize: 18),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            //  backgroundColor: ColorsConst.backgroundColor,
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    formDetails != null && formDetails.data != null
                        ? SizedBox(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: formDetails.data!.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: InkWell(
                                    onTap: () {
                                      showDialogState(context, formDetails.data![index], index);
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      height: 50,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(border: Border.all(color: Color(int.parse(themeColor.value.barColor!.color!)), width: 1), borderRadius: BorderRadius.circular(4)),
                                      // margin: const EdgeInsets.only(right: 16),
                                      child: TextField(
                                        controller: listController[index],
                                        keyboardType: TextInputType.text,
                                        enabled: false,
                                        decoration: InputDecoration(hintText: formDetails.data![index].title ?? 'No data', border: InputBorder.none, counterText: ""),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(child: Text("No data found".tr)),
                    const SizedBox(height: 20),
                    formDetails != null && formDetails.data != null
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: CustomDarkButton(
                              onPressed: () {
                                _validation();
                              },
                              caption: 'Next'.tr,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future _validation() async {
    Map<String, dynamic> varietyDetails = {};
    bool isStatus = false;

    for (int i = 0; i < formDetails.data!.length; i++) {
      final langValue = (HeaderSingleton().local == 'en' ? '' : "${formDetails.data![i].title} ");
      final newLangValue = HeaderSingleton().local == 'en' ? "${formDetails.data![i].title} " : '';
      if (listController[i].text.isEmpty) {
        isStatus = true;
        WidgetUtils.errorDialog(context, langValue + "Please enter valid ".tr + newLangValue);
        setState(() {});
        break;
      } else {
        varietyDetails[formDetails.data![i].id!] = listController[i].text;
      }
    }
    if (!isStatus) {
      varietyDetails['crop_id'] = widget.cropID;
      final response = await APIService.postAPIMethod(url: ApiURL.varietyFilteredData, params: varietyDetails);
      final data = json.decode(response.body);
      VaritesResponse res = VaritesResponse.fromJson(data);
      if (data["success"] == 1) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CropVarietiesScreen(varietyDetails: varietyDetails, from: "dss", cropID: widget.cropID, cropName: widget.cropName)));
      } else {
        WidgetUtils.errorDialog(context, data['message']);
        setState(() {});
      }
    }
  }

  Future getVarietiesMaster() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final formResponse = await APIService.postAPIMethod(url: ApiURL.dynamicCropParams, params: {"crop_id": widget.cropID});
      // final encode = jsonEncode(formResponse.body);
      formDetails = VarietyFormDetails.fromJson(json.decode(formResponse.body));
      if (formDetails.success == 1) {
        listController = List.generate(formDetails.data!.length, (index) => TextEditingController());
      } else {
        isDataNotFound = true;
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // //print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showDialogState(BuildContext context, final details, int listIndex) {
    TextEditingController controller = TextEditingController();
    List<String> _searchResult = [];
    _searchResult.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<DSSProvider>(//                    <--- Consumer
              builder: (context, dSSModel, child) {
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
                            child: SizedBox(
                              height: 50,
                              child: ListTile(
                                  dense: true,
                                  leading: const Icon(Icons.search),
                                  title: TextField(
                                    controller: controller,
                                    decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                                    onChanged: (text) {
                                      bool isFound = false;
                                      _searchResult.clear();
                                      if (text.isEmpty) {
                                        setState(() {});
                                        return;
                                      }
                                      for (final userDetail in details.value) {
                                        if (userDetail.toUpperCase().contains(text.toUpperCase()) && !isFound) {
                                          _searchResult.add(userDetail);
                                          isFound = true;
                                        }
                                      }

                                      setState(() {});
                                    },
                                  ),
                                  trailing: InkWell(
                                      child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                      onTap: () {
                                        listController[listIndex].clear();
                                        _searchResult.clear();
                                        if ("".isEmpty) {
                                          setState(() {});
                                          return;
                                        }
                                        for (var userDetail in details.value) {
                                          if (userDetail.name.contains("")) {
                                            _searchResult.add(userDetail);
                                          }
                                        }
                                        setState(() {});
                                      })),
                            ),
                          )),
                      SizedBox(
                        height: 300.0, // Change as per your requirement
                        // width: 550.0,
                        child: _searchResult.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: _searchResult.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        setState(() {
                                          listController[listIndex].text = _searchResult[index];
                                          stateID = details.id;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        margin: const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        child: WidgetUtils.appTextWidget(context: context, title: _searchResult[index], fontSize: 16, family: 'Graphik'),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                                      ));
                                },
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: details.value.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        setState(() {
                                          listController[listIndex].text = details.value[index];
                                          // //print(listController[listIndex].text);
                                          // stateID = details.id;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: WidgetUtils.appTextWidget(context: context, title: details.value[index], fontSize: 16, family: 'Graphik'),
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
