import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../components/widgets/base_widget.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({Key? key}) : super(key: key);

  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  bool isDataNotFound = false;

  int page = 1;
  bool nextFlag = false;
  bool pageFlag = false;

  @override
  void initState() {
    super.initState();
    var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
    marketModel.clearMyOrderList();
    fetchMyOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(builder: (context, marketPlaceModel, child) {
      return SafeArea(
        child: BaseWidget(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xff27914F),
              iconTheme: const IconThemeData(color: Colors.white),
              title: WidgetUtils.appTextWidget(context: context, title: 'My Order'.tr, color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            child: marketPlaceModel.myOrderList.isEmpty
                ? Center(
                    child: Text(
                      'No order Place yet'.tr,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: 'Graphik'),
                      textAlign: TextAlign.left,
                    ),
                  )
                : Container(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                          setState(() {
                            if (!nextFlag) {
                              if (!pageFlag) {
                                page += 1;
                                pageFlag = true;
                                fetchMyOrder();
                              }
                            }
                          });
                        }
                        return true;
                      },
                      child: ListView(children: [
                        ListView.builder(
                            itemCount: marketPlaceModel.myOrderList.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return buildOrderItem(marketPlaceModel.myOrderList[index], index);
                            })
                      ]),
                    ),
                  )),
      );
    });
  }



  buildOrderItem(MyOrderData myOrderData, int index) {
    Color statusColors = const Color(0xffFF0000), statusColor = const Color(0xffFF0000);
    statusColor = HelperUtils().getColorStatus(myOrderData.status!);
    statusColors = HelperUtils().getColorStatus(myOrderData.payment_status!);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(myOrderData.orderDate);
    DateFormat dateFormat2 = DateFormat("dd MMM yyyy hh:mm a");
    var date = dateFormat2.format(dateTime);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OrderDetailsScreen(myOrderData)));
        },
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        child: Row(
                      children: [
                        const Text(
                          "Order Id :",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                        ),
                        Text(
                          myOrderData.id,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.green, fontSize: 14.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                        ),
                      ],
                    )),
                    const SizedBox(height: 5),
                    SizedBox(
                      child: Row(
                        children: [
                          const Text(
                            "Status :",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                          ),
                          Text(
                            myOrderData.status,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: statusColor, fontSize: 14.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Payment Status :",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                          ),
                          Text(
                            myOrderData.payment_status ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: statusColors, fontSize: 14.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      child: Row(
                        children: [
                          const Text(
                            "Date :",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                          ),
                          Text(
                            date,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.green, fontSize: 14.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      child: Row(
                        children: [
                          const Text(
                            "Total Amount : ",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "₹" + myOrderData.amount!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.green, fontSize: 16.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  fetchMyOrder() async {
    try {
      setState(() {
        isLoading.value = true;
      });
      var param = {"start": page.toString(), "client_id": HeaderSingleton().paramsMaps!.userId!};
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.getOrderList);
        http.Response response = await http.post(fetchSchoolsUri, headers: headerParams, body: param);
        var data = json.decode(response.body);
        MyOrderResponse res = MyOrderResponse.fromJson(data);
        if (res.status != 1) {
          WidgetUtils.errorDialog(context, res.message);
          setState(() {
            nextFlag = true;
          });
        } else {
          if (res.data.isEmpty) {
            setState(() {
              nextFlag = true;
            });
          } else {
            var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
            marketModel.setMyOrderList(res.data);
            setState(() {
              pageFlag = false;
            });
          }
        }
      } else {
        setState(() {
          isDataNotFound = true;
        });
      }
    } catch (e) {
      rethrow;
    }
    setStateIfMounted(() {
      isLoading.value = false;
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  verifyOrder() async {
    try {
      setState(() {
        isLoading.value = true;
      });

      var param = {"client_id": HeaderSingleton().paramsMaps!.userId!};
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.verifyPayments);

        http.Response response = await http.post(fetchSchoolsUri, headers: headerParams, body: param);
        var data = json.decode(response.body);
        // print(data);

        fetchMyOrder();
      } else {
        fetchMyOrder();
      }
    } on SocketException {
    } catch (e) {
      // print(e);
      fetchMyOrder();
    }
    setStateIfMounted(() {
      isLoading.value = false;
    });
  }
}
