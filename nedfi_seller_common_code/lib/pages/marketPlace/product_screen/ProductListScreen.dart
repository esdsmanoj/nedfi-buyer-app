import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:nedfi_seller_common_code/components/widgets/base_widget.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ValueNotifier<List<ProductsList>> marketProductList = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    fetchProduct();
    getProductList(context).then((value) {
      marketProductList.value = value;
    });
  }

  Future<List<ProductsList>> getProductList(BuildContext context) async {
    return SQLiteDbProvider.db.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    MQuery().init(context);
    return BaseWidget(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          title: WidgetUtils.appTextWidget(context: context, title: "Products".tr, color: Colors.white, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 18),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: <Widget>[
            Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const CartItemsScreen()));
                    },
                    icon: const Icon(Icons.shopping_cart, size: 25.0, color: Colors.white),
                  ),
                ),
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
                            style: const TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w500),
                          ),
                        ))
                    : Container()
              ],
            )
          ]),
      child: Provider.of<MarketPlaceProvider>(context, listen: false).productList.isNotEmpty
          ? SizedBox(
              width: double.infinity,
              child: ListView(
                children: [
                  ListView.builder(
                      itemCount: Provider.of<MarketPlaceProvider>(context, listen: false).productList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return buildProductItem(Provider.of<MarketPlaceProvider>(context, listen: false).productList[index]);
                      }),
                ],
              ))
          : Center(
              child: Text("No data found".tr)
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton.extended(
          label: Text('My Order'.tr, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Graphik')),
          icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrderScreen()));
          },
        ),
      ),
    );
  }

  Widget buildProductItem(ProductData productData) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(productData.catName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Graphik')),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => AllProductListScreen(productData.pcatId, productData.catName)))
                  .then((value){
                    setState(() {

                    });
                  });
                },
                child: const Text(
                  'See all',
                  style: TextStyle(color: Color(0xff27914F), fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Graphik'),
                ),
              ),
            ],
          ),
        ),
        productListItems(productData.productsList),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget productListItems(List<ProductsList> _items) {
    return SizedBox(
      height: MQuery.height! * 0.25,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        itemBuilder: (_, i) => GroceryItem(
            item: _items[i],
            onFunctionCalled: () => setState(() {
                  isLoading.value = false;
                })),
        separatorBuilder: (_, __) => const SizedBox(width: 5),
      ),
    );
  }

  Future fetchProduct() async {
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.productListing);
        http.Response response = await http.get(fetchSchoolsUri, headers: headerParams);
        var data = json.decode(response.body);
        ProductResponse npkResponse = ProductResponse.fromJson(data);
        if (npkResponse.status != 1) {
          WidgetUtils.errorDialog(context, npkResponse.msg);
        } else {
          if (npkResponse.data.isNotEmpty) {
            var landCropModel = Provider.of<MarketPlaceProvider>(context, listen: false);
            landCropModel.setProductList(npkResponse.data);
          }
        }
      }
      isLoading.value = false;
      setState(() {});
    } catch (e) {
      isLoading.value = false;
      setState(() {});
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
