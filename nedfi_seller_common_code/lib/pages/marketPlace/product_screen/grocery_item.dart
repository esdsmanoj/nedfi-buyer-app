import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';

class GroceryItem extends StatelessWidget {
  final ProductsList item;
  final Function onFunctionCalled;

  const GroceryItem({Key? key, required this.item, required this.onFunctionCalled}) : super(key: key);

  Future<void> onTap(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemDetailsScreen(item: item)));
    if (result == null) {
      SQLiteDbProvider.db.getAllProducts().then((value) => productDetailList.value = value); //productDetailList.value =Provider.of<MarketPlaceModel>(context, listen: false).cartProductList;
      onFunctionCalled.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    MQuery().init(context);
    var homeDashboardModel = Provider.of<HomeDashboardProvider>(context, listen: false);

    return InkWell(onTap: () => onTap(context), child: buildRecommendProducts(context)
        // child: Container(
        //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        //   width: MQuery.width! * 0.4,
        //   decoration: BoxDecoration(color: Colors.white54, border: Border.all(color: kBorderColor, width: 1.5), borderRadius: BorderRadius.circular(15)),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       SizedBox(
        //         height: MediaQuery.of(context).size.height * 0.09,
        //         child: Hero(
        //           tag: item.hashCode,
        //           child: CachedNetworkImage(
        //             height: 200,
        //             imageUrl: "${(HeaderSingleton().configurationDetails != null ? HeaderSingleton().configurationDetails!.marketCatImageUrl : homeDashboardModel.configUrl.marketCatImageUrl)}" +
        //                 "/" +
        //                 item.logo,
        //             imageBuilder: (context, imageProvider) => Container(height: 200, decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.fill))),
        //             placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
        //             errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover),
        //           ),
        //         ),
        //       ),
        //       const SizedBox(height: 5),
        //       SizedBox(
        //           width: 200,
        //           height: item.productName.length > 40 ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.03,
        //           child: Text(item.productName,
        //               style: const TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500, fontFamily: 'Graphik'),
        //               maxLines: item.productName.length > 40 ? 2 : 1,
        //               overflow: TextOverflow.ellipsis)),
        //       Text(
        //         ('${item.unit_desc} ${item.unit}'),
        //         maxLines: 1,
        //         overflow: TextOverflow.ellipsis,
        //         style: const TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w400, fontFamily: 'Graphik'),
        //       ),
        //       Text(
        //         int.parse(item.inStockAlert) <= int.parse(item.inStock)
        //             ? ""
        //             : item.inStock == "0"
        //                 ? 'Out of stock'.tr
        //                 : item.inStock + " left",
        //         textAlign: TextAlign.center,
        //         style: const TextStyle(color: Colors.red, fontSize: 12.0, fontWeight: FontWeight.w400, fontFamily: 'Graphik'),
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text(
        //             '\₹${item.price}',
        //             style: const TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: 'Graphik'),
        //           ),
        //           Container(
        //             padding: const EdgeInsets.all(7),
        //             decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(10)),
        //             child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        );
  }

  Widget buildRecommendProducts(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
            width: MediaQuery.of(context).size.width * 0.45,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Stack(
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Container(
                          child: CachedNetworkImage(
                            imageUrl:
                                "${(HeaderSingleton().configurationDetails != null ? HeaderSingleton().configurationDetails!.marketCatImageUrl : HeaderSingleton().configurationDetails!.marketCatImageUrl)}" +
                                    "/" +
                                    item.logo,
                            imageBuilder: (context, imageProvider) => Container(
                                height: 58,
                                width: 58,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
                            placeholder: (context, url) => Image.file(File(image), fit: BoxFit.contain, height: 58, width: 58),
                            errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.contain, height: 58, width: 58),
                          ),
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: double.maxFinite,
                          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 4),
                        child: SizedBox(height: 18, width: 200, child: WidgetUtils.appTextWidget(context: context, title: item.productName, fontWeight: FontWeight.w500, fontSize: 12)),
                      ),
                      /*item.inStock != "0" && (item.unit_desc != null && item.unit != null)
                          ?*/ Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: 60,
                                      child: Text(
                                        ('${item.unit_desc} ${item.unit}'),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400, fontFamily: 'Graphik'),
                                      )),
                                  SizedBox(
                                    width: 60,
                                    child: Text(
                                      int.parse(item.inStockAlert) <= int.parse(item.inStock)
                                          ? ""
                                          : item.inStock == "0"
                                              ? 'Out of stock'.tr
                                              : item.inStock + " left",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(color: Colors.red, fontSize: 10.0, fontWeight: FontWeight.w400, fontFamily: 'Graphik'),
                                    ),
                                  ),
                                ],
                              ))
                         /* : const SizedBox(height: 5,)*/,
                      item.mrp != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8.0,right:8,bottom: 6),
                              child: Text("₹${item.mrp ?? ""}",
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w300, fontSize: 12, decoration: TextDecoration.lineThrough, fontFamily: 'Graphik')),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,right:8,bottom: 6),
                        child: WidgetUtils.appTextWidget(context: context, title: "₹${item.price}", color: const Color(0xff27914F), fontWeight: FontWeight.w500, fontSize: 16, family: 'Graphik'),
                      ),
                    ],
                  ),
                  item.discount != null && item.discount != "0"
                      ? Positioned(
                          right: -2,
                          top: 7,
                          child: Container(
                            alignment: Alignment.center,
                            height: 20,
                            width: 50,
                            child: Text((item.discount ?? "") + "%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 12, fontFamily: 'Graphik')),
                            decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(16)),
                                border: Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ), color: Colors.red.shade400),
                          ))
                      : Container()
                ],
              ),
            )));
  }
}
