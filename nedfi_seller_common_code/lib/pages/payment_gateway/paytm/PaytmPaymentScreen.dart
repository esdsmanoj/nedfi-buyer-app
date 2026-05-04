import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../components/utils/EditText.dart';
import 'package:nedfi_seller_common_code/app_imports.dart';

class PaytmPaymentScreen extends StatefulWidget {
  const PaytmPaymentScreen({Key? key}) : super(key: key);

  @override
  _PaytmPaymentScreenState createState() => _PaytmPaymentScreenState();
}

class _PaytmPaymentScreenState extends State<PaytmPaymentScreen> {
  String mid = "ietInV03106399887818", orderId = "", amount = "", txnToken = "";
  String result = "";
  bool isStaging = false;
  bool isApiCallInprogress = false;
  String callbackUrl = "";
  bool restrictAppInvoke = false;
  bool enableAssist = true;
  late UserData paramsMaps;
  final String website = "WEBSTAGING"; //"DEFAULT";
  final String url = 'https://flutter-paytm-backend.herokuapp.com/generateTxnToken';
  final String mKey = "ImFNW&b9DK7lMFnD";

  @override
  void initState() {
    // print("initState");
    super.initState();
    paramsMaps = UserData();
    getUserModel(context).then((value) {
      paramsMaps = value;
      orderId = "ORDERID_" + DateTime.now().millisecondsSinceEpoch.toString();
      paymentToken();
      //generateTxnToken(100,orderId);
    });
  }

  Future<UserData> getUserModel(BuildContext context) async {
    paramsMaps = (await SharePrefsHelper.getInstance(context)?.getUserModel())!;
    return paramsMaps;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              EditText('Merchant ID', mid, onChange: (val) => mid = val),
              EditText('Order ID', orderId, onChange: (val) => orderId = val),
              EditText('Amount', amount, onChange: (val) => amount = val),
              EditText('Transaction Token', txnToken, onChange: (val) => txnToken = val),
              Row(
                children: <Widget>[
                  Checkbox(
                      activeColor: const Color(0xFF27914F),
                      value: isStaging,
                      onChanged: (bool? val) {
                        setState(() {
                          isStaging = val!;
                        });
                      }),
                  const Text("Staging")
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                      activeColor:const Color(0xFF27914F),
                      value: restrictAppInvoke,
                      onChanged: (bool? val) {
                        setState(() {
                          restrictAppInvoke = val!;
                        });
                      }),
                  const Text("Restrict AppInvoke")
                ],
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: isApiCallInprogress
                      ? null
                      : () {
                          _startTransaction();
                        },
                  child: const Text('Start Transcation'),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: const Text("Message : "),
              ),
              Text(result),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startTransaction() async {
    if (txnToken.isEmpty) {
      return;
    }
    var sendMap = <String, dynamic>{
      "mid": mid,
      "orderId": orderId,
      "amount": amount,
      "txnToken": txnToken,
      "callbackUrl": callbackUrl,
      "isStaging": isStaging,
      "restrictAppInvoke": restrictAppInvoke,
      "enableAssist": enableAssist
    };
    // print(sendMap);
    try {
      /*var response = AllInOneSdk.startTransaction(mid, orderId, amount, txnToken, "", isStaging, restrictAppInvoke, enableAssist);
      response.then((value) {
        // print(value);
        setState(() {
          result = value.toString();
        });
      }).catchError((onError) {
        if (onError is PlatformException) {
          // print("err11");
          // print(onError);
          setState(() {
            result = onError.message.toString() + " \n  " + onError.details.toString();
          });
        } else {
          setState(() {
            // print("err12");
            result = onError.toString();
            // print(result);
          });
        }
      });*/
    } catch (err) {
      result = err.toString();
      // print("err13");
      // print(err);
    }
  }

  String getMap(double amount, String callbackUrl, String orderId) {
    return json.encode({
      "mid": mid,
      "key_secret": mKey,
      "website": website,
      "orderId": orderId,
      "amount": amount.toString(),
      "callbackUrl": callbackUrl,
      "custId": "122",
    });
  }

  Future<void> generateTxnToken(double amount, String orderId) async {
    final callBackUrl = 'https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId';
    final body = getMap(amount, callBackUrl, orderId);

    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {'Content-type': "application/json"},
      );
      setState(() {
        txnToken = response.body;
      });
      await _startTransaction();
    } catch (e) {
      // print(e);
    }
  }

  paymentToken() async {
    try {
      String varifyurl = "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID" + orderId;
      // // var headerModel = Provider.of<HeaderModel>(context, listen: false);
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse("https://dev.famrut.com/payment/paytm-master/index.php");

        // print(fetchSchoolsUri);
        var param = {
          "MID": mid,
          "ORDER_ID": orderId,
          "CUST_ID": paramsMaps.userId!,
          "CHANNEL_ID": "WAP",
          "TXN_AMOUNT": "100",
          "WEBSITE": "WEBSTAGING",
          "CALLBACK_URL": varifyurl,
          "INDUSTRY_TYPE_ID": "Retail"
        };
        http.Response response = await http.post(fetchSchoolsUri, body: param, headers: headerParams);
        var data = json.decode(response.body);
        // print(data);

        if (data["CHECKSUMHASH"] != null) {
          txnToken = data["CHECKSUMHASH"];
        }
        if (data["ORDER_ID"] != null) {
          //  orderId=data["ORDER_ID"];
        }
      } else {
        WidgetUtils.informationDialog(context, AppTranslations.of(context)?.text("key_connection_lost") ?? 'key_connection_lost'.tr);
      }
    } on SocketException {
      WidgetUtils.informationDialog(context, 'key_connection_lost'.tr);
    } catch (e) {
      // print(e);
      // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
    }
    setStateIfMounted(() {
      // _isLoading = false;
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
