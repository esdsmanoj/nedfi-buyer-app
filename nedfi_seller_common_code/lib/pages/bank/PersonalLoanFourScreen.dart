import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/custom_dark_button.dart';
import '../../components/utils/helper_utils.dart';
import '../../components/utils/widget_utils.dart';
import '../../singleton/header_singleton.dart';
import '../../providers/loan_provider.dart';
import '../../model/CityResponse.dart';
import '../../model/StateResponse.dart';

class PersonalLoanFourScreen extends StatefulWidget {
  const PersonalLoanFourScreen({Key? key}) : super(key: key);

  @override
  _PersonalLoanFourScreenState createState() => _PersonalLoanFourScreenState();
}

class _PersonalLoanFourScreenState extends State<PersonalLoanFourScreen> {
  TextEditingController? firstNameController,
      lastNameController,
      mobileNoController,
      emailController,
      dobController,
      genderController,
      fatherController,
      countryController,
      stateController,
      disctricController,
      villageController,
      postalController,
      addressController;

//  FocusNode? _addressFocusNode;

  bool? _isLoading;
  late String _loadingText;
  String? stateID;

  TextEditingController controller = TextEditingController();
  TextEditingController controllerOne = TextEditingController();

  List<StateData> _searchResult = [];

  List<CityData> _searchResultOne = [];
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _loadingText = 'Loading . . .';
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    mobileNoController = TextEditingController();
    emailController = TextEditingController();
    dobController = TextEditingController();
    genderController = TextEditingController();
    fatherController = TextEditingController();
    countryController = TextEditingController(text: 'INDIA');
    stateController = TextEditingController();
    disctricController = TextEditingController();
    villageController = TextEditingController();
    postalController = TextEditingController();
    addressController = TextEditingController();
    getDetails();
  }

  Future getDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      setState(() {
        firstNameController!.text = loanModel.cofirstName;
        lastNameController!.text = loanModel.colastName;
        mobileNoController!.text = loanModel.co_mobileNo;
        emailController!.text = loanModel.co_email;
        dobController!.text = loanModel.co_dob;
        genderController!.text = loanModel.co_gender;
        fatherController!.text = loanModel.co_father;
        countryController!.text = loanModel.co_countr;
        stateController!.text = loanModel.co_state;
        disctricController!.text = loanModel.co_disctric;
        villageController!.text = loanModel.co_village;
        postalController!.text = loanModel.co_postal;
        addressController!.text = loanModel.co_address;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.green,
                value: HeaderSingleton().isSameInfoStatus,
                onChanged: (bool? value) {
                  setState(() {
                    HeaderSingleton().setStatusInfo(value!);
                    if (HeaderSingleton().isSameInfoStatus) {
                      var loanModel = Provider.of<LoanProvider>(context, listen: false);
                      firstNameController!.text = loanModel.firstName;
                      lastNameController!.text = loanModel.lastName;
                      mobileNoController!.text = loanModel.mobileNo;
                      emailController!.text = loanModel.email;
                      dobController!.text = loanModel.dob;
                      genderController!.text = loanModel.gender;
                      fatherController!.text = loanModel.father;
                      countryController!.text = loanModel.country;
                      stateController!.text = loanModel.state;
                      disctricController!.text = loanModel.disctric;
                      villageController!.text = loanModel.village;
                      postalController!.text = loanModel.postal;
                      addressController!.text = loanModel.address;
                    } else {
                      firstNameController!.text = "";
                      lastNameController!.text = "";
                      mobileNoController!.text = "";
                      emailController!.text = "";
                      dobController!.text = "";
                      genderController!.text = "";
                      fatherController!.text = "";
                      countryController!.text = "";
                      stateController!.text = "";
                      disctricController!.text = "";
                      villageController!.text = "";
                      postalController!.text = "";
                      addressController!.text = "";
                    }
                  });
                },
              ),
              WidgetUtils.appTextWidget(context: context, title: 'Same as Personal Information'.tr, fontSize: 16, fontWeight: FontWeight.w400, family: 'Graphik', textAlign: TextAlign.start),
            ],
          ),
          Container(
            width: double.maxFinite,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              controller: firstNameController,
              keyboardType: TextInputType.text,
              enabled: false,
              decoration: InputDecoration(hintText: 'First Name'.tr, border: InputBorder.none, counterText: ""),
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
              controller: lastNameController,
              keyboardType: TextInputType.text,
              enabled: false,
              decoration: InputDecoration(hintText: 'Last Name'.tr, border: InputBorder.none, counterText: ""),
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
              controller: mobileNoController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(hintText: 'Mobile No.'.tr, border: InputBorder.none, counterText: ""),
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
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'Email Address'.tr, border: InputBorder.none, counterText: ""),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () {
              dialogSelectDOB();
            },
            child: Container(
              width: double.maxFinite,
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
              // margin: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: dobController,
                keyboardType: TextInputType.datetime,
                enabled: false,
                decoration: InputDecoration(hintText: 'Date of birth'.tr, border: InputBorder.none, counterText: ""),
              ),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () => showDialogGender(context),
            child: Container(
              width: double.maxFinite,
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(border: Border.all(color: Colors.green.shade300), borderRadius: BorderRadius.circular(4)),
              // margin: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: genderController,
                keyboardType: TextInputType.text,
                enabled: false,
                decoration: InputDecoration(hintText: 'Gender'.tr, border: InputBorder.none, counterText: ""),
              ),
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
              controller: fatherController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: 'Father/Husband/Spouse Name'.tr, border: InputBorder.none, counterText: ""),
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
              controller: countryController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: 'Country'.tr, border: InputBorder.none, counterText: ""),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () {
              showCompanyFilter(context);
            },
            child: Container(
              width: double.maxFinite,
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
              // margin: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: stateController,
                keyboardType: TextInputType.text,
                enabled: false,
                decoration: InputDecoration(hintText: 'State'.tr, border: InputBorder.none, counterText: ""),
              ),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () {
              if (stateID == null) {
                WidgetUtils.errorDialog(context, 'Select State'.tr);
              } else {
                showDistrictFilter(context);
              }
            },
            child: Container(
              width: double.maxFinite,
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1), borderRadius: BorderRadius.circular(4)),
              // margin: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: disctricController,
                keyboardType: TextInputType.text,
                enabled: false,
                decoration: InputDecoration(hintText: 'District'.tr, border: InputBorder.none, counterText: ""),
              ),
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
              controller: villageController,
              keyboardType: TextInputType.text,
              maxLength: 50,
              decoration: InputDecoration(hintText: 'Village/Town'.tr, border: InputBorder.none, counterText: ""),
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
              controller: postalController,
              keyboardType: TextInputType.text,
              maxLength: 6,
              decoration: InputDecoration(hintText: 'Postal Code'.tr, border: InputBorder.none, counterText: ""),
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
              controller: addressController,
              keyboardType: TextInputType.streetAddress,
              maxLength: 6,
              decoration: InputDecoration(hintText: 'Address'.tr, border: InputBorder.none, counterText: ""),
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
                    HeaderSingleton().setStatusInfo(false);
                    var loanModel = Provider.of<LoanProvider>(context, listen: false);
                    loanModel.setPageIndex(3);
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _validation() {
    RegExp expression = RegExp('^[1-9][0-9]{5}');
    RegExp nameRegex = RegExp(r"^[a-zA-Z]+$");
    if (firstNameController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter First Name'.tr);
    } else if (!nameRegex.hasMatch(firstNameController!.text.toString())) {
      WidgetUtils.errorDialog(context, 'Please Enter FirstName'.tr);
    } else if (lastNameController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Last Name'.tr);
    } else if (!nameRegex.hasMatch(lastNameController!.text.toString())) {
      WidgetUtils.errorDialog(context, 'Please Enter LastName'.tr);
    } else if (mobileNoController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Mobile No.'.tr);
    } else if (emailController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Email Address'.tr);
    } else if (!emailController!.text.isValidEmail()) {
      WidgetUtils.errorDialog(context, 'Please Enter Valid Email Address'.tr);
    } else if (dobController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Select Date of Birth'.tr);
    } else if (genderController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Select gender'.tr);
    } else if (fatherController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter father/husband/spouse name'.tr);
    } else if (countryController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Country'.tr);
    } else if (stateController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter State'.tr);
    } else if (disctricController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter District'.tr);
    } else if (villageController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter village/town'.tr);
    } else if (!nameRegex.hasMatch(villageController!.text.toString())) {
      WidgetUtils.errorDialog(context, 'Please Enter Village Name'.tr);
    } else if (postalController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Postal Code'.tr);
    } else if (!expression.hasMatch(postalController!.text.toString())) {
      WidgetUtils.errorDialog(context, 'Please Enter postal code'.tr);
    } else if (addressController!.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Address'.tr);
    } else {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      loanModel.setPersonalLoanPageFour(firstNameController!.text, lastNameController!.text, mobileNoController!.text, emailController!.text, dobController!.text, genderController!.text,
          fatherController!.text, countryController!.text, stateController!.text, disctricController!.text, villageController!.text, postalController!.text, addressController!.text);
      loanModel.setPageIndex(5);
    }
  }

  void showDialogGender(BuildContext buildContext) {
    final type = ['Male'.tr, 'Female'.tr];
    showDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return CupertinoAlertDialog(
              title: WidgetUtils.appTextWidget(context: context, title: 'Select gender'.tr, color: Colors.black, fontSize: 18),
              actions: [
                CupertinoDialogAction(
                    child: WidgetUtils.appTextWidget(context: context, title: type[0].tr, fontSize: 16),
                    onPressed: () {
                      genderController!.text = type[0];
                      setState(() {});
                      Navigator.pop(ctx);
                    }),
                CupertinoDialogAction(
                    child: WidgetUtils.appTextWidget(context: context, title: type[1].tr, fontSize: 16),
                    onPressed: () {
                      genderController!.text = type[1];
                      setState(() {});
                      Navigator.pop(ctx);
                    }),
              ],
            );
          });
        });
  }

  void dialogSelectDOB() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year - 13),
        firstDate: DateTime(1950),
//DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(DateTime.now().year - 13));

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        dobController!.text = formattedDate;
      });
    }
  }

  void showCompanyFilter(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<LoanProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return CupertinoAlertDialog(
                  title: WidgetUtils.appTextWidget(context: context, title: 'Select State'.tr),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3, // Change as per your requirement
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ListView(shrinkWrap: true, children: <Widget>[
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
                                        final value = await HelperUtils().getCity(_searchResult[index].id, (value) {}, context);
                                        var loanModel = Provider.of<LoanProvider>(context, listen: false);
                                        loanModel.setCity(value!);
                                        // setState(() {
                                        stateID = _searchResult[index].id;
                                        // });
                                      },
                                      child: Card(
                                        elevation: 0,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    _searchResult[index].name,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 16.0),
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

                                        // setState(() {
                                        stateID = loanModel.stateList[index].id;
                                        // });
                                      },
                                      child: Card(
                                        elevation: 0,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    loanModel.stateList[index].name,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 16.0),
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
              return CupertinoAlertDialog(
                  title: Text('Select District'.tr),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3, // Change as per your requirement
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ListView(shrinkWrap: true, children: <Widget>[
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
                                          disctricController!.text = _searchResultOne[index].name;
                                          //cityName = loanModel.citylist.[index].name;
                                        });
                                      },
                                      child: Card(
                                        elevation: 0,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: WidgetUtils.appTextWidget(
                                                      context: context, title: _searchResultOne[index].name, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, fontSize: 16.0),
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
                                          disctricController!.text = loanModel.cityList[index].name;
                                          //cityName = listOne[index].name;
                                        });
                                      },
                                      child: Card(
                                        elevation: 0,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    loanModel.cityList[index].name,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 16.0),
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
}
