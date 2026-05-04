import 'package:get/get.dart';

import '../../../app_imports.dart';
import '../../../model/trade_product_model/BuyerDemand.dart';
import '../../../model/trade_product_model/UpcomingProduct.dart';
import '../../../model/trade_product_model/master_listing_model.dart';
import '../../../providers/master_provider.dart';
import '../nedfi_products/add_product/AddProductMainScreen.dart';

class BuyerDemandScreen extends StatefulWidget {
  const BuyerDemandScreen({super.key});

  @override
  State<BuyerDemandScreen> createState() => _BuyerDemandScreenState();
}

class _BuyerDemandScreenState extends State<BuyerDemandScreen> {
  TextEditingController? demandTypeController = TextEditingController(text: 'Immediate'.tr);
  TextEditingController? categoryController = TextEditingController();
  TextEditingController? cropController = TextEditingController();
  String categoryID = "";
  String demandID = "1";
  String cropID = "";

  @override
  void initState() {
    super.initState();
    getMasterList();
    // getUpcomingProduct();
    getBuyersDemandProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MasterProvider>(builder: (context, masterProvider, child) {
      return Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0, bottom: 10),
              child: Container(
                width: (MediaQuery.of(context).size.width) - 20,
                height: 58,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                // margin: const EdgeInsets.only(right: 16),
                child: TextField(
                  onTap: () {
                    showDemandType(context);
                  },
                  controller: demandTypeController,
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      hintText: 'Category'.tr,
                      border: InputBorder.none,
                      counterText: "",
                      suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width / 2) - 15,
                    height: 58,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                    // margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      onTap: () {
                        showProductCategory(context);
                      },
                      controller: categoryController,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          hintText: 'Category'.tr,
                          border: InputBorder.none,
                          counterText: "",
                          suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width / 2) - 15,
                    height: 58,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                    // margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      onTap: () {
                        if (categoryID == "") {
                          WidgetUtils.errorDialog(context, 'Please Select Product Category'.tr);
                        } else {
                          showProductFilter(context);
                        }
                      },
                      controller: cropController,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                          hintText: 'Product'.tr,
                          border: InputBorder.none,
                          counterText: "",
                          suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey)),
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: masterProvider.buyerDemandList.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 100),
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return productItem(masterProvider.buyerDemandList[index]);
                },
              ),
            )
          ],
        ),
      );
    });
  }

  productItem(BuyerDemandData item) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      SizedBox(child: WidgetUtils.appTextWidget(context: context, title: item.productTitle ?? "", fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 20)),
                    ],
                  ),
                ),
                WidgetUtils.appTextWidget(
                    context: context,
                    title: "₹" + (item.priceFrom ?? "") + "-" + (item.priceTo ?? "") + "/" + (item.priceUnitTitle ?? ""),
                    fontWeight: FontWeight.w500,
                    family: 'Graphik',
                    color: Color(int.parse(themeColor.value.buttonColor!.color!)),
                    fontSize: 14),
              ],
            ),
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils.appTextWidget(
                    context: context, title: "Variety -".tr + (item.productVarietyTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                WidgetUtils.appTextWidget(
                    context: context, title: "Type -".tr + (item.productTypeTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
              ],
            ),
            const SizedBox(height: 5),
            Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils.appTextWidget(context: context, title: "Category".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                WidgetUtils.appTextWidget(context: context, title: (item.productCategoryTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
              ],
            ),
            const SizedBox(height: 5),
            Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils.appTextWidget(context: context, title: "Demand added On".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                WidgetUtils.appTextWidget(context: context, title: getDateFormat(item.postedOn ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
              ],
            ),
            const SizedBox(height: 5),
            Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils.appTextWidget(context: context, title: "Demand Type".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                WidgetUtils.appTextWidget(
                    context: context, title: (demandID == "1" ? 'Immediate'.tr : 'Future'.tr), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
              ],
            ),
            const SizedBox(height: 5),
            Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils.appTextWidget(context: context, title: "Quantity".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                WidgetUtils.appTextWidget(
                    context: context, title: item.quantity??"0", fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
              ],
            ),
            const SizedBox(height: 5),
            Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils.appTextWidget(context: context, title: "Posted By".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                WidgetUtils.appTextWidget(
                    context: context, title: (item.firstName ?? "") + " " + (item.lastName ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
              ],
            ),
            const SizedBox(height: 5),
            Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            const SizedBox(height: 5),
            item.prodCatId != "2"
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetUtils.appTextWidget(context: context, title: "Availability From".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                      WidgetUtils.appTextWidget(
                          context: context, title: getMonthDateFormat(item.availableFrom ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                    ],
                  ),
            item.prodCatId != "2" ? Container() : const SizedBox(height: 5),
            item.prodCatId != "2" ? Container() : Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            item.prodCatId != "2" ? Container() : const SizedBox(height: 5),
            item.prodCatId != "2"
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetUtils.appTextWidget(context: context, title: "Availability To".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                      WidgetUtils.appTextWidget(
                          context: context, title: getMonthDateFormat(item.availableTo ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                    ],
                  ),
            item.prodCatId != "2" ? Container() : const SizedBox(height: 5),
            item.prodCatId != "2" ? Container() : Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            item.prodCatId != "2" ? Container() : const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProductMainScreen(
                                      type: "NEW",
                                      from: "demand",
                                      item: item,
                                    ))).then((value) {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                        decoration: BoxDecoration(border: Border.all(color: Color(int.parse(themeColor.value.buttonColor!.color!))), borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            Icon(Icons.add, color: Color(int.parse(themeColor.value.buttonColor!.color!))),
                            const SizedBox(width: 4),
                            WidgetUtils.appTextWidget(
                                context: context, title: "Add Product".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: Color(int.parse(themeColor.value.buttonColor!.color!)), fontSize: 14),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future getBuyersDemandProductList() async {
    try {
      var param = {
        "prod_cat_id": categoryID,
        "product_id": cropID,
        "demand_type": demandID,
      };
      final response = await APIService.postAPIMethod(url: ApiURL.buyersDemandProductList, params: param);
      final data = json.decode(response.body);
      final res = BuyerDemand.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setBuyerDemand(res.data!);
        } else {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setBuyerDemand([]);
        }
      } else {
        var masterProvider = Provider.of<MasterProvider>(context, listen: false);
        masterProvider.setBuyerDemand([]);
      }
      setState(() {});
    } catch (e) {
      print(e);
      setState(() {});
    }
  }

  Future getMasterList() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getMasterListing);
      final data = json.decode(response.body);
      final res = MasterListing.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setMasterData(res.data!);
        }
      }
      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }

  Future getUpcomingProduct() async {
    try {
      var param = {"product_category": categoryID};
      final response = await APIService.postAPIMethod(url: ApiURL.productList, params: param);
      final data = json.decode(response.body);
      final res = UpcomingProduct.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setUpcomingProduct(res.data!);
        }
      }
      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }

  void showDemandType(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final List<String> dssModel = ['Immediate'.tr, 'Future'.tr];

        return StatefulBuilder(
          builder: (ctx, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SizedBox(
                height: 400,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WidgetUtils.appTextWidget(
                            context: context,
                            title: 'Select Demand Type'.tr,
                            color: Colors.black,
                            fontSize: 18,
                            family: 'Graphik',
                            fontWeight: FontWeight.w500,
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(ctx),
                            child: SvgPicture.asset(
                              "assets/images/cross.svg",
                              height: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dssModel.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                demandTypeController!.text = dssModel[index];
                                demandID = (index + 1).toString();

                                categoryController!.text = "";
                                categoryID = "";

                                getBuyersDemandProductList();
                              });
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                              margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(width: 1, color: Colors.grey.shade300),
                              ),
                              child: WidgetUtils.appTextWidget(
                                context: context,
                                title: dssModel[index],
                                fontSize: 16,
                                family: 'Graphik',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  void showProductCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final allCategories = Provider.of<MasterProvider>(context, listen: true).masterData?.productCategory ?? [];

        List<ProductCategory> dssModel = [];
        if (demandID == "1") {
          // Only if at least 3 items are available
          if (allCategories.length >= 3) {
            dssModel = [allCategories[0], allCategories[2]];
          }
        } else {
          if (allCategories.length >= 2) {
            dssModel = [allCategories[1]];
          }
        }

        return StatefulBuilder(builder: (ctx, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SizedBox(
              height: 400,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(
                          context: context,
                          title: 'Select Product Category'.tr,
                          color: Colors.black,
                          fontSize: 18,
                          family: 'Graphik',
                          fontWeight: FontWeight.w500,
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(ctx),
                          child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: dssModel.isNotEmpty
                        ? ListView.builder(
                      itemCount: dssModel.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              categoryController!.text = dssModel[index].title ?? "";
                              categoryID = dssModel[index].id.toString();
                              getUpcomingProduct();
                              getBuyersDemandProductList();
                            });
                          },
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 1, color: Colors.grey.shade300),
                            ),
                            child: WidgetUtils.appTextWidget(
                              context: context,
                              title: dssModel[index].title ?? "",
                              fontSize: 16,
                              family: 'Graphik',
                            ),
                          ),
                        );
                      },
                    )
                        : Center(
                      child: WidgetUtils.appTextWidget(
                        context: context,
                        title: 'No Category Available'.tr,
                        color: Colors.black,
                        fontSize: 16,
                        family: 'Graphik',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }


  TextEditingController controllerOne = TextEditingController();

  List<UpcomingProductData> _searchResultOne = [];

  void showProductFilter(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<MasterProvider>(//                    <--- Consumer
              builder: (context, loanModel, child) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5, // Change as per your requirement
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ListView(shrinkWrap: true, children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetUtils.appTextWidget(context: context, title: 'Select Product'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: SvgPicture.asset(
                                      "assets/images/cross.svg",
                                      height: 20,
                                    ))
                              ],
                            )),
                        Card(
                          child: ListTile(
                              dense: true,
                              leading: const Icon(Icons.search),
                              title: TextField(
                                controller: controllerOne,
                                decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                                onChanged: (text) {
                                  _searchResultOne.clear();
                                  if (text.isEmpty) {
                                    setState(() {});
                                    return;
                                  }
                                  for (var userDetail in loanModel.upcomingProductList) {
                                    if (userDetail.title!.toUpperCase().contains(text.toUpperCase()) || userDetail.title!.toLowerCase().contains(text.toLowerCase())) _searchResultOne.add(userDetail);
                                  }

                                  setState(() {});
                                },
                              ),
                              trailing: InkWell(
                                  child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                                  onTap: () {
                                    controllerOne.clear();
                                    _searchResultOne.clear();
                                    if ("".isEmpty) {
                                      setState(() {});
                                      return;
                                    }
                                    for (var userDetail in loanModel.upcomingProductList) {
                                      if (userDetail.title!.contains("")) _searchResultOne.add(userDetail);
                                    }
                                    setState(() {});
                                  })),
                        ),
                        SizedBox(
                          height: 350.0, // Change as per your requirement
                          width: 550.0,
                          child: _searchResultOne.isNotEmpty || controllerOne.text.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(bottom: 60),
                                  itemCount: _searchResultOne.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            cropController!.text = _searchResultOne[index].title ?? "";
                                            cropID = _searchResultOne[index].id ?? "";
                                            getBuyersDemandProductList();
                                          });
                                        },
                                        child: Card(
                                          elevation: 0,
                                          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width - 20,
                                                      height: 40,
                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                      margin: const EdgeInsets.only(bottom: 10),
                                                     // decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                                      child: WidgetUtils.appTextWidget(
                                                          context: context, title: _searchResultOne[index].title!, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, fontSize: 16.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                        ));
                                  },
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(bottom: 60),
                                  itemCount: loanModel.upcomingProductList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            cropController!.text = loanModel.upcomingProductList[index].title ?? "";
                                            cropID = loanModel.upcomingProductList[index].id ?? "";
                                            getBuyersDemandProductList();
                                          });
                                        },
                                        child: Card(
                                          elevation: 0,
                                          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width - 20,
                                                      height: 40,
                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                      margin: const EdgeInsets.only(bottom: 10),
                                                   //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1, color: Colors.grey.shade300)),
                                                      child: Text(
                                                        loanModel.upcomingProductList[index].title ?? "",
                                                        textAlign: TextAlign.start,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(fontSize: 16.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                        ));
                                  },
                                ),
                        ),
                      ]),
                    ),
                  ));
            });
          });
        });
  }
}
