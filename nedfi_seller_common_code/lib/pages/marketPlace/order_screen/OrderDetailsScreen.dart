import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../components/widgets/base_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  MyOrderData myOrderData;

  OrderDetailsScreen(this.myOrderData, {super.key});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  var date,planDetails,amount,status,payment_status,orderDate ='';
  Color statusColor = const Color(0xffFF0000), statusColors = const Color(0xffFF0000);

  @override
  void initState() {
    super.initState();
    fetchProductOrders();
    planDetails=widget.myOrderData.planDetails;
    amount= widget.myOrderData.amount;
    status= widget.myOrderData.status;
    payment_status=widget.myOrderData.payment_status;
    orderDate=widget.myOrderData.orderDate;
  }

  @override
  Widget build(BuildContext context) {
    statusColor = HelperUtils().getColorStatus(status);
    statusColors = HelperUtils().getColorStatus(payment_status??"");

    if(orderDate!="") {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime dateTime = dateFormat.parse(orderDate);
      DateFormat dateFormat2 = DateFormat("dd MMM yyyy hh:mm a");
       date = dateFormat2.format(dateTime);
    }

    return Consumer<MarketPlaceProvider>(builder: (context, marketPlaceModel, child) {
      return BaseWidget(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xff27914F),
          iconTheme: const IconThemeData(color: Colors.white),
          title: WidgetUtils.appTextWidget(context: context, title: "Order Details".tr, color: Colors.white, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
        ),
        child: ListView(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  children: [
                    Flexible(
                      flex: 9,
                      child: Column(
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
                                widget.myOrderData.id,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.green, fontSize: 14.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                              ),
                            ],
                          )),
                          const SizedBox(height: 5),
                          SizedBox(
                            // width: MediaQuery.of(context).size.width - 50,
                            child: Row(
                              children: [
                                const Text(
                                  "Status :",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                                ),
                                Text(
                                 status,
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
                                 payment_status ?? "",
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
                                  date??"",
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
                                  "₹" + amount!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.green, fontSize: 16.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: SizedBox(
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                     planDetails ?? "",
                                      style: const TextStyle(color: Colors.green),
                                    ))),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "Product List :",
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14.0, fontFamily: 'Graphik'),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: ListView.builder(
                  itemCount: marketPlaceModel.oderDetailsList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return productItem(marketPlaceModel.oderDetailsList[index]);
                  },
                )),
          ],
        ),
      );
    });
  }

  productItem(ProductsList marketProductData) {
    var homeDashboardModel = Provider.of<HomeDashboardProvider>(context, listen: false);
    Color statusColor = const Color(0xffFF0000);
    statusColor = HelperUtils().getColorStatus(marketProductData.status);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: FadeInImage.assetNetwork(
                    placeholder: image,
                    imageErrorBuilder: (ctx, obj, st) => Image.file(File(image), fit: BoxFit.fill),
                    image: homeDashboardModel.configUrl.marketCatImageUrl + "/" + marketProductData.logo,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(marketProductData.productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: 'Graphik')),
                    const SizedBox(width: 10),
                    Text(
                      "Qty: ${marketProductData.quantity} / ${marketProductData.unit}",
                      style: const TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'price: ₹${marketProductData.sub_total}',
                      style: const TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Status :",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        ),
                        Text(
                          marketProductData.status,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: statusColor, fontSize: 12.0, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Text(
                      marketProductData.deliveryDays,
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: Colors.grey, fontSize: 14.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  fetchProductOrders() async {
    try {
      setState(() {
        isLoading.value = true;
      });
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.userOrderDetails + "/" + widget.myOrderData.id);
        http.Response response = await http.get(fetchSchoolsUri, headers: headerParams);
        var data = json.decode(response.body);
        MarketProductResponse res = MarketProductResponse.fromJson(data);
        var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        if (res.status != 1) {
          marketModel.setMarketProductList([]);
        } else {
          if (res.data.isEmpty) {
            marketModel.setMarketProductList([]);
          } else {
            marketModel.setOderDetailsList(res.data);
            setState(() {
              planDetails=res.orderData?[0].planDetails;
              amount=res.orderData?[0].amount;
              status=res.orderData?[0].status??"";
              payment_status=res.orderData?[0].payment_status??"";
              orderDate=res.orderData?[0].orderDate??"";
              statusColor = HelperUtils().getColorStatus(status);
              statusColors = HelperUtils().getColorStatus(payment_status??"");
              if(orderDate!="") {
                DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
                DateTime dateTime = dateFormat.parse(orderDate);
                DateFormat dateFormat2 = DateFormat("dd MMM yyyy hh:mm a");
                date = dateFormat2.format(dateTime);
              }
            });
          }
        }
      } else {
        var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        marketModel.setMarketProductList([]);
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
}
