import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../../../app_imports.dart';
import '../../../../components/widgets/AnimatedToggle.dart';
import '../../../../model/CityResponse.dart';
import '../../../../model/NedfiProductType.dart';
import '../../../../model/NedfiProductVariety.dart';
import '../../../../model/StateResponse.dart';
import '../../../../model/trade_product_info.dart';
import '../../../../providers/master_provider.dart';
import '../../../../model/AddProductResponse.dart';


class AddProductStepTwoScreen extends StatefulWidget {
  String? id;
  final ValueChanged onPressed;
  AddProductStepTwoScreen({this.id,required this.onPressed});

  @override
  State<AddProductStepTwoScreen> createState() => _AddProductStepTwoScreenState();
}

class _AddProductStepTwoScreenState extends State<AddProductStepTwoScreen> {
  TextEditingController? storageController=TextEditingController();
  TextEditingController? pickupLoacationController=TextEditingController();
  TextEditingController? railwayStationController=TextEditingController();
  TextEditingController? airpoertController=TextEditingController();
  TextEditingController? postOfficeController=TextEditingController();
  TextEditingController? godownController=TextEditingController();
  TextEditingController? nationalHighwayController=TextEditingController();
  TextEditingController? stateHighwayController=TextEditingController();
  TextEditingController? locationProduceHighwayController=TextEditingController();
  TextEditingController? paymentTypeController=TextEditingController();
  TextEditingController? stateController=TextEditingController();
  TextEditingController? districtController=TextEditingController();
  TextEditingController? paymentAmountController=TextEditingController();

  bool packaging_flag=false;
  bool logisticPartner_flag=false;
  int negotiable_flag=1;
  int certifications_flag=1;
  String storageID="";
  String paymentID="";
  String stateID="";
  String district="";
  String id="";
  late var masterProvider ;

  @override
  void initState() {
    super.initState();
    getStoreage();
    getState();
    masterProvider = Provider.of<MasterProvider>(context, listen: false);
    if(masterProvider.type=="EDIT") {
      id = masterProvider.treadProductCurrent!.id ?? "";
      getProductList();
    }else{
      id=masterProvider.itemId;
      getProductList();
    }
  }

  Future getProductList() async {
    try {
      var param={"user_id":HeaderSingleton().paramsMaps!.userId,
        "id":id};
      final response = await APIService.postAPIMethod(url: ApiURL.getTradeProducts, params: param);
      final data = json.decode(response.body);
      final res = TradeProductInfo.fromJson(data);
      if (res.success == 1) {
        if(res.data!=null) {
          var masterProvider = Provider.of<MasterProvider>(
              context, listen: false);
          masterProvider.setCurrentTreadProduct(res.data![0]);
          masterProvider.setType("EDIT"??"");
          masterProvider.setItemId(id??"");
          if(masterProvider.type=="EDIT"){
            id=masterProvider.treadProductCurrent!.id??"";

            storageController!.text=masterProvider.treadProductCurrent!.storageTypeTitle;
            pickupLoacationController!.text=masterProvider.treadProductCurrent!.pickupLocation;
            railwayStationController!.text=masterProvider.treadProductCurrent!.otherDistance!.railway??"";
            airpoertController!.text=masterProvider.treadProductCurrent!.otherDistance!.airport??"";
            postOfficeController!.text=masterProvider.treadProductCurrent!.otherDistance!.postOffice??"";
            godownController!.text=masterProvider.treadProductCurrent!.otherDistance!.godown??"";
            nationalHighwayController!.text=masterProvider.treadProductCurrent!.otherDistance!.nationalHighway??"";
            stateHighwayController!.text=masterProvider.treadProductCurrent!.otherDistance!.stateHighway??"";
            locationProduceHighwayController!.text=masterProvider.treadProductCurrent!.produceToHighwayDistance??"";
            paymentTypeController!.text=masterProvider.treadProductCurrent!.advancePayment??"";
            stateController!.text=masterProvider.treadProductCurrent!.stateName??"";
            districtController!.text=masterProvider.treadProductCurrent!.cityName??"";
            paymentAmountController!.text=masterProvider.treadProductCurrent!.advancePayment??"";
            storageID=masterProvider.treadProductCurrent!.storageTypeId;
            stateID=masterProvider.treadProductCurrent!.stateId;
            district=masterProvider.treadProductCurrent!.cityId;
            final value = await HelperUtils().getCity(stateID, (value) {}, context);
            var loanModel = Provider.of<LoanProvider>(context, listen: false);
            loanModel.setCity(value!);
            if(masterProvider.treadProductCurrent!.negotiations=="t"){
              negotiable_flag=0;
            }else{
              negotiable_flag=1;
            }

            if(masterProvider.treadProductCurrent!.certifcations=="t"){
              certifications_flag=0;
            }else{
              certifications_flag=1;
            }
            //print(masterProvider.treadProductCurrent!.negotiations);
            //print(negotiable_flag.toString());
            setState(() {

            });
          }
        }
      }
    } catch (e) {
      //print(e);
      setState(() {});
    }
  }


