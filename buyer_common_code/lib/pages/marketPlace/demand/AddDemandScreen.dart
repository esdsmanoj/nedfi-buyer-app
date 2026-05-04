import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app_imports.dart';
import '../../../components/month_picker_dialog/month_picker_dialog.dart';
import '../../../model/NedfiProductType.dart';
import '../../../model/NedfiProductVariety.dart';
import '../../../model/ProductType.dart';
import '../../../model/master_listing_model.dart';
import '../../../providers/master_provider.dart';

class AddDemandScreen extends StatefulWidget {
  const AddDemandScreen({super.key});

  @override
  State<AddDemandScreen> createState() => _AddDemandScreenState();
}

class _AddDemandScreenState extends State<AddDemandScreen> {
  TextEditingController productCategoryController = TextEditingController(),
      productTypeController = TextEditingController(),
      productController = TextEditingController(),
      productVarietyController = TextEditingController(),
      priceRangeTo = TextEditingController(),
      priceRangeFrom = TextEditingController(),
      fromDateController = TextEditingController(),
      toDateController = TextEditingController(),
      quantity = TextEditingController(),
      priceUnitController = TextEditingController();
  var _value = 0, _value2 = 0;
  String productCategoryID = "", priceUnitID = "";
  int activeDateCount = 0;
  String productTypeID = "", productID = "", productVarietyID = "", packagingID = "";
  bool seasonFlag = false, upcomingFlag = false;

