import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SelectPickupPointScreen extends StatefulWidget {
  const SelectPickupPointScreen({Key? key}) : super(key: key);

  @override
  _SelectPickupPointScreenState createState() => _SelectPickupPointScreenState();
}

class _SelectPickupPointScreenState extends State<SelectPickupPointScreen> {
  String _loadingText = 'Loading..';
  bool? _isLoading;
  List<ProductsList> marketProductList = [];
  bool isDataNotFound = false, apiCall = false;
  late PickUpPointData pickUpPoint;
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  late HomeDashboardProvider homeDashboardModel;
  var orderId = "", paymentId = "", signature = "", isSelected = 0;

  @override
  void initState() {
    super.initState();
    // _initLoaction();
    print("Called");
    homeDashboardModel = Provider.of<HomeDashboardProvider>(context, listen: false);
    HelperUtils().initLocation(context,(Tuple2<String, String> item) {
      if(item.item1.isNotEmpty && item.item2.isNotEmpty){
        homeDashboardModel.setLatLog(item.item1.toString(), item.item2.toString());
        if (!apiCall) {
          checkPickupLocation();
          setState(() {
            apiCall = true;
          });
        }
      }
    }, () => setState(() {}));

    var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);

    _isLoading = false;
    _loadingText = 'Loading . . .';
    getProductList(context).then((value) {
      setState(() {
        marketProductList = value;
        marketModel.setCartProductList(marketProductList);
        checkPickupLocation();
      });
    });
  }

  Future<List<ProductsList>> getProductList(BuildContext context) async {
    return SQLiteDbProvider.db.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MarketPlaceProvider, UserLoanProfileProvider>(builder: (context, marketPlaceModel, profileModel, child) {
      return SafeArea(
        child: CustomProgressHandler(
            isLoading: _isLoading!,
            loadingText: _loadingText,
            child: Scaffold( backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor:Color(int.parse(themeColor.value.barColor!.color!)),
                iconTheme: const IconThemeData(color: Colors.white),
                title: WidgetUtils.appTextWidget(context: context, title: 'Select pickup point'.tr, color: Colors.white, fontSize: 18),
              ),
              body: isDataNotFound
                  ? Center(
                      child: Text('No Pickup point available............'.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.left),
                    )
                  : ListView.builder(
                      itemCount: marketPlaceModel.pickUpPointlist.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return _pickupPointItem(marketPlaceModel.pickUpPointlist[index], index);
                      },
                    ),
              bottomNavigationBar: SizedBox(
                height: 70,
                child: isDataNotFound
                    ? Container()
                    : Card(
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('₹' + marketPlaceModel.prise.toString() + " | " + marketPlaceModel.cartProductList.length.toString() + " Items",
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.left),
                            ),
                            SizedBox(
                              width: 170,
                              child: CustomDarkButton(
                                onPressed: () async {
                                  // checkout();

                                  /* String environment = "QA";
                                    String merchantId = "T_99143";
                                    String appId = "f36fd341200411cd";
                                    String merchantName = "ESDS Test";

                                    final _fluttersdkPlugin = Fluttersdk();
                                    _fluttersdkPlugin.setAppInfo(environment, merchantId, appId, merchantName);
                                    _fluttersdkPlugin.makePayment(      "10",      "T_99143",      "20230131055923",      "+91",      'esds@esds.test.com',      "aa9b90d31cf131fff742bf1dac71aab90e48b9b10f2fa94b124694012e80161a");
*/

                                  paymentGateway(marketPlaceModel.prise.toString());

                                  // try {
                                  //   String environment = "QA";
                                  //   String merchantId = 'P_30334';//'P_30334';//res.data.merchantId; //get merchantId
                                  //   String appId = '80bc18249511f868';//res.data.secretKey; //get appId
                                  //   String merchantName = "ESDS"; //Getting merchant name
                                  //   String? setAppInfoResult = await Fluttersdk()
                                  //       .setAppInfo("prod", merchantId, appId, merchantName);
                                  //   setState(() {
                                  //     debug// print("setAppInfoResult => $setAppInfoResult");
                                  //   });
                                  //
                                  //   final orderId = 100000 + Random().nextInt(900000);
                                  //   String invoiceNumber = '000000$orderId';
                                  //   String? paymentResponse = "";
                                  //   setState(() {
                                  //     order_id = invoiceNumber;
                                  //   });
                                  //   await checkout();
                                  //   paymentResponse = await Fluttersdk().makePayment(
                                  //       marketPlaceModel.prise.toString(), merchantId, invoiceNumber, "356", "", "secureToken");
                                  //   String response = paymentResponse
                                  //       .toString()
                                  //       .substring(25, paymentResponse.toString().length);
                                  //   response = response
                                  //       .toString()
                                  //       .replaceAll("=", ":")
                                  //       .substring(1, response.toString().length - 1);
                                  //   final listResult = response.split(",");
                                  //
                                  //   Map<String, dynamic> resultMap = {};
                                  //   for (final details in listResult) {
                                  //     final splitKey = details.split(":");
                                  //     resultMap[splitKey[0].trim()] = splitKey[1].trim();
                                  //   }
                                  //   PayPhiSuccess payPhiSuccess = PayPhiSuccess.fromJson(resultMap);
                                  //   if (payPhiSuccess.respDescription == "Transaction successful") {
                                  //     payment_id = payPhiSuccess.paymentID!;
                                  //     checkout();
                                  //   } else if (payPhiSuccess.respDescription ==
                                  //       "Transaction Rejected") {
                                  //     failedOrder();
                                  //   }
                                  //   // });
                                  // } on PlatformException {
                                  //   rethrow;
                                  // } catch (e) {
                                  //   // print(e);
                                  // }

                                  // razorPayOrder(marketPlaceModel.prise.toString());
                                  // paytmOrder(marketPlaceModel.prise.toString());
                                  /*  Razorpay razorpay = Razorpay();
                                    var options = {
                                      'key': 'rzp_test_kwOKNsg8RvtFrM',
                                      'amount': marketPlaceModel.prise,
                                      'name': 'Acme Corp.',
                                      'description': 'Fine T-Shirt',
                                      'retry': {'enabled': true, 'max_count': 1},
                                      'send_sms_hash': true,
                                      'order_id':'order_KuXuAfOcpLlNt6',
                                      'prefill': {'contact': profileModel.datas[0].phone??"", 'email': profileModel.datas[0].email??""},
                                      'external': {
                                        'wallets': ['paytm']
                                      }
                                    };
                                    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                                    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                                    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                                    razorpay.open(options);*/
                                },
                                caption: 'Place Order'.tr,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            )),
      );
    });
  }

  _pickupPointItem(PickUpPointData pickUpPointData, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            pickUpPoint = pickUpPointData;
            isSelected = index;
          });
        },
        child: Container(
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: const Color(0xff92b89e).withOpacity(0.7), offset: const Offset(0, 15), blurRadius: 16.0),
              ],
              border: Border.all(color: const Color(0xff10ad42), width: 1.0, style: BorderStyle.solid),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 30.0,
                        width: 30.0,
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected == index ? Colors.green : Colors.transparent,
                          border: Border.all(width: 1.0, color: isSelected == index ? Colors.green : Colors.grey),
                          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 230,
                        child: Text(
                          pickUpPointData.address,
                          style: const TextStyle(color: Color(0XFF000000), fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future checkPickupLocation() async {
    try {
      setState(() {
        _isLoading = true;
      });
      var homeDashboardModel = Provider.of<HomeDashboardProvider>(context, listen: false);
      // // var headerModel = Provider.of<HeaderModel>(context, listen: false);
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.checkPickupLocation + "/" + marketProductList[0].id + "/" + homeDashboardModel.lat + "/" + homeDashboardModel.log);
        http.Response response = await http.get(fetchSchoolsUri, headers: headerParams);
        var data = json.decode(response.body);
        PickUpPointResponse res = PickUpPointResponse.fromJson(data);
        var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        if (res.status != 1) {
          setState(() {
            isDataNotFound = true;
          });
        } else {
          if (res.data.isEmpty) {
            setState(() {
              isDataNotFound = true;
            });
          } else {
            pickUpPoint = res.data[0];
            marketModel.setPickUpPointList(res.data);
          }
        }
      } else {
        var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        marketModel.setMarketProductList([]);
        /* WidgetUtils.errorDialog(context, 'key_connection_lost'.tr,
            2);*/
      }
    } on SocketException {
      /*WidgetUtils.errorDialog(context, 'key_connection_lost'.tr,
          2);*/
    } catch (e) {
      // print(e);
      // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
    }
    setStateIfMounted(() {
      _isLoading = false;
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  razorPayOrder(String prise, String marchantKey, String mode) async {
    try {
      setState(() {
        _isLoading = true;
      });
      // // var headerModel = Provider.of<HeaderModel>(context, listen: false);
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.paymentGenerateOrder);
        // print(fetchSchoolsUri);
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
        if (mode == "sandbox") {
        } else {}

        Map<String, dynamic> params1 = {
          "receipt": Random().nextInt(10000).toString(),
          "amount": prise,
          "cart_prod_ids": productID,
          "cart_prod_quantity": productQTY,
        };

        http.Response response = await http.post(fetchSchoolsUri, headers: headerParams, body: params1);
        var data = json.decode(response.body);
        // print(data);
        RazorpayOrder res = RazorpayOrder.fromJson(data);
        var profileModel = Provider.of<UserLoanProfileProvider>(context, listen: false);
        if (res.status != "1") {
        } else {
          setState(() {
            _isLoading = true;
          });
          Timer(const Duration(seconds: 5), () {
            setState(() {
              _isLoading = false;
            });
          });
          setState(() {
            orderId = res.data.id;
          });
          // Razorpay razorpay = Razorpay();
          var options = {
            'key': marchantKey,
            'amount': prise,
            'name': 'Famrut',
            'description': '',
            'retry': {'enabled': true, 'max_count': 1},
            'send_sms_hash': true,
            'order_id': res.data.id,
            'prefill': {'contact': profileModel.profileData[0].phone ?? "", 'email': profileModel.profileData[0].email ?? ""},
            'external': {
              'wallets': ['paytm']
            }
          };

         /* razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
          razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
          razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
          razorpay.open(options);*/
        }
      } else {
        /* WidgetUtils.errorDialog(context, 'key_connection_lost'.tr,
            2);*/
      }
    } on SocketException {
      /*WidgetUtils.errorDialog(context, 'key_connection_lost'.tr,
          2);*/
    } catch (e) {
      // print(e);
      // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
    }
    setStateIfMounted(() {
      _isLoading = false;
    });
  }

  paytmOrder(String prise, String mid) async {
    try {
      setState(() {
        _isLoading = true;
      });
      // // var headerModel = Provider.of<HeaderModel>(context, listen: false);
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.paytmPaymentGenerateOrder);
        // print(fetchSchoolsUri);
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
        var orderId = "ORDED_" + Random().nextInt(10000).toString();
        Map<String, dynamic> params1 = {
          "receipt": Random().nextInt(10000).toString(),
          "amount": prise,
          "cart_prod_ids": productID,
          "cart_prod_quantity": productQTY,
          "mid": mid,
          "orderId": orderId,
          "custId": HeaderSingleton().paramsMaps!.userId
        };

        http.Response response = await http.post(fetchSchoolsUri, headers: headerParams, body: params1);
        var data = json.decode(response.body);
        // print(data);
        PaytmToken res = PaytmToken.fromJson(data);
        if (res.status != "1") {
        } else {
          String result = '';
          try {
            // var response = AllInOneSdk.startTransaction(
            //   mid,
            //   orderId,
            //   prise.toString(),
            //   res.data.body.txnToken,
            //   "callBackUrl",
            //   true,
            //   true,
            // );
            // response.then((value) {
            //   updateOrder();
            //   // print(value);
            // }).catchError((onError) {
            //   if (onError is PlatformException) {
            //     result = onError.message! + " \n " + onError.details.toString();
            //     // print(result);
            //   } else {
            //     result = onError.toString();
            //     // print(result);
            //   }
            // });
          } catch (err) {
            // Transaction failed
            result = err.toString();
            // print(result);
          }
        }
      }
    } catch (e) {
      // print(e);
      // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
    }
    setStateIfMounted(() {
      _isLoading = false;
    });
  }

  Future updateOrder({bool? isStatus = false}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var headerModel = Provider.of<HeaderSingleton>(context, listen: false);

      Map<String, dynamic> params1 = {
        "order_id": orderId,
        "payment_id": paymentId,
        "signature": signature,
      };
      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.update_client_order), body: params1, headers: headerParams);
      var data = json.decode(response.body);
      // print(data);
      var res = CommonModel.fromJson(data);
      if (res.status == 1 && !isStatus!) {
        var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        marketPlaceModel.setClearCart();
        SQLiteDbProvider.db.deleteAll();
        WidgetUtils.successDialog(context, res.message);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OrderThankYouScreen(massage: res.pickupMsg)), (Route<dynamic> route) => false);
      } else {
        WidgetUtils.errorDialog(context, res.message);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future paymentGateway(String prise) async {
    setState(() {
      _isLoading = true;
    });
    try {
      // // var headerModel = Provider.of<HeaderModel>(context, listen: false);
      http.Response response = await http.get(Uri.parse(baseURL + ApiURL.paymentGateway), headers: headerParams);
      var data = json.decode(response.body);
      // print(data);
      var res = PaymentGateway.fromJson(data);
      if (res.status == "1") {
        if (res.data.title.toLowerCase() == "razorpay") {
          /*  if(res.data.mode.toLowerCase()=="sandbox"){
            razorPayOrder("1", res.data.merchantKey);
          }else{*/
          razorPayOrder(prise, res.data.merchantKey, res.data.mode);
          //}
        } else if (res.data.title.toLowerCase() == "paytm") {
          if (res.data.mode.toLowerCase() == "sandbox") {
            paytmOrder("1", res.data.merchantId);
          } else {
            paytmOrder(prise, res.data.merchantId);
          }
        } else if (res.data.title.toLowerCase() == "payphi") {
          await checkout();
        } else if (res.data.title.toLowerCase() == "cod") {
          final Tuple2 result = await checkout();
          if (result.item1 == 1) {
            var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
            marketPlaceModel.setClearCart();
            SQLiteDbProvider.db.deleteAll();
            WidgetUtils.successDialog(context, result.item2);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OrderThankYouScreen(massage: result.item2)), (Route<dynamic> route) => false);
          }
        }
      } else {
        if (res.data.title.toLowerCase() == "cod") {
          await checkout();
          var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
          marketPlaceModel.setClearCart();
          SQLiteDbProvider.db.deleteAll();
        }
        // WidgetUtils.errorDialog(context, res.message, 3);
      }
      setState(() {
        _isLoading = false;
      });
    } on SocketException {
      /* WidgetUtils.errorDialog(context, 'key_connection_lost'.tr,2);*/
    } catch (e) {
      // print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future checkout() async {
    setState(() {
      _isLoading = true;
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
        "first_name": HeaderSingleton().paramsMaps!.firstName,
        "last_name": HeaderSingleton().paramsMaps!.lastName,
        "email_id": HeaderSingleton().paramsMaps!.email,
        "cphone": HeaderSingleton().paramsMaps!.phone,
        "country": "IN",
        "billing_state": "",
        "billing_city": "",
        "billing_village": HeaderSingleton().paramsMaps!.village,
        "billing_pin_code": HeaderSingleton().paramsMaps!.postcode,
        "billing_address1": HeaderSingleton().paramsMaps!.address1,
        "company_name": "",
        "cart_prod_ids": productID,
        "cart_prod_quantity": productQTY,
        "btn_submit": "submit",
        "pickup_location_id": pickUpPoint.id,
        "order_id": orderId,
        "payment_id": paymentId,
        "signature": signature,
      };
      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.addClientOrder), body: params1, headers: headerParams);
      var data = json.decode(response.body);
      // print(data);
      var res = CommonModel.fromJson(data);
      if (res.status == 1) {
        if (res.redirectPaymentGatewayUrl != null || res.redirectPaymentGatewayUrl != "") {
          var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
          marketPlaceModel.setClearCart();
          SQLiteDbProvider.db.deleteAll();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PayphiIFrameScreen(orderId: res.orderId.toString(), domain: HeaderSingleton().appName.value, url: res.redirectPaymentGatewayUrl)));
        }
        return Tuple2(res.status, res.pickupMsg);
      } else {
        WidgetUtils.errorDialog(context, res.message);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

 /* void handlePaymentErrorResponse(PaymentFailureResponse response) {
    *//*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * *//*
    failedOrder();
    WidgetUtils.errorDialog(context, 'Payment Failed'.tr);
    //showAlertDialog(context, "Payment Failed",
    //  "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }*/

  Future failedOrder() async {
    setState(() {
      _isLoading = true;
    });
    try {
      //var headerModel =
      //    Provider.of<HeaderModel>(context, listen: false);
      var params = {"status": "Failed", "order_id": orderId};

      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.paymentStatus), headers: headerParams, body: params);
      var data = json.decode(response.body);
      // print(baseURL + ApiURL.paymentStatus);
      // print(data);
      var res = CommonModel.fromJson(data);
      if (res.status == "1") {
      } else {}

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // print(e.toString());
      setState(() {
        _isLoading = false;
      });
      /*WidgetUtils.errorDialog(context, 'Not_able_to_get_Menu'.tr,
          2);*/
    }
  }

  /*void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    *//*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * *//*
    setState(() {
      orderId = response.orderId!;
      paymentId = response.paymentId!;
      signature = response.signature!;
    });
    // failedOrder();
    updateOrder();
    // print("Payment ID: ${response.paymentId}");
    // print("Order ID: ${response.orderId}");
    // print("Signature: ${response.signature}");
    //showAlertDialog(
    //   context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }*/

  /*void handleExternalWalletSelected(ExternalWalletResponse response) {
    WidgetUtils.errorDialog(context, 'External Wallet Selected'.tr);
    *//*showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");*//*
  }*/

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
