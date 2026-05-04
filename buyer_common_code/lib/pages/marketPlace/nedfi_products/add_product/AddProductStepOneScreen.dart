import 'package:buyer_common_code/model/NedfiProductVariety.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../app_imports.dart';
import '../../../../components/month_picker_dialog/month_picker_dialog.dart';
import '../../../../model/AddProductResponse.dart';
import '../../../../model/NedfiProductType.dart';
import '../../../../model/trade_product_info.dart';
import '../../../../providers/master_provider.dart';

class AddProductStepOneScreen extends StatefulWidget {
  String? id;
  final ValueChanged onPressed;

  AddProductStepOneScreen({this.id, required this.onPressed});

  @override
  State<AddProductStepOneScreen> createState() => _AddProductStepOneScreenState();
}

class _AddProductStepOneScreenState extends State<AddProductStepOneScreen> {
  TextEditingController? productCategoryController = TextEditingController();
  TextEditingController? productTypeController = TextEditingController();
  TextEditingController? productController = TextEditingController();
  TextEditingController? productVarietyController = TextEditingController();
  TextEditingController? activeDateController = TextEditingController();

  TextEditingController? seasonFromController = TextEditingController();
  TextEditingController? seasonToController = TextEditingController();

  TextEditingController? marketableUnitController = TextEditingController();
  TextEditingController? quantityUnitController = TextEditingController();
  TextEditingController? priceUnitController = TextEditingController();
  TextEditingController? marketableController = TextEditingController();
  TextEditingController? quantityController = TextEditingController();
  TextEditingController? priceController = TextEditingController();
  TextEditingController? packagingController = TextEditingController();
  TextEditingController? expectedYieldFromController = TextEditingController();
  TextEditingController? expectedYieldToController = TextEditingController();
  TextEditingController? expectedYieldFromUnitController = TextEditingController();
  TextEditingController? expectedYieldToUnitController = TextEditingController();
  TextEditingController? avaliableFromController = TextEditingController();
  TextEditingController? avaliableToController = TextEditingController();

  bool packaging_flag = true;
  bool logisticPartner_flag = true;
  String productCategoryID = "";
  int activeDateCount = 0;
  String productTypeID = "";
  String productID = "";
  String productVarietyID = "";
  String packagingID = "";
  bool season_flag = false;
  bool upcoming_flag = false;
  var _value = 0;
  String priceUnitID = "";
  String marketableUnitID = "";
  String expectedYieldFromUnitID = "";
  String expectedYieldToUnitID = "";

  String seasonFromID = "";
  String seasonToID = "";
  String id = "";

  DateTime? avaliableFromDate;
  DateTime? avaliableToDate;

  bool isKeyBoard = false;
  late var masterProvider;

  @override
  void initState() {
    super.initState();
    getPackaging();
    masterProvider = Provider.of<MasterProvider>(context, listen: false);
    //print(widget.id);
    //print(masterProvider.itemId);
    if (widget.id != null) {
      id = widget.id ?? "";
      getProductList();
    }

    if (masterProvider.itemId != "") {
      id = masterProvider.itemId;
      getProductList();
    }
  }

