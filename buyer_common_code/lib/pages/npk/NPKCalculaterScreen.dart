import 'package:buyer_common_code/app_imports.dart';
import 'package:get/get.dart';

import '../../model/DSSCropResponse.dart';
import '../../providers/npk_provider.dart';

class NPKCalculatorScreen extends StatefulWidget {
  final List<SeasonData> seasonData;
  String? cropType, cropName, n, p, k, s, image, typeName, type;

  NPKCalculatorScreen({super.key, required this.seasonData, this.cropType, this.cropName, this.n, this.p, this.k, this.s, this.image, this.typeName, this.type});

  @override
  _NPKCalculatorScreenState createState() => _NPKCalculatorScreenState();
}

class _NPKCalculatorScreenState extends State<NPKCalculatorScreen> {
  bool? isLoading;
  late String _loadingText;
  TextEditingController? cropTypeController, agreementController, loanAmountController;

  final TextEditingController _fieldN = TextEditingController();
  final TextEditingController _fieldP = TextEditingController();
  final TextEditingController _fieldK = TextEditingController();
  final TextEditingController _fields = TextEditingController();
  late String seasonValue;
  var _value = 1;
  var cropID = "";

  @override
  void initState() {
    super.initState();
    isLoading = false;
    _loadingText = 'Loading . . .';
    if (widget.seasonData.isNotEmpty) {
      seasonValue = widget.seasonData[0].id!;
    }
    cropTypeController = TextEditingController();
    agreementController = TextEditingController();
    loanAmountController = TextEditingController();
    if (widget.cropType != null) {
      cropID = widget.cropType!;
    }
    if (widget.n == null && widget.p == null && widget.k == null) {
      getCategory();
    } else {
      _fieldN.text = widget.n ?? "";
      _fieldP.text = widget.p ?? "";
      _fieldK.text = widget.k ?? "";
      _fields.text = widget.s ?? "";
      cropTypeController!.text = widget.cropName ?? "onion";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NPKProvider>(builder: (context, dSSSModel, child) {
      return SafeArea(
        child: CustomProgressHandler(
          isLoading: isLoading!,
          loadingText: _loadingText,
          child: Scaffold( backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(context: context, title: 'NPK Calculator'.tr, color: Colors.white, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: SafeArea(
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(), // new
                  children: [
                    widget.cropType == null ? Container() : const SizedBox(height: 00),
                    widget.cropType == null
                        ? Container()
                        : Container(
                            color: const Color(0xffE7F3EB),
                            child: SizedBox(
                              height: 150,
                              width: 100,
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 5.0),
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              color: const Color(0xfff5f5f5),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    child: FadeInImage.assetNetwork(
                                                        placeholder: ApiURL.imgPlaceHolder,
                                                        imageErrorBuilder: (ctx, obj, st) => Image.file(File(imgPlaceHolder), fit: BoxFit.fill),
                                                        image: widget.image!,
                                                        fit: BoxFit.fill),
                                                    height: 80,
                                                  ),
                                                ],
                                              )),
                                          Text(
                                            widget.cropName!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.black, fontSize: 15.0),
                                          ),
                                          Text(
                                            widget.typeName ?? "",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.black, fontSize: 12.0),
                                          ),
                                        ],
                                      ))),
                            ),
                          ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Season'.tr, style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    widget.seasonData.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              for (int i = 0; i < widget.seasonData.length; i++)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio(
                                      value: widget.seasonData[i].id!,
                                      groupValue: seasonValue,
                                      activeColor: const Color(0xff27914F),
                                      onChanged: (String? value) {
                                        seasonValue = value!;
                                        // //print(value!);
                                        setState(() {});
                                      },
                                    ),
                                    Text(
                                      widget.seasonData[i].value!,
                                      style: const TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                            ],
                          )
                        : Container(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Enter Land Area'.tr, style: const TextStyle(color: Colors.black, fontFamily: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20, bottom: 10),
                      child: Column(
                        children: [
                          widget.cropType == null
                              ? InkWell(
                                  onTap: () {
                                    showCropType(context);
                                  },
                                  child: Container(
                                    width: double.maxFinite,
                                    height: 50,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF), width: 1), color: Colors.white, borderRadius: BorderRadius.circular(4)),
                                    // margin: const EdgeInsets.only(right: 16),
                                    child: TextField(
                                      controller: cropTypeController,
                                      keyboardType: TextInputType.text,
                                      enabled: false,
                                      decoration: InputDecoration(
                                        hintText: 'Select Crop type'.tr,
                                        border: InputBorder.none,
                                        counterText: "",
                                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                        labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
                                      ),
                                      style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                )
                              : Container(),
                          widget.cropType == null ? const SizedBox(height: 10) : Container(),
                          Container(
                            width: double.maxFinite,
                            height: 50,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF), width: 1.0), borderRadius: BorderRadius.circular(5)),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller: loanAmountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Land Area'.tr,
                                border: InputBorder.none,
                                counterText: "",
                                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
                              ),
                              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(height: 22),
                          Row(
                            children: <Widget>[
                              for (int i = 1; i <= 2; i++)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio(
                                        value: i,
                                        groupValue: _value,
                                        activeColor: const Color(0xff27914F),
                                        onChanged: (int? value) {
                                          setState(() {
                                            _value = value!;
                                          });
                                        }),
                                    Text(i == 1 ? 'Hectare'.tr : 'Acre'.tr,
                                        style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.black, fontFamily: 'Graphik', fontSize: 12, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          /*  Text('SUGGESTED DOSE'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12.0)),
                            SizedBox(height: MediaQuery.of(context).size.height*0.01),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF), width: 1.0), borderRadius: BorderRadius.circular(5)),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    controller: _fieldN,
                                    maxLength: 3,
                                    decoration: InputDecoration(
                                      isCollapsed: false,
                                      counterText: "",
                                      border: InputBorder.none,
                                      hintText: 'N'.tr,
                                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
                                    ),
                                    style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  ),
                                  height: 58,
                                  width: 70),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF), width: 1.0), borderRadius: BorderRadius.circular(5)),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    controller: _fieldP,
                                    maxLength: 3,
                                    decoration: InputDecoration(
                                      isCollapsed: false,
                                      counterText: "",
                                      border: InputBorder.none,
                                      hintText: 'P'.tr,
                                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
                                    ),
                                    style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  ),
                                  height: 58,
                                  width: 70),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFFCFCFCF), width: 1.0),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    controller: _fieldK,
                                    maxLength: 3,
                                    decoration: InputDecoration(
                                      isCollapsed: false,
                                      counterText: "",
                                      border: InputBorder.none,
                                      hintText: 'K'.tr,
                                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
                                    ),
                                    style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  ),
                                  height: 58,
                                  width: 70),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFFCFCFCF), width: 1.0),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    controller: _fields,
                                    maxLength: 3,
                                    decoration: InputDecoration(
                                      isCollapsed: false,
                                      counterText: "",
                                      border: InputBorder.none,
                                      hintText: 'S'.tr,
                                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
                                    ),
                                    style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  ),
                                  height: 58,
                                  width: 70),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('N'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Graphik')),
                                Text('P'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Graphik')),
                                Text('K'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Graphik')),
                                Text('S'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Graphik')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CustomDarkButton(
                        onPressed: () {
                          if (cropTypeController!.text.isEmpty) {
                            WidgetUtils.errorDialog(context, 'Please Select Crop Type'.tr);
                          } else if (loanAmountController!.text.isEmpty || loanAmountController!.text == "0") {
                            WidgetUtils.errorDialog(context, 'Please Enter valid Land Area'.tr);
                          } else if (loanAmountController!.text.contains("-")) {
                            WidgetUtils.errorDialog(context, 'Please Enter valid Land Area'.tr);
                          } else if (loanAmountController!.text.contains(",")) {
                            WidgetUtils.errorDialog(context, 'Please Enter valid Land Area'.tr);
                          } else if (loanAmountController!.text.contains("[") || loanAmountController!.text.contains("]")) {
                            WidgetUtils.errorDialog(context, 'Please Enter valid Land Area'.tr);
                          } else {
                            var type = "Acre";
                            if (_value == 2) {
                              type = "Acre";
                            } else {
                              type = "Hectare";
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NPKListScreen(
                                          season: seasonValue,
                                          cropType: cropID,
                                          landArea: loanAmountController!.text.toString(),
                                          type: type,
                                          n: _fieldN.text,
                                          p: _fieldP.text,
                                          k: _fieldK.text,
                                          s: _fields.text,
                                        )));
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             MacroMicronutrienScreen(cropType: cropID, landArea: loanAmountController!.text.toString(),
                            //                 type: type, n: _fieldN.text,
                            //                 p: _fieldP.text,
                            //                 k: _fieldK.text,nutrition_management: widget.type,banket: "1",)));
                          }
                        },
                        caption: 'Calculate'.tr,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void showCropType(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<NPKProvider>(context, listen: false).allCropsList;
          return StatefulBuilder(builder: (ctx, StateSetter setState) {
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
                              WidgetUtils.appTextWidget(context: context, title: 'Select Crop Type'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/cross.svg",
                                    height: 20,
                                  ))
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
                                        cropID = dssModel[index].cropId!;
                                        cropTypeController!.text = dssModel[index].name!;
                                        _fieldN.text = dssModel[index].n ?? "";
                                        _fieldP.text = dssModel[index].p ?? "";
                                        _fieldK.text = dssModel[index].k ?? "";
                                        _fields.text = dssModel[index].s ?? "";
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: WidgetUtils.appTextWidget(context: context, title: dssModel[index].name!, fontSize: 16, family: 'Graphik'),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
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

  Future getCategory() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getCropsList);
      final data = json.decode(response.body);
      // //print(data);
      var res = CropDetails.fromJson(data);
      if (res.status == 1) {
        final dSSModel = Provider.of<NPKProvider>(context, listen: false);
        dSSModel.setDSSAllCropsList(res.data!.allCrops!);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // //print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
}
