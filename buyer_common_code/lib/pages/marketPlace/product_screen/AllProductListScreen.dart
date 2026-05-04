import 'package:buyer_common_code/app_imports.dart';
import 'package:get/get.dart';

import '../../../components/widgets/base_widget.dart';

class AllProductListScreen extends StatefulWidget {
  String catID, name;

  AllProductListScreen(this.catID, this.name, {super.key});

  @override
  _AllProductListScreenState createState() => _AllProductListScreenState();
}

class _AllProductListScreenState extends State<AllProductListScreen> {
  bool isDataNotFound = false;
  List<ProductsList> marketProductList = [];
  int page = 1;
  bool nextFlag = false;
  bool pageFlag = false;
  dynamic marketModel;

  @override
  void initState() {
    super.initState();
    marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
    marketModel.setAllProductClear();
    getProductList(context).then((value) {
      setState(() {
        marketProductList = value;
      });
    });
    fetchProduct();
  }

  Future<List<ProductsList>> getProductList(BuildContext context) async {
    return SQLiteDbProvider.db.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(builder: (context, marketPlaceModel, child) {
      return SafeArea(
        child: BaseWidget(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color(0xff27914F),
            title: WidgetUtils.appTextWidget(context: context, title: widget.name.tr, color: Colors.white, fontSize: 18),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                    height: 150.0,
                    width: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CartItemsScreen()));
                      },
                      child: Stack(
                        children: <Widget>[
                          const IconButton(
                            icon: Icon(Icons.shopping_cart, color: Colors.white),
                            onPressed: null,
                          ),
                           Provider.of<MarketPlaceProvider>(context, listen: false).cartProductList.isEmpty
                              ? Container()
                              : Positioned(
                                  left: 25,
                                  child: Stack(
                                    children: <Widget>[
                                      Icon(Icons.brightness_1, size: 25.0, color: Colors.red[800]),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            Provider.of<MarketPlaceProvider>(context, listen: false).cartProductList.length.toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                        ],
                      ),
                    )),
              )
            ],
          ),
          child: marketPlaceModel.allProductList.isEmpty
              ? Center(
                  child: Text(
                    'No Data Available'.tr,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                      setState(() {
                        if (!nextFlag) {
                          if (!pageFlag) {
                            page += 1;
                            marketModel.setPage(page);
                            pageFlag = true;
                            fetchProduct();
                          }
                        }
                      });
                    }
                    return true;
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    itemCount: marketPlaceModel.allProductList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return GroceryItem(
                          item: marketPlaceModel.allProductList[index],
                          onFunctionCalled: () => setState(() {
                                isLoading.value = false;
                              }));
                    },
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 2.0, mainAxisSpacing: 5.0, childAspectRatio:0.88),
                  ),
                ),
        ),
      );
    });
  }

  fetchProduct() async {
    try {
      setState(() {
        isLoading.value = true;
      });
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.postAPIMethod(url: ApiURL.getAllProductWithPagination, params: {"cat_id": widget.catID, "start": page.toString(), "sort_filter": ""});
        final data = json.decode(response.body);
        MarketProductResponse res = MarketProductResponse.fromJson(data);
        var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        if (res.status != 1) {
          nextFlag = true;
          marketModel.setMarketProductList([]);
        } else {
          if (res.data.isEmpty) {
            nextFlag = true;
            marketModel.setMarketProductList([]);
          } else {
            marketModel.setAllProductList(res.data);
            pageFlag = false;
          }
        }
      } else {
        isDataNotFound = true;
        var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        marketModel.setMarketProductList([]);
      }
      setState(() {});
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
