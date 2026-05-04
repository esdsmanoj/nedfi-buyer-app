import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_dark_button.dart';
import '../../model/profile_model.dart';
import '../../components/utils/widget_utils.dart';

class BankDetailsScreen extends StatefulWidget {
  final List<ProfileData> userDetails;
  Function(bool)? onStateChanged;

  BankDetailsScreen({Key? key, required this.userDetails, required this.onStateChanged}) : super(key: key);

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    bankNameController.text = widget.userDetails[0].bankName!;
    branchNameController.text = widget.userDetails[0].branchName!;
    accountNumberController.text = widget.userDetails[0].accNo!;
    ifscCodeController.text = widget.userDetails[0].ifscCode!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  WidgetUtils.appTextWidget(context:context,title: 'Bank Details'.tr, fontWeight: FontWeight.w700, fontSize: 16),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                    // margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      controller: branchNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Branch name'.tr, border: InputBorder.none, counterText: ""),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                    // margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      controller: accountNumberController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Account Number'.tr, border: InputBorder.none, counterText: ""),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                    // margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      controller: ifscCodeController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'IFSC Code'.tr, border: InputBorder.none, counterText: ""),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomDarkButton(
                      caption: "Continue".tr,
                      onPressed: () {
                        // uploadDocument();
                      }),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
