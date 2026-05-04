import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:nedfi_seller_common_code/components/widgets/base_widget.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../model/profile_model.dart';

class MyCartScreen extends StatefulWidget {
  Map<String, dynamic> params1;

  MyCartScreen(this.params1, {Key? key}) : super(key: key);

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  var deliveryCharges = "0";
  List<ProductsList> marketProductList = [];

  var orderId = "";
  var paymentId = "";
  var signature = "";

  @override
  void initState() {
    super.initState();
    var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
    getProductList(context).then((value) {
      setState(() {
        marketProductList = value;
        marketModel.setCartProductList(marketProductList);
      });
    });
    getDeliveryCharges();
  }

  Future<List<ProductsList>> getProductList(BuildContext context) async {
    return SQLiteDbProvider.db.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(builder: (context, marketPlaceModel, child) {
      return BaseWidget(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          // automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff27914F),
          title: WidgetUtils.appTextWidget(context: context, title: 'Order Summery'.tr, color: Colors.white, fontSize: 18),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shipping Address'.tr,
                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.13,
                width: double.maxFinite,
                child: Card(
                  elevation: 4,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            widget.params1["billing_address1"] +
                                ", " +
                                widget.params1["billing_village"] +
                                ", " +
                                widget.params1["billing_city"] +
                                ", " +
                                widget.params1["billing_state"] +
                                ", " +
                                widget.params1["billing_pin_code"],
                            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Price Detail".tr,
                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.185,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal'.tr,
                              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "₹ " + marketPlaceModel.prise.toStringAsFixed(2),
                              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(thickness: 0.4, color: Colors.grey),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery Fee".tr,
                              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "+ ₹ " + deliveryCharges,
                              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(thickness: 0.4, color: Colors.grey),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tax'.tr,
                              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹ " + (double.parse(deliveryCharges) + marketPlaceModel.prise).toStringAsFixed(2),
                              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavBar: Container(
          height: 80,
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tax'.tr,
                      style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₹ " + (double.parse(deliveryCharges) + marketPlaceModel.prise).toStringAsFixed(2),
                      style: const TextStyle(color: Color(0xff02A88A), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 200,
                  child: CustomDarkButton(
                    caption: 'Buy'.tr,
                    onPressed: () {
                      HelperUtils().showNormalDialog(
                          context: context,
                          title: 'Are_you_sure'.tr,
                          content: 'Do you want to place order'.tr,
                          onYesTapped: (value) async {
                            Navigator.of(value).pop(false);
                            if (widget.params1['payment_type'] == "Cash on Delivery") {
                              final result = await checkout();
                              if (result == 1) {
                                var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
                                marketPlaceModel.setClearCart();
                                SQLiteDbProvider.db.deleteAll();
                                WidgetUtils.successDialog(context, 'Order placed successfully');
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OrderThankYouScreen(massage: 'orderPlaced'.tr)), (Route<dynamic> route) => false);
                              }
                            } else {
                              paymentGateway((double.parse(deliveryCharges) + marketPlaceModel.prise).toStringAsFixed(2));
                            }
                          });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  getDeliveryCharges() async {
    try {
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.delivery_charges);
        http.Response response = await http.get(fetchSchoolsUri, headers: headerParams);
        var data = json.decode(response.body);
        DeliveryCharges res = DeliveryCharges.fromJson(data);
        if (res.success != 1) {
        } else {
          setState(() {
            deliveryCharges = res.data?.description ?? "0";
          });
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  razorPayOrder(String prise, String merchantKey, String mode) async {
    try {
      setState(() {
        isLoading.value = true;
      });
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.paymentGenerateOrder);
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
        if (mode == "sandbox") {}

        Map<String, dynamic> params1 = {"receipt": Random().nextInt(10000).toString(), "amount": prise, "cart_prod_ids": productID, "cart_prod_quantity": productQTY};

        http.Response response = await http.post(fetchSchoolsUri, headers: headerParams, body: params1);
        var data = json.decode(response.body);
        RazorpayOrder res = RazorpayOrder.fromJson(data);
        var profileModel = Provider.of<ProfileModel>(context, listen: false);
        if (res.status != "1") {
        } else {
          setState(() {
            orderId = res.data.id;
          });
          await checkout();
          setState(() {
            isLoading.value = true;
          });
          Timer(const Duration(seconds: 5), () {
            setState(() {
              isLoading.value = false;
            });
          });
        /*  Razorpay razorpay = Razorpay();
          var options = {
            'key': merchantKey,
            'amount': prise,
            'name': 'AgriEco System',
            'description': '',
            'retry': {'enabled': true, 'max_count': 1},
            'send_sms_hash': true,
            'order_id': res.data.id,
            'prefill': {'contact': profileModel.data[0].phone ?? "", 'email': profileModel.data[0].email ?? ""},
            'external': {
              'wallets': ['paytm']
            }
          };
          razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
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
      isLoading.value = false;
    });
  }

  paytmOrder(String prise, String mid) async {
    try {
      setState(() {
        isLoading.value = true;
      });
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.paymentGenerateOrder);
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
        setState(() {
          orderId = orderId;
        });
        await checkout();
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
        PaytmToken res = PaytmToken.fromJson(data);
        if (res.status != "1") {
        } else {
          String result = '';
          try {
            /*var response = AllInOneSdk.startTransaction(mid, orderId, prise.toString(), res.data.body.txnToken, "callBackUrl", true, true);
            response.then((value) {
              updateOrder();
            }).catchError((onError) {
              if (onError is PlatformException) {
                result = onError.message! + " \n  " + onError.details.toString();
              } else {
                result = onError.toString();
              }
            });*/
          } catch (err) {
            result = err.toString();
          }
        }
      }
    } catch (e) {
      rethrow;
    }
    setStateIfMounted(() {
      isLoading.value = false;
    });
  }

  paymentGateway(String prise) async {
    setState(() {
      isLoading.value = true;
    });
    try {
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
          //  if (res.data.mode.toLowerCase() == "sandbox") {
          try {
            /* String environment = "QA";
              String merchantId = res.data.merchantId; //get merchantId
              String appId = res.data.secretKey; //get appId
              String merchantName = res.data.otherKey; //Getting merchant name
              String? setAppInfoResult = await Fluttersdk()
                  .setAppInfo("QA", merchantId, appId, merchantName);
              setState(() {
                debug// print("setAppInfoResult => $setAppInfoResult");
              });

              final orderId = 100000 + Random().nextInt(900000);
              String invoiceNumber = '000000$orderId';
              String? paymentResponse = "";
              setState(() {
                order_id = invoiceNumber;
              });*/

            await checkout();
            /*  paymentResponse = await Fluttersdk().makePayment(
                  prise, merchantId, invoiceNumber, "356", "", "secureToken");
              String response = paymentResponse
                  .toString()
                  .substring(25, paymentResponse.toString().length);
              response = response
                  .toString()
                  .replaceAll("=", ":")
                  .substring(1, response.toString().length - 1);
              final listResult = response.split(",");

              Map<String, dynamic> resultMap = {};
              for (final details in listResult) {
                final splitKey = details.split(":");
                resultMap[splitKey[0].trim()] = splitKey[1].trim();
              }
              PayPhiSuccess payPhiSuccess = PayPhiSuccess.fromJson(resultMap);
              if (payPhiSuccess.respDescription == "Transaction successful") {
                payment_id = payPhiSuccess.paymentID!;
                updateOrder();
              } else if (payPhiSuccess.respDescription ==
                  "Transaction Rejected") {
                failedOrder();
              }*/
            // });
          } on PlatformException {
            rethrow;
          } catch (e) {
            rethrow;
          }
          // }
        } else if (res.data.title.toLowerCase() == "cod") {
          final result = await checkout();
          if (result == 1) {
            var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
            marketPlaceModel.setClearCart();
            SQLiteDbProvider.db.deleteAll();
            WidgetUtils.successDialog(context, 'Order placed successfully');
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OrderThankYouScreen(massage: 'orderPlaced'.tr)), (Route<dynamic> route) => false);
          }
        }
      } else {
        if (res.data.title.toLowerCase() == "cod") {
          var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
          marketPlaceModel.setClearCart();
          SQLiteDbProvider.db.deleteAll();
          await checkout();
        }
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
        "client_id": widget.params1["client_id"],
        "first_name": widget.params1["first_name"],
        "last_name": widget.params1["last_name"],
        "email_id": widget.params1["email_id"],
        "cphone": widget.params1["cphone"],
        "country": "IN",
        "billing_state": widget.params1["billing_state"],
        "billing_city": widget.params1["billing_city"],
        "billing_village": widget.params1["billing_village"],
        "billing_pin_code": widget.params1["billing_pin_code"],
        "billing_address1": widget.params1["billing_address1"],
        "company_name": "",
        "cart_prod_ids": productID,
        "cart_prod_quantity": productQTY,
        "btn_submit": "submit",
        // "pickup_location_id": "",
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
          if (widget.params1['payment_method'] == "Cash on Delivery") {
            WidgetUtils.successDialog(context, 'Order placed successfully');
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OrderThankYouScreen(massage: 'orderPlaced'.tr)), (Route<dynamic> route) => false);
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PayphiIFrameScreen(orderId: res.orderId.toString(), domain: HeaderSingleton().appName.value, url: res.redirectPaymentGatewayUrl)));
          }
        }
        return res.status;
      } else {
        WidgetUtils.errorDialog(context, res.message);
      }

      setState(() {
        isLoading.value = false;
      });
    } catch (e) {
      // print(e.toString());
      setState(() {
        isLoading.value = false;
      });
    }
  }

  updateOrder({bool? isStatus = false}) async {
    setState(() {
      isLoading.value = true;
    });
    try {
      Map<String, dynamic> params1 = {"order_id": orderId, "payment_id": paymentId, "signature": signature};
      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.update_client_order), body: params1, headers: headerParams);
      var data = json.decode(response.body);
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
        isLoading.value = false;
      });
    } catch (e) {
      setState(() {
        isLoading.value = false;
      });
    }
  }

/*  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    *//*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * *//*
    failedOrder();
    WidgetUtils.errorDialog(context, 'Payment Failed'.tr);
    *//*showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");*//*
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
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
    updateOrder();
    // print("Payment ID: ${response.paymentId}");
    // print("Order ID: ${response.orderId}");
    // print("Signature: ${response.signature}");
    //showAlertDialog(
    //   context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    WidgetUtils.errorDialog(context, 'External Wallet Selected'.tr);
    *//* showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");*//*
  }*/

  failedOrder() async {
    setState(() {
      isLoading.value = true;
    });
    try {
      var params = {"status": "Failed", "order_id": orderId};
      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.payment_status), headers: headerParams, body: params);
      var data = json.decode(response.body);
      var res = CommonModel.fromJson(data);
      if (res.status == 1) {
        await updateOrder(isStatus: true);
      } else {}

      setState(() {
        isLoading.value = false;
      });
    } catch (e) {
      setState(() {
        isLoading.value = false;
      });
    }
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: Text("Continue".tr),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [continueButton],
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
