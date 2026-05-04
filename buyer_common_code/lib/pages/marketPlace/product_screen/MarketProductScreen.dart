import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/components/widgets/base_widget.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MarketProductScreen extends StatefulWidget {
  MarketPlaceCatagryData? marketPlaceCategoryData;

  MarketProductScreen(this.marketPlaceCategoryData, {super.key});

  @override
  _MarketProductScreenState createState() => _MarketProductScreenState();
}

class _MarketProductScreenState extends State<MarketProductScreen> {
  bool isDataNotFound = false;
  List<MarketProductData> marketProductList = [];

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  @override
  void dispose() {
    super.dispose();
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(builder: (context, marketPlaceModel, child) {
      return SafeArea(
        child: BaseWidget(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, title: "Products".tr, color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SizedBox(
                    height: 150.0,
                    width: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const CartItemsScreen()));
                      },
                      child: Stack(
                        children: <Widget>[
                          const Icon(Icons.shopping_cart, color: Colors.white),
                          Provider.of<MarketPlaceProvider>(context, listen: false).cartProductList.isNotEmpty
                              ? Positioned(
                                  top: 8,
                                  right: 3,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.red,
                                    child: Text(
                                      Provider.of<MarketPlaceProvider>(context, listen: false).cartProductList.length.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                                    ),
                                  ))
                              : Container(),
                        ],
                      ),
                    )),
              )
            ],
          ),
          child: isDataNotFound
              ? Center(
                  child: Text(
                    'No data found'.tr,
                    style: const TextStyle(color: Colors.black, fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                )
              : GridView.builder(
                  itemCount: marketPlaceModel.marketProductList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return productItem(marketPlaceModel.marketProductList[index]);
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.7, crossAxisSpacing: 2, mainAxisSpacing: 2, crossAxisCount: 2),
                ),
        ),
      );
    });
  }

  Widget productItem(MarketProductData marketProductData) {
    var homeDashboardModel = Provider.of<HomeDashboardProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          width: MediaQuery.of(context).size.width * 0.4,
          child: LayoutBuilder(
            builder: (_, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: marketProductData.hashCode,
                    child: Center(
                      child: FadeInImage.assetNetwork(
                          placeholder: image,
                          imageErrorBuilder: (ctx, obj, st) => Image.file(File(imgPlaceHolder), fit: BoxFit.fill),
                          image: "${(HeaderSingleton().configurationDetails != null ? HeaderSingleton().configurationDetails!.marketCatImageUrl : homeDashboardModel.configUrl.marketCatImageUrl)}" +
                              "/" +
                              marketProductData.logo,
                          height: 120,
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(marketProductData.product_name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(marketProductData.type, style: const TextStyle(color: Colors.black45, fontSize: 13)),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${marketProductData.price}',
                        style: const TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      marketProductData.cartFlag
                          ? const Text(
                              'Already in cart',
                              style: TextStyle(color: Colors.orange, fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          : InkWell(
                              onTap: () {
                                var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
                                marketPlaceModel.setCartFlag(marketProductData.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                                child: const Text("ADD", style: TextStyle(fontSize: 20, color: Colors.white)),
                              ),
                            ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future fetchProduct() async {
    try {
      setState(() {
        isLoading.value = true;
      });
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.getAllProductWithPagination);
        var param = {"cat_id": widget.marketPlaceCategoryData!.pcatId, "start": "0", "sort_filter": ""};
        http.Response response = await http.post(fetchSchoolsUri, body: param, headers: headerParams);
        var data = json.decode(response.body);
        MarketProductResponse res = MarketProductResponse.fromJson(data);
        var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        if (res.status != 1) {
          setState(() {
            isDataNotFound = true;
          });
          marketModel.setMarketProductList([]);
        } else {
          if (res.data.isEmpty) {
            setState(() {
              isDataNotFound = true;
            });
            marketModel.setMarketProductList([]);
          }
        }
      } else {
        setState(() {
          isDataNotFound = true;
        });
        var marketModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        marketModel.setMarketProductList([]);
      }
      setState(() {
        isLoading.value = false;
      });
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
