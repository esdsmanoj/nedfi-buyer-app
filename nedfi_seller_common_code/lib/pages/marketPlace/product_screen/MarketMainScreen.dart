import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:nedfi_seller_common_code/components/widgets/base_widget.dart';
import 'package:nedfi_seller_common_code/pages/marketPlace/seller/SellerHomeScreen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../model/AllMenu.dart';

class MarketMainScreen extends StatefulWidget {
  const MarketMainScreen({Key? key}) : super(key: key);

  @override
  _MarketMainScreenState createState() => _MarketMainScreenState();
}

class _MarketMainScreenState extends State<MarketMainScreen> {
  var cartFlag = false;

  @override
  void initState() {
    super.initState();
    getAllMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(builder: (context, marketPlaceModel, child) {
      return BaseWidget(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, title: cartFlag ? "Buyer/Seller".tr : "Seller".tr, color: Colors.white, fontSize: 18),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: cartFlag
                    ? SizedBox(
                        height: 150.0,
                        width: 50.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const CartItemsScreen()));
                          },
                          child: Stack(
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
                          ),
                        ))
                    : Container(),
              )
            ],
          ),
          child: Center(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: marketPlaceModel.marketMenulist.length,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return marketMenu(marketPlaceModel.marketMenulist[index]);
              },
            ),
          ));
    });
  }

  marketMenu(BottomMenu bottomMenu) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          isLoading.value = false;
          if (bottomMenu.mapKey == "buy_product") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductListScreen()));
          } else if (bottomMenu.mapKey == "sell_product") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SellerHomeScreen(onAddButtonTap: (value) {})));
          }
        },
        child: Container(
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: const Color(0xff92b89e).withOpacity(0.7), offset: const Offset(0, 15), blurRadius: 16.0),
              ],
              border: Border.all(color: Color(int.parse(themeColor.value.barColor!.color!)), width: 1.0, style: BorderStyle.solid),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: Padding(padding: const EdgeInsets.all(5.0), child: Center(child: Image.network(bottomMenu.icon!))),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.height * 0.23,
                        child: Text(
                          bottomMenu.title!,
                          style: const TextStyle(color: Color(0XFF000000), fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 30, color: Colors.black),
                ],
              ),
            )),
      ),
    );
  }

  getAllMenu() async {
    isLoading.value = true;
    try {
      http.Response response = await http.get(Uri.parse(baseURL + ApiURL.all_menu), headers: headerParams);
      var data = json.decode(response.body);
      var res = AllMenu.fromJson(data);
      if (res.status == 1) {
        var homeDashboardModel = Provider.of<MarketPlaceProvider>(context, listen: false);
        homeDashboardModel.setMarketMenuList(res.data!.marketMenu!);
        for (var element in res.data!.marketMenu!) {
          if (element.mapKey == "buy_product") {
            setState(() {
              cartFlag = true;
            });
          }
        }
      }
      isLoading.value = false;
    } catch (e) {
      setState(() {
        isLoading.value = false;
      });
      rethrow;
    }
  }
}
