import 'package:buyer_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartItemsScreen extends StatefulWidget {
  const CartItemsScreen({Key? key}) : super(key: key);

  @override
  _CartItemsScreenState createState() => _CartItemsScreenState();
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  List<ProductsList> marketProductList = [];
  bool isDataNotFound = false;
  String orderBeforeTime = "";
  ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future getDetails() async {
    loading.value = true;
    final marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
    marketProductList = await getProductList(context);
    if (marketProductList.isNotEmpty) {
      isDataNotFound = true;
      marketModel.setCartProductList(marketProductList);
    }
    await checkCart();
    await getOrderBeforeTime();
    loading.value = false;
    setState(() {});
  }

  Future<List<ProductsList>> getProductList(BuildContext context) async {
    return SQLiteDbProvider.db.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(builder: (context, marketPlaceModel, child) {
      return CustomProgressHandler(
        isLoading: loading.value,
        loadingText: "",
        child: Scaffold( backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, title: 'Cart'.tr, color: Colors.white, fontSize: 18),
            leading: InkWell(onTap: () => Navigator.pop(context, marketPlaceModel), child: const Icon(Icons.arrow_back, color: Colors.white)),
          ),
          body: SizedBox(
            height: double.maxFinite,
            child: marketPlaceModel.cartProductList.isEmpty
                ? Center(
                    child: WidgetUtils.appTextWidget(
                        context: context, title: 'No Product in cart'.tr, color: Colors.black, family: 'Graphik', fontWeight: FontWeight.w500, fontSize: 14, textAlign: TextAlign.left),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: marketPlaceModel.cartProductList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return buildProductItems(marketPlaceModel.cartProductList[index], index, marketPlaceModel);
                      // return productItem(marketPlaceModel.cartProductList[index]);
                    },
                  ),
          ),
          bottomNavigationBar: marketPlaceModel.cartProductList.isEmpty
              ? Container(height: 10)
              : Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    Text(orderBeforeTime, style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WidgetUtils.appTextWidget(
                            context: context,
                            title: '₹' + marketPlaceModel.prise.toString() + " | " + marketPlaceModel.cartProductList.length.toString() + " Items",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.050,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: CustomDarkButton(
                              onPressed: () async {
                                loading.value = true;
                                // PaytmConfig().generateTxnToken(100, "ORDERID_"+DateTime.now().millisecondsSinceEpoch.toString());
                                /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DeliverySelectionScreen()));*/
                                await checkCartProceed();
                                loading.value = false;
                              },
                              caption: 'Checkout'.tr,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),
        ),
      );
    });
  }

  Widget buildProductItems(ProductsList marketProductData, int index, final marketPlaceModel) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.17,
      margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: const Color(0xFFF5EDED)),
            child: CachedNetworkImage(
              height: 90,
              width: 90,
              imageUrl:
                  "${(HeaderSingleton().configurationDetails != null ? HeaderSingleton().configurationDetails!.marketCatImageUrl : Provider.of<HomeDashboardProvider>(context, listen: false).configUrl.marketCatImageUrl)}" +
                      marketProductData.logo,
              imageBuilder: (context, imageProvider) => Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
              ),
              placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover, height: 70, width: 70),
              errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover, height: 70, width: 70),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(child: WidgetUtils.appTextWidget(context: context, title: marketProductData.productName, family: 'Graphik', fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),
              WidgetUtils.appTextWidget(
                  context: context,
                  title: marketProductData.purchaseLimit == "" ? "" : "Max Purchase Limit is".tr + " " + marketProductData.purchaseLimit,
                  textAlign: TextAlign.start,
                  color: Colors.red,
                  fontSize: 12.0),
              WidgetUtils.appTextWidget(context: context, title: '₹${marketProductData.price}', family: 'Graphik', color: const Color(0xff02A88A), fontSize: 14, fontWeight: FontWeight.w500),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      var qty = int.parse(marketProductData.qty ?? "1");
                      if (qty > 1) {
                        qty = qty - 1;
                      }
                      var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
                      marketPlaceModel.setUpdateCart(marketProductData.id, qty.toString());
                      SQLiteDbProvider.db.updatecart(marketProductData.id, qty.toString());
                    },
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                      // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 0.2)),
                      child: SvgPicture.asset("assets/images/substraction.svg", height: 26),
                    ),
                  ),
                  const SizedBox(width: 13),
                  WidgetUtils.appTextWidget(context: context, title: '${marketProductData.qty}', family: 'Graphik', color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                  const SizedBox(width: 13),
                  InkWell(
                    onTap: () {
                      var qty = int.parse(marketProductData.qty ?? "1");
                      var limit = 50;
                      if (marketProductData.purchaseLimit == "") {
                        limit = 50;
                      } else {
                        limit = int.parse(marketProductData.purchaseLimit);
                      }
                      if (int.parse(marketProductData.inStock) > qty) {
                        if (qty < limit) {
                          qty = qty + 1;
                        } else {
                          WidgetUtils.informationDialog(context, 'Max Purchase Limit is'.tr + " " + limit.toString());
                        }
                      } else {
                        WidgetUtils.informationDialog(context, 'Only'.tr + " " + marketProductData.inStock + " " + 'stock is available'.tr);
                      }
                      marketPlaceModel.setUpdateCart(marketProductData.id, qty.toString());
                      SQLiteDbProvider.db.updatecart(marketProductData.id, qty.toString());
                    },
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                      // decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                      child: SvgPicture.asset("assets/images/addIcon.svg", height: 26),
                    ),
                  ),
                  const SizedBox(width: 59),
                  InkWell(
                      onTap: () {
                        HelperUtils().showNormalDialog(
                            context: context,
                            title: 'Are_you_sure'.tr,
                            content: 'Do you want to remove product from cart'.tr,
                            onYesTapped: (value) async {
                              Navigator.of(value).pop(false);
                              marketPlaceModel.setUpdateCart(marketProductData.id, "1".toString());
                              SQLiteDbProvider.db.updatecart(marketProductData.id, "1".toString());
                              marketPlaceModel.setDeleteCart(marketProductData.id);
                              SQLiteDbProvider.db.delete(marketProductData.id);
                              productDetailList.value.removeAt(index);
                            });
                      },
                      child: SvgPicture.asset("assets/images/delete.svg", height: 15))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Future checkCart() async {
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
      final marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
      final response = await APIService.postAPIMethod(url: ApiURL.checkProductStock, params: {"cart_prod_ids": productID, "cart_prod_quantity": productQTY});
      var res = CheckCart.fromJson(json.decode(response.body));
      if (res.status == "1") {
        final data = res.data;
        if (data.isNotEmpty) {
          for (final element in data) {
            for (int i = 0; i < marketProductList.length; i++) {
              if (element.productId == marketProductList[i].id.toString()) {
                if (element.stock == 0) {
                  WidgetUtils.informationDialog(context, marketProductList[i].productName + " " + "Out of stock".tr);
                  var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
                  var ids = marketProductList[i].id;
                  marketPlaceModel.setDeleteCart(ids.toString());
                  SQLiteDbProvider.db.delete(ids.toString());
                  productDetailList.value.removeAt(i);
                }
              }
            }
          }
        }
        marketProductList = await getProductList(context);
        marketPlaceModel.setCartProductList(marketProductList);
      }
    } catch (e) {
      loading.value = false;
      setStateIfMounted(() {});
    }
  }

  Future checkCartProceed() async {
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
      Map<String, dynamic> params1 = {"cart_prod_ids": productID, "cart_prod_quantity": productQTY};
      final response = await http.post(Uri.parse(baseURL + ApiURL.checkProductStock), body: params1, headers: headerParams);
      var data = json.decode(response.body);
      var res = CheckCart.fromJson(data);
      var flags = false;
      if (res.status == "1") {
        var data = res.data;

        if (data.isNotEmpty) {
          for (var element in data) {
            for (int i = 0; i < marketProductList.length; i++) {
              if (element.productId == marketProductList[i].id.toString()) {
                if (element.stock == 0) {
                  WidgetUtils.informationDialog(context, marketProductList[i].productName + "Out of stock".tr);
                  var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
                  var ids = marketProductList[i].id;
                  marketPlaceModel.setDeleteCart(ids.toString());
                  SQLiteDbProvider.db.delete(ids.toString());
                  productDetailList.value.removeAt(i);
                  flags = true;
                }
              }
            }
          }
        }

        if (flags == false) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliverySelectionScreen()));
        }
      }
    } catch (e) {
      loading.value = false;
      setStateIfMounted(() {});
    }
  }

  Future getOrderBeforeTime() async {
    try {
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.getAPIMethod(url: ApiURL.orderBeforeTime);
        OrderBeforeTime res = OrderBeforeTime.fromJson(json.decode(response.body));
        if (res.success != 1) {
        } else {
          setStateIfMounted(() {
            orderBeforeTime = res.message;
          });
        }
      }
    } catch (e) {
      loading.value = false;
      setStateIfMounted(() {});
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
