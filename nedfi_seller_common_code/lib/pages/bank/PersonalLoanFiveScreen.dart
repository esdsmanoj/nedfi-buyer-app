import 'package:get/get.dart';
import '../user_details/e_kyc_screen.dart';
import 'package:nedfi_seller_common_code/app_imports.dart';

class PersonalLoanFiveScreen extends StatefulWidget {
  const PersonalLoanFiveScreen({Key? key}) : super(key: key);

  @override
  _PersonalLoanFiveScreenState createState() => _PersonalLoanFiveScreenState();
}

class _PersonalLoanFiveScreenState extends State<PersonalLoanFiveScreen> {
  TextEditingController? adhaarController, panCardController;

  @override
  void initState() {
    super.initState();
    adhaarController = TextEditingController();
    panCardController = TextEditingController();
    getDetails();
  }

  Future getDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      setState(() {
        adhaarController!.text = loanModel.aadharCard;
        panCardController!.text = loanModel.panCard;
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
              controller: adhaarController,
              keyboardType: TextInputType.number,
              maxLength: 14,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CardNumberFormatter(),
              ],
              decoration: InputDecoration(
                hintText: 'Aadhar Card'.tr,
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
              controller: panCardController,
              keyboardType: TextInputType.text,
              maxLength: 10,
              decoration: InputDecoration(
                hintText: 'Pan card'.tr,
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
                    loanModel.setPageIndex(4);
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
          )
        ],
      ),
    );
  }

  void _validation() {
    // RegExp expression = RegExp(r'^[2-9]{1}[0-9]{3}\s[0-9]{4}\s[0-9]{4}$');
    // RegExp panExpression = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (adhaarController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Aadhar card'.tr);
    } else if (!aadhaarExpression.hasMatch(adhaarController!.text)) {
      WidgetUtils.errorDialog(context, 'Please enter valid card number'.tr);
    } else if (panCardController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Pan Card'.tr);
    } else if (!panExpression.hasMatch(panCardController!.text)) {
      WidgetUtils.errorDialog(context, 'Enter Valid Pan Card'.tr);
    } else {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      loanModel.setCardDetails(adhaarController!.text, panCardController!.text);
      loanModel.setPageIndex(6);
    }
  }
}
