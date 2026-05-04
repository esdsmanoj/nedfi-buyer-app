import 'package:get/get.dart';
import 'package:tuple/tuple.dart';
import 'package:buyer_common_code/app_imports.dart';

class HarvesterLoanScreen extends StatefulWidget {
  const HarvesterLoanScreen({Key? key}) : super(key: key);

  @override
  State<HarvesterLoanScreen> createState() => _HarvesterLoanScreenState();
}

class _HarvesterLoanScreenState extends State<HarvesterLoanScreen> {
  TextEditingController? registrationCost,
      tractorModelController,
      exShowroomPriceController,
      insuranceChargesController,
      costOfAccessoriesController,
      loanAmountController,
      horsePowerController,
      harvesterModelController;

  @override
  void initState() {
    super.initState();
    registrationCost = TextEditingController();
    tractorModelController = TextEditingController();
    exShowroomPriceController = TextEditingController();
    insuranceChargesController = TextEditingController();
    costOfAccessoriesController = TextEditingController();
    loanAmountController = TextEditingController();
    horsePowerController = TextEditingController();
    harvesterModelController = TextEditingController();
    getDetails();
  }

  Future getDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      setState(() {
        registrationCost!.text = loanModel.registionCost;
        exShowroomPriceController!.text = loanModel.exShowroomPrice;
        insuranceChargesController!.text = loanModel.combinHarvMake;
        costOfAccessoriesController!.text = loanModel.costofAccessories;
        loanAmountController!.text = loanModel.loanAmountRequired;
        horsePowerController!.text = loanModel.typeofHarvester;
        harvesterModelController!.text = loanModel.HarvesterModel;
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
              controller: registrationCost,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Registration cost'.tr,
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
              controller: insuranceChargesController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Combine Harvester Make'.tr,
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
            onTap: () {
              final cropType = ['Controlled_Combine_Harvesters'.tr, 'Conventional_self_propelled_Combine_Harvesters'.tr, 'Rotary_self_propelled_Combine_Harvesters'.tr];
              showHarvesterDialog(context, 'Select Type of combine harvester'.tr, cropType, (value) {
                Navigator.pop(value.item2);
                setState(() {
                  horsePowerController!.text = cropType[value.item1];
                });
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
                controller: horsePowerController,
                keyboardType: TextInputType.text,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Select type of combine harvester'.tr,
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
              var cropType = ['Shaktiman_Paddy_Master_3776'.tr, 'Kartar_4000'.tr, 'Dasmesh_9100_Maize'.tr, 'Preet_987'.tr];
              showHarvesterDialog(context, 'Select combine harvester model'.tr, cropType, (value) {
                Navigator.pop(value.item2);
                setState(() {
                  harvesterModelController!.text = cropType[value.item1];
                });
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
                controller: harvesterModelController,
                keyboardType: TextInputType.text,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Select Combine harvester model'.tr,
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
          ),
        ],
      ),
    );
  }

  void showHarvesterDialog(BuildContext context, String title, dynamic cropType, Function(Tuple2<int, BuildContext> value) onTap) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(builder: (ctx, StateSetter setState) {
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 200,
                              child: WidgetUtils.appTextWidget(
                                  overflow: TextOverflow.ellipsis, context: context, title: title, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500)),
                          InkWell(
                              onTap: () {
                                Navigator.pop(ctx);
                              },
                              child:  SvgPicture.asset(
                               "assets/images/cross.svg",
                            height: 20,
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: cropType.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => onTap(Tuple2(index, ctx)),
                            child: Container(
                              // height: 45,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: SizedBox(width:200,child: WidgetUtils.appTextWidget(context: context, overflow: TextOverflow.ellipsis,title: cropType[index], fontSize: 14, family: 'Graphik', fontWeight: FontWeight.w400)),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                            ),
                          );
                        }),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          });
        });
  }

  void _validation() {
    if (loanAmountController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Loan Amount'.tr);
    } else if (registrationCost!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Registration Cost'.tr);
    } else if (exShowroomPriceController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Ex-Showroom price'.tr);
    } else if (insuranceChargesController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Combine Harvestor Make'.tr);
    } else if (costOfAccessoriesController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Cost Of Accessories'.tr);
    } else if (horsePowerController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Select Type of combine harvester'.tr);
    } else if (harvesterModelController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter combine harvester model'.tr);
    } else {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      loanModel.setHarvesterDetails(loanAmountController!.text, registrationCost!.text, exShowroomPriceController!.text, insuranceChargesController!.text, costOfAccessoriesController!.text,
          horsePowerController!.text, harvesterModelController!.text);
      loanModel.setPageIndex(2);
    }
  }
}