  getState() async {
    await HelperUtils().getState( (value) {}, context);
  }

  @override
  Widget build(BuildContext context) {
    return  KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery
                .of(context)
                .size
                .height - 170,
            child: ListView(
              children: [
                const SizedBox(height: 10),
                WidgetUtils.appTextWidget(context: context,
                    title: 'Other Details'.tr,
                    fontWeight: FontWeight.w500,
                    family: 'Graphik',
                    fontSize: 20,
                    color: Color(int.parse(themeColor.value.barColor!.color!))),
                const SizedBox(height: 20),
                WidgetUtils.appTextWidget(context: context,
                    title: 'Storage Type'.tr,
                    fontWeight: FontWeight.w500,
                    family: 'Graphik',
                    fontSize: 16),
                const SizedBox(height: 08),
                Container(
                  width: double.maxFinite,
                  height: 58,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4)),
                  // margin: const EdgeInsets.only(right: 16),
                  child: TextField(
                    onTap: () {
                      showStorageType(context);
                    },
                    controller: storageController,
                    keyboardType: TextInputType.text,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'Graphik',
                            fontWeight: FontWeight.w400),
                        hintStyle: const TextStyle(color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'Graphik',
                            fontWeight: FontWeight.w400),
                        hintText: 'Select Storage Type'.tr,
                        border: InputBorder.none,
                        counterText: "",
                        suffixIcon: Icon(Icons.keyboard_arrow_down, color:Colors.grey)),
                    style: const TextStyle(color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Graphik',
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 10),
                WidgetUtils.appTextWidget(context: context,
                    title: 'Pickup Location'.tr,
                    fontWeight: FontWeight.w500,
                    family: 'Graphik',
                    fontSize: 16),
                const SizedBox(height: 08),
                Container(
                  width: double.maxFinite,
                  height: 58,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4)),
                  // margin: const EdgeInsets.only(right: 16),
                  child: TextField(
                    controller: pickupLoacationController,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    maxLength: 100,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey,
                          fontSize: 16,
                          fontFamily: 'Graphik',
                          fontWeight: FontWeight.w400),
                      hintStyle: const TextStyle(color: Colors.grey,
                          fontSize: 16,
                          fontFamily: 'Graphik',
                          fontWeight: FontWeight.w400),
                      hintText: 'Enter Pickup Location'.tr,
                      border: InputBorder.none,
                      counterText: "",),
                    style: const TextStyle(color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Graphik',
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 08),
                Row(
                  children: [
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)),
                      // margin: const EdgeInsets.only(right: 16),
                      child: TextField(
                        onTap: () {
                          showStateFilter(context);
                        },
                        controller: stateController,
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.grey,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintStyle: const TextStyle(color: Colors.grey,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintText: 'State'.tr,
                            border: InputBorder.none,
                            counterText: "",
                            suffixIcon: Icon(Icons.keyboard_arrow_down, color:Colors.grey)),
                        style: const TextStyle(color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Graphik',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)),
                      // margin: const EdgeInsets.only(right: 16),
                      child: TextField(
                        onTap: () {
                          if(stateID==""){
                            WidgetUtils.errorDialog(context, 'Please Select State'.tr);
                          }else{
                            showDistrictFilter(context);
                          }

                        },
                        controller: districtController,
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.grey,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintStyle: const TextStyle(color: Colors.grey,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintText: 'District'.tr,
                            border: InputBorder.none,
                            counterText: "",
                            suffixIcon: Icon(Icons.keyboard_arrow_down, color:Colors.grey)),
                        style: const TextStyle(color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Graphik',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                WidgetUtils.appTextWidget(context: context,
                    title: 'Distance from Pickup Location'.tr,
                    fontWeight: FontWeight.w500,
                    family: 'Graphik',
                    fontSize: 16),
                const SizedBox(height: 08),
                Row(
                  children: [
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)),
                      // margin: const EdgeInsets.only(right: 16),
                      child: TextField(

                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintStyle: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintText: 'Railway Station'.tr,
                            border: InputBorder.none,
                            counterText: ""),
                        style: const TextStyle(color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Graphik',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: ((MediaQuery
                                .of(context)
                                .size
                                .width/2) * 0.65),
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller: railwayStationController,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter'.tr,
                                border: InputBorder.none,
                                counterText: "",),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            height: 58,
                            width: 1,
                          ),
                          Container(
                            width: ((MediaQuery
                                .of(context)
                                .size
                                .width/2) * 0.25),
                            height: 58,
                            alignment: Alignment.center,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintText: 'KM'.tr,
                                  counterText: "",
                                  border: InputBorder.none),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 08),
                Row(
                  children: [
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)),
                      // margin: const EdgeInsets.only(right: 16),
                      child: TextField(

                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintStyle: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintText: 'Airport'.tr,
                            border: InputBorder.none,
                            counterText: ""),
                        style: const TextStyle(color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Graphik',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: ((MediaQuery
                                .of(context)
                                .size
                                .width/2) * 0.65),
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller: airpoertController,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter'.tr,
                                border: InputBorder.none,
                                counterText: "",),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            height: 58,
                            width: 1,
                          ),
                          Container(
                            width: ((MediaQuery
                                .of(context)
                                .size
                                .width/2) * 0.25),
                            height: 58,
                            alignment: Alignment.center,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintText: 'KM'.tr,
                                  counterText: "",
                                  border: InputBorder.none),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 08),
                Row(
                  children: [
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)),
                      // margin: const EdgeInsets.only(right: 16),
                      child: TextField(

                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintStyle: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintText: 'Post Office'.tr,
                            border: InputBorder.none,
                            counterText: ""),
                        style: const TextStyle(color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Graphik',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: ((MediaQuery
                                .of(context)
                                .size
                                .width/2) * 0.65),
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller: postOfficeController,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter'.tr,
                                border: InputBorder.none,
                                counterText: "",),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            height: 58,
                            width: 1,
                          ),
                          Container(
                            width: ((MediaQuery
                                .of(context)
                                .size
                                .width/2) * 0.25),
                            height: 58,
                            alignment: Alignment.center,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintText: 'KM'.tr,
                                  counterText: "",
                                  border: InputBorder.none),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 08),
                Row(
                  children: [
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)),
                      // margin: const EdgeInsets.only(right: 16),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintStyle: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintText: 'Godown/Storage'.tr,
                            border: InputBorder.none,
                            counterText: ""),
                        style: const TextStyle(color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Graphik',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: ((MediaQuery
                                .of(context)
                                .size
                                .width/2) * 0.65),
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller: godownController,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter'.tr,
                                border: InputBorder.none,
                                counterText: "",),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            height: 58,
                            width: 1,
                          ),
                          Container(
                            width: ((MediaQuery
                                .of(context)
                                .size
                                .width/2) * 0.25),
                            height: 58,
                            alignment: Alignment.center,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintText: 'KM'.tr,
                                  counterText: "",
                                  border: InputBorder.none),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 08),
                Row(
                  children: [
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)),
                      // margin: const EdgeInsets.only(right: 16),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintStyle: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintText: 'National Highway'.tr,
                            border: InputBorder.none,
                            counterText: ""),
                        style: const TextStyle(color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Graphik',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: ((MediaQuery
                                .of(context)
                                .size
                                .width/2) * 0.65),
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller: nationalHighwayController,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter'.tr,
                                border: InputBorder.none,
                                counterText: "",),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            height: 58,
                            width: 1,
                          ),
                          Container(
                            width: ((MediaQuery
                                .of(context)
                                .size
                                .width/2) * 0.25),
                            height: 58,
                            alignment: Alignment.center,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintText: 'KM'.tr,
                                  counterText: "",
                                  border: InputBorder.none),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 08),
                Row(
                  children: [
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)),
                      // margin: const EdgeInsets.only(right: 16),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintStyle: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintText: 'State Highway'.tr,
                            border: InputBorder.none,
                            counterText: ""),
                        style: const TextStyle(color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Graphik',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: (MediaQuery
                          .of(context)
                          .size
                          .width / 2) - 15,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: ((MediaQuery
                                .of(context)
                                .size
                                .width/2) * 0.65),
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller: stateHighwayController,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter'.tr,
                                border: InputBorder.none,
                                counterText: "",),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            height: 58,
                            width: 1,
                          ),
                          Container(
                            width: ((MediaQuery
                                .of(context)
                                .size
                                .width/2) * 0.25),
                            height: 58,
                            alignment: Alignment.center,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintText: 'KM'.tr,
                                  counterText: "",
                                  border: InputBorder.none),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                WidgetUtils.appTextWidget(context: context,
                    title: 'Location of Produce to Highway (Distance)'.tr,
                    fontWeight: FontWeight.w500,
                    family: 'Graphik',
                    fontSize: 16),
                const SizedBox(height: 08),
                Container(
                  width: double.maxFinite,
                  height: 58,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4)),
                  // margin: const EdgeInsets.only(right: 16),
                  child: TextField(
                    controller: locationProduceHighwayController,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey,
                          fontSize: 16,
                          fontFamily: 'Graphik',
                          fontWeight: FontWeight.w400),
                      hintStyle: const TextStyle(color: Colors.grey,
                          fontSize: 16,
                          fontFamily: 'Graphik',
                          fontWeight: FontWeight.w400),
                      hintText: 'Enter'.tr,
                      border: InputBorder.none,
                      counterText: "",),
                    style: const TextStyle(color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Graphik',
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 10),
                WidgetUtils.appTextWidget(context: context,
                    title: 'Advance Payment (%)'.tr,
                    fontWeight: FontWeight.w500,
                    family: 'Graphik',
                    fontSize: 16),
                const SizedBox(height: 08),
                Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)),
                      // margin: const EdgeInsets.only(right: 16),
                      child: TextField(
                        onTap: () {
                          showPaymentType(context);
                        },
                        controller: paymentTypeController,
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.grey,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintStyle: const TextStyle(color: Colors.grey,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                            hintText: 'Select Payment Type'.tr,
                            border: InputBorder.none,
                            counterText: "",
                            suffixIcon: Icon(Icons.keyboard_arrow_down, color:Colors.grey)),
                        style: const TextStyle(color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Graphik',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 10),
                    paymentTypeController!.text.toLowerCase()!="other"?Container():Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: (MediaQuery
                                .of(context)
                                .size
                                .width * 0.60),
                            height: 58,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            // margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller: paymentAmountController,
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter'.tr,
                                border: InputBorder.none,
                                counterText: "",),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            height: 58,
                            width: 1,
                          ),
                          Container(
                            width: (MediaQuery
                                .of(context)
                                .size
                                .width * 0.30),
                            height: 58,
                            alignment: Alignment.center,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintStyle: const TextStyle(color: Colors.grey,
                                      fontSize: 16,
                                      fontFamily: 'Graphik',
                                      fontWeight: FontWeight.w400),
                                  hintText: '%'.tr,
                                  counterText: "",
                                  border: InputBorder.none),
                              style: const TextStyle(color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Graphik',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WidgetUtils.appTextWidget(context: context,
                        title: 'Negotiable?'.tr,
                        fontWeight: FontWeight.w500,
                        family: 'Graphik',
                        fontSize: 16),
                    Container(
                      width: (MediaQuery.of(context).size.width/2)-20,
                      child: AnimatedToggle(
                        initialPosition: negotiable_flag,
                        values: ['Yes'.tr, 'No'.tr],
                        onToggleCallback: (value) {
                          setState(() {
                            negotiable_flag = value;
                          });
                        },
                        buttonColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                        backgroundColor: const Color(0xFFFFFFFF),
                        textColor: const Color(0xFFFFFFFF),
                        borderColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WidgetUtils.appTextWidget(context: context,
                        title: 'Quality Certifications'.tr,
                        fontWeight: FontWeight.w500,
                        family: 'Graphik',
                        fontSize: 16),
                    Container(
                      width: (MediaQuery.of(context).size.width/2)-20,
                      child: AnimatedToggle(
                        initialPosition: certifications_flag,
                        values: ['Yes'.tr, 'No'.tr],
                        onToggleCallback: (value) {
                          setState(() {
                            certifications_flag = value;
                          });
                        },
                        buttonColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                        backgroundColor: const Color(0xFFFFFFFF),
                        textColor: const Color(0xFFFFFFFF),
                        borderColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                      ),
                    ),
                  ],
                ),
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
                    textColor: Color(
                        int.parse(themeColor.value.buttonTextColor!.color!)),
                    color: Color(int.parse(themeColor.value.buttonColor!.color!))),
                isKeyboardVisible? const SizedBox(height: 400): const SizedBox(height: 20)
              ],
            ),
          );
        });

  }

  void showStorageType(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider
              .of<MasterProvider>(context, listen: true)
              .storageList ?? [];
          return StatefulBuilder(builder: (ctx, StateSetter setStates) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 400,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context,
                                  title: 'Select Product Category'.tr,
                                  color: Colors.black,
                                  fontSize: 18,
                                  family: 'Graphik',
                                  fontWeight: FontWeight.w500),
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
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.4, // Change as per your requirement
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.6,
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.5, // Change as per your requirement
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.6,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dssModel.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        storageController!.text = dssModel[index].title ?? "";
                                        storageID = dssModel[index].id.toString();
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: WidgetUtils.appTextWidget(
                                          context: context,
                                          title: dssModel[index].title ?? "",
                                          fontSize: 16,
                                          family: 'Graphik'),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          border: Border.all(width: 1,
                                              color: Colors.grey.shade300)),
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


  void showPaymentType(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider
              .of<MasterProvider>(context, listen: true)
              .masterData?.productPayment ?? [];
          return StatefulBuilder(builder: (ctx, StateSetter setStates) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 400,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context,
                                  title: 'Select Payment Type'.tr,
                                  color: Colors.black,
                                  fontSize: 18,
                                  family: 'Graphik',
                                  fontWeight: FontWeight.w500),
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
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.4, // Change as per your requirement
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.6,
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.5, // Change as per your requirement
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.6,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dssModel.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        paymentTypeController!.text =
                                            dssModel[index].title ?? "";
                                        if(paymentTypeController!.text.toLowerCase()=="other"){
                                          paymentAmountController!.text= "";
                                        }else {
                                          paymentAmountController!.text =
                                              dssModel[index].title ?? "";
                                        }
                                        paymentID = dssModel[index].id.toString();

                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: WidgetUtils.appTextWidget(
                                          context: context,
                                          title: dssModel[index].title ?? "",
                                          fontSize: 16,
                                          family: 'Graphik'),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          border: Border.all(width: 1,
                                              color: Colors.grey.shade300)),
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


  Future getStoreage() async {
    try {
      final response = await APIService.getAPIMethod(
          url: ApiURL.storageType);
      final data = json.decode(response.body);
      final res = NedfiProductVariety.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(
              context, listen: false);
          masterProvider.setStorageData(res.data ?? []);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  TextEditingController controller = TextEditingController();
  TextEditingController controllerOne = TextEditingController();

  List<StateData> _searchResult = [];

  List<CityData> _searchResultOne = [];

  void showStateFilter(BuildContext context) {
    var loanModel = Provider.of<LoanProvider>(context, listen: false);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<LoanProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
                return StatefulBuilder(builder: (context, StateSetter setState) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5, // Change as per your requirement
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetUtils.appTextWidget(context: context,
                                      title: 'Select State'.tr,
                                      color: Colors.black,
                                      fontSize: 18,
                                      family: 'Graphik',
                                      fontWeight: FontWeight.w500),
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        "assets/images/cross.svg",
                                        height: 20,
                                      ))
                                ],
                              )),
                          Card(
                            child: ListTile(
                                dense: true,
                                leading: const Icon(Icons.search),
                                title: TextField(
                                  controller: controller,
                                  decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                                  onChanged: (text) {
                                    _searchResult.clear();
                                    if (text.isEmpty) {
                                      setState(() {});
                                      return;
                                    }
                                    for (var userDetail in loanModel.stateList) {
                                      if (userDetail.name.toUpperCase().contains(text.toUpperCase())) _searchResult.add(userDetail);
                                    }

                                    setState(() {});
                                  },
                                ),
                                trailing: InkWell(
                                    child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                    onTap: () {
                                      controller.clear();
                                      _searchResult.clear();
                                      if ("".isEmpty) {
                                        setState(() {});
                                        return;
                                      }
                                      for (var userDetail in loanModel.stateList) {
                                        if (userDetail.name.contains("")) _searchResult.add(userDetail);
                                      }
                                      setState(() {});
                                    })),
                          ),
                          SizedBox(
                            height: 350.0, // Change as per your requirement
                            width: 550.0,
                            child: _searchResult.isNotEmpty || controller.text.isNotEmpty
                                ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResult.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);

                                      stateController!.text = _searchResult[index].name;
                                      stateID = _searchResult[index].id;
                                      final value = await HelperUtils().getCity(_searchResult[index].id, (value) {}, context);
                                      loanModel.setCity(value!);
                                      districtController!.text="";
                                      district="";
                                    },
                                    child: Card(
                                      elevation: 0,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                child: Container(
                                                  width:MediaQuery.of(context).size.width-20 ,
                                                  height: 40,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 5, vertical: 10),
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          4),
                                                      border: Border.all(width: 1,
                                                          color: Colors.grey.shade300)),
                                                  child: Text(
                                                    _searchResult[index].name,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 16.0),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ]),
                                    ));
                              },
                            )
                                : ListView.builder(
                              shrinkWrap: true,
                              itemCount: loanModel.stateList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      var loanModel = Provider.of<LoanProvider>(context, listen: false);
                                      stateController!.text = loanModel.stateList[index].name;
                                      final value = await HelperUtils().getCity(loanModel.stateList[index].id, (value) {}, context);
                                      loanModel.setCity(value!);
                                      districtController!.text ="";
                                      district = "";

                                      stateID = loanModel.stateList[index].id;

                                    },
                                    child: Card(
                                      elevation: 0,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                child: Container(
                                                  width:MediaQuery.of(context).size.width-20 ,
                                                  height: 40,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 5, vertical: 10),
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          4),
                                                      border: Border.all(width: 1,
                                                          color: Colors.grey.shade300)),
                                                  child: Text(
                                                    loanModel.stateList[index].name,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 16.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ));
                              },
                            ),
                          ),
                        ]),
                      ));
                });
              });
        });
  }

  void showDistrictFilter(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<LoanProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
                return StatefulBuilder(builder: (context, StateSetter setState) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5, // Change as per your requirement
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetUtils.appTextWidget(context: context,
                                      title: 'Select District'.tr,
                                      color: Colors.black,
                                      fontSize: 18,
                                      family: 'Graphik',
                                      fontWeight: FontWeight.w500),
                                  InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        "assets/images/cross.svg",
                                        height: 20,
                                      ))
                                ],
                              )),
                          Card(
                            child: ListTile(
                                dense: true,
                                leading: const Icon(Icons.search),
                                title: TextField(
                                  controller: controllerOne,
                                  decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                                  onChanged: (text) {
                                    _searchResultOne.clear();
                                    if (text.isEmpty) {
                                      setState(() {});
                                      return;
                                    }
                                    for (var userDetail in loanModel.cityList) {
                                      if (userDetail.name.toUpperCase().contains(text.toUpperCase()) || userDetail.name.toLowerCase().contains(text.toLowerCase())) _searchResultOne.add(userDetail);
                                    }

                                    setState(() {});
                                  },
                                ),
                                trailing: InkWell(
                                    child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                    onTap: () {
                                      controllerOne.clear();
                                      _searchResultOne.clear();
                                      if ("".isEmpty) {
                                        setState(() {});
                                        return;
                                      }
                                      for (var userDetail in loanModel.cityList) {
                                        if (userDetail.name.contains("")) _searchResultOne.add(userDetail);
                                      }
                                      setState(() {});
                                    })),
                          ),
                          SizedBox(
                            height: 350.0, // Change as per your requirement
                            width: 550.0,
                            child: _searchResultOne.isNotEmpty || controllerOne.text.isNotEmpty
                                ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResultOne.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        districtController!.text = _searchResultOne[index].name;
                                        district = _searchResultOne[index].id;

                                      });
                                    },
                                    child: Card(
                                      elevation: 0,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                child: Container(
                                                  width:MediaQuery.of(context).size.width-20 ,
                                                  height: 40,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 5, vertical: 10),
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          4),
                                                      border: Border.all(width: 1,
                                                          color: Colors.grey.shade300)),
                                                  child: WidgetUtils.appTextWidget(
                                                      context: context, title: _searchResultOne[index].name, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, fontSize: 16.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ));
                              },
                            )
                                : ListView.builder(
                              shrinkWrap: true,
                              itemCount: loanModel.cityList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        districtController!.text = loanModel.cityList[index].name;
                                        district = loanModel.cityList[index].id;
                                      });
                                    },
                                    child: Card(
                                      elevation: 0,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                child: Container(
                                                  width:MediaQuery.of(context).size.width-20 ,
                                                  height: 40,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 5, vertical: 10),
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          4),
                                                      border: Border.all(width: 1,
                                                          color: Colors.grey.shade300)),
                                                  child: Text(
                                                    loanModel.cityList[index].name,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 16.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ));
                              },
                            ),
                          ),
                        ]),
                      ));
                });
              });
        });
  }

  submit(){
    if(storageController!.text.toString().isEmpty){
      WidgetUtils.errorDialog(context, 'Please Select Storage Type'.tr);
    }else if(pickupLoacationController!.text.toString().isEmpty){
      WidgetUtils.errorDialog(context, 'Please Enter Pickup Location'.tr);
    }else if(stateController!.text.toString().isEmpty){
      WidgetUtils.errorDialog(context, 'Please Select State'.tr);
    }else if(districtController!.text.toString().isEmpty){
      WidgetUtils.errorDialog(context, 'Please Select District'.tr);
    }else if(railwayStationController!.text.toString().isEmpty){
      WidgetUtils.errorDialog(context, 'Please Enter Railway Station Distance'.tr);
    }else if(airpoertController!.text.toString().isEmpty){
      WidgetUtils.errorDialog(context, 'Please Enter Airport Distance'.tr);
    } else if(postOfficeController!.text.toString().isEmpty){
      WidgetUtils.errorDialog(context, 'Please Enter Post Office Distance'.tr);
    }else if(godownController!.text.toString().isEmpty){
      WidgetUtils.errorDialog(context, 'Please Enter Godown Distance'.tr);
    }else if(nationalHighwayController!.text.toString().isEmpty){
      WidgetUtils.errorDialog(context, 'Please Enter National Highway Distance'.tr);
    }else if(stateHighwayController!.text.toString().isEmpty){
      WidgetUtils.errorDialog(context, 'Please Enter State Highway Distance'.tr);
    } else if(locationProduceHighwayController!.text.toString().isEmpty){
      WidgetUtils.errorDialog(context, 'Please Enter Produce To Highway Distance'.tr);
    }else {
      if(paymentTypeController!.text.isEmpty){
        WidgetUtils.errorDialog(context, 'Please Select Payment %'.tr);
      }else if(paymentTypeController!.text.toLowerCase()=="other"){
        if(paymentAmountController!.text.toString().isEmpty){
          WidgetUtils.errorDialog(context, 'Please Enter Payment %'.tr);
        }else{
          addProduct();
        }
      }else{
        addProduct();
      }


    }
    setState(() {});
  }

  addProduct() async {
    try {
      var otherDetails={
        "railway":railwayStationController!.text.toString(),
        "airport":airpoertController!.text.toString(),
        "post_office":postOfficeController!.text.toString(),
        "godown":godownController!.text.toString(),
        "national_highway":nationalHighwayController!.text.toString(),
        "state_railway":stateHighwayController!.text.toString()
      };
      var params={
        "id":id,
        "storage_type_id":storageID,
        "state":stateID,
        "city":district ,
        "pickup_location":pickupLoacationController!.text.toString() ,
        /*"other_distance":otherDetails ,*/
        "produce_to_highway_distance":locationProduceHighwayController!.text.toString() ,
        "advance_payment":paymentAmountController!.text.toString() ,
        "negotiations":negotiable_flag==0?"true":"false" ,
        "certifcations": certifications_flag==0?"true":"false",
        "step":"2", "railway":railwayStationController!.text.toString(),
        "airport":airpoertController!.text.toString(),
        "post_office":postOfficeController!.text.toString(),
        "godown":godownController!.text.toString(),
        "national_highway":nationalHighwayController!.text.toString(),
        "state_highway":stateHighwayController!.text.toString()};
      final response = await APIService.postAPIMethod(
          url: ApiURL.addTradeProduct, params: params);
      final data = json.decode(response.body);
      //print(data);
      final res = AddProductResponse.fromJson(data);
      if (res.success == 1) {
        var loanModel = Provider.of<MasterProvider>(context, listen: false);
        loanModel.setProductCurrentIndex(3);
        loanModel.setItemId(res.data??"");
        widget.onPressed(3);
        WidgetUtils.successDialog(context, res.message??"");
      }else{
        WidgetUtils.errorDialog(context, res.message??"");
      }
      setState(() {});
    } catch (e) {
      //print(e);
      setState(() {});
    }

  }

}
