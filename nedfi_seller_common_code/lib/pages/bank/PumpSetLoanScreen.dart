import 'package:get/get.dart';
import 'package:tuple/tuple.dart';
import 'package:nedfi_seller_common_code/app_imports.dart';

class PumpSetLoanScreen extends StatefulWidget {
  const PumpSetLoanScreen({Key? key}) : super(key: key);

  @override
  State<PumpSetLoanScreen> createState() => _PumpSetLoanScreenState();
}

class _PumpSetLoanScreenState extends State<PumpSetLoanScreen> {
  TextEditingController? cropTypeController, agreementController, loanAmountController, costProjectController;

  @override
  void initState() {
    super.initState();
    cropTypeController = TextEditingController();
    agreementController = TextEditingController();
    loanAmountController = TextEditingController();
    costProjectController = TextEditingController();
    getDetails();
  }

  Future getDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      setState(() {
        cropTypeController!.text = loanModel.loanAmountRequired;
        agreementController!.text = loanModel.costofProjrct;
        loanAmountController!.text = loanModel.fuleEnergyCost;
        costProjectController!.text = loanModel.groundwater;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: costProjectController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Cost of Project'.tr,
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
            onTap: () {
              var cropType = ['Solid_fuel'.tr, 'Liquid_fuels'.tr, 'Fuel_gas'.tr, 'Biofuels'.tr, 'Fossil_fuels'.tr, 'Energy'.tr, 'Fission'.tr, 'Fusion'.tr];
              showCropType(context, 'Select Fuel/Energy Type'.tr, cropType, (value) {
                {
                  Navigator.pop(value.item2);
                  setState(() {
                    cropTypeController!.text = cropType[value.item1];
                  });
                  FocusManager.instance.primaryFocus?.nextFocus();
                }
              });
            },
            child: Container(
              width: double.maxFinite,
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
              // margin: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: cropTypeController,
                keyboardType: TextInputType.text,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Select Fuel/Energy Type'.tr,
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
          InkWell(
            onTap: () {
              showAgreement(context);
            },
            child: Container(
              width: double.maxFinite,
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
              // margin: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: agreementController,
                keyboardType: TextInputType.text,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Do you have ground water certificates'.tr,
                  border: InputBorder.none,
                  counterText: "",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
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
          )
        ],
      ),
    );
  }

  void _validation() {
    if (loanAmountController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Loan Amount'.tr);
    } else if (costProjectController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Cost of Project'.tr);
    } else if (cropTypeController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Select Fuel/Energy Type'.tr);
    } else if (agreementController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Do you have ground water certificates'.tr);
    } else {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      loanModel.setPumpSetDetails(loanAmountController!.text, costProjectController!.text, cropTypeController!.text, agreementController!.text);
      loanModel.setPageIndex(2);
    }
  }

  void showCropType(BuildContext context, String title, final cropType, Function(Tuple2<int, BuildContext>) value) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5, // Change as per your requirement
              width: MediaQuery.of(context).size.width * 0.6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
                child: ListView(shrinkWrap: true, children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WidgetUtils.appTextWidget(context: context, title: title, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child:  SvgPicture.asset(
                               "assets/images/cross.svg",
                            height: 20,
                          ))
                        ],
                      )),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35, // Change as per your requirement
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cropType.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () => value(Tuple2(index, context)),
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: WidgetUtils.appTextWidget(context: context, title: cropType[index], fontSize: 16, family: 'Graphik'),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                            ));
                      },
                    ),
                  ),
                ]),
              ),
            ));
          });
        });
  }

  void showAgreement(BuildContext context) {
    HelperUtils().showNormalDialog(
        context: context,
        title: 'Are_you_sure'.tr,
        content: 'Do you have ground water certificates'.tr,
        noTapped: (valueCalled) {
          setState(() {
            agreementController!.text = 'key_no'.tr;
          });
        },
        onYesTapped: (value) async {
          Navigator.pop(value);
          setState(() {
            agreementController!.text = 'key_yes'.tr;
          });
        });
  }
}
