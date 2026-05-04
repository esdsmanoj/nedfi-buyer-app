import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:nedfi_seller_common_code/model/PayuServerResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
// import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';

import '../../components/widgets/base_widget.dart';
import '../../model/CityResponse.dart';
import '../../model/StateResponse.dart';
import 'cart_screen/my_cart_screen.dart';

var transactionID = "";
late PayuServerResponse payuServerRes;

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> /*implements PayUCheckoutProProtocol*/ {
  List<ProductsList> marketProductList = [];

  TextEditingController firstnameController = TextEditingController(text: HeaderSingleton().paramsMaps!.firstName),
      lastNameController = TextEditingController(text: HeaderSingleton().paramsMaps!.lastName),
      mobileNoController = TextEditingController(text: HeaderSingleton().paramsMaps!.phone),
      emailController = TextEditingController(text: HeaderSingleton().paramsMaps!.email),
      stateController = TextEditingController(),
      disctricController = TextEditingController(),
      villageController = TextEditingController(),
      postalController = TextEditingController(text: HeaderSingleton().paramsMaps!.postcode),
      addressController = TextEditingController(text: HeaderSingleton().paramsMaps!.address1),
      paymentController = TextEditingController(),
      controller = TextEditingController(),
      controllerOne = TextEditingController();
  String? stateID,payment_type;
  List<StateData> searchListState = [];
  List<CityData> searchListCity = [];
  // late PayUCheckoutProFlutter _checkoutPro;

  @override
  void initState() {
    super.initState();
    transactionID = "TNX" + Random().nextInt(100000).toString();
    // _checkoutPro = PayUCheckoutProFlutter(this);
    var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
    getProductList(context).then((value) {
      setState(() {
        marketProductList = value;
        marketModel.setCartProductList(marketProductList);
      });
    });
    getState();
    var profileModel = Provider.of<UserLoanProfileProvider>(context, listen: false);
    if (profileModel.profileData.isNotEmpty) {
      firstnameController.text = profileModel.profileData[0].firstName ?? "";
      lastNameController.text = profileModel.profileData[0].lastName ?? "";
      mobileNoController.text = profileModel.profileData[0].phone ?? "";
      emailController.text = profileModel.profileData[0].email ?? "";
      stateController.text = profileModel.profileData[0].state ?? "";
      disctricController.text = profileModel.profileData[0].city ?? "";
      villageController.text = profileModel.profileData[0].village ?? "";
      postalController.text = profileModel.profileData[0].postcode ?? "";
      addressController.text = profileModel.profileData[0].address1 ?? "";
      paymentController.text = "Cash on Delivery";
    }
    generateHashKey();
  }

  Future<List<ProductsList>> getProductList(BuildContext context) async {
    return SQLiteDbProvider.db.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<MarketPlaceProvider>(builder: (context, marketPlaceModel, child) {
        return BaseWidget(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, title: 'Checkout'.tr, color: Colors.white, fontSize: 18),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Theme.of(context).primaryColor, width: 1.0), borderRadius: BorderRadius.circular(14)),

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.start,
                              controller: firstnameController,
                              maxLength: 50,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                              ],
                              decoration: InputDecoration(
                                isCollapsed: false,
                                counter: Container(),
                                border: InputBorder.none,
                                hintText: 'First Name'.tr,
                                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey, fontSize: 18),
                                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                              ),
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                            ),
                          ),
                        ),
                    const SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
                          borderRadius: BorderRadius.circular(14),
                        ),

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.start,
                              controller: lastNameController,
                              maxLength: 50,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                              ],
                              decoration: InputDecoration(
                                  isCollapsed: false,
                                  counter: Container(),
                                  border: InputBorder.none,
                                  hintText: 'Last Name'.tr,
                                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey, fontSize: 18),
                                  labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18)),
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                            ),
                          ),
                        ),
                    const SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Theme.of(context).primaryColor, width: 1.0), borderRadius: BorderRadius.circular(14)),

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              enabled: false,
                              controller: mobileNoController,
                              maxLength: 10,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              ],
                              decoration: InputDecoration(
                                isCollapsed: false,
                                counter: Container(),
                                border: InputBorder.none,
                                hintText: 'Mobile No.'.tr,
                                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey, fontSize: 18),
                                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                              ),
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                            ),
                          ),
                        ),
                    const SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
                          borderRadius: BorderRadius.circular(14),
                        ),

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.start,
                              controller: emailController,
                              maxLength: 50,
                              decoration: InputDecoration(
                                isCollapsed: false,
                                counter: Container(),
                                border: InputBorder.none,
                                hintText: 'Email Address'.tr,
                                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey, fontSize: 18),
                                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                              ),
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                            ),
                          ),
                        ),
                    const SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Theme.of(context).primaryColor, width: 1.0), borderRadius: BorderRadius.circular(14)),

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: InkWell(
                              onTap: () {
                                showStateDialog(context);
                              },
                              child: TextField(
                                enabled: false,
                                onTap: () {},
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.start,
                                controller: stateController,
                                maxLength: 50,
                                decoration: InputDecoration(
                                  isCollapsed: false,
                                  counter: Container(),
                                  border: InputBorder.none,
                                  hintText: 'State'.tr,
                                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey, fontSize: 18),
                                  labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                                ),
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Theme.of(context).primaryColor, width: 1.0), borderRadius: BorderRadius.circular(14)),

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: InkWell(
                              onTap: () {
                                if (stateID == null) {
                                  WidgetUtils.errorDialog(context, 'Select State'.tr);
                                } else {
                                  showDistrictDialog(context);
                                }
                              },
                              child: TextField(
                                enabled: false,
                                onTap: () {},
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.start,
                                controller: disctricController,
                                maxLength: 50,
                                decoration: InputDecoration(
                                  isCollapsed: false,
                                  counter: Container(),
                                  border: InputBorder.none,
                                  hintText: 'District'.tr,
                                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey, fontSize: 18),
                                  labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                                ),
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Theme.of(context).primaryColor, width: 1.0), borderRadius: BorderRadius.circular(14)),

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.start,
                              controller: villageController,
                              maxLength: 50,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                              ],
                              decoration: InputDecoration(
                                isCollapsed: false,
                                counter: Container(),
                                border: InputBorder.none,
                                hintText: 'Village/Town'.tr,
                                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey, fontSize: 18),
                                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                              ),
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                            ),
                          ),
                        ),
                    const SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
                          borderRadius: BorderRadius.circular(14),
                        ),

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.start,
                              controller: postalController,
                              maxLength: 6,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              ],
                              decoration: InputDecoration(
                                isCollapsed: false,
                                counter: Container(),
                                border: InputBorder.none,
                                hintText: 'Postal Code'.tr,
                                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey, fontSize: 18),
                                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                              ),
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                            ),
                          ),
                        ),
                    const SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Theme.of(context).primaryColor, width: 1.0), borderRadius: BorderRadius.circular(14)),

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: TextField(
                              keyboardType: TextInputType.streetAddress,
                              textAlign: TextAlign.start,
                              controller: addressController,
                              maxLength: 100,
                              decoration: InputDecoration(
                                isCollapsed: false,
                                counter: Container(),
                                border: InputBorder.none,
                                hintText: 'Address'.tr,
                                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey, fontSize: 18),
                                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                              ),
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                            ),
                          ),
                        ),
                    const SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
                          borderRadius: BorderRadius.circular(14),
                        ),

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                            child: InkWell(
                              onTap: () {
                                showPaymentDialog(context);
                              },
                              child: TextField(
                                enabled: false,
                                onTap: () {},
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.start,
                                controller: paymentController,
                                maxLength: 50,
                                decoration: InputDecoration(
                                  isCollapsed: false,
                                  counter: Container(),
                                  border: InputBorder.none,
                                  hintText: 'Payment Method'.tr,
                                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey, fontSize: 18),
                                  labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
                                ),
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: CustomDarkButton(
                          onPressed: () {
                            _validation();
                          },
                          caption: 'Submit'.tr),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  _validation() {
    String regexPattern = r'^[6-9]\d{9}$';
    final regExp = RegExp(regexPattern);
    if (firstnameController.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter First Name'.tr);
    } else if (lastNameController.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Last Name'.tr);
    } else if (mobileNoController.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Mobile No.'.tr);
    } else if (!regExp.hasMatch(mobileNoController.text)) {
      WidgetUtils.errorDialog(context, 'Enter Mobile No.'.tr);
    } else if (stateController.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter State'.tr);
    } else if (disctricController.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter District'.tr);
    } else if (villageController.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter village/town'.tr);
    } else if (postalController.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Postal Code'.tr);
    } else if (addressController.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Enter Address'.tr);
    } else if (paymentController.text.isEmpty) {
      WidgetUtils.errorDialog(context, 'Select Payment Method'.tr);
    } else {
      var productID = "";
      var productQTY = "";
      for (int i = 0; i < marketProductList.length; i++) {
        if (productID == "") {
          productID = marketProductList[i].id;
          productQTY = marketProductList[i].qty!;
        } else {
          productID = productID + "," + marketProductList[i].id;
          productQTY = productQTY + "," + marketProductList[i].qty!;
        }
      }
      Map<String, dynamic> params1 = {
        "client_id": HeaderSingleton().paramsMaps!.userId,
        "first_name": firstnameController.text.toString(),
        "last_name": lastNameController.text.toString(),
        "email_id": emailController.text.toString(),
        "cphone": mobileNoController.text.toString(),
        "country": "IN",
        "billing_state": stateController.text.toString(),
        "billing_city": disctricController.text.toString(),
        "billing_village": villageController.text.toString(),
        "billing_pin_code": postalController.text.toString(),
        "billing_address1": addressController.text.toString(),
        "company_name": "",
        "cart_prod_ids": productID,
        "cart_prod_quantity": productQTY,
        "payment_method": paymentController.text.toString(),
        "payment_type":payment_type.toString(),
        "btn_submit": "submit",
      };
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyCartScreen(params1)));
      /*showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Do you want to place order'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(false);
                      checkout();
                     */ /* _checkoutPro.openCheckoutScreen(
                        payUPaymentParams: PayUParams.createPayUPaymentParams(), // REQUIRED
                        payUCheckoutProConfig: PayUParams.createPayUConfigParams(),
                      );*/ /*
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ));*/
    }
  }

  checkout() async {
    setState(() {
      isLoading.value = true;
    });
    try {
      var productID = "";
      var productQTY = "";
      for (int i = 0; i < marketProductList.length; i++) {
        if (productID == "") {
          productID = marketProductList[i].id;
          productQTY = marketProductList[i].qty!;
        } else {
          productID = productID + "," + marketProductList[i].id;
          productQTY = productQTY + "," + marketProductList[i].qty!;
        }
      }
      Map<String, dynamic> params1 = {
        "client_id": HeaderSingleton().paramsMaps!.userId,
        "first_name": firstnameController.text.toString(),
        "last_name": lastNameController.text.toString(),
        "email_id": emailController.text.toString(),
        "cphone": mobileNoController.text.toString(),
        "country": "IN",
        "billing_state": stateController.text.toString(),
        "billing_city": disctricController.text.toString(),
        "billing_village": villageController.text.toString(),
        "billing_pin_code": postalController.text.toString(),
        "billing_address1": addressController.text.toString(),
        "company_name": "",
        "cart_prod_ids": productID,
        "cart_prod_quantity": productQTY,
        "btn_submit": "submit",
      };
      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.addClientOrder), body: params1, headers: headerParams);
      var data = json.decode(response.body);
      var res = CommonModel.fromJson(data);
      if (res.status == 1) {
        var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        marketPlaceModel.setClearCart();
        SQLiteDbProvider.db.deleteAll();
        WidgetUtils.successDialog(context, res.message);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OrderThankYouScreen(massage: res.pickupMsg)), (Route<dynamic> route) => false);
      } else {
        WidgetUtils.errorDialog(context, res.message);
      }
      setState(() {
        isLoading.value = false;
      });
    } catch (e) {
      setState(() {
        isLoading.value = false;
      });
    }
  }

  getState() async {
    setState(() {
      isLoading.value = true;
    });
    try {
      //var headerModel =
      //    Provider.of<HeaderModel>(context, listen: false);
      Map<String, dynamic> params1 = {
        "type": "1",
        "country_id": "101",
      };
      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.getStates), body: params1, headers: headerParams);
      var data = json.decode(response.body);
      // print(StateResponse.fromJson(data).toJson());
      var res = StateResponse.fromJson(data);
      if (res.status == 1) {
        //setState(() {
        var loanModel = Provider.of<LoanProvider>(context, listen: false);
        loanModel.setStates(res.data);
        // });
      }
      setState(() {
        isLoading.value = false;
      });
    } catch (e) {
      // print(e.toString());
      setState(() {
        isLoading.value = false;
      });
      /*WidgetUtils.errorDialog(context, 'Not_able_to_get_Menu'.tr,
          2);*/
    }
  }

  getCity(String stateID) async {
    setState(() {
      isLoading.value = true;
    });
    try {
      //var headerModel =
      //    Provider.of<HeaderModel>(context, listen: false);
      Map<String, dynamic> params1 = {
        "type": "1",
        "state_id": stateID,
      };
      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.getCities), body: params1, headers: headerParams);
      var data = json.decode(response.body);
      // print(CityResponse.fromJson(data).toJson());
      var res = CityResponse.fromJson(data);
      if (res.status == 1) {
        //setState(() {
        var loanModel = Provider.of<LoanProvider>(context, listen: false);
        loanModel.setCity(res.data);
        // });
      } else {
        /*WidgetUtils.errorDialog(context, 'Not_able_to_get_Menu'.tr,
            2);*/
      }

      setState(() {
        isLoading.value = false;
      });
    } on SocketException {
      /*WidgetUtils.errorDialog(context,

          'key_connection_lost'.tr,
         2);*/
    } catch (e) {
      // print(e.toString());
      setState(() {
        isLoading.value = false;
      });
      /* WidgetUtils.errorDialog(context, 'Not_able_to_get_Menu'.tr,
          2);*/
    }
  }

  showStateDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<LoanProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return CupertinoAlertDialog(
                  title: Text('Select State'.tr),
                  content: SizedBox(
                    height: 350.0, // Change as per your requirement
                    width: 600.0,
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      Card(
                        child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.search),
                            title: TextField(
                              controller: controller,
                              decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                              onChanged: (text) {
                                searchListState.clear();
                                if (text.isEmpty) {
                                  setState(() {});
                                  return;
                                }
                                for (var userDetail in loanModel.stateList) {
                                  if (userDetail.name.toUpperCase().contains(text.toUpperCase())) searchListState.add(userDetail);
                                }

                                setState(() {});
                              },
                            ),
                            trailing: InkWell(
                                child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                onTap: () {
                                  controller.clear();
                                  searchListState.clear();
                                  if ("".isEmpty) {
                                    setState(() {});
                                    return;
                                  }
                                  for (var userDetail in loanModel.stateList) {
                                    if (userDetail.name.contains("")) searchListState.add(userDetail);
                                  }
                                  setState(() {});
                                })),
                      ),
                      SizedBox(
                        height: 350.0, // Change as per your requirement
                        width: 550.0,
                        child: searchListState.isNotEmpty || controller.text.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchListState.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          stateController.text = searchListState[index].name;
                                          getCity(searchListState[index].id);
                                          stateID = searchListState[index].id;
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
                                                  child: Text(searchListState[index].name,
                                                      textAlign: TextAlign.start, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0)),
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
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          stateController.text = loanModel.stateList[index].name;
                                          getCity(loanModel.stateList[index].id);
                                          stateID = loanModel.stateList[index].id;
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
                                                  child: Text(loanModel.stateList[index].name,
                                                      textAlign: TextAlign.start, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0)),
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

  void showDistrictDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<LoanProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return CupertinoAlertDialog(
                  title: Text('Select District'.tr),
                  content: SizedBox(
                    height: 350.0, // Change as per your requirement
                    width: 600.0,
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      Container(
                        child: Card(
                          child: ListTile(
                              dense: true,
                              leading: const Icon(Icons.search),
                              title: TextField(
                                controller: controllerOne,
                                decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                                onChanged: (text) {
                                  searchListCity.clear();
                                  if (text.isEmpty) {
                                    setState(() {});
                                    return;
                                  }
                                  for (var userDetail in loanModel.cityList) {
                                    if (userDetail.name.toUpperCase().contains(text.toUpperCase()) || userDetail.name.toLowerCase().contains(text.toLowerCase())) searchListCity.add(userDetail);
                                  }

                                  setState(() {});
                                },
                              ),
                              trailing: InkWell(
                                  child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                  onTap: () {
                                    controllerOne.clear();
                                    searchListCity.clear();
                                    if ("".isEmpty) {
                                      setState(() {});
                                      return;
                                    }
                                    for (var userDetail in loanModel.cityList) {
                                      if (userDetail.name.contains("")) searchListCity.add(userDetail);
                                    }
                                    setState(() {});
                                  })),
                        ),
                      ),
                      SizedBox(
                        height: 350.0, // Change as per your requirement
                        width: 550.0,
                        child: searchListCity.isNotEmpty || controllerOne.text.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchListCity.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          disctricController.text = searchListCity[index].name;
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
                                                  child: Text(
                                                    searchListCity[index].name,
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
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: loanModel.cityList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          disctricController.text = loanModel.cityList[index].name;
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

  void showPaymentDialog(BuildContext context) {
    var cropType = ['Cash on Delivery'.tr, 'Online'.tr];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return CupertinoAlertDialog(
                title: Text('Select Payment Method'.tr),
                content: SizedBox(
                  height: 200.0, // Change as per your requirement
                  width: 600.0,
                  child: ListView(shrinkWrap: true, children: <Widget>[
                    SizedBox(
                      height: 350.0, // Change as per your requirement
                      width: 350.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cropType.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  if(index==0) {
                                    payment_type ='Cash on Delivery';
                                  }else{
                                    payment_type ='Online';
                                  }
                                  paymentController.text = cropType[index];
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
                                            cropType[index],
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
  }

  showAlertDialog(BuildContext context, String title, String content) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(title: Text(title), content: SingleChildScrollView(scrollDirection: Axis.vertical, child: Text(content)), actions: [okButton]);
        });
  }

  generateHashKey() async {
    setState(() {
      isLoading.value = true;
    });
    try {
      var productID = "";
      var productQTY = "";
      for (int i = 0; i < marketProductList.length; i++) {
        if (productID == "") {
          productID = marketProductList[i].id;
          productQTY = marketProductList[i].qty!;
        } else {
          productID = productID + "," + marketProductList[i].id;
          productQTY = productQTY + "," + marketProductList[i].qty!;
        }
      }
      Map<String, dynamic> params1 = {
        "txnid": transactionID,
        "amount": "100",
        "productinfo": "bhaji",
        "firstname": "bhushan",
        "email": "",
        "user_credentials": "",
        "udf1": "",
        "udf2": "",
        "udf3": "",
        "udf4": "",
        "udf5": "",
        "offerKey": "",
        "cardBin": ""
      };
      http.Response response = await http.post(Uri.parse("https://dev.famrut.com/payment/payu/checksum.php"), body: params1, headers: headerParams);
      var data = json.decode(response.body);
      var res = PayuServerResponse.fromJson(data);
      payuServerRes = res;
      generateHash(res.toJson());
      setState(() {
        isLoading.value = false;
      });
    } catch (e) {
      setState(() {
        isLoading.value = false;
      });
    }
  }

  @override
  generateHash(Map response) {
    // Pass response param to your backend server
    // Backend will generate the hash which you need to pass to SDK
    // hashResponse: is the response which you get from your server
    Map hashResponse = {};
    // _checkoutPro.hashGenerated(hash: hashResponse);
  }

  @override
  onPaymentSuccess(dynamic response) {
    showAlertDialog(context, "onPaymentSuccess", response.toString());
  }

  @override
  onPaymentFailure(dynamic response) {
    showAlertDialog(context, "onPaymentFailure", response.toString());
  }

  @override
  onPaymentCancel(Map? response) {
    showAlertDialog(context, "onPaymentCancel", response.toString());
  }

  @override
  onError(Map? response) {
    showAlertDialog(context, "onError", response.toString());
  }
}

class PayUTestCredentials {
  static const merchantKey = "gtKFFx";
  static const iosSurl = "https://www.payumoney.com/mobileapp/payumoney/success.php";
  static const iosFurl = "https://www.payumoney.com/mobileapp/payumoney/failure.php";
  static const androidSurl = "https://www.payumoney.com/mobileapp/payumoney/success.php";
  static const androidFurl = "https://www.payumoney.com/mobileapp/payumoney/failure.php";

  static const merchantAccessKey = ""; //<ADD YOUR MERCHNAT ACCESS KEY> Optional
  static const sodexoSourceId = ""; //<ADD YOUR SODEXO SOURCE ID> Optional
}

//Pass these values from your app to SDK, this data is only for test purpose
class PayUParams {
 /* static Map createPayUPaymentParams() {
    *//*var siParams = {
      PayUSIParamsKeys.isFreeTrial: true,
      PayUSIParamsKeys.billingAmount: '1', //REQUIRED
      PayUSIParamsKeys.billingInterval: 1, //REQUIRED
      PayUSIParamsKeys.paymentStartDate: '2023-04-20', //REQUIRED
      PayUSIParamsKeys.paymentEndDate: '2023-04-30', //REQUIRED
      PayUSIParamsKeys.billingCycle: 'once', //REQUIRED //Can be any of 'daily','weekly','yearly','adhoc','once','monthly'
      PayUSIParamsKeys.remarks: 'Test SI transaction',
      PayUSIParamsKeys.billingCurrency: 'INR',
      PayUSIParamsKeys.billingLimit: 'ON', //ON, BEFORE, AFTER
      PayUSIParamsKeys.billingRule: 'MAX', //MAX, EXACT
    };*//*

   *//* var additionalParam = {
      PayUAdditionalParamKeys.udf1: "udf1",
      PayUAdditionalParamKeys.udf2: "udf2",
      PayUAdditionalParamKeys.udf3: "udf3",
      PayUAdditionalParamKeys.udf4: "udf4",
      PayUAdditionalParamKeys.udf5: "udf5",
      PayUAdditionalParamKeys.merchantAccessKey: PayUTestCredentials.merchantAccessKey,
      PayUAdditionalParamKeys.sourceId: PayUTestCredentials.sodexoSourceId,
    };*//*

    var spitPaymentDetails = [
      {
        "type": "absolute",
        "splitInfo": {
          "imAJ7I": {"aggregatorSubTxnId": "Testchild123", "aggregatorSubAmt": "5"},
          "qOoYIv": {"aggregatorSubTxnId": "Testchild098", "aggregatorSubAmt": "5"},
        }
      }
    ];

   *//* var payUPaymentParams = {
      PayUPaymentParamKey.key: PayUTestCredentials.merchantKey, //REQUIRED
      PayUPaymentParamKey.amount: "100.0", //REQUIRED
      PayUPaymentParamKey.productInfo: "Info", //REQUIRED
      PayUPaymentParamKey.firstName: "Abc", //REQUIRED
      PayUPaymentParamKey.email: "test@gmail.com", //REQUIRED
      PayUPaymentParamKey.phone: "9999999999", //REQUIRED
      PayUPaymentParamKey.ios_surl: PayUTestCredentials.iosSurl, //REQUIRED
      PayUPaymentParamKey.ios_furl: PayUTestCredentials.iosFurl, //REQUIRED
      PayUPaymentParamKey.android_surl: PayUTestCredentials.androidSurl, //REQUIRED
      PayUPaymentParamKey.android_furl: PayUTestCredentials.androidFurl, //REQUIRED
      PayUPaymentParamKey.environment: "1", //0 => Production 1 => Test
      PayUPaymentParamKey.userCredential: null, //Pass user credential to fetch saved cards => A:B - OPTIONAL
      PayUPaymentParamKey.transactionId: transactionID, //REQUIRED
      //  PayUPaymentParamKey.additionalParam: additionalParam, // OPTIONAL
      PayUPaymentParamKey.enableNativeOTP: true, // OPTIONAL
      PayUPaymentParamKey.userToken: "<Pass a unique token to fetch offers>", // OPTIONAL
      PayUPaymentParamKey.payUSIParams: siParams, // OPTIONAL
      PayUPaymentParamKey.splitPaymentDetails: spitPaymentDetails, // OPTIONAL
      PayUPaymentParamKey.additionalParam: {
        "payment_related_details_for_mobile_sdk": payuServerRes.paymentRelatedDetailsForMobileSdkHash,
        "vas_for_mobile_sdk": payuServerRes.vasForMobileSdkHash,
        "payment": payuServerRes.paymentHash
      }
    };*//*

    // return payUPaymentParams;
  }*/

  /*static Map createPayUConfigParams() {
    var paymentModesOrder = [
      {"Wallets": "PHONEPE"},
      {"UPI": "TEZ"},
      {"Wallets": ""},
      {"EMI": ""},
      {"NetBanking": ""},
    ];

    var cartDetails = [
      {"GST": "5%"},
      {"Delivery Date": "25 Dec"},
      {"Status": "In Progress"}
    ];
    var enforcePaymentList = [
      {"payment_type": "CARD", "enforce_ibiboCode": "UTIBENCC"},
    ];

   *//* var customNotes = [
      {
        "custom_note": "Its Common custom note for testing purpose",
        "custom_note_category": [PayUPaymentTypeKeys.emi, PayUPaymentTypeKeys.card]
      },
      {"custom_note": "Payment options custom note", "custom_note_category": null}
    ];*//*

   *//* var payUCheckoutProConfig = {
      PayUCheckoutProConfigKeys.primaryColor: "#4994EC",
      PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
      PayUCheckoutProConfigKeys.merchantName: "PayU",
      PayUCheckoutProConfigKeys.merchantLogo: "logo",
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
      PayUCheckoutProConfigKeys.cartDetails: cartDetails,
      PayUCheckoutProConfigKeys.paymentModesOrder: paymentModesOrder,
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 30000,
      PayUCheckoutProConfigKeys.customNotes: customNotes,
      PayUCheckoutProConfigKeys.autoSelectOtp: true,
      // PayUCheckoutProConfigKeys.enforcePaymentList: enforcePaymentList,
      PayUCheckoutProConfigKeys.waitingTime: 30000,
      PayUCheckoutProConfigKeys.autoApprove: true,
      PayUCheckoutProConfigKeys.merchantSMSPermission: true,
      PayUCheckoutProConfigKeys.showCbToolbar: true,
    };*//*
    // return payUCheckoutProConfig;
  }*/
}
