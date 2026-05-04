import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/app_imports.dart';

class CropLoanTwoScreen extends StatefulWidget {
  const CropLoanTwoScreen({Key? key}) : super(key: key);

  @override
  _CropLoanTwoScreenState createState() => _CropLoanTwoScreenState();
}

class _CropLoanTwoScreenState extends State<CropLoanTwoScreen> {
  TextEditingController? firstnameController, lastnameController, mobileController, alternativeMobileController;

  @override
  void initState() {
    super.initState();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    mobileController = TextEditingController();
    alternativeMobileController = TextEditingController();

    setDatas();
  }

  Future setDatas() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // final profileModel = Provider.of<ProfileProvider>(context, listen: false);
      // setState(() {
      firstnameController!.text = HeaderSingleton().profileDetails.value!.data[0].firstName ?? "";
      lastnameController!.text = HeaderSingleton().profileDetails.value!.data[0].lastName ?? "";
      mobileController!.text = HeaderSingleton().profileDetails.value!.data[0].phone ?? "";
      // });

      final loanModel = Provider.of<LoanProvider>(context, listen: false);
      if (loanModel.firstName != "") {
        setState(() {
          firstnameController!.text = loanModel.firstName;
          lastnameController!.text = loanModel.lastName;
          mobileController!.text = loanModel.mobile;
          alternativeMobileController!.text = loanModel.altermobile;
        });
      }
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
                controller: firstnameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'First Name'.tr,
                  border: InputBorder.none,
                  counterText: "",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
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
                controller: lastnameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Last Name'.tr,
                  border: InputBorder.none,
                  counterText: "",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
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
                controller: mobileController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: 'Mobile Number'.tr,
                  border: InputBorder.none,
                  counterText: "",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
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
                controller: alternativeMobileController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: 'Alternate Mobile Number'.tr,
                  border: InputBorder.none,
                  counterText: "",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  labelStyle: const TextStyle(fontSize: 14, fontFamily: 'Graphik', color: Colors.grey, fontWeight: FontWeight.w400),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  height: 50,
                  child: CustomDarkButton(
                    onPressed: () {
                      var loanModel = Provider.of<LoanProvider>(context, listen: false);
                      loanModel.setPageIndex(1);
                      FocusManager.instance.primaryFocus?.nextFocus();
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
                      // FocusManager.instance.primaryFocus?.nextFocus();
                    },
                    caption: 'Next'.tr,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _validation() {
    String regexPattern = r'^[6-9]\d{9}$';
    final regExp = RegExp(regexPattern);
    RegExp nameRegex = RegExp(r"^[a-zA-Z]+$");
    if (firstnameController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter First Name'.tr);
    } else if (!nameRegex.hasMatch(firstnameController!.text.toString())) {
      WidgetUtils.errorDialog(context, 'Please Enter FirstName'.tr);
    } else if (!nameRegex.hasMatch(lastnameController!.text.toString())) {
      WidgetUtils.errorDialog(context, 'Please Enter LastName'.tr);
    } else if (lastnameController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Last Name'.tr);
    } else if (mobileController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Mobile'.tr);
    } else if (!regExp.hasMatch(mobileController!.text)) {
      WidgetUtils.errorDialog(context, AppTranslations.of(context)?.text("key_mobile_no_instruction") ?? 'key_mobile_no_instruction'.tr);
    } else {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      loanModel.setPersonalDetails(firstnameController!.text, lastnameController!.text, mobileController!.text, alternativeMobileController!.text);
      loanModel.setPageIndex(3);
    }
  }
}