  Future getProductList() async {
    try {
      var param = {"user_id": HeaderSingleton().paramsMaps!.userId, "id": id};
      final response = await APIService.postAPIMethod(url: ApiURL.getTradeProducts, params: param);
      final data = json.decode(response.body);
      //print(param);
      //print(data);
      final res = TradeProductInfo.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setCurrentTreadProduct(res.data![0]);
          masterProvider.setType("EDIT" ?? "");
          masterProvider.setItemId(widget.id ?? "");
          if (masterProvider.type == "EDIT") {
            id = masterProvider.treadProductCurrent!.id ?? "";
            productCategoryController!.text = masterProvider.treadProductCurrent!.productCategoryTitle ?? "";
            productTypeController!.text = masterProvider.treadProductCurrent!.productTypeTitle ?? "";
            productController!.text = masterProvider.treadProductCurrent!.productTitle ?? "";
            productVarietyController!.text = masterProvider.treadProductCurrent!.productVarietyTitle ?? "";
            activeDateController!.text = masterProvider.treadProductCurrent!.activeTillDate ?? "";
            if (masterProvider.treadProductCurrent!.seasonText != null) {
              seasonFromController!.text = masterProvider.treadProductCurrent!.seasonText.toString().split(",")[0].split("-").last.trim();
              seasonToController!.text = masterProvider.treadProductCurrent!.seasonText.toString().split(",")[1].split("-").last.trim();
            }
            marketableUnitController!.text = masterProvider.treadProductCurrent!.surplusUnitTitle ?? "";
            quantityUnitController!.text = masterProvider.treadProductCurrent!.sellQtyUnitTitle ?? "";
            priceUnitController!.text = masterProvider.treadProductCurrent!.priceUnitTitle ?? "";
            marketableController!.text = masterProvider.treadProductCurrent!.surplus ?? "";
            quantityController!.text = masterProvider.treadProductCurrent!.sellQty ?? "";
            priceController!.text = masterProvider.treadProductCurrent!.price ?? "";
            packagingController!.text = masterProvider.treadProductCurrent!.packagingTitle ?? "";
            expectedYieldFromController!.text = masterProvider.treadProductCurrent?.otherDetails?.yieldFrom ?? "";
            expectedYieldToController!.text = masterProvider.treadProductCurrent?.otherDetails?.yieldTo ?? "";
            expectedYieldFromUnitController!.text = masterProvider.treadProductCurrent?.otherDetails?.yieldFromUnitText ?? "";
            expectedYieldToUnitController!.text = masterProvider.treadProductCurrent?.otherDetails?.yieldToUnitText ?? "";
            avaliableFromController!.text = masterProvider.treadProductCurrent?.otherDetails?.availabilityFrom ?? "";
            avaliableToController!.text = masterProvider.treadProductCurrent?.otherDetails?.availabilityTo ?? "";

            activeDateCount = 0;
            _value = 0;
            priceUnitID = masterProvider.treadProductCurrent!.priceUnit.toString();
            marketableUnitID = masterProvider.treadProductCurrent!.surplusUnit.toString();
            expectedYieldFromUnitID = masterProvider.treadProductCurrent!.otherDetails?.yieldFromUnit.toString() ?? "";
            expectedYieldToUnitID = masterProvider.treadProductCurrent!.otherDetails?.yieldFromUnit.toString() ?? "";

            seasonFromID = masterProvider.treadProductCurrent!.otherDetails?.seasonFrom.toString() ?? "";
            seasonToID = masterProvider.treadProductCurrent!.otherDetails?.seasonTo.toString() ?? "";

            productCategoryID = masterProvider.treadProductCurrent!.prodCatId.toString();
            productTypeID = masterProvider.treadProductCurrent!.prodTypeId.toString();
            productID = masterProvider.treadProductCurrent!.prodId.toString();
            productVarietyID = masterProvider.treadProductCurrent!.prodVarietyId.toString();
            packagingID = masterProvider.treadProductCurrent!.packagingMasterId.toString();
            if (masterProvider.treadProductCurrent!.prodCatId.toString() == "3") {
              season_flag = true;
              upcoming_flag = false;
            } else if (masterProvider.treadProductCurrent!.prodCatId.toString() == "2") {
              upcoming_flag = true;
              season_flag = true;
            } else {
              season_flag = false;
              upcoming_flag = false;
            }
            if (masterProvider.treadProductCurrent!.withPackging == "t") {
              packagingController!.text = masterProvider.treadProductCurrent!.packagingTitle ?? "";
              packaging_flag = true;
            } else {
              packaging_flag = false;
            }

            if (masterProvider.treadProductCurrent!.withLogisticPartner == "t") {
              logisticPartner_flag = true;
            } else {
              logisticPartner_flag = false;
            }

            if (masterProvider.treadProductCurrent!.prodDetails != null) {
              if (masterProvider.treadProductCurrent!.prodDetails == "1") {
                _value = 1;
              } else {
                _value = 2;
              }
            }
          }
          setState(() {});
        }
      }
    } catch (e) {
      //print(e);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Consumer<MasterProvider>(builder: (context, masterProvider, child) {
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 10, top: 10, right: 10),
          height: MediaQuery.of(context).size.height - 170,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              WidgetUtils.appTextWidget(
                  context: context, title: 'Product Details'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 20, color: Color(int.parse(themeColor.value.barColor!.color!))),
              const SizedBox(height: 20),
              WidgetUtils.appTextWidget(context: context, title: 'Product Category'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
              const SizedBox(height: 08),
              Container(
                width: double.maxFinite,
                height: 58,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                // margin: const EdgeInsets.only(right: 16),
                child: TextField(
                  onTap: () {
                    showProductCategory(context);
                  },
                  controller: productCategoryController,
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintText: 'Select Product Category'.tr,
                      border: InputBorder.none,
                      counterText: "",
                      suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 10),
              WidgetUtils.appTextWidget(context: context, title: 'Product Type'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
              const SizedBox(height: 08),
              Container(
                width: double.maxFinite,
                height: 58,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                // margin: const EdgeInsets.only(right: 16),
                child: TextField(
                  onTap: () {
                    showProductType(context);
                  },
                  controller: productTypeController,
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintText: 'Select Product Type'.tr,
                      border: InputBorder.none,
                      counterText: "",
                      suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 10),
              WidgetUtils.appTextWidget(context: context, title: 'Product'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
              upcoming_flag == true
                  ? Container(
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Container(
                            width: 250,
                            height: 50,
                            child: Row(
                              children: [
                                for (int i = 1; i <= 2; i++)
                                  Container(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: i,
                                          groupValue: _value,
                                          activeColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                                          onChanged: (int? value) {
                                            setState(() {
                                              _value = value!;
                                            });
                                          },
                                        ),
                                        Text(
                                          i == 1 ? 'Produce'.tr : 'Product'.tr,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    )
                  : Container(),
              const SizedBox(height: 08),
              Container(
                width: double.maxFinite,
                height: 58,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                // margin: const EdgeInsets.only(right: 16),
                child: TextField(
                  onTap: () {
                    if (productTypeID == "") {
                      WidgetUtils.errorDialog(context, 'Please Select Product Type'.tr);
                    } else {
                      showProduct(context);
                    }
                  },
                  controller: productController,
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintText: 'Select Product'.tr,
                      border: InputBorder.none,
                      counterText: "",
                      suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: upcoming_flag == false ? (MediaQuery.of(context).size.width / 2) - 15 : (MediaQuery.of(context).size.width) - 20,
                    height: 58,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                    // margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      onTap: () {
                        if (productID == "") {
                          WidgetUtils.errorDialog(context, 'Please Select Product'.tr);
                        } else {
                          showProductVariety(context);
                        }
                      },
                      controller: productVarietyController,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          hintText: 'Variety'.tr,
                          border: InputBorder.none,
                          counterText: "",
                          suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    width: upcoming_flag == false ? 10 : 0,
                  ),
                  upcoming_flag == false
                      ? Container(
                          width: (MediaQuery.of(context).size.width / 2) - 15,
                          height: 58,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                          // margin: const EdgeInsets.only(right: 16),
                          child: TextField(
                            onTap: () {
                              if (productCategoryID == "") {
                                WidgetUtils.errorDialog(context, 'Please Select Product Category'.tr);
                              } else {
                                dialogSelectDate();
                              }
                            },
                            controller: activeDateController,
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                hintText: 'Active Till'.tr,
                                border: InputBorder.none,
                                counterText: "",
                                suffixIcon: Icon(Icons.calendar_month_outlined, color: Color(int.parse(themeColor.value.buttonColor!.color!)))),
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          ),
                        )
                      : Container(),
                ],
              ),
              upcoming_flag ? upcomingWeight() : Container(),
              season_flag == false ? const SizedBox(height: 10) : Container(),
              season_flag == false ? WidgetUtils.appTextWidget(context: context, title: 'Season'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16) : Container(),
              season_flag == false ? const SizedBox(height: 08) : Container(),
              season_flag == false
                  ? Row(
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 15,
                          height: 58,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                          // margin: const EdgeInsets.only(right: 16),
                          child: TextField(
                            onTap: () {
                              showSeason(context, "from");
                            },
                            controller: seasonFromController,
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                hintText: 'Season from'.tr,
                                border: InputBorder.none,
                                counterText: "",
                                suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          width: 10,
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
                              showSeason(context, "to");
                            },
                            controller: seasonToController,
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                hintText: 'Season to'.tr,
                                border: InputBorder.none,
                                counterText: "",
                                suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              productCategoryID == "2"
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        WidgetUtils.appTextWidget(context: context, title: 'Marketable Surplus'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                        const SizedBox(height: 08),
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            children: [
                              Container(
                                width: (MediaQuery.of(context).size.width * 0.60),
                                height: 58,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(left: 10),
                                // margin: const EdgeInsets.only(right: 16),
                                child: TextField(
                                  controller: marketableController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 5,
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  decoration: InputDecoration(
                                    hintText: 'Enter Value'.tr,
                                    border: InputBorder.none,
                                    counterText: "",
                                  ),
                                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  color: Colors.grey.shade300,
                                  height: 58,
                                  width: 1,
                                ),
                              ),
                              Container(
                                width: (MediaQuery.of(context).size.width * 0.30),
                                height: 58,
                                alignment: Alignment.center,
                                child: TextField(
                                  onTap: () {
                                    showUnit(context, "marketable");
                                  },
                                  controller: marketableUnitController,
                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      hintText: ''.tr,
                                      counterText: "",
                                      border: InputBorder.none,
                                      suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        WidgetUtils.appTextWidget(context: context, title: 'Quantity (Immediate Sell)'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                        const SizedBox(height: 08),
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            children: [
                              Container(
                                width: (MediaQuery.of(context).size.width * 0.60),
                                height: 58,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(left: 10),
                                // margin: const EdgeInsets.only(right: 16),
                                child: TextField(
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 5,
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  decoration: InputDecoration(
                                    hintText: 'Enter Quantity'.tr,
                                    border: InputBorder.none,
                                    counterText: "",
                                  ),
                                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  color: Colors.grey.shade300,
                                  height: 58,
                                  width: 1,
                                ),
                              ),
                              Container(
                                width: (MediaQuery.of(context).size.width * 0.30),
                                height: 58,
                                alignment: Alignment.center,
                                child: TextField(
                                  onTap: () {
                                    //showUnit(context, "quantity");
                                  },
                                  controller: quantityUnitController,
                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                      hintText: ''.tr,
                                      counterText: "",
                                      border: InputBorder.none,
                                      suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 10),
              WidgetUtils.appTextWidget(context: context, title: 'Price (₹)'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
              const SizedBox(height: 08),
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width * 0.60),
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10),
                      // margin: const EdgeInsets.only(right: 16),
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        maxLength: 7,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          hintText: 'Enter Price'.tr,
                          border: InputBorder.none,
                          counterText: "",
                        ),
                        style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        color: Colors.grey.shade300,
                        height: 58,
                        width: 1,
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width * 0.30),
                      height: 58,
                      alignment: Alignment.center,
                      child: TextField(
                        onTap: () {},
                        controller: priceUnitController,
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            hintText: ''.tr,
                            counterText: "",
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                        style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width / 2) - 15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: logisticPartner_flag,
                          activeColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                          onChanged: (bool? value) {
                            setState(() {
                              if (logisticPartner_flag == true) {
                                logisticPartner_flag = false;
                              } else {
                                logisticPartner_flag = true;
                              }
                            });
                          },
                        ),
                        WidgetUtils.appTextWidget(context: context, title: 'Logistic'.tr, fontSize: 16, fontWeight: FontWeight.w400, family: 'Graphik', textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width / 2) - 15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: packaging_flag,
                          activeColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                          onChanged: (bool? value) {
                            setState(() {
                              if (packaging_flag == true) {
                                packaging_flag = false;
                              } else {
                                packaging_flag = true;
                              }
                            });
                          },
                        ),
                        WidgetUtils.appTextWidget(context: context, title: 'Packaging'.tr, fontSize: 16, fontWeight: FontWeight.w400, family: 'Graphik', textAlign: TextAlign.start),
                      ],
                    ),
                  )
                ],
              ),
              packaging_flag
                  ? Column(
                      children: [
                        const SizedBox(height: 08),
                        Container(
                          width: double.maxFinite,
                          height: 58,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                          // margin: const EdgeInsets.only(right: 16),
                          child: TextField(
                            onTap: () {
                              showPackaging(context);
                            },
                            controller: packagingController,
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                hintText: 'Select Packaging'.tr,
                                border: InputBorder.none,
                                counterText: "",
                                suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 20),
              WidgetUtils.buttonWidget(
                  context: context,
                  radius: 8,
                  title: "Next".tr,
                  size: 18,
                  family: 'Graphik',
                  weight: FontWeight.w500,
                  callback: () {
                    submit();
                  },
                  textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                  color: Color(int.parse(themeColor.value.buttonColor!.color!))),
              isKeyboardVisible ? const SizedBox(height: 400) : const SizedBox(height: 20)
            ],
          ),
        );
      });
    });
  }

  upcomingWeight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 08),
        WidgetUtils.appTextWidget(context: context, title: 'Availability'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
        const SizedBox(height: 08),
        Container(
          width: double.maxFinite,
          height: 58,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
          // margin: const EdgeInsets.only(right: 16),
          child: TextField(
            onTap: () {
              dialogSelectDateAvlaible("from");
            },
            controller: avaliableFromController,
            keyboardType: TextInputType.text,
            readOnly: true,
            decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                hintText: 'Availability From'.tr,
                border: InputBorder.none,
                counterText: "",
                suffixIcon: Icon(Icons.calendar_month_outlined, color: Color(int.parse(themeColor.value.buttonColor!.color!)))),
            style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 08),
        Container(
          width: double.maxFinite,
          height: 58,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
          // margin: const EdgeInsets.only(right: 16),
          child: TextField(
            onTap: () {
              if (avaliableFromController!.text.toString() == "") {
                WidgetUtils.errorDialog(context, 'Please Select Available from Date');
              } else {
                dialogSelectDateAvlaible("to");
              }
            },
            controller: avaliableToController,
            keyboardType: TextInputType.text,
            readOnly: true,
            decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                hintText: 'Availability To'.tr,
                border: InputBorder.none,
                counterText: "",
                suffixIcon: Icon(Icons.calendar_month_outlined, color: Color(int.parse(themeColor.value.buttonColor!.color!)))),
            style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 10),
        WidgetUtils.appTextWidget(context: context, title: 'Expected yield'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
        const SizedBox(height: 08),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width * 0.60),
                height: 58,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10),
                // margin: const EdgeInsets.only(right: 16),
                child: TextField(
                  controller: expectedYieldFromController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Enter Expected yield From'.tr,
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  color: Colors.grey.shade300,
                  height: 58,
                  width: 1,
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width * 0.30),
                height: 58,
                alignment: Alignment.center,
                child: TextField(
                  onTap: () {
                    showUnit(context, "expectedYieldFrom");
                  },
                  controller: expectedYieldFromUnitController,
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintText: ''.tr,
                      counterText: "",
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 08),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width * 0.60),
                height: 58,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10),
                // margin: const EdgeInsets.only(right: 16),
                child: TextField(
                  controller: expectedYieldToController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Enter Expected yield To'.tr,
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  color: Colors.grey.shade300,
                  height: 58,
                  width: 1,
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width * 0.30),
                height: 58,
                alignment: Alignment.center,
                child: TextField(
                  onTap: () {
                    //showUnit(context,"expectedYieldTo");
                  },
                  controller: expectedYieldToUnitController,
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintText: ''.tr,
                      counterText: "",
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ],
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
                                        productCategoryController!.text = dssModel[index].title ?? "";
                                        productCategoryID = dssModel[index].id.toString();
                                        activeDateCount = dssModel[index].days ?? 0;
                                        activeDateController!.text = DateFormat('dd-MM-yyyy').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + activeDateCount));
                                        if (dssModel[index].id.toString() == "3") {
                                          season_flag = true;
                                          upcoming_flag = false;
                                        } else if (dssModel[index].id.toString() == "2") {
                                          upcoming_flag = true;
                                          season_flag = true;
                                        } else {
                                          season_flag = false;
                                          upcoming_flag = false;
                                        }
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

  void showProductType(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).productTypeList ?? [];
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
                              WidgetUtils.appTextWidget(context: context, title: 'Select Product Type'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
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
                                        productTypeController!.text = dssModel[index].title ?? "";
                                        productTypeID = dssModel[index].id.toString();

                                        productController!.text = "";
                                        productID = "";
                                        productVarietyController!.text = "";
                                        productVarietyID = "";

                                        getProduct(productCategoryID, productTypeID);
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

  Future getProduct(String categoryID, String productID) async {
    try {
      var params = {/*"product_category": categoryID,*/ "product_type": productID};
      final response = await APIService.postAPIMethod(url: ApiURL.productData, params: params);
      final data = json.decode(response.body);
      final res = NedfiProductType.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setProductData(res.data ?? []);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  void showProduct(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).productList ?? [];
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
                              WidgetUtils.appTextWidget(context: context, title: 'Select Product'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
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
                          child: dssModel.isNotEmpty
                              ? ListView(shrinkWrap: true, children: <Widget>[
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    // Change as per your requirement
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dssModel.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                productController!.text = dssModel[index].title ?? "";
                                                productID = dssModel[index].id ?? "";
                                                productVarietyController!.text = "";
                                                productVarietyID = "";
                                                getProductVariety(productID);
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
                                ])
                              : Center(
                                  child:
                                      WidgetUtils.appTextWidget(context: context, title: 'No Product Available'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                                )),
                    ],
                  ),
                ));
          });
        });
  }

  Future getProductVariety(String productID) async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.productVariety + "/" + productID);
      final data = json.decode(response.body);
      final res = NedfiProductVariety.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setProductVarietyData(res.data ?? []);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  void showProductVariety(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).productVarietyList ?? [];
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
                              WidgetUtils.appTextWidget(context: context, title: 'Select Product'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
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
                          child: dssModel.isNotEmpty
                              ? ListView(shrinkWrap: true, children: <Widget>[
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    // Change as per your requirement
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dssModel.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                productVarietyController!.text = dssModel[index].title ?? "";
                                                productVarietyID = dssModel[index].id ?? "";
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
                                ])
                              : Center(
                                  child: WidgetUtils.appTextWidget(
                                      context: context, title: 'No Product Variety Available'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                                )),
                    ],
                  ),
                ));
          });
        });
  }

  Future dialogSelectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + activeDateCount),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + activeDateCount),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(int.parse(themeColor.value.buttonColor!.color!)),
              onPrimary: Color(int.parse(themeColor.value.buttonTextColor!.color!)), // <-- SEE HERE
              onSurface: Colors.black87, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color(int.parse(themeColor.value.buttonColor!.color!)), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        activeDateController!.text = formattedDate;
      });
    } else {}
  }

  Future dialogSelectDateAvlaible(String type) async {
    /* DateTime? pickedDate = await showDatePicker(
        context: context,
      initialDatePickerMode: DatePickerMode.year,
        initialDate: DateTime.now(),
      firstDate: DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(DateTime.now().year+ 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:Color(int.parse(themeColor.value.buttonColor!.color!)),
              onPrimary: Color(int.parse(themeColor.value.buttonTextColor!.color!)), // <-- SEE HERE
              onSurface: Colors.black87, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary:Color(int.parse(themeColor.value.buttonColor!.color!)), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
        );*/
    showMonthPicker(
        context: context,
        initialDate: DateTime.now(),
        headerColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
        headerTextColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
        selectedMonthTextColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
        selectedMonthBackgroundColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
        unselectedMonthTextColor: Colors.black,
        confirmWidget: Text(
          "OK",
          style: TextStyle(color: Color(int.parse(themeColor.value.buttonColor!.color!))),
        ),
        cancelWidget: Text(
          "CANCEL",
          style: TextStyle(color: Color(int.parse(themeColor.value.buttonColor!.color!))),
        )).then((date) {
      if (date != null) {
        setState(() {
          String formattedDate = DateFormat('MMM-yyyy').format(date);
          if (type == "from") {
            avaliableFromDate = date;
            avaliableFromController!.text = formattedDate;
          } else {
            //print("avaliableFromDate!.compareTo(date)");
            //print(date.compareTo(avaliableFromDate!));
            if (date.compareTo(avaliableFromDate!) >= 0) {
              avaliableToDate = date;
              avaliableToController!.text = formattedDate;
            } else {
              WidgetUtils.errorDialog(context, 'Available To Date Should Be Grater Then Available From date ');
            }
          }
        });
      }
    });
    /* if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        if(type=="from") {
          avaliableFromController!.text = formattedDate;
        }else{
          avaliableToController!.text = formattedDate;
        }
      });
    } else {}*/
  }

  void showUnit(BuildContext context, String type) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).masterData?.productUnit ?? [];
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
                              WidgetUtils.appTextWidget(context: context, title: 'Select Unit'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
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
                          child: dssModel.isNotEmpty
                              ? ListView(shrinkWrap: true, children: <Widget>[
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    // Change as per your requirement
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dssModel.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                if (type == "marketable") {
                                                  marketableUnitController!.text = dssModel[index].title ?? "";
                                                  marketableUnitID = dssModel[index].id.toString();
                                                  quantityUnitController!.text = dssModel[index].title ?? "";
                                                  priceUnitController!.text = dssModel[index].title ?? "";
                                                  priceUnitID = dssModel[index].id.toString();
                                                } else if (type == "expectedYieldFrom") {
                                                  expectedYieldFromUnitController!.text = dssModel[index].title ?? "";
                                                  expectedYieldFromUnitID = dssModel[index].id.toString();
                                                  /* }else if(type=="expectedYieldTo"){*/
                                                  expectedYieldToUnitController!.text = dssModel[index].title ?? "";
                                                  priceUnitController!.text = dssModel[index].title ?? "";
                                                  expectedYieldToUnitID = dssModel[index].id.toString();
                                                  priceUnitID = dssModel[index].id.toString();
                                                } else {
                                                  quantityUnitController!.text = dssModel[index].title ?? "";
                                                  priceUnitController!.text = dssModel[index].title ?? "";
                                                  priceUnitID = dssModel[index].id.toString();
                                                }
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
                                ])
                              : Center(
                                  child: WidgetUtils.appTextWidget(context: context, title: 'No Unit Available'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                                )),
                    ],
                  ),
                ));
          });
        });
  }

  void showSeason(BuildContext context, String type) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).masterData?.season ?? [];
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
                              WidgetUtils.appTextWidget(context: context, title: 'Select Season'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
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
                          child: dssModel.isNotEmpty
                              ? ListView(shrinkWrap: true, children: <Widget>[
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    // Change as per your requirement
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dssModel.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                if (type == "from") {
                                                  seasonFromController!.text = dssModel[index].title ?? "";
                                                  seasonFromID = dssModel[index].id.toString();
                                                } else {
                                                  seasonToController!.text = dssModel[index].title ?? "";
                                                  seasonToID = dssModel[index].id.toString();
                                                }
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
                                ])
                              : Center(
                                  child:
                                      WidgetUtils.appTextWidget(context: context, title: 'No Season Available'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                                )),
                    ],
                  ),
                ));
          });
        });
  }

  void showPackaining(BuildContext context, String type) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).masterData?.season ?? [];
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
                              WidgetUtils.appTextWidget(context: context, title: 'Select Packaging'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
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
                          child: dssModel.isNotEmpty
                              ? ListView(shrinkWrap: true, children: <Widget>[
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    // Change as per your requirement
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dssModel.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                packagingController!.text = dssModel[index].title ?? "";
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
                                ])
                              : Center(
                                  child:
                                      WidgetUtils.appTextWidget(context: context, title: 'No Season Available'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                                )),
                    ],
                  ),
                ));
          });
        });
  }

  Future getPackaging() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.packagingList);
      final data = json.decode(response.body);
      final res = NedfiProductVariety.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setPackagingData(res.data ?? []);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  void showPackaging(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).packagingList;
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
                              WidgetUtils.appTextWidget(context: context, title: 'Select Packaging'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
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
                          child: dssModel.isNotEmpty
                              ? ListView(shrinkWrap: true, children: <Widget>[
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    // Change as per your requirement
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dssModel.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                packagingController!.text = dssModel[index].title ?? "";
                                                packagingID = dssModel[index].id ?? "";
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
                                ])
                              : Center(
                                  child: WidgetUtils.appTextWidget(
                                      context: context, title: 'No Packaging Available'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                                )),
                    ],
                  ),
                ));
          });
        });
  }

  submit() {
    if (productCategoryController!.text.toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Select Product Category'.tr);
    } else if (productTypeController!.text.toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Select Product Type'.tr);
    } else if (productController!.text.toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Select Product'.tr);
    } else if (productVarietyController!.text.toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Select Product Variety'.tr);
    } else if (productCategoryID == "1") {
      if (activeDateController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Active Till Date'.tr);
      } else if (seasonFromController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Season From'.tr);
      } else if (seasonToController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Season To'.tr);
      } else if (marketableController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Marketable Surplus'.tr);
      } else if (marketableUnitController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Marketable Surplus Unit'.tr);
      } else if (quantityController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Quantity'.tr);
      } else if (quantityUnitController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Quantity Unit'.tr);
      } else if (double.parse(quantityController!.text.toString()) > double.parse(marketableController!.text.toString())) {
        WidgetUtils.errorDialog(context, 'Quantity (Immediate Sell) should be less then Marketable Surplus'.tr);
      } else if (priceController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Price'.tr);
      } else if (priceUnitController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Price Unit'.tr);
      } else if (packaging_flag) {
        if (packagingController!.text.toString().isEmpty) {
          WidgetUtils.errorDialog(context, 'Please Select Packaging'.tr);
        } else {
          addProduct();
        }
      } else {
        addProduct();
      }
    } else if (productCategoryID == "2") {
      if (_value == 0) {
        WidgetUtils.errorDialog(context, 'Please Select Product Details'.tr);
      } else if (activeDateController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Active Till Date'.tr);
      } else if (avaliableFromController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Available From'.tr);
      } else if (avaliableToController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Available To'.tr);
      } else if (expectedYieldFromController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Expected Yield From'.tr);
      } else if (expectedYieldFromUnitController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Expected Yield From Unit'.tr);
      } else if (expectedYieldToController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Expected Yield To'.tr);
      } else if (expectedYieldToUnitController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Expected Yield To Unit'.tr);
      } else if (double.parse(expectedYieldFromController!.text.toString()) > double.parse(expectedYieldToController!.text.toString())) {
        WidgetUtils.errorDialog(context, 'Expected Yield To should be less then Expected Yield From'.tr);
      } else if (priceController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Price'.tr);
      } else if (priceUnitController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Price Unit'.tr);
      } else if (packaging_flag) {
        if (packagingController!.text.toString().isEmpty) {
          WidgetUtils.errorDialog(context, 'Please Select Packaging'.tr);
        } else {
          addProduct();
        }
      } else {
        addProduct();
      }
    } else if (productCategoryID == "3") {
      if (marketableController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Marketable Surplus'.tr);
      } else if (marketableUnitController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Marketable Surplus Unit'.tr);
      } else if (quantityController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Quantity'.tr);
      } else if (quantityUnitController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Quantity Unit'.tr);
      } else if (double.parse(quantityController!.text.toString()) > double.parse(marketableController!.text.toString())) {
        WidgetUtils.errorDialog(context, 'Quantity (Immediate Sell) should be less then Marketable Surplus'.tr);
      } else if (priceController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Price'.tr);
      } else if (priceUnitController!.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Price Unit'.tr);
      } else if (packaging_flag) {
        if (packagingController!.text.toString().isEmpty) {
          WidgetUtils.errorDialog(context, 'Please Select Packaging'.tr);
        } else {
          addProduct();
        }
      } else {
        addProduct();
      }
    }
    setState(() {});
  }

  addProduct() async {
    try {
      var otherDetails = {"season_from": seasonFromID, "season_to": seasonToID, "available_from": avaliableFromController!.text.toString(), "available_to": avaliableToController!.text.toString()};
      if (productCategoryID == "2") {
        otherDetails = {
          "availability_from": avaliableFromController!.text.toString(),
          "availability_to": avaliableToController!.text.toString(),
          "yield_from": expectedYieldFromController!.text.toString(),
          "yield_from_unit": expectedYieldFromUnitID,
          "yield_to": expectedYieldToController!.text.toString(),
          "yield_to_unit": expectedYieldToUnitID
        };
      }
      var params = {
        "id": id,
        "user_id": HeaderSingleton().paramsMaps!.userId.toString(),
        "prod_cat_id": productCategoryID,
        "prod_type_id": productTypeID,
        "prod_id": productID,
        "prod_variety_id": productVarietyID,
        "active_till_date": activeDateController!.text.toString(),
        "surplus": marketableController!.text.toString(),
        "surplus_unit": marketableUnitID,
        /* "other_details": otherDetails.toString(),*/
        "sell_qty": quantityController!.text.toString(),
        "sell_qty_unit": priceUnitID,
        "price": priceController!.text.toString(),
        "price_unit": priceUnitID,
        "with_logistic_partner": logisticPartner_flag.toString(),
        "with_packging": packaging_flag.toString(),
        "packaging_master_id": packagingID.toString(),
        "step": "1",
        "season_from": seasonFromID,
        "season_to": seasonToID,
        "availability_from": avaliableFromController!.text.toString(),
        "availability_to": avaliableToController!.text.toString()
      };
      if (productCategoryID == "2") {
        params = {
          "id": id,
          "user_id": HeaderSingleton().paramsMaps!.userId.toString(),
          "prod_cat_id": productCategoryID,
          "prod_type_id": productTypeID,
          "prod_id": productID,
          "prod_variety_id": productVarietyID,
          "active_till_date": activeDateController!.text.toString(),
          "surplus": marketableController!.text.toString(),
          "surplus_unit": marketableUnitID,
          /* "other_details": otherDetails.toString(),*/
          "sell_qty": quantityController!.text.toString(),
          "sell_qty_unit": priceUnitID,
          "price": priceController!.text.toString(),
          "price_unit": priceUnitID,
          "with_logistic_partner": logisticPartner_flag.toString(),
          "with_packging": packaging_flag.toString(),
          "packaging_master_id": packagingID.toString(),
          "prod_details": _value.toString(),
          "step": "1",
          "availability_from": avaliableFromController!.text.toString(),
          "availability_to": avaliableToController!.text.toString(),
          "yield_from": expectedYieldFromController!.text.toString(),
          "yield_from_unit": expectedYieldFromUnitID,
          "yield_to": expectedYieldToController!.text.toString(),
          "yield_to_unit": expectedYieldToUnitID
        };
      }
      //print(params);

      final response = await APIService.postAPIMethod(url: ApiURL.addTradeProduct, params: params);
      final data = json.decode(response.body);
      //print(data);
      final res = AddProductResponse.fromJson(data);
      if (res.success == 1) {
        var loanModel = Provider.of<MasterProvider>(context, listen: false);
        loanModel.setProductCurrentIndex(2);
        loanModel.setItemId(res.data.toString() ?? "");
        widget.onPressed(2);
        WidgetUtils.successDialog(context, res.message ?? "");
      } else {
        WidgetUtils.errorDialog(context, res.message ?? "");
      }
      setState(() {});
    } catch (e) {
      WidgetUtils.errorDialog(context, e.toString());
      //print(e);
      setState(() {});
    }
  }
}