  Future getProductType() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.productType);
      final data = json.decode(response.body);
      final res = ProductType.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setProductTypeData(res.data ?? []);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  Future getMasterList() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getMasterListing);
      final data = json.decode(response.body);
      final res = MasterListing.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setMasterData(res.data!);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getMasterList();
    getProductType();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold( backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          title: WidgetUtils.appTextWidget(context: context, title: 'Add Demand'.tr, color: Colors.white, fontSize: 18),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Consumer<MasterProvider>(builder: (context, masterProvider, child) {
          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 10, top: 10, right: 10),
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                WidgetUtils.appTextWidget(context: context, title: 'Demand Type'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                SizedBox(
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
                                      groupValue: _value2,
                                      activeColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                                      onChanged: (int? value) {
                                        setState(() {
                                          _value2 = value!;
                                          productCategoryController.text = "";
                                          productCategoryID = "";
                                        });
                                      },
                                    ),
                                    Text(
                                      i == 1 ? 'Immediate'.tr : 'Future'.tr,
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
                ),
                const SizedBox(height: 10),
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
                      if (_value2 == 0) {
                        WidgetUtils.errorDialog(context, "Please Select Demand Type".tr);
                      } else {
                        showProductCategory(context);
                      }
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
                _value2 == 1
                    ? Container()
                    : SizedBox(
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
                                      // width: 150,
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
                      ),
                _value2 == 1 ? Container() : const SizedBox(height: 08),
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
                      width: (MediaQuery.of(context).size.width) - 20,
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
                  ],
                ),
                const SizedBox(height: 08),
                Container(
                  width: double.maxFinite,
                  height: 58,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                  // margin: const EdgeInsets.only(right: 16),
                  child:    TextField(
                    controller:quantity ,
                    keyboardType: TextInputType.number,
                      maxLength: 7,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintText: 'Quantity'.tr,
                        border: InputBorder.none,
                        counterText: "",
                      ),
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    ),
                ),
                const SizedBox(height: 10),
                _value2 == 1 ? Container() : WidgetUtils.appTextWidget(context: context, title: 'Availability'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                _value2 == 1 ? Container() : const SizedBox(height: 08),
                _value2 == 1
                    ? Container()
                    : Row(
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
                                dialogSelectDateAvlaible("from");
                              },
                              controller: fromDateController,
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintText: 'From'.tr,
                                  border: InputBorder.none,
                                  counterText: "",
                                  suffixIcon: Icon(Icons.calendar_month_outlined, color: Color(int.parse(themeColor.value.buttonColor!.color!)))),
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: (MediaQuery.of(context).size.width / 2) - 15,
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              onTap: () {
                                dialogSelectDateAvlaible("to");
                              },
                              controller: toDateController,
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintText: 'To'.tr,
                                  border: InputBorder.none,
                                  counterText: "",
                                  suffixIcon: Icon(Icons.calendar_month_outlined, color: Color(int.parse(themeColor.value.buttonColor!.color!)))),
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                _value2 == 1 ? Container() : const SizedBox(height: 10),
                WidgetUtils.appTextWidget(context: context, title: 'Price (₹)'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                const SizedBox(height: 08),
                Row(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width / 2) - 15,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Container(
                            width: ((MediaQuery.of(context).size.width / 2) * 0.65),
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller:priceRangeFrom ,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                hintText: 'Min'.tr,
                                border: InputBorder.none,
                                counterText: "",
                              ),
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            height: 58,
                            width: 1,
                          ),
                          Container(
                            width: ((MediaQuery.of(context).size.width / 2) * 0.25),
                            height: 58,
                            alignment: Alignment.center,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintText: '₹'.tr,
                                  counterText: "",
                                  border: InputBorder.none),
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width / 2) - 15,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Container(
                            width: ((MediaQuery.of(context).size.width / 2) * 0.65),
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller: priceRangeTo,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                hintText: 'Max'.tr,
                                border: InputBorder.none,
                                counterText: "",
                              ),
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            height: 58,
                            width: 1,
                          ),
                          Container(
                            width: ((MediaQuery.of(context).size.width / 2) * 0.25),
                            height: 58,
                            alignment: Alignment.center,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                  hintText: '₹'.tr,
                                  counterText: "",
                                  border: InputBorder.none),
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                WidgetUtils.appTextWidget(context: context, title: 'Unit'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                const SizedBox(height: 08),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width) - 22,
                        height: 58,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          onTap: () {
                            showUnit(context, "marketable");
                          },
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
                const SizedBox(height: 20),
                WidgetUtils.buttonWidget(
                    context: context,
                    radius: 8,
                    title: 'Add demand'.tr,
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
        }),
      );
    });
  }

  submit() {
    if (_value2 == 0) {
      WidgetUtils.errorDialog(context, 'Please Select Demand Type'.tr);
    } else if (_value2 == 1) {
      if (productCategoryController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Product Category'.tr);
      } else if (productTypeController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Product Type'.tr);
      } else if (productController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Product'.tr);
      } else if (productVarietyController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Product Variety'.tr);
      } else if (productVarietyController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Product Variety'.tr);
      } else if (priceRangeFrom.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Price Range Min'.tr);
      } else if (priceRangeTo.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Price Range Max'.tr);
      } else if (double.parse(priceRangeFrom.text.toString()) > double.parse(priceRangeTo.text.toString())) {
        WidgetUtils.errorDialog(context, 'Min Price Range should be less then Max Price Range'.tr);
      } else if (priceUnitController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select unit'.tr);
      } else {
        addDemand();
      }
    } else if (_value2 == 2) {
      if (productCategoryController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Product Category'.tr);
      } else if (productTypeController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Product Type'.tr);
      } else if (_value == 0) {
        WidgetUtils.errorDialog(context, 'Please Select Product'.tr);
      } else if (productController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Product'.tr);
      } else if (productVarietyController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Product Variety'.tr);
      } else if (productVarietyController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Product Variety'.tr);
      }  else if (quantity.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Quantity'.tr);
      } else if (fromDateController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Available From Date'.tr);
      } else if (toDateController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select Available To date'.tr);
      } else if (priceRangeFrom.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Price Range Min'.tr);
      } else if (priceRangeTo.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Enter Price Range Max'.tr);
      } else if (double.parse(priceRangeFrom.text.toString()) > double.parse(priceRangeTo.text.toString())) {
        WidgetUtils.errorDialog(context, 'Min Price Range should be less then Max Price Range'.tr);
      } else if (priceUnitController.text.toString().isEmpty) {
        WidgetUtils.errorDialog(context, 'Please Select unit'.tr);
      } else {
        addDemand();
      }
    }
  }

  void showProductCategory(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          var dssModel = [];
          if (_value2 == 1) {
            var dssM = Provider.of<MasterProvider>(context, listen: true).masterData?.productCategory ?? [];
            dssModel.add(dssM[0]);
            dssModel.add(dssM[2]);
          } else {
            var dssM = Provider.of<MasterProvider>(context, listen: true).masterData?.productCategory ?? [];
            dssModel.add(dssM[1]);
          }

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
                                        productCategoryController.text = dssModel[index].title ?? "";
                                        productCategoryID = dssModel[index].id.toString();
                                        activeDateCount = dssModel[index].days ?? 0;
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
          final dssModel = Provider.of<MasterProvider>(context, listen: true).productTypeList;
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
          final dssModel = Provider.of<MasterProvider>(context, listen: true).productList;
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
                                                productController.text = dssModel[index].title ?? "";
                                                productID = dssModel[index].id ?? "";
                                                productVarietyController.text = "";
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
          final dssModel = Provider.of<MasterProvider>(context, listen: true).productVarietyList;
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
                                                productVarietyController.text = dssModel[index].title ?? "";
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

  Future addDemand() async {
    try {
      var param;
      if(avaliableToDate!=null) {
        String formattedDateTO = DateFormat('yyyy-MM-dd hh:mm:ss').format(
            avaliableToDate!);
        String formattedDateFrom = DateFormat('yyyy-MM-dd hh:mm:ss').format(
            avaliableFromDate!);
         param = {
          "buyer_id": HeaderSingleton().paramsMaps!.userId,
          'product_id': productID,
          'prod_cat_id': productCategoryID,
          'prod_type_id': productTypeID,
          'prod_variety_id': productVarietyID,
          'price_from': priceRangeFrom.text.toString(),
          'price_to': priceRangeTo.text.toString(),
          'price_unit': priceUnitID,
          'demand_type': (_value2).toString(),
          'prod_detail': (_value).toString(),
          'available_from': formattedDateFrom ?? "",
          'available_to': formattedDateTO ?? "",
           'quantity':quantity
        };
      }else{
        param = {
          "buyer_id": HeaderSingleton().paramsMaps!.userId,
          'product_id': productID,
          'prod_cat_id': productCategoryID,
          'prod_type_id': productTypeID,
          'prod_variety_id': productVarietyID,
          'price_from': priceRangeFrom.text.toString(),
          'price_to': priceRangeTo.text.toString(),
          'price_unit': priceUnitID,
          'demand_type': (_value2).toString(),
          'quantity':quantity
        };
      }
      final response = await APIService.postAPIMethod(url: ApiURL.addDemandProduct, params: param);
      final data = json.decode(response.body);
      print(data);
      final res = CommonModel.fromJson(data);
      if (res.status.toString() == "1") {
        WidgetUtils.successDialog(context, res.message);
        Navigator.pop(context);
      } else {
        WidgetUtils.errorDialog(context, res.message);
      }
    } catch (e) {
      print(e);
      setState(() {});
    }
  }

  DateTime? avaliableFromDate;
  DateTime? avaliableToDate;

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
        context: context,firstDate:DateTime.now() ,
        initialDate: DateTime.now(),
        headerColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
        headerTextColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
        selectedMonthTextColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
        selectedMonthBackgroundColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
        unselectedMonthTextColor: Colors.black,
        confirmWidget: Text(
          "OK".tr,
          style: TextStyle(color: Color(int.parse(themeColor.value.buttonColor!.color!))),
        ),
        cancelWidget: Text(
          "CANCEL".tr,
          style: TextStyle(color: Color(int.parse(themeColor.value.buttonColor!.color!))),
        )).then((date) {
      if (date != null) {
        setState(() {
          String formattedDate = DateFormat('MMM-yyyy').format(date);
          if (type == "from") {
            avaliableFromDate = date;
            fromDateController.text = formattedDate;
          } else {
            //print("avaliableFromDate!.compareTo(date)");
            //print(date.compareTo(avaliableFromDate!));
            if (date.compareTo(avaliableFromDate!) >= 0) {
              avaliableToDate = date;
              toDateController.text = formattedDate;
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

  Future dialogSelectDate(String type) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime(DateTime.now().year),
      firstDate: DateTime(DateTime.now().year - 5),
      //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.light(primary: Color(int.parse(themeColor.value.buttonColor!.color!)), onPrimary: Color(int.parse(themeColor.value.buttonTextColor!.color!)), onSurface: Colors.black87),
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
      String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(pickedDate);
      setState(() {
        if (type == "from") {
          fromDateController.text = formattedDate;
        } else {
          toDateController.text = formattedDate;
        }
      });
    } else {}
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
                                                priceUnitController.text = dssModel[index].title ?? "";
                                                priceUnitID = dssModel[index].id.toString();
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
}
