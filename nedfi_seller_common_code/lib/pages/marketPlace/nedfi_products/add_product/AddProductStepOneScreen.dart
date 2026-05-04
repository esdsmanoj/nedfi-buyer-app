import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nedfi_seller_common_code/model/trade_product_model/NedfiProductVariety.dart';

import '../../../../app_imports.dart';
import '../../../../components/month_picker_dialog/month_picker_dialog.dart';
import '../../../../model/trade_product_model/AddProductResponse.dart';
import '../../../../model/trade_product_model/BuyerDemand.dart';
import '../../../../model/NedfiProductType.dart';
import '../../../../model/trade_product_model/master_listing_model.dart';
import '../../../../model/trade_product_model/trade_product_info.dart';
import '../../../../providers/master_provider.dart';

class AddProductStepOneScreen extends StatefulWidget {
  String? id, from;
  final ValueChanged onPressed;
  BuyerDemandData? item;

  AddProductStepOneScreen({super.key, this.id, this.from, required this.onPressed, this.item});

  @override
  State<AddProductStepOneScreen> createState() => _AddProductStepOneScreenState();
}

class _AddProductStepOneScreenState extends State<AddProductStepOneScreen> {
  TextEditingController productCategoryController = TextEditingController(),
      productTypeController = TextEditingController(),
      productController = TextEditingController(),
      productVarietyController = TextEditingController(),
      activeDateController = TextEditingController(),
      seasonFromController = TextEditingController(),
      seasonToController = TextEditingController(),
      marketableUnitController = TextEditingController(),
      quantityUnitController = TextEditingController(),
      priceUnitController = TextEditingController(),
      marketableController = TextEditingController(),
      quantityController = TextEditingController(),
      priceController = TextEditingController(),
      packagingController = TextEditingController(),
      expectedYieldFromController = TextEditingController(),
      expectedYieldToController = TextEditingController(),
      expectedYieldFromUnitController = TextEditingController(),
      expectedYieldToUnitController = TextEditingController(),
      availableFromController = TextEditingController(),
      availableToController = TextEditingController();
  bool isKeyBoard = false, packagingFlag = true, logisticPartnerFlag = true, seasonFlag = false, upComingFlag = false;
  int activeDateCount = 0;
  var _value = 1;
  String productCategoryID = "",
      productTypeID = "",
      productID = "",
      productVarietyID = "",
      packagingID = "",
      priceUnitID = "",
      marketableUnitID = "",
      expectedYieldFromUnitID = "",
      expectedYieldToUnitID = "",
      seasonFromID = "",
      seasonToID = "",
      id = "",
      status = "8";
  DateTime? availableFromDate, availableToDate;
  dynamic masterProvider;

