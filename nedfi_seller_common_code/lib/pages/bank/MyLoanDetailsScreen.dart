import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';

import '../../components/utils/Utilities.dart';
import '../../components/widgets/base_widget.dart';

class MyLoanDetailsScreen extends StatefulWidget {
  LoanDetailsData loanDetailsData;

  MyLoanDetailsScreen(this.loanDetailsData, {super.key});

  @override
  State<MyLoanDetailsScreen> createState() => _MyLoanDetailsScreenState();
}

class _MyLoanDetailsScreenState extends State<MyLoanDetailsScreen> {
  @override
  void initState() {
    super.initState();
    getLoanDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(builder: (context, loanModel, child) {
      return BaseWidget(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          title: WidgetUtils.appTextWidget(context: context, title: 'Loan Details'.tr, color: Colors.white, fontSize: 18),
          leading: InkWell(onTap: () => Navigator.pop(context), child:  const Icon(Icons.arrow_back, color: Colors.white)),
        ),
        child: SingleChildScrollView(
            child: Container(
                margin:  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:  const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                ),
                child: setDetails(loanModel))),
      );
    });
  }

  Future getLoanDetails() async {
    isLoading.value = true;
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getMyLoans + "/" + widget.loanDetailsData.Id);

      final data = json.decode(response.body);
      final res = MyLoanDetailsResponse.fromJson(data);
      if (res.status == 1) {
        var loanModel = Provider.of<LoanProvider>(context, listen: false);
        loanModel.setMyLoanDetails(res.data.application);
        loanModel.setMyLoanDetailsBanks(res.data.banks);
        var otherDetails = json.decode(res.data.application[0].otherDetails ?? "");
        if (otherDetails != "") {
          loanModel.setOtherLoanDetails(OtherLoanDetails.fromJson(otherDetails));
        }
      }
      isLoading.value = false;
      setState(() {});
    } catch (e) {
      isLoading.value = false;
      setState(() {});
    }
  }

  Widget setDetails(LoanProvider loanModel) {
    return Padding(
      padding:  const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Utilities.isEmpty(loanModel.otherLoanDetails.first_name ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'First Name'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.first_name ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.last_name ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Last Name'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.last_name ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.village ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Village'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.village ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.city ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'City'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.city ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.state ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'State'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.state ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.dob ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Date of birth'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.dob ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.contact_no ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Contact No'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.contact_no ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.email ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Email'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.email ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.address1 ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Address1'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.address1 ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.address2 ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Address2'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.address2 ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.annual_agriculture_income ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Annual Agriculture Income'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.annual_agriculture_income ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.other_annual_income_if_any ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Other Annual Income If Any'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.other_annual_income_if_any ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_first_name ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant First Name'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_first_name ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_last_name ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant Last Name'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_last_name ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.alternate_contact_no ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Alternate Contact No'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.alternate_contact_no ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_contact_no ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant Contact No'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_contact_no ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_date_of_birth ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant Date Of Birth'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_date_of_birth ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_alternate_contact_no ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant Alternate Contact No'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_alternate_contact_no ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_address1 ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant Address1'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_address1 ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_address2 ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant Address2'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_address2 ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_village ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant village'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_village ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_city ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant City'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_city ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_state ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant State'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_state ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_email ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant Email'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_email ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_father_or_husband_or_spouse_name ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant Father or Husband or Spouse Name'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_father_or_husband_or_spouse_name ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_gender ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant Gender'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_gender ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.co_applicant_postcode ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Co Applicant postcode'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.co_applicant_postcode ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.Combine_Harvestor_make ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Combine Harvestor Make'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.Combine_Harvestor_make ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.Combine_Harvestor_model ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Combine Harvestor Model'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.Combine_Harvestor_model ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.cost_of_accessories ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Cost of Accessories'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.cost_of_accessories ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.Cost_of_Project ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Cost of Project'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.Cost_of_Project ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.encumbrance_if_any ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Encumbrance if any'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.encumbrance_if_any ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.ex_showroom_price ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Ex Showroom price'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.ex_showroom_price ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.Fuel_Energy_Type ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Fuel Energy Type'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.Fuel_Energy_Type ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.insurance_charges ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Insurance Charges'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.insurance_charges ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.irrigated_area_in_acres ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Irrigated Area In Acres'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.irrigated_area_in_acres ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.land_shared_leased_in_acres ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Land Shared Leased in acres'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.land_shared_leased_in_acres ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.Loan_Amount_Required ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Loan Amount Required'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.Loan_Amount_Required ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.owned_land_in_acres ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Owned Land in acres'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.owned_land_in_acres ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.Registration_Cost ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Registration Cost'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.Registration_Cost ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.shared_in_acres ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Shared in acres'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.shared_in_acres ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.source_of_irrigation ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Source of Irrigation'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.source_of_irrigation ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.survey_block_number ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Survey Block Number'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.survey_block_number ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.Tie_Up_Agreement ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Tie Up Agreement'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.Tie_Up_Agreement ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.total_area_in_acres ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Total Area In Acres'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.total_area_in_acres ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.total_income ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Total Income'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.total_income ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.traactor_company ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Tractor Company'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.traactor_company ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.traactor_model ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Tractor Model'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.traactor_model ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.Type_of_Combine_Harvestor ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Type of Combine Harvestor'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.Type_of_Combine_Harvestor ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.Type_of_Crop ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Type of Crop'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.Type_of_Crop ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
          Utilities.isEmpty(loanModel.otherLoanDetails.type_of_horse_power ?? "")
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Type of Horse Power'.tr + " :  ",
                        textAlign: TextAlign.start,
                        style:  const TextStyle(color: Color(0XFF000000), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        loanModel.otherLoanDetails.type_of_horse_power ?? "",
                        style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
           const SizedBox(
            height: 10,
          ),
           const Divider(),
          Center(
            child: Text(
              'Bank details'.tr,
              style:  TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
           const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'No Bank has shown interest yet'.tr,
              style:  const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
    );
  }
}
