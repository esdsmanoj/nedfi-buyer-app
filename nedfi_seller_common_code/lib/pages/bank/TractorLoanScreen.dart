import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/app_imports.dart';

class TractorLoanScreen extends StatefulWidget {
  const TractorLoanScreen({Key? key}) : super(key: key);

  @override
  _TractorLoanScreenState createState() => _TractorLoanScreenState();
}

class _TractorLoanScreenState extends State<TractorLoanScreen> {
  TextEditingController? tractorCompanyController,
      tractorModelController,
      exShowroomPriceController,
      insurancechargesController,
      costOfAccessoriesController,
      loanAmountController,
      horsePowerController;

  @override
  void initState() {
    super.initState();
    tractorCompanyController = TextEditingController();
    tractorModelController = TextEditingController();
    exShowroomPriceController = TextEditingController();
    insurancechargesController = TextEditingController();

    costOfAccessoriesController = TextEditingController();
    loanAmountController = TextEditingController();
    horsePowerController = TextEditingController();
    getDetails();
  }

  Future getDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      setState(() {
        tractorCompanyController!.text = loanModel.tractorCompany;
        tractorModelController!.text = loanModel.tractorModel;
        exShowroomPriceController!.text = loanModel.exShowroomPrice;
        insurancechargesController!.text = loanModel.insurancecharges;
        costOfAccessoriesController!.text = loanModel.costofAccessories;
        loanAmountController!.text = loanModel.loanAmountRequired;
        horsePowerController!.text = loanModel.horsePowertype;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: tractorCompanyController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Tractor Company'.tr,
                border: InputBorder.none,
                counterText: "",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: tractorModelController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Tractor Model'.tr,
                border: InputBorder.none,
                counterText: "",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: exShowroomPriceController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Ex Showroom Price'.tr,
                border: InputBorder.none,
                counterText: "",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: insurancechargesController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Insurance charges'.tr,
                border: InputBorder.none,
                counterText: "",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: costOfAccessoriesController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'cost of Accessories'.tr,
                border: InputBorder.none,
                counterText: "",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          InkWell(
            onTap: () => showSelectionDialog(context, ['Electrical_horsepower_hp_E'.tr, 'Mechanical_horsepower_hp_I'.tr, 'Boiler_horsepower_hp_S'.tr, 'Hydraulic_horsepower'.tr], ""),
            child: Container(
              width: double.maxFinite,
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
              // margin: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: horsePowerController,
                keyboardType: TextInputType.text,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Select Horse Power'.tr,
                  border: InputBorder.none,
                  counterText: "",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: loanAmountController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Loan Amount'.tr,
                border: InputBorder.none,
                counterText: "",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
              child: CustomDarkButton(
                onPressed: () {
                  _validation();
                },
                caption: 'Next'.tr,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void _validation() {
    if (tractorCompanyController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Tractor Company'.tr);
    } else if (tractorModelController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Tractor Model'.tr);
    } else if (exShowroomPriceController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Ex-Showroom price'.tr);
    } else if (insurancechargesController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Insurances Charges'.tr);
    } else if (costOfAccessoriesController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Cost Of Accessories'.tr);
    } else if (loanAmountController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Loan Amount'.tr);
    } else if (horsePowerController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Horse Power'.tr);
    } else {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      loanModel.setTractorDetails(tractorCompanyController!.text, tractorModelController!.text, exShowroomPriceController!.text, insurancechargesController!.text, costOfAccessoriesController!.text,
          loanAmountController!.text, horsePowerController!.text);
      loanModel.setPageIndex(2);
    }
  }

  void showSelectionDialog(BuildContext buildContext, final cropType, String type) {
    showDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return CupertinoAlertDialog(
              title: WidgetUtils.appTextWidget(context: context, title: 'Select horse power'.tr, color: Colors.black, fontSize: 18),
              actions: List.generate(
                cropType.length,
                (index) {
                  return CupertinoDialogAction(
                      child: WidgetUtils.appTextWidget(context: context, title: cropType[index], fontSize: 16),
                      onPressed: () {
                        horsePowerController!.text = cropType[index];
                        setState(() {});
                        Navigator.pop(ctx);
                      });
                },
              ),
            );
          });
        });
  }
}
