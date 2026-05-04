import 'package:nedfi_seller_common_code/model/MacroMicronutrientCal.dart';
import 'package:get/get.dart';

import 'package:nedfi_seller_common_code/app_imports.dart';

import '../../../model/DSSCropResponse.dart';
import '../../../model/npk_recommend_model.dart';

class SoilHealthNPKCalculaterScreen extends StatefulWidget {
  String? cropType, cropName, n, p, k, s, image, title, type, typeName;
  final List<SeasonData> seasonData;

  SoilHealthNPKCalculaterScreen({Key? key, required this.seasonData, this.cropType, this.cropName, this.n, this.p, this.k, this.s, this.image, this.title, this.type, this.typeName}) : super(key: key);

  @override
  _SoilHealthNPKCalculaterScreenState createState() => _SoilHealthNPKCalculaterScreenState();
}

class _SoilHealthNPKCalculaterScreenState extends State<SoilHealthNPKCalculaterScreen> {
  bool? _isLoading;
  NPKRecommend? details;
  late String _loadingText, seasonValue;
  String? nStatus, pStatus, kStatus, sStatus, ferrousStatus, zinkStatus, boronStatus, manganeseStatus, copperStatus;
  late TextEditingController nitrogenController, phosphorusController, potassiumController, sulphurController, landAreaController;
  dynamic detailsNPK;
  TextEditingController ferrousController = TextEditingController(),
      zinkController = TextEditingController(),
      boronController = TextEditingController(),
      manganeseController = TextEditingController(),
      copperController = TextEditingController();
  var _value = 1;
  var cropID = "";
  String title = 'Soil Health Card';
  bool isSwitched = false;

  final itemKey = GlobalKey(), itemKey1 = GlobalKey();

  Future scrollToIndex() async {
    final ctx = itemKey.currentContext!;
    await Scrollable.ensureVisible(ctx);
    // final ctx1 = itemKey1.currentContext!;
    // await Scrollable.ensureVisible(ctx1);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    if (widget.seasonData.isNotEmpty) {
      seasonValue = widget.seasonData[0].id!;
    }
    if (widget.title != null && widget.title!.isNotEmpty) {
      if (widget.title == 'nutrient management - blanket') {
        title = 'Blanket';
      }
    }
    _loadingText = 'Loading . . .';

