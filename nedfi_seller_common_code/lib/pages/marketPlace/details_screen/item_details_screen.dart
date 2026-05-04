import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';

import '../../../components/widgets/base_widget.dart';

class ItemDetailsScreen extends StatefulWidget {
  static const routeName = 'item-details-screen/';
  final ProductsList item;

  const ItemDetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late final ProductsList item;
  var unescape = HtmlUnescape();
  List<ProductsList> marketProductList = [];
  bool flagInCart = false;
  late UserData paramsMaps;
  String orderBeforeTime = "";
  var qty = 1;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    isLoading.value = true;
    getDetails();
    isLoading.value = false;
  }

  Future getDetails() async {
    try {
      productDetailList.value = await getProductList(context);
      marketProductList = productDetailList.value;
      for (final element in productDetailList.value) {
        if (item.id == element.id) {
          setState(() {
            flagInCart = true;
            item.qty = element.qty;
            qty = int.parse(element.qty ?? "1");
          });
        }
      }
      await getOrderBeforeTime();
    } catch (e) {
      isLoading.value = false;
    }
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
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(widget.item.productName, style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Graphik', color: Colors.white, fontSize: 16)),
            actions: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: IconButton(
                      onPressed: () async {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const CartItemsScreen()));
                        getDetails();
                        setState(() => isLoading.value = false);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.shopping_cart, size: 25.0, color: Colors.white),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: productDetailList,
                    builder: (ctx, List<ProductsList> value, child) {
                      return value.isNotEmpty
                          ? Positioned(
                              top: 8,
                              right: 3,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                                child: Text(
                                  productDetailList.value.length.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontFamily: 'Graphik', fontSize: 11.0, fontWeight: FontWeight.w500),
                                ),
                              ))
                          : Container();
                    },
                  ),
                ],
              )
            ]),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    color: const Color(0xffFFEEF0),
                    height: MediaQuery.of(context).size.height * 0.36,
                    width: double.maxFinite,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          height: MediaQuery.of(context).size.height * 0.36,
                          width: double.maxFinite,
                          imageUrl:
                              '${(HeaderSingleton().configurationDetails != null ? HeaderSingleton().configurationDetails!.marketCatImageUrl : Provider.of<HomeDashboardProvider>(context, listen: false).configUrl.marketCatImageUrl)}'
                                      "/" +
                                  item.logo,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                          ),
                          placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                          errorWidget: (context, url, error) => Image.file(File(image), height: 300, fit: BoxFit.cover),
                        ),
                        item.discount != null && item.discount != "0"
                            ? Positioned(
                            right: -2,
                            top: 7,
                            child: Container(
                              alignment: Alignment.center,
                              height: 20,
                              width: 50,
                              child: Text((item.discount ?? "") + "%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 16, fontFamily: 'Graphik')),
                              decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(16)), color: Colors.red.shade400),
                            ))
                            : Container(),
                      ],
                    )),
                const SizedBox(height: 26),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: WidgetUtils.appTextWidget(context: context, title: item.productName, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.black)),
                    //WidgetUtils.appTextWidget(context: context, title: "₹${item.price}", fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w600, color: const Color(0xff27914F)),
                  ]),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(

                            child: Text(
                              ('${item.unit_desc} ${item.unit}'),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w400, fontFamily: 'Graphik'),
                            )),
                        SizedBox(


                          child: Text(
                            int.parse(item.inStockAlert) <= int.parse(item.inStock)
                                ? ""
                                : item.inStock == "0"
                                ? 'Out of stock'.tr
                                : item.inStock + " left",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: const TextStyle(color: Colors.red, fontSize: 18.0, fontWeight: FontWeight.w400, fontFamily: 'Graphik'),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      item.mrp != null
                          ? Padding(
                        padding: const EdgeInsets.only(left: 8.0,right:8,bottom: 6),
                        child: Text("₹${item.mrp ?? ""}",
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w300, fontSize: 15, decoration: TextDecoration.lineThrough, fontFamily: 'Graphik')),
                      )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,right:8,bottom: 6),
                        child: WidgetUtils.appTextWidget(context: context, title: "₹${item.price}", color: const Color(0xff27914F), fontWeight: FontWeight.w500, fontSize: 16, family: 'Graphik'),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 300,
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: _htmlText(item.brief)),
                ),
              ],
            ),
          ),
        ),
        bottomNavBar: Container(
            height: 120,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(orderBeforeTime, style: const TextStyle(color: Colors.orange, fontFamily: 'Graphik', fontSize: 14, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (item.purchaseLimit.isEmpty || int.parse(item.purchaseLimit) == 1) {
                          WidgetUtils.informationDialog(context, item.purchaseLimit == "" ? "" : 'Max Purchase Limit is'.tr + " " + (item.purchaseLimit ?? '1'));
                        } else {
                          if (int.parse(item.purchaseLimit) >= 1) {
                            if (qty > 1) {
                              qty = qty - 1;
                            }
                            marketPlaceModel.setUpdateCart(item.id, qty.toString());
                            SQLiteDbProvider.db.updatecart(item.id, qty.toString());
                          } else {}
                        }
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.height * 0.03,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 0.2)),
                        child: const Icon(Icons.remove, color: Colors.black, size: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    WidgetUtils.appTextWidget(context: context, title: '$qty', family: 'Graphik', color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        if (item.purchaseLimit.isEmpty || int.parse(item.purchaseLimit) == 1) {
                          WidgetUtils.informationDialog(context, item.purchaseLimit == "" ? "" : 'Max Purchase Limit is'.tr + " " + (item.purchaseLimit));
                        } else if (int.parse(item.purchaseLimit) > 1) {
                          // qty = int.parse(item.qty ?? "1");
                          var limit = 50;
                          if (item.purchaseLimit == "") {
                            limit = 50;
                          } else {
                            limit = int.parse(item.purchaseLimit);
                          }
                          if (int.parse(item.inStock ?? "0") > qty) {
                            if (qty < limit) {
                              qty = qty + 1;
                            } else {
                              WidgetUtils.informationDialog(context, item.purchaseLimit == "" ? "" : 'Max Purchase Limit is'.tr + " " + (item.purchaseLimit));
                            }
                          } else {
                            WidgetUtils.informationDialog(context, 'Only'.tr + " " + (item.inStock ?? "0") + " " + 'stock is available'.tr);
                          }
                          marketPlaceModel.setUpdateCart(item.id, qty.toString());
                          SQLiteDbProvider.db.updatecart(item.id, qty.toString());
                        }
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.height * 0.03,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 0.2)),
                        child: const Icon(Icons.add, color: Colors.black, size: 20),
                      ),
                    ),
                    const SizedBox(width: 30),
                    InkWell(
                      onTap: () async {
                        if (item.inStock == '0') {
                          isLoading.value = true;
                          await notifyMe();
                          isLoading.value = false;
                        } else if (!flagInCart) {
                          if (int.parse(item.inStock ?? '0') >= qty) {
                            setState(() {
                              item.type = item.unit;
                              item.qty = qty.toString();
                            });
                            SQLiteDbProvider.db.insert(item);
                            marketPlaceModel.setCartFlag(item.id);
                            marketProductList.add(item);
                            marketPlaceModel.setCartProductList(marketProductList);
                            productDetailList.value = marketPlaceModel.cartProductList;
                            setState(() {
                              flagInCart = true;
                            });
                          } else {
                            WidgetUtils.informationDialog(context, 'Only'.tr + " " + (item.inStock ?? "0") + " " + 'stock is available'.tr);
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: 185,
                        child: WidgetUtils.appTextWidget(
                            context: context,
                            title: item.inStock == "0"
                                ? 'Notify Me'.tr
                                : flagInCart
                                    ? 'Added To Cart'.tr
                                    : 'Add To Cart'.tr,
                            fontSize: 16,
                            color: Colors.white),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(64), color: const Color(0xffFFB039)),
                      ),
                    )
                  ],
                ),
              ],
            )),
      );
    });
  }

  _htmlText(String text) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: SingleChildScrollView(
            /* scrollDirection: Axis.horizontal,*/
            child: Html(
              shrinkWrap: true,
              data: unescape.convert(text),
              style: {
                "body": Style(fontSize:  FontSize(16), fontFamily: 'Graphik', fontWeight: FontWeight.w400, letterSpacing: 0.0),
                "table": Style(backgroundColor: Colors.white,fontFamily: 'Graphik', fontWeight: FontWeight.w400, ),
                // "tr": Style(padding:  EdgeInsets.all(2), border: Border.all(color: Colors.black),fontFamily: 'Graphik', fontWeight: FontWeight.w400, ),
                // "th": Style(padding:  EdgeInsets.all(2), border: Border.all(color: Colors.black),fontFamily: 'Graphik', fontWeight: FontWeight.w400, ),
                // "td": Style(padding:  EdgeInsets.all(2), border: Border.all(color: Colors.black),fontFamily: 'Graphik', fontWeight: FontWeight.w400, ),
              },
              /*customRender: {
                "table": (context, child) {
                  return SingleChildScrollView(scrollDirection: Axis.horizontal, child: (context.tree as TableLayoutElement).toWidget(context));
                }
              }*/
            ),
          ),
        ),
      ],
    );
  }

  Future getOrderBeforeTime() async {
    try {
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.getAPIMethod(url: ApiURL.orderBeforeTime);
        OrderBeforeTime res = OrderBeforeTime.fromJson(json.decode(response.body));
        if (res.success != 1) {
        } else {
          setState(() {
            orderBeforeTime = res.message;
          });
        }
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future notifyMe() async {
    try {
      // // var headerModel = Provider.of<HeaderModel>(context, listen: false);
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        var param = {"client_id": HeaderSingleton().paramsMaps!.userId, "product_id": item.id};
        final response = await APIService.postAPIMethod(url: ApiURL.clientChoice, params: param);
        var data = json.decode(response.body);
        // print(data);
        CommonModel res = CommonModel.fromJson(data);
        if (res.status != 1) {
          WidgetUtils.errorDialog(context, res.msg);
        } else {
          WidgetUtils.successDialog(context, res.msg);
        }
      } else {
        var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        marketModel.setMarketProductList([]);
        /* WidgetUtils.errorDialog(context, 'key_connection_lost'.tr,
            2);*/
      }
    } on SocketException {
      /* WidgetUtils.errorDialog(context, 'key_connection_lost'.tr,
          2);*/
    } catch (e) {
      // print(e);
      // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
