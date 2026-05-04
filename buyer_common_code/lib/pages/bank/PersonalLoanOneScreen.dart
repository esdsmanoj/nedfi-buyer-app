import 'package:get/get.dart';
import 'package:buyer_common_code/app_imports.dart';

class PersonalLoanOneScreen extends StatefulWidget {
  const PersonalLoanOneScreen({Key? key}) : super(key: key);

  @override
  _PersonalLoanOneScreenState createState() => _PersonalLoanOneScreenState();
}

class _PersonalLoanOneScreenState extends State<PersonalLoanOneScreen> {
  TextEditingController? annualAgriIncomeController, otherIncomeController, totalIncomeController, loanAmountController;

  @override
  void initState() {
    super.initState();
    annualAgriIncomeController = TextEditingController();
    otherIncomeController = TextEditingController();
    totalIncomeController = TextEditingController();
    loanAmountController = TextEditingController();
    getDetails();
  }

  Future getDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      setState(() {
        annualAgriIncomeController!.text = loanModel.annuleAgriIncome;
        otherIncomeController!.text = loanModel.otherIncome;
        totalIncomeController!.text = loanModel.totalIncome;
        loanAmountController!.text = loanModel.loanAmount;
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
                controller: annualAgriIncomeController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Annual Agriculture Income'.tr,
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
                controller: otherIncomeController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Other Annual Income If Any'.tr,
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
                controller: totalIncomeController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'total Income'.tr,
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
                controller: loanAmountController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Loan Amount'.tr,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  counterText: "",
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
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
            )
          ],
        ),
      ),
    );
  }

  void _validation() {
    if (annualAgriIncomeController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Annual Agriculture Income'.tr);
    } else if (totalIncomeController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Total Income'.tr);
    } else if (loanAmountController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Loan Amount'.tr);
    } else {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      loanModel.setPersonalLoanPageOne(annualAgriIncomeController!.text, otherIncomeController!.text, totalIncomeController!.text, loanAmountController!.text);
      loanModel.setPageIndex(2);
    }
  }
}
