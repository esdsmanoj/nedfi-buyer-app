import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:nedfi_seller_common_code/components/widgets/base_widget.dart';
import 'package:get/get.dart';
import 'MarketProductScreen.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({Key? key}) : super(key: key);

  @override
  _MarketPlaceScreenState createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  String netCarretURL = "";
late MarketPlaceProvider marketPlaceModel;

  @override
  void initState() {
    super.initState();
    isLoading.value = false;
    getProductList(context).then((value) {
      productDetailList.value = value;
    });
    marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
    if (marketPlaceModel.marketPlaceCategoryList.isEmpty) {
      getDetails();
    }
    isLoading.value = false;
  }

  Future<List<ProductsList>> getProductList(BuildContext context) async {
    return SQLiteDbProvider.db.getAllProducts();
  }

  Future getDetails() async {
    await fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(builder: (context, marketModel, child) {
      return SafeArea(
        child: BaseWidget(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, title: "Products".tr, color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0, top: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CartItemsScreen()));
                  },
                  child: Stack(
                    children: <Widget>[
                      const Icon(Icons.shopping_cart, color: Colors.white),
                      marketModel.cartProductList.isNotEmpty
                          ? Positioned(
                              top: 8,
                              right: 3,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                                child: Text(
                                  marketModel.cartProductList.length.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                                ),
                              ))
                          : Container()
                      //   },
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
          child: GridView.builder(
            itemCount: marketModel.marketPlaceCategoryList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return marketCategoryItems(marketModel.marketPlaceCategoryList[index], index);
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1, crossAxisSpacing: 2, mainAxisSpacing: 2, crossAxisCount: 3),
          ),
        ),
      );
    });
  }

  Widget marketCategoryItems(MarketPlaceCatagryData marketPlaceCategoryData, int index) {
    var homeDashboardModel = Provider.of<HomeDashboardProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MarketProductScreen(marketPlaceCategoryData)));
      },
      child: SizedBox(
        height: 80,
        width: 80,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            child: Column(
              children: [
                Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: const Color(0xfff5f5f5),
                    child: Column(
                      children: [
                        SizedBox(
                          child: FadeInImage.assetNetwork(
                              placeholder: image,
                              imageErrorBuilder: (ctx, obj, st) => Image.file(File(image), fit: BoxFit.fill),
                              image: "${(HeaderSingleton().configurationDetails != null ? HeaderSingleton().configurationDetails!.productImageUrl : homeDashboardModel.configUrl.ProductImageUrl)}" +
                                  "/" +
                                  marketPlaceCategoryData.mobIcon,
                              fit: BoxFit.fill),
                          height: 80,
                          width: 80
                        ),
                      ],
                    )),
                SizedBox(
                    width: 80,
                    height: 20,
                    child: Text(marketPlaceCategoryData.name,
                        textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontFamily: 'Graphik', fontSize: 14.0))),
              ],
            )),
      ),
    );
  }

  Future fetchCategory() async {
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.getAPIMethod(url: ApiURL.getProductCategoryEcom);
        final data = json.decode(response.body);
        MarketPlaceCatagryResponse res = MarketPlaceCatagryResponse.fromJson(data);
        if (res.status != 1) {
          WidgetUtils.errorDialog(context, res.message);
        } else {
          marketPlaceModel.setMarketPlaceCategoryList(res.data);
        }
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future fetchNetCarret() async {
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.getAPIMethod(url: ApiURL.ncAuth + "/" + HeaderSingleton().paramsMaps!.phone!);
        var data = json.decode(response.body);
        if (data["status"] != 1) {
          WidgetUtils.errorDialog(context, data["data"] ?? "");
        } else {
          setState(() {
            netCarretURL = data["data"];
          });
        }
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
