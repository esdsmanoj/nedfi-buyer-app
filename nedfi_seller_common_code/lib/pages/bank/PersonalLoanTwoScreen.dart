import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/app_imports.dart';

class PersonalLoanTwoScreen extends StatefulWidget {
  const PersonalLoanTwoScreen({Key? key}) : super(key: key);

  @override
  _PersonalLoanTwoScreenState createState() => _PersonalLoanTwoScreenState();
}

class _PersonalLoanTwoScreenState extends State<PersonalLoanTwoScreen> {
  TextEditingController? villageController,
      surveyNumberController,
      landSharedLeasedController,
      sharedAreaController,
      totalAreaController,
      irrigatedAreaController,
      irrigationSourceController,
      encumbrancController;

  @override
  void initState() {
    super.initState();
    villageController = TextEditingController();
    // _villageFocusNode = FocusNode();
    surveyNumberController = TextEditingController();
    landSharedLeasedController = TextEditingController();
    sharedAreaController = TextEditingController();
    totalAreaController = TextEditingController();
    irrigatedAreaController = TextEditingController();
    irrigationSourceController = TextEditingController();
    encumbrancController = TextEditingController();
    getDetails();
  }

  Future getDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      setState(() {
        villageController!.text = loanModel.villageController;
        surveyNumberController!.text = loanModel.surveyNumberController;
        landSharedLeasedController!.text = loanModel.landSharedLeasedController;
        sharedAreaController!.text = loanModel.sharedAreaController;
        totalAreaController!.text = loanModel.totalAreaController;
        irrigatedAreaController!.text = loanModel.irrigatedAreaController;
        irrigationSourceController!.text = loanModel.irrigationSourceController;
        encumbrancController!.text = loanModel.encumbrancController;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Padding(
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
              controller: villageController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Village'.tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                border: InputBorder.none,
                counterText: "",
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: surveyNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Survey Number'.tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                border: InputBorder.none,
                counterText: "",
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: landSharedLeasedController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Land Shared Leased In Acers'.tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                border: InputBorder.none,
                counterText: "",
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: sharedAreaController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Shared Area In Acers'.tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                border: InputBorder.none,
                counterText: "",
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: totalAreaController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Total Area In Acers'.tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                border: InputBorder.none,
                counterText: "",
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: irrigatedAreaController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Irrigated Area In Acers'.tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                border: InputBorder.none,
                counterText: "",
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: irrigationSourceController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Irrigation Source'.tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                border: InputBorder.none,
                counterText: "",
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: encumbrancController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'encumbrance if any'.tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                border: InputBorder.none,
                counterText: "",
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  height: 50,
                  child: CustomDarkButton(
                    onPressed: () {
                      var loanModel = Provider.of<LoanProvider>(context, listen: false);
                      loanModel.setPageIndex(1);
                    },
                    caption: 'Back'.tr,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  height: 50,
                  child: CustomDarkButton(
                    onPressed: () {
                      _validation();
                    },
                    caption: 'Next'.tr,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  void _validation() {
    RegExp nameRegex = RegExp(r"^[a-zA-Z]+$");
    if (villageController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Village'.tr);
    } else if (!nameRegex.hasMatch(villageController!.text)) {
      WidgetUtils.errorDialog(context, 'Enter Village'.tr);
    } else if (surveyNumberController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Survey Number'.tr);
    } else if (landSharedLeasedController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Land Shared Leased'.tr);
    } else if (sharedAreaController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter shared Area'.tr);
    } else if (totalAreaController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Total Area'.tr);
    } else if (irrigatedAreaController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Irrigated Area'.tr);
    } else if (irrigationSourceController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Irrigation Source'.tr);
    } else {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      loanModel.setPersonalLoanPageTwo(villageController!.text, surveyNumberController!.text, landSharedLeasedController!.text, sharedAreaController!.text, totalAreaController!.text,
          irrigatedAreaController!.text, irrigationSourceController!.text, encumbrancController!.text);
      loanModel.setPageIndex(3);
    }
  }
}