    nitrogenController = TextEditingController();
    phosphorusController = TextEditingController();
    potassiumController = TextEditingController();
    sulphurController = TextEditingController();
    landAreaController = TextEditingController();
    //_loanAmount// focusNode = // focusNode();
    if (widget.cropType != null) {
      cropID = widget.cropType!;
    }
    if (widget.n == null && widget.p == null && widget.k == null) {
      getCategory();
    } else {
      //nitrogenController.text = widget.n ?? "";
      //phosphorusController.text = widget.p ?? "";
      //potassiumController.text = widget.k ?? "";
      // croptypeController!.text = widget.cropName ?? "onion";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          iconTheme: const IconThemeData(color: Colors.white),
          title: WidgetUtils.appTextWidget(context: context, title: 'NPKS(Soil Health Card)'.tr, color: Colors.white, fontSize: 18),
        ),
        body: CustomProgressHandler(
            isLoading: _isLoading!,
            loadingText: _loadingText,
            child: SingleChildScrollView(
              child: widget.cropType != ""
                  ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      widget.cropType == null
                          ? Container()
                          : Container(
                              color: const Color(0xffE7F3EB),
                              child: SizedBox(
                                height: 150,
                                width: double.maxFinite,
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
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
                                              widget.typeName!,
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
                        child: Text('Season'.tr, style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          for (int i = 0; i < widget.seasonData.length; i++)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio(
                                  value: widget.seasonData[i].id!,
                                  groupValue: seasonValue,
                                  activeColor: Color(int.parse(themeColor.value.iconColor!.color!)),
                                  onChanged: (String? value) {
                                    seasonValue = value!;
                                    setState(() {});
                                  },
                                  // onChanged: (SeasonData value) {
                                  //   setState(() {
                                  //     seasonValue = value!.id!;
                                  //   });
                                  // },
                                ),
                                Text(
                                  widget.seasonData[i].value!,
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Enter Land Area'.tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFFCFCFCF), width: 1.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.start,
                                  controller: landAreaController,
                                  maxLength: 3,
                                  // // focusNode: _loanAmount// focusNode,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    hintText: 'Land Area'.tr,
                                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                                    labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                                  ),
                                  style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                                )),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          for (int i = 1; i <= 2; i++)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio(
                                  value: i,
                                  groupValue: _value,
                                  activeColor: Color(int.parse(themeColor.value.iconColor!.color!)),
                                  onChanged: (int? value) {
                                    setState(() {
                                      _value = value!;
                                    });
                                  },
                                ),
                                Text(
                                  i == 1 ? 'Hectare'.tr : 'Acre'.tr,
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Nitrogen \n(N)'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12.0)),
                                  Text('Phosphors \n(P)'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12.0)),
                                  Text('Potassium \n(K)'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12.0)),
                                  Text('Sulphur \n(S)'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12.0)),
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF), width: 1), borderRadius: BorderRadius.circular(5)),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    controller: nitrogenController,
                                    maxLength: 3,
                                    decoration: InputDecoration(
                                      isCollapsed: false,
                                      counterText: "",
                                      border: InputBorder.none,
                                      hintText: 'N'.tr,
                                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    ),
                                    style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  ),
                                  height: 58,
                                  width: 70,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF), width: 1), borderRadius: BorderRadius.circular(5)),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    controller: phosphorusController,
                                    maxLength: 3,
                                    decoration: InputDecoration(
                                      isCollapsed: false,
                                      border: InputBorder.none,
                                      hintText: 'P'.tr,
                                      counterText: "",
                                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    ),
                                    style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  ),
                                  height: 58,
                                  width: 70,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFFCFCFCF), width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      controller: potassiumController,
                                      maxLength: 3,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText: 'K'.tr,
                                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      ),
                                      style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400)),
                                  height: 58,
                                  width: 70,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFFCFCFCF), width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      controller: sulphurController,
                                      maxLength: 3,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText: 'S'.tr,
                                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      ),
                                      style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400)),
                                  height: 58,
                                  width: 70,
                                ),
                              ],
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(child: Text('Ferrous\n(Fe)'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12.0))),
                                    Flexible(child: Text('Zink\n(Zn)'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12.0))),
                                    Flexible(child: Text('Boron\n(Bo)'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12.0))),
                                    Flexible(child: Text('Manganese\n(mn)'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12.0))),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF), width: 1), borderRadius: BorderRadius.circular(5)),
                                  child: TextField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      controller: ferrousController,
                                      maxLength: 3,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText: 'Fe'.tr,
                                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      ),
                                      style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400)),
                                  height: 58,
                                  width: 70,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF), width: 1), borderRadius: BorderRadius.circular(5)),
                                  child: TextField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      controller: zinkController,
                                      maxLength: 3,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText: 'Zn'.tr,
                                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      ),
                                      style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400)),
                                  height: 58,
                                  width: 70,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFFCFCFCF), width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      controller: boronController,
                                      maxLength: 3,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText: 'Bo'.tr,
                                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      ),
                                      style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400)),
                                  height: 58,
                                  width: 70,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFFCFCFCF), width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      controller: manganeseController,
                                      maxLength: 3,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        counterText: "",
                                        border: InputBorder.none,
                                        hintText: 'Mn'.tr,
                                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      ),
                                      style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400)),
                                  height: 58,
                                  width: 70,
                                ),
                              ],
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Copper \n(Cu)'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 12.0)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 58,
                                    width: 70,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF), width: 1), borderRadius: BorderRadius.circular(5)),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      controller: copperController,
                                      maxLength: 3,
                                      decoration: InputDecoration(
                                          isCollapsed: false,
                                          border: InputBorder.none,
                                          hintText: 'Cu'.tr,
                                          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                          counterText: ""),
                                      style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: WidgetUtils.buttonWidget(
                                context: context,
                                radius: 8,
                                title: 'Submit'.tr,
                                size: 18,
                                family: 'Graphik',
                                textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                                color: Color(int.parse(themeColor.value.buttonColor!.color!)),
                                weight: FontWeight.w500,
                                callback: () async {
                                  Future.delayed(const Duration(seconds: 2), () {
                                    scrollToIndex();
                                    setState(() {});
                                  });
                                  microValidateDetails();
                                }),
                          )),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      detailsNPK != null
                          ? Column(
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                  height: 1,
                                  color: Colors.black26,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'NPKS Result'.tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                                // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'Nitrogen\n(N)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                nStatus != null
                                                    ? Container(
                                                        height: 30,
                                                        alignment: Alignment.center,
                                                        margin: const EdgeInsets.only(left: 8),
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: nStatus!.toLowerCase() == 'low'
                                                                ? Colors.red.shade50
                                                                : nStatus!.toLowerCase() == 'medium'
                                                                    ? Colors.yellow.shade50
                                                                    : Colors.green.shade50),
                                                        child: WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: nStatus!,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontSize: 14,
                                                            color: nStatus!.toLowerCase() == 'low'
                                                                ? Colors.red
                                                                : nStatus!.toLowerCase() == 'medium'
                                                                    ? Colors.yellow
                                                                    : Colors.green,
                                                            fontWeight: FontWeight.w600),
                                                      )
                                                    : Container(),
                                              ]),
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'phosphorus\n(P)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                pStatus != null
                                                    ? Container(
                                                        height: 30,
                                                        alignment: Alignment.center,
                                                        margin: const EdgeInsets.only(left: 8),
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: pStatus!.toLowerCase() == 'low'
                                                                ? Colors.red.shade50
                                                                : pStatus!.toLowerCase() == 'medium'
                                                                    ? Colors.yellow.shade50
                                                                    : Colors.green.shade50),
                                                        child: WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: pStatus!,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontSize: 14,
                                                            color: pStatus!.toLowerCase() == 'low'
                                                                ? Colors.red
                                                                : pStatus!.toLowerCase() == 'medium'
                                                                    ? Colors.yellow
                                                                    : Colors.green,
                                                            fontWeight: FontWeight.w600),
                                                      )
                                                    : Container(),
                                              ]),
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'Potassium\n(K)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                kStatus != null
                                                    ? Container(
                                                        height: 30,
                                                        alignment: Alignment.center,
                                                        margin: const EdgeInsets.only(left: 8),
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: kStatus!.toLowerCase() == 'low'
                                                                ? Colors.red.shade50
                                                                : kStatus!.toLowerCase() == 'medium'
                                                                    ? Colors.yellow.shade50
                                                                    : Colors.green.shade50),
                                                        child: WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: kStatus!,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontSize: 14,
                                                            color: kStatus!.toLowerCase() == 'low'
                                                                ? Colors.red
                                                                : kStatus!.toLowerCase() == 'medium'
                                                                    ? Colors.yellow
                                                                    : Colors.green,
                                                            fontWeight: FontWeight.w600),
                                                      )
                                                    : Container(),
                                              ]),
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'Sulphur\n(S)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                sStatus != null
                                                    ? Container(
                                                        height: 30,
                                                        alignment: Alignment.center,
                                                        margin: const EdgeInsets.only(left: 8),
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: sStatus!.toLowerCase() == 'low'
                                                                ? Colors.red.shade50
                                                                : sStatus!.toLowerCase() == 'medium'
                                                                    ? Colors.yellow.shade50
                                                                    : Colors.green.shade50),
                                                        child: WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: sStatus!,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontSize: 14,
                                                            color: sStatus!.toLowerCase() == 'low'
                                                                ? Colors.red
                                                                : sStatus!.toLowerCase() == 'medium'
                                                                    ? Colors.yellow
                                                                    : Colors.green,
                                                            fontWeight: FontWeight.w600),
                                                      )
                                                    : Container(),
                                              ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                Text(
                                  'Micro Nutrient Result'.tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            //
                                            children: [
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'Ferrous (Fe)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                ferrousStatus != null
                                                    ? Container(
                                                        height: 30,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5), color: ferrousStatus!.toLowerCase() == 'deficiency' ? Colors.red.shade50 : Colors.green.shade50),
                                                        child: WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: ferrousStatus!,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontSize: 14,
                                                            color: ferrousStatus!.toLowerCase() == 'deficiency' ? Colors.red : Colors.green,
                                                            fontWeight: FontWeight.w600),
                                                      )
                                                    : Container(),
                                              ]),
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'Zink (Zn)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                zinkStatus != null
                                                    ? Container(
                                                        height: 30,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5), color: zinkStatus!.toLowerCase() == 'deficiency' ? Colors.red.shade50 : Colors.green.shade50),
                                                        child: WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: zinkStatus!,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontSize: 14,
                                                            color: zinkStatus!.toLowerCase() == 'deficiency' ? Colors.red : Colors.green,
                                                            fontWeight: FontWeight.w600),
                                                      )
                                                    : Container(),
                                              ]),
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'Boron (Bo)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                boronStatus != null
                                                    ? Container(
                                                        height: 30,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5), color: boronStatus!.toLowerCase() == 'deficiency' ? Colors.red.shade50 : Colors.green.shade50),
                                                        child: WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: boronStatus!,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontSize: 14,
                                                            color: boronStatus!.toLowerCase() == 'deficiency' ? Colors.red : Colors.green,
                                                            fontWeight: FontWeight.w600),
                                                      )
                                                    : Container(),
                                              ]),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'Manganese (Mg)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                manganeseStatus != null
                                                    ? Container(
                                                        height: 30,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5), color: manganeseStatus!.toLowerCase() == 'deficiency' ? Colors.red.shade50 : Colors.green.shade50),
                                                        child: WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: manganeseStatus!,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontSize: 14,
                                                            color: manganeseStatus!.toLowerCase() == 'deficiency' ? Colors.red : Colors.green,
                                                            fontWeight: FontWeight.w600),
                                                      )
                                                    : Container(),
                                              ]),
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'Copper (Co)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                copperStatus != null
                                                    ? Container(
                                                        height: 30,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5), color: copperStatus!.toLowerCase() == 'deficiency' ? Colors.red.shade50 : Colors.green.shade50),
                                                        child: WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: copperStatus!,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontSize: 14,
                                                            color: copperStatus!.toLowerCase() == 'deficiency' ? Colors.red : Colors.green,
                                                            fontWeight: FontWeight.w600),
                                                      )
                                                    : Container(),
                                              ]),
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                                Text(
                                  'NPKS Recommended'.tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'Nitrogen\n(N)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 58,
                                                  width: 70,
                                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF), width: 1), borderRadius: BorderRadius.circular(5)),
                                                  child: Text(
                                                    detailsNPK != null
                                                        ? _value == 1
                                                            ? detailsNPK.data.macronutrient!.recommendation.n.toString()
                                                            : detailsNPK.data.macronutrient!.recommendation.n.toString()
                                                        : '',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                  ),
                                                )
                                              ]),
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'phosphorus\n(P)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 58,
                                                  width: 70,
                                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF), width: 1), borderRadius: BorderRadius.circular(5)),
                                                  child: Text(
                                                    detailsNPK != null
                                                        ? _value == 1
                                                            ? detailsNPK.data.macronutrient!.recommendation.p.toString()
                                                            : detailsNPK.data.macronutrient!.recommendation.p.toString()
                                                        : '',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                  ),
                                                )
                                              ]),
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'Potassium\n(K)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 58,
                                                  width: 70,
                                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF), width: 1), borderRadius: BorderRadius.circular(5)),
                                                  child: Text(
                                                    detailsNPK != null
                                                        ? _value == 1
                                                            ? detailsNPK.data.macronutrient!.recommendation.k.toString()
                                                            : detailsNPK.data.macronutrient!.recommendation.k.toString()
                                                        : '',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                  ),
                                                )
                                              ]),
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                Text(
                                                  'Sulphur\n(S)'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 58,
                                                  width: 70,
                                                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF), width: 1), borderRadius: BorderRadius.circular(5)),
                                                  child: Text(
                                                    detailsNPK != null
                                                        ? _value == 1
                                                            ? detailsNPK.data.macronutrient!.recommendation.s.toString()
                                                            : detailsNPK.data.macronutrient!.recommendation.s.toString()
                                                        : '',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                  ),
                                                )
                                              ]),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Container(
                                            key: itemKey,
                                            // margin: const EdgeInsets.symmetric(horizontal: 16),
                                            child: WidgetUtils.buttonWidget(
                                                context: context,
                                                radius: 8,
                                                title: 'Calculate'.tr,
                                                size: 18,
                                                family: 'Graphik',
                                                textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                                                color: Color(int.parse(themeColor.value.buttonColor!.color!)),
                                                weight: FontWeight.w500,
                                                callback: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => NPKListScreen(
                                                                cropType: cropID,
                                                                landArea: landAreaController.text.toString(),
                                                                type: widget.cropType,
                                                                season: seasonValue,
                                                                n: _value == 1
                                                                    ? detailsNPK.data.macronutrient!.recommendation.n.toString()
                                                                    : detailsNPK.data.macronutrient!.recommendation.n.toString(),
                                                                p: _value == 1
                                                                    ? detailsNPK.data.macronutrient!.recommendation.p.toString()
                                                                    : detailsNPK.data.macronutrient!.recommendation.p.toString(),
                                                                k: _value == 1
                                                                    ? detailsNPK.data.macronutrient!.recommendation.k.toString()
                                                                    : detailsNPK.data.macronutrient!.recommendation.k.toString(),
                                                                s: _value == 1
                                                                    ? detailsNPK.data.macronutrient!.recommendation.s.toString()
                                                                    : detailsNPK.data.macronutrient!.recommendation.s.toString(),
                                                              )));
                                                }),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            )
                          : Container()
                    ])
                  : Center(child: Text('No Data Available'.tr)),
            )));
  }

  Future<void> validateDetails() async {
    bool isStatus = false;
    try {
      if (nitrogenController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Nitrogen value'.tr);
        isStatus = true;
      } else if (phosphorusController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter phosphorus value'.tr);
        isStatus = true;
      } else if (potassiumController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter potassium value'.tr);
        isStatus = true;
      } else if (sulphurController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter sulphur value'.tr);
      } else if (landAreaController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Land Area value'.tr);
        isStatus = true;
      } else {}
      if (!isStatus) {
        Map<String, dynamic> parameters = {};
        parameters['crop_id'] = widget.cropType;
        parameters['nitrogen'] = nitrogenController.text;
        parameters['phosphorus'] = phosphorusController.text;
        parameters['pottasium'] = potassiumController.text;
        parameters['sulphur'] = sulphurController.text;
        parameters['unit'] = _value == 1 ? 'Hectare' : 'Acre';
        parameters['size'] = landAreaController.text;

        final response = await APIService.postAPIMethod(url: ApiURL.npkRecommend, params: parameters);
        final data = json.decode(response.body);
        // print(data);
        final res = NPKRecommend.fromJson(data);
        if (res.status == 1) {
          // setState(() {
          // details = res;
          //
          /* detailsNPK = res;
          nStatus = res.data!.npkStatus!.n!;
          sStatus = res.data!.npkStatus!.s!;
          kStatus = res.data!.npkStatus!.k!;
          pStatus = res.data!.npkStatus!.p!;*/

          /* final dSSModel = Provider.of<NPKModel>(context, listen: false);
          dSSModel.setNPKDetails(res);
          nStatus = dSSModel.npkRecommend.data!.npkStatus!.n!;
          sStatus = dSSModel.npkRecommend.data!.npkStatus!.s!;
          kStatus = dSSModel.npkRecommend.data!.npkStatus!.k!;
          pStatus = dSSModel.npkRecommend.data!.npkStatus!.p!;
          // dSSCropList=res.data;
          detailsNPK =
              Provider.of<NPKModel>(context, listen: false).npkRecommend;*/
          setState(() {});
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> microValidateDetails() async {
    bool isStatus = false;
    try {
      if (nitrogenController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Nitrogen value'.tr);
        isStatus = true;
      } else if (phosphorusController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter phosphorus value'.tr);
        isStatus = true;
      } else if (potassiumController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter potassium value'.tr);
        isStatus = true;
      } else if (sulphurController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter sulphur value'.tr);
        isStatus = true;
      } else if (landAreaController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Land Area value'.tr);
        isStatus = true;
      } else if (ferrousController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Ferrous value'.tr);
        isStatus = true;
      } else if (manganeseController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Manganese value'.tr);
        isStatus = true;
      } else if (zinkController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter zink value'.tr);
        isStatus = true;
      } else if (copperController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Copper value'.tr);
        isStatus = true;
      } else if (boronController.text.isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter boron value'.tr);
        isStatus = true;
      }
      if (!isStatus) {
        Map<String, dynamic> parameters = {};
        parameters['crop_id'] = widget.cropType;
        parameters['nutrition_management'] = widget.type;
        parameters['n'] = nitrogenController.text;
        parameters['p'] = phosphorusController.text;
        parameters['k'] = potassiumController.text;
        parameters['s'] = sulphurController.text;
        parameters['i'] = ferrousController.text;
        parameters['m'] = manganeseController.text;
        parameters['z'] = zinkController.text;
        parameters['c'] = copperController.text;
        parameters['b'] = boronController.text;
        parameters['areaunit'] = _value == 1 ? 'Hectare' : 'Acre';
        parameters['season'] = seasonValue;
        parameters['area'] = landAreaController.text;
        parameters['btn_submit'] = "submit";
        final response = await APIService.postAPIMethod(url: ApiURL.macro_micronutrient_cal, params: parameters);
        final data = json.decode(response.body);
        final res = MacroMicronutrientCal.fromJson(data);
        if (res.status == 1) {
          if (res.data != null && res.data.macronutrient != null) {
            detailsNPK = res;
            nStatus = res.data.macronutrient!.impression.n ?? "0";
            sStatus = res.data.macronutrient!.impression.s ?? "0";
            kStatus = res.data.macronutrient!.impression.k ?? "0";
            pStatus = res.data.macronutrient!.impression.p ?? "0";
            ferrousStatus = res.data.micronutrient!.impression.i ?? "0";
            zinkStatus = res.data.micronutrient!.impression.z ?? "0";
            boronStatus = res.data.micronutrient!.impression.b ?? "0";
            manganeseStatus = res.data.micronutrient!.impression.m ?? "0";
            copperStatus = res.data.micronutrient!.impression.c ?? "0";
          } else {
            WidgetUtils.errorDialog(context, res.message);
          }
          setState(() {});
        } else {
          WidgetUtils.errorDialog(context, res.message);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future getCategory() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getCropsList);
      var data = json.decode(response.body);
      // print(data);
      var res = CropDetails.fromJson(data);
      if (res.status == 1) {
        // setState(() {
        var dSSModel = Provider.of<NPKModel>(context, listen: false);
        dSSModel.setDSSCatagoryList(res.data!.allCrops!);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // Provider.of<NPKModel>(context, listen: false).setNPKDetails(NPKRecommend());
    super.dispose();
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;

  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 3,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(border: OutlineInputBorder(), counterText: '', hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