  Future getMasterList() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getMasterListing);
      final data = json.decode(response.body);
      final res = MasterListing.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setMasterData(res.data!);
          // if (widget.from != null) {
          for (var element in res.data!.productCategory!) {
            if (productCategoryID == element.id.toString()) {
              activeDateCount = element.days ?? 0;
              activeDateController.text = DateFormat('dd-MM-yyyy').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + activeDateCount));
            }
          }
          //  }
          setState(() {});
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getPackaging();
    masterProvider = Provider.of<MasterProvider>(context, listen: false);
    if (widget.from != null) {
      if (productCategoryController.text.isEmpty) {
        productCategoryController.text = widget.item?.productCategoryTitle ?? "";
        productTypeController.text = widget.item?.productTypeTitle ?? "";
        productController.text = widget.item?.productTitle ?? "";
        productVarietyController.text = widget.item?.productVarietyTitle ?? "";
        productCategoryID = widget.item?.prodCatId ?? "";
        productTypeID = widget.item?.prodTypeId ?? "";
        productID = widget.item?.prodId ?? "";
        productVarietyID = widget.item?.prodVarietyId ?? "";
        if (widget.item?.prodCatId.toString() == "3") {
          seasonFlag = true;
          upComingFlag = false;
        } else if (widget.item?.prodCatId.toString() == "2") {
          upComingFlag = true;
          seasonFlag = true;
        } else {
          seasonFlag = false;
          upComingFlag = false;
        }
        if (widget.item?.prodCatId == "2") {
          DateTime formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').parse(widget.item?.availableFrom ?? "");
          availableFromDate = formattedDate;
          availableFromController.text = DateFormat('MMM-yyyy').format(formattedDate);
          DateTime formattedDateto = DateFormat('yyyy-MM-dd hh:mm:ss').parse(widget.item?.availableTo ?? "");
          availableToDate = formattedDateto;
          availableToController.text = DateFormat('MMM-yyyy').format(formattedDateto);
        }
        setState(() {});
        getMasterList();
      }
    } else {
      if (masterProvider.itemId != "" && masterProvider.itemId != null) {
        id = masterProvider.itemId;
        // status = "8";
        getProductList();
      }

      if (widget.id != null) {
        id = widget.id ?? "";
        status = "1";
        getProductList();
      }
    }
  }

  /// Getting product list details from the API.
  Future getProductList() async {
    try {
      var param = {"user_id": HeaderSingleton().paramsMaps!.userId, "id": id};
      final response = await APIService.postAPIMethod(url: ApiURL.tradeProduct, params: param);
      final data = json.decode(response.body);
      final res = TradeProductInfo.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setCurrentTreadProduct(res.data![0]);
          masterProvider.setType("EDIT");
          masterProvider.setItemId(widget.id ?? "");
          if (masterProvider.type == "EDIT") {
            id = masterProvider.treadProductCurrent!.id ?? "";
            productCategoryController.text = masterProvider.treadProductCurrent!.productCategoryTitle ?? "";
            productTypeController.text = masterProvider.treadProductCurrent!.productTypeTitle ?? "";
            productController.text = masterProvider.treadProductCurrent!.productTitle ?? "";
            productVarietyController.text = masterProvider.treadProductCurrent!.productVarietyTitle ?? "";
            activeDateController.text = masterProvider.treadProductCurrent!.activeTillDate ?? "";

            if (masterProvider.treadProductCurrent!.seasonText != null) {
              seasonFromController.text = masterProvider.treadProductCurrent!.seasonText.toString().split(",")[0].split("-").last.trim();
              seasonToController.text = masterProvider.treadProductCurrent!.seasonText.toString().split(",")[1].split("-").last.trim();
            }
            marketableUnitController.text = masterProvider.treadProductCurrent!.surplusUnitTitle ?? "";
            quantityUnitController.text = masterProvider.treadProductCurrent!.sellQtyUnitTitle ?? "";
            priceUnitController.text = masterProvider.treadProductCurrent!.priceUnitTitle ?? "";
            marketableController.text = masterProvider.treadProductCurrent!.surplus ?? "";
            quantityController.text = masterProvider.treadProductCurrent!.sellQty ?? "";
            priceController.text = masterProvider.treadProductCurrent!.price ?? "";
            packagingController.text = masterProvider.treadProductCurrent!.packagingTitle ?? "";
            expectedYieldFromController.text = masterProvider.treadProductCurrent?.otherDetails?.yieldFrom ?? "";
            expectedYieldToController.text = masterProvider.treadProductCurrent?.otherDetails?.yieldTo ?? "";
            expectedYieldFromUnitController.text = masterProvider.treadProductCurrent?.otherDetails?.yieldFromUnitText ?? "";
            expectedYieldToUnitController.text = masterProvider.treadProductCurrent?.otherDetails?.yieldToUnitText ?? "";
            availableFromController.text = masterProvider.treadProductCurrent?.otherDetails?.availableFrom ?? "";
            availableToController.text = masterProvider.treadProductCurrent?.otherDetails?.availableTo ?? "";

            if (masterProvider.treadProductCurrent?.otherDetails != null) {
              if (masterProvider.treadProductCurrent?.otherDetails?.availableFrom != "") {
                try {
                  DateTime formattedDate = DateFormat('MM-yyyy').parse(masterProvider.treadProductCurrent?.otherDetails?.availableFrom ?? "");
                  availableFromDate = formattedDate;
                } catch (e) {
                  DateTime formattedDate = DateFormat('MMM-yyyy').parse(masterProvider.treadProductCurrent?.otherDetails?.availableFrom ?? "");
                  availableFromDate = formattedDate;
                }
              }
            }
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
              seasonFlag = true;
              upComingFlag = false;
            } else if (masterProvider.treadProductCurrent!.prodCatId.toString() == "2") {
              upComingFlag = true;
              seasonFlag = true;
            } else {
              seasonFlag = false;
              upComingFlag = false;
            }
            if (masterProvider.treadProductCurrent!.withPackging == "t") {
              packagingController.text = masterProvider.treadProductCurrent!.packagingTitle ?? "";
              packagingFlag = true;
            } else {
              packagingFlag = false;
            }

            if (masterProvider.treadProductCurrent!.withLogisticPartner == "t") {
              logisticPartnerFlag = true;
            } else {
              logisticPartnerFlag = false;
            }

            if (masterProvider.treadProductCurrent!.prod_details != null) {
              if (masterProvider.treadProductCurrent!.prod_details == "1") {
                _value = 1;
              } else {
                _value = 2;
              }
            }
            if (masterProvider.treadProductCurrent!.storageTypeTitle == null || masterProvider.treadProductCurrent!.storageTypeTitle == "") {
              status = "8";
            }
            getProduct(masterProvider.treadProductCurrent!.prodCatId ?? "", masterProvider.treadProductCurrent!.prodTypeId ?? "");
          }
          setState(() {});
        }
      }
    } catch (e) {
      print(e);
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
                      suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
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
                      suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 10),
              WidgetUtils.appTextWidget(context: context, title: 'Product'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
              upComingFlag == true
                  ? SizedBox(
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          SizedBox(
                            width: 250,
                            height: 50,
                            child: Row(
                              children: [
                                for (int i = 1; i <= 2; i++)
                                  SizedBox(
                                    width: 120,
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
                                          style: const TextStyle(color: Colors.black),
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
                      suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: upComingFlag == false ? (MediaQuery.of(context).size.width / 2) - 15 : (MediaQuery.of(context).size.width) - 20,
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
                          suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    width: upComingFlag == false ? 10 : 0,
                  ),
                  upComingFlag == false
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
              upComingFlag ? upcomingUIWidget() : Container(),
              seasonFlag == false ? const SizedBox(height: 10) : Container(),
              seasonFlag == false ? WidgetUtils.appTextWidget(context: context, title: 'Season'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16) : Container(),
              seasonFlag == false ? const SizedBox(height: 08) : Container(),
              seasonFlag == false
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
                                suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
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
                                suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
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
                        /* const SizedBox(height: 10),
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
                                      suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),*/
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
                                    showUnit(context, "marketable");
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
                                      suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
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
                            suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                        style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 2) - 15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: logisticPartnerFlag,
                          activeColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                          onChanged: (bool? value) {
                            setState(() {
                              if (logisticPartnerFlag == true) {
                                logisticPartnerFlag = false;
                              } else {
                                logisticPartnerFlag = true;
                              }
                            });
                          },
                        ),
                        WidgetUtils.appTextWidget(context: context, title: 'Logistic'.tr, fontSize: 16, fontWeight: FontWeight.w400, family: 'Graphik', textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 2) - 15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: packagingFlag,
                          activeColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                          onChanged: (bool? value) {
                            setState(() {
                              if (packagingFlag == true) {
                                packagingFlag = false;
                              } else {
                                packagingFlag = true;
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
              packagingFlag
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
                                suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
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

  /// Building the upcoming widget UI design.
  Widget upcomingUIWidget() {
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
              dialogSelectDateAvailable("from");
            },
            controller: availableFromController,
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
              if (availableFromController.text.toString() == "") {
                WidgetUtils.errorDialog(context, 'Please Select Available from Date');
              } else {
                dialogSelectDateAvailable("to");
              }
            },
            controller: availableToController,
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
                      suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
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
                      suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///Showing product category dialog design.
  void showProductCategory(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider.of<MasterProvider>(context, listen: true).masterData?.productCategory ?? [];
          return StatefulBuilder(builder: (ctx, StateSetter setStates) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WidgetUtils.appTextWidget(
                            context: context,
                            title: 'Select Product Category'.tr,
                            color: Colors.black,
                            fontSize: 18,
                            family: 'Graphik',
                            fontWeight: FontWeight.w500,
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(ctx),
                            child: SvgPicture.asset(
                              "assets/images/cross.svg",
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300, // Set a fixed height that works well across devices
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
                                  activeDateCount = dssModel[index].days ?? 0;
                                  activeDateController.text = DateFormat('dd-MM-yyyy')
                                      .format(DateTime.now().add(Duration(days: activeDateCount)));

                                  // Set flags
                                  if (dssModel[index].id.toString() == "3") {
                                    seasonFlag = true;
                                    upComingFlag = false;
                                  } else if (dssModel[index].id.toString() == "2") {
                                    upComingFlag = true;
                                    seasonFlag = true;
                                  } else {
                                    seasonFlag = false;
                                    upComingFlag = false;
                                  }
                                });
                              },
                              child: Container(
                              
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(width: 1, color: Colors.grey.shade300),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: WidgetUtils.appTextWidget(
                                    context: context,
                                    title: dssModel[index].title ?? "",
                                    fontSize: 16,
                                    family: 'Graphik',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  ///Showing product type dialog design.
  void showProductType(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final dssModel = Provider.of<MasterProvider>(context, listen: true).productTypeList;
        return StatefulBuilder(builder: (ctx, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(
                          context: context,
                          title: 'Select Product Type'.tr,
                          color: Colors.black,
                          fontSize: 18,
                          family: 'Graphik',
                          fontWeight: FontWeight.w500,
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(ctx),
                          child: SvgPicture.asset(
                            "assets/images/cross.svg",
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300, // Fixed height for scrollable area
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: dssModel.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                productTypeController.text = dssModel[index].title ?? "";
                                productTypeID = dssModel[index].id.toString();

                                productController.text = "";
                                productID = "";
                                productVarietyController.text = "";
                                productVarietyID = "";

                                getProduct(productCategoryID, productTypeID);
                              });
                            },
                            child: Container(
                            
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(width: 1, color: Colors.grey.shade300),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: WidgetUtils.appTextWidget(
                                  context: context,
                                  title: dssModel[index].title ?? "",
                                  fontSize: 16,
                                  family: 'Graphik',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  /// Getting trade product details from the API.
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

  /// Showing the product UI design.
  void showProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final dssModel = Provider.of<MasterProvider>(context, listen: true).productList;
        return StatefulBuilder(
          builder: (ctx, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Use min to wrap content
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(
                          context: context,
                          title: 'Select Product'.tr,
                          color: Colors.black,
                          fontSize: 18,
                          family: 'Graphik',
                          fontWeight: FontWeight.w500,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(ctx);
                          },
                          child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    dssModel.isNotEmpty
                        ? SizedBox(
                      height: 300, // fixed scrollable area
                      child: ListView.builder(
                        itemCount: dssModel.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                productController.text = dssModel[index].title ?? "";
                                productID = dssModel[index].id ?? "";
                                productVarietyController.text = "";
                                productVarietyID = "";
                                getProductVariety(productID);
                              });
                            },
                            child: Container(
                            
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(width: 1, color: Colors.grey.shade300),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: WidgetUtils.appTextWidget(
                                  context: context,
                                  title: dssModel[index].title ?? "",
                                  fontSize: 16,
                                  family: 'Graphik',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: WidgetUtils.appTextWidget(
                        context: context,
                        title: 'No Product Available'.tr,
                        color: Colors.black,
                        fontSize: 18,
                        family: 'Graphik',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  /// Getting product verity as per the product ID.
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

  /// Showing the product verity as per the product selected.
  void showProductVariety(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final dssModel = Provider.of<MasterProvider>(context, listen: true).productVarietyList;
        return StatefulBuilder(
          builder: (ctx, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(
                          context: context,
                          title: 'Select Product Variety'.tr,
                          color: Colors.black,
                          fontSize: 18,
                          family: 'Graphik',
                          fontWeight: FontWeight.w500,
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(ctx),
                          child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    dssModel.isNotEmpty
                        ? SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: dssModel.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                productVarietyController.text = dssModel[index].title ?? "";
                                productVarietyID = dssModel[index].id ?? "";
                              });
                            },
                            child: Container(
                            
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(width: 1, color: Colors.grey.shade300),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: WidgetUtils.appTextWidget(
                                  context: context,
                                  title: dssModel[index].title ?? "",
                                  fontSize: 16,
                                  family: 'Graphik',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: WidgetUtils.appTextWidget(
                        context: context,
                        title: 'No Product Variety Available'.tr,
                        color: Colors.black,
                        fontSize: 18,
                        family: 'Graphik',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  /// showing the date calendar dialog for date selection.
  Future dialogSelectDate() async {
    if (productCategoryID != "") {
      Provider.of<MasterProvider>(context, listen: false).masterData?.productCategory!.forEach((element) {
        if (element.id.toString() == productCategoryID) {
          activeDateCount = element.days ?? 0;
        }
      });
    }
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
                backgroundColor: Color(int.parse(themeColor.value.buttonColor!.color!)), // button text color
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
        activeDateController.text = formattedDate;
      });
    } else {}
  }

  /// Showing the selected dialog date available on calendar.
  Future dialogSelectDateAvailable(String type) async {
    showMonthPicker(
        context: context,
        firstDate: DateTime.now(),
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
            availableFromDate = date;
            availableFromController.text = formattedDate;
          } else {
            if (date.compareTo(availableFromDate!) >= 0) {
              availableToDate = date;
              availableToController.text = formattedDate;
            } else {
              WidgetUtils.errorDialog(context, 'Available To Date Should Be Greater Then Available From date'.tr);
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetUtils.appTextWidget(
                        context: context,
                        title: 'Select Unit'.tr,
                        color: Colors.black,
                        fontSize: 18,
                        family: 'Graphik',
                        fontWeight: FontWeight.w500,
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(ctx),
                        child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  dssModel.isNotEmpty
                      ? SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: dssModel.length,
                      itemBuilder: (BuildContext context, int index) {
                        final unit = dssModel[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              switch (type) {
                                case "marketable":
                                  marketableUnitController.text = unit.title ?? "";
                                  marketableUnitID = unit.id.toString();
                                  quantityUnitController.text = unit.title ?? "";
                                  priceUnitController.text = unit.title ?? "";
                                  priceUnitID = unit.id.toString();
                                  break;

                                case "expectedYieldFrom":
                                  expectedYieldFromUnitController.text = unit.title ?? "";
                                  expectedYieldFromUnitID = unit.id.toString();
                                  expectedYieldToUnitController.text = unit.title ?? "";
                                  expectedYieldToUnitID = unit.id.toString();
                                  priceUnitController.text = unit.title ?? "";
                                  priceUnitID = unit.id.toString();
                                  break;

                                default:
                                  quantityUnitController.text = unit.title ?? "";
                                  priceUnitController.text = unit.title ?? "";
                                  priceUnitID = unit.id.toString();
                              }
                            });
                          },
                          child: Container(
                          
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 1, color: Colors.grey.shade300),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: WidgetUtils.appTextWidget(
                                context: context,
                                title: unit.title ?? "",
                                fontSize: 16,
                                family: 'Graphik',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: WidgetUtils.appTextWidget(
                      context: context,
                      title: 'No Unit Available'.tr,
                      color: Colors.black,
                      fontSize: 18,
                      family: 'Graphik',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void showSeason(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final dssModel = Provider.of<MasterProvider>(context, listen: true).masterData?.season ?? [];

        return StatefulBuilder(builder: (ctx, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetUtils.appTextWidget(
                        context: context,
                        title: 'Select Season'.tr,
                        color: Colors.black,
                        fontSize: 18,
                        family: 'Graphik',
                        fontWeight: FontWeight.w500,
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(ctx),
                        child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  dssModel.isNotEmpty
                      ? SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: dssModel.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              final selected = dssModel[index];
                              if (type == "from") {
                                seasonFromController.text = selected.title ?? "";
                                seasonFromID = selected.id.toString();
                              } else {
                                seasonToController.text = selected.title ?? "";
                                seasonToID = selected.id.toString();
                              }
                            });
                          },
                          child: Container(
                          
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 1, color: Colors.grey.shade300),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: WidgetUtils.appTextWidget(
                                context: context,
                                title: dssModel[index].title ?? "",
                                fontSize: 16,
                                family: 'Graphik',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: WidgetUtils.appTextWidget(
                      context: context,
                      title: 'No Season Available'.tr,
                      color: Colors.black,
                      fontSize: 18,
                      family: 'Graphik',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
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
                                                packagingController.text = dssModel[index].title ?? "";
                                              });
                                            },
                                            child: Container(
                                            
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

        return StatefulBuilder(
          builder: (ctx, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(
                          context: context,
                          title: 'Select Packaging'.tr,
                          color: Colors.black,
                          fontSize: 18,
                          family: 'Graphik',
                          fontWeight: FontWeight.w500,
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(ctx),
                          child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// List or No Data
                    dssModel.isNotEmpty
                        ? SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: dssModel.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = dssModel[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                packagingController.text = item.title ?? "";
                                packagingID = item.id ?? "";
                              });
                            },
                            child: Container(
                            
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(width: 1, color: Colors.grey.shade300),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: WidgetUtils.appTextWidget(
                                  context: context,
                                  title: item.title ?? "",
                                  fontSize: 16,
                                  family: 'Graphik',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: WidgetUtils.appTextWidget(
                        context: context,
                        title: 'No Packaging Available'.tr,
                        color: Colors.black,
                        fontSize: 18,
                        family: 'Graphik',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  submit() {
    if (productCategoryController.text.toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Select Product Category'.tr);
    } else if (productTypeController.text.toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Select Product Type'.tr);
    } else if (productController.text.toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Select Product'.tr);
    } else if (productVarietyController.text.toString().isEmpty) {
      WidgetUtils.errorDialog(context, 'Please Select Product Variety'.tr);
    } else if (productCategoryID == "1") {
      if (activeDateController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Active Till Date'.tr);
      } else if (seasonFromController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Season From'.tr);
      } else if (seasonToController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Season To'.tr);
      }
      /* else if (marketableController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Marketable Surplus'.tr);
      } else if (marketableUnitController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Marketable Surplus Unit'.tr);
      }*/
      else if (quantityController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Quantity'.tr);
      } else if (quantityUnitController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Quantity Unit'.tr);
      }
      /*else if (double.parse(quantityController.text.toString()) > double.parse(marketableController.text.toString())) {
        WidgetUtils.errorDialog(context, 'Quantity (Immediate Sell) should be less then Marketable Surplus'.tr);
      }*/
      else if (priceController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Price'.tr);
      } else if (priceUnitController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Price Unit'.tr);
      } else if (packagingFlag) {
        if (packagingController.text.toString().isEmpty) {
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
      } else if (activeDateController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Active Till Date'.tr);
      } else if (availableFromController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Available From'.tr);
      } else if (availableToController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Available To'.tr);
      } else if (expectedYieldFromController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Expected Yield From'.tr);
      } else if (expectedYieldFromUnitController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Expected Yield From Unit'.tr);
      } else if (expectedYieldToController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Expected Yield To'.tr);
      } else if (expectedYieldToUnitController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Expected Yield To Unit'.tr);
      } else if (double.parse(expectedYieldFromController.text.toString()) > double.parse(expectedYieldToController.text.toString())) {
        WidgetUtils.errorDialog(context, 'Expected Yield To should be greater then Expected Yield From'.tr);
      } else if (priceController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Price'.tr);
      } else if (priceUnitController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Price Unit'.tr);
      } else if (packagingFlag) {
        if (packagingController.text.toString().isEmpty) {
          WidgetUtils.errorDialog(context, 'Please Select Packaging'.tr);
        } else {
          addProduct();
        }
      } else {
        addProduct();
      }
    } else if (productCategoryID == "3") {
      /*if (marketableController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Marketable Surplus'.tr);
      } else if (marketableUnitController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Marketable Surplus Unit'.tr);
      } else*/
      if (quantityController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Quantity'.tr);
      } else if (quantityUnitController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Quantity Unit'.tr);
      }
      /* else if (double.parse(quantityController.text.toString()) > double.parse(marketableController.text.toString())) {
        WidgetUtils.errorDialog(context, 'Quantity (Immediate Sell) should be less then Marketable Surplus'.tr);
      }*/
      else if (priceController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Price'.tr);
      } else if (priceUnitController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Price Unit'.tr);
      } else if (packagingFlag) {
        if (packagingController.text.toString().isEmpty) {
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
      var otherDetails = {"season_from": seasonFromID, "season_to": seasonToID, "available_from": availableFromController.text.toString(), "available_to": availableToController.text.toString()};
      if (productCategoryID == "2") {
        otherDetails = {
          "availability_from": availableFromController.text.toString(),
          "availability_to": availableToController.text.toString(),
          "yield_from": expectedYieldFromController.text.toString(),
          "yield_from_unit": expectedYieldFromUnitID,
          "yield_to": expectedYieldToController.text.toString(),
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
        "active_till_date": activeDateController.text.toString(),
        "surplus": marketableController.text.toString(),
        "surplus_unit": marketableUnitID,
        /* "other_details": otherDetails.toString(),*/
        "sell_qty": quantityController.text.toString(),
        "sell_qty_unit": priceUnitID,
        "price": priceController.text.toString(),
        "price_unit": priceUnitID,
        "with_logistic_partner": logisticPartnerFlag.toString(),
        "with_packging": packagingFlag.toString(),
        "packaging_master_id": packagingID.toString(),
        "step": "1",
        "season_from": seasonFromID,
        "season_to": seasonToID,
        "availability_from": availableFromController.text.toString(),
        "availability_to": availableToController.text.toString(),
        "status": "1"
      };
      if (productCategoryID == "2") {
        params = {
          "id": id,
          "user_id": HeaderSingleton().paramsMaps!.userId.toString(),
          "prod_cat_id": productCategoryID,
          "prod_type_id": productTypeID,
          "prod_id": productID,
          "prod_variety_id": productVarietyID,
          "active_till_date": activeDateController.text.toString(),
          "surplus": marketableController.text.toString(),
          "surplus_unit": marketableUnitID,
          /* "other_details": otherDetails.toString(),*/
          "sell_qty": quantityController.text.toString(),
          "sell_qty_unit": priceUnitID,
          "price": priceController.text.toString(),
          "price_unit": priceUnitID,
          "with_logistic_partner": logisticPartnerFlag.toString(),
          "with_packging": packagingFlag.toString(),
          "packaging_master_id": packagingID.toString(),
          "prod_details": _value.toString(),
          "step": "1",
          "availability_from": availableFromController.text.toString(),
          "availability_to": availableToController.text.toString(),
          "yield_from": expectedYieldFromController.text.toString(),
          "yield_from_unit": expectedYieldFromUnitID,
          "yield_to": expectedYieldToController.text.toString(),
          "yield_to_unit": expectedYieldToUnitID,
          "status": status
        };
      }
      final response = await APIService.postAPIMethod(url: ApiURL.addTradeProduct, params: params);
      final data = json.decode(response.body);
      final res = AddProductResponse.fromJson(data);
      if (res.success == 1) {
        var loanModel = Provider.of<MasterProvider>(context, listen: false);
        loanModel.setProductCurrentIndex(2);
        loanModel.setItemId(res.data.toString());
        widget.onPressed(2);
        WidgetUtils.successDialog(context, res.message);
      } else {
        WidgetUtils.errorDialog(context, res.message);
      }
      setState(() {});
    } catch (e) {
      WidgetUtils.errorDialog(context, e.toString());
      setState(() {});
    }
  }
}
