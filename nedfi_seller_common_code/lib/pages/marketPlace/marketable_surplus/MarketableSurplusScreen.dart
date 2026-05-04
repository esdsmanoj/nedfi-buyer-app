import 'package:get/get.dart';

import '../../../app_imports.dart';
import '../../../model/trade_product_model/MarketableSurplus.dart';
import '../../../model/NedfiProductType.dart';
import '../../../model/ProductType.dart';
import '../../../model/trade_product_model/master_listing_model.dart';
import '../../../providers/master_provider.dart';
import '../nedfi_products/add_product/AddProductMainScreen.dart';

class MarketableSurplusScreen extends StatefulWidget {
  const MarketableSurplusScreen({super.key});

  @override
  State<MarketableSurplusScreen> createState() => _MarketableSurplusScreenState();
}

class _MarketableSurplusScreenState extends State<MarketableSurplusScreen> {
  TextEditingController? categoryController = TextEditingController();
  TextEditingController? cropController = TextEditingController();
  TextEditingController? typeController = TextEditingController();
  String categoryID="";
  String cropID="";
  String typeID="";
  List<MarketableSurplusData> marketableSurplusList=[];

  @override
  void initState() {
    super.initState();
    getMasterList();
    getProductType();
    getBuyersDemandProductList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      loadingText: '',
      isLoading: isLoading.value,
      child: DefaultTabController(
          length: 5,
          child: Scaffold( backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                centerTitle: false,
                backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
                title: WidgetUtils.appTextWidget(context: context, title: 'Marketable Surplus'.tr, family: 'Graphik',
                    fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
                iconTheme: const IconThemeData(color: Colors.white),
                leading: IconButton(
                  icon: const Icon(Icons.keyboard_backspace_sharp),
                  onPressed: () {

                    Navigator.pop(context);

                  },
                ),
              ),
              body: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: (MediaQuery
                        .of(context)
                        .size
                        .width) - 15,
                    height: 58,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4)),
                    // margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      onTap: () {
                        showProductCategory(context);
                      },
                      controller: categoryController,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.grey,
                              fontSize: 16,
                              fontFamily: 'Graphik',
                              fontWeight: FontWeight.w400),
                          hintStyle: const TextStyle(color: Colors.grey,
                              fontSize: 16,
                              fontFamily: 'Graphik',
                              fontWeight: FontWeight.w400),
                          hintText: 'Product'.tr,
                          border: InputBorder.none,
                          counterText: "",
                          suffixIcon: Icon(Icons.keyboard_arrow_down,
                              color: Colors.grey)),
                      style: const TextStyle(color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Graphik',
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                    child: Row(
                      children: [
                        Container(
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width / 2) - 15,
                          height: 58,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4)),
                          // margin: const EdgeInsets.only(right: 16),
                          child: TextField(
                            onTap: () {
                              showProductType(context);
                            },
                            controller: typeController,
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: 'Graphik',
                                    fontWeight: FontWeight.w400),
                                hintStyle: const TextStyle(color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: 'Graphik',
                                    fontWeight: FontWeight.w400),
                                hintText: 'Type'.tr,
                                border: InputBorder.none,
                                counterText: "",
                                suffixIcon: Icon(Icons.keyboard_arrow_down,
                                    color: Colors.grey)),
                            style: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width / 2) - 15,
                          height: 58,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4)),
                          // margin: const EdgeInsets.only(right: 16),
                          child: TextField(
                            onTap: () {
                              if(typeController!.text.toString()==""){
                                WidgetUtils.errorDialog(
                                    context, 'Please Select Product Type'.tr);
                              }else{
                                showProduct(context);
                              }
                            },
                            controller: cropController,
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: 'Graphik',
                                    fontWeight: FontWeight.w400),
                                hintStyle: const TextStyle(color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: 'Graphik',
                                    fontWeight: FontWeight.w400),
                                hintText: 'Product'.tr,
                                border: InputBorder.none,
                                counterText: "",
                                suffixIcon: Icon(Icons.keyboard_arrow_down,
                                    color: Colors.grey)),
                            style: const TextStyle(color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Graphik',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  marketableSurplusList.length==0?Container(
                    child: Center(
                      child: WidgetUtils.appTextWidget(context: context, title: 'No Data Available'.tr),
                    ),
                  ): Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount:marketableSurplusList.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 100),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return productItem(marketableSurplusList[index]);
                      },
                    ),
                  )
                ],
              ))
      ),
    );
  }
  productItem(MarketableSurplusData item){
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
                    title: "₹" +(item.price ?? "")+  "/" + (item.priceUnitTitle ?? ""),
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
                    context: context, title: "Variety - ".tr + (item.productVarietyTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                WidgetUtils.appTextWidget(
                    context: context, title: "Type - ".tr + (item.productTypeTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
              ],
            ),
            const SizedBox(height: 5),
            Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils.appTextWidget(
                    context: context, title: "Available".tr , fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                WidgetUtils.appTextWidget(
                    context: context, title:  (item.surplusAvailable ?? "").toString()+  "/" + (item.priceUnitTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
              ],
            ),
            const SizedBox(height: 5),
            Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils.appTextWidget(
                    context: context, title: "Total".tr , fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                WidgetUtils.appTextWidget(
                    context: context, title:  (item.surplusTotal ?? "").toString()+  "/" + (item.priceUnitTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
              ],
            ),
            const SizedBox(height: 5),
            Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils.appTextWidget(
                    context: context, title: "Sold".tr , fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                WidgetUtils.appTextWidget(
                    context: context, title:  (item.sellQtySold ?? "").toString()+  "/" + (item.priceUnitTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
              ],
            ),
            const SizedBox(height: 5),
            Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            const SizedBox(height: 5),
           /* Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetUtils.appTextWidget(
                    context: context, title: "Sold".tr , fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                WidgetUtils.appTextWidget(
                    context: context, title:  (item.sellQtySold ?? "").toString()+  "/" + (item.priceUnitTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
              ],
            ),
            const SizedBox(height: 5),
            Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
            const SizedBox(height: 5),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductMainScreen(type: "NEW"))).then((value) {

                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
                        decoration: BoxDecoration(border: Border.all(color: Color(int.parse(themeColor.value.buttonColor!.color!))), borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            Icon(Icons.add,color: Color(int.parse(themeColor.value.buttonColor!.color!))),
                            const SizedBox(width: 4),
                            WidgetUtils.appTextWidget(context: context, title: "Add Product".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: Color(int.parse(themeColor.value.buttonColor!.color!)), fontSize: 14),
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
      var param={
      "user_id":userId,
      "start":"1",
      "prod_cat_id":categoryID.toString(),
    "prod_type_id":typeID.toString(),
    "prod_id":cropID.toString(),
      };

      final response = await APIService.postAPIMethod(url: ApiURL.marketableSurplus, params:param );

      final data = json.decode(response.body);

      final res = MarketableSurplus.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {

          marketableSurplusList= res.data!;
        }
      }
      setState(() {

      });
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
      setState(() {

      });
    } catch (e) {
      setState(() {});
    }
  }

  Future getProduct(String categoryID, String productID) async {
    try {
      var params = {/*"product_category": categoryID,*/ "product_type": productID};
      final response = await APIService.postAPIMethod(
          url: ApiURL.productData, params: params);
      final data = json.decode(response.body);
      final res = NedfiProductType.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(
              context, listen: false);
          masterProvider.setProductData(res.data ?? []);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  void showProductCategory(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider
              .of<MasterProvider>(context, listen: true)
              .masterData
              ?.productCategory ?? [];
          return StatefulBuilder(builder: (ctx, StateSetter setStates) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 400,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context,
                                  title: 'Select Product Category'.tr,
                                  color: Colors.black,
                                  fontSize: 18,
                                  family: 'Graphik',
                                  fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/cross.svg",
                                    height: 20,
                                  ))
                            ],
                          )),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.4, // Change as per your requirement
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.6,
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.5, // Change as per your requirement
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.6,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dssModel.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        categoryController!.text =
                                            dssModel[index].title ?? "";
                                        categoryID = dssModel[index].id.toString();
                                        getBuyersDemandProductList();
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: WidgetUtils.appTextWidget(
                                          context: context,
                                          title: dssModel[index].title ?? "",
                                          fontSize: 16,
                                          family: 'Graphik'),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          border: Border.all(width: 1,
                                              color: Colors.grey.shade300)),
                                    ));
                              },
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  Future getProductType() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.productType);
      final data = json.decode(response.body);
      final res = ProductType.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setProductTypeData(res.data ?? []);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  void showProduct(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider
              .of<MasterProvider>(context, listen: true)
              .productList ?? [];
          return StatefulBuilder(builder: (ctx, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 400,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context,
                                  title: 'Select Product'.tr,
                                  color: Colors.black,
                                  fontSize: 18,
                                  family: 'Graphik',
                                  fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/cross.svg",
                                    height: 20,
                                  ))
                            ],
                          )),
                      const SizedBox(height: 10),
                      SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.4, // Change as per your requirement
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.6,
                          child: dssModel.isNotEmpty ? ListView(
                              shrinkWrap: true, children: <Widget>[
                            SizedBox(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.5,
                              // Change as per your requirement
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.6,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: dssModel.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          cropController!.text =
                                              dssModel[index].title ?? "";
                                          cropID = dssModel[index].id ?? "";
                                          getBuyersDemandProductList();
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        margin: const EdgeInsets.only(
                                            bottom: 10),
                                        child: WidgetUtils.appTextWidget(
                                            context: context,
                                            title: dssModel[index].title ?? "",
                                            fontSize: 16,
                                            family: 'Graphik'),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                4),
                                            border: Border.all(width: 1,
                                                color: Colors.grey.shade300)),
                                      ));
                                },
                              ),
                            ),
                          ]) :
                          Center(
                            child: WidgetUtils.appTextWidget(context: context,
                                title: 'No Product Available'.tr,
                                color: Colors.black,
                                fontSize: 18,
                                family: 'Graphik',
                                fontWeight: FontWeight.w500),

                          )

                      ),
                    ],
                  ),
                ));
          });
        });
  }

  void showProductType(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final dssModel = Provider
              .of<MasterProvider>(context, listen: true)
              .productTypeList ?? [];
          return StatefulBuilder(builder: (ctx, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 400,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WidgetUtils.appTextWidget(context: context,
                                  title: 'Select Product Type'.tr,
                                  color: Colors.black,
                                  fontSize: 18,
                                  family: 'Graphik',
                                  fontWeight: FontWeight.w500),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/cross.svg",
                                    height: 20,
                                  ))
                            ],
                          )),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.4, // Change as per your requirement
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.6,
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.5, // Change as per your requirement
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.6,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dssModel.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        typeController!.text = dssModel[index].title ?? "";
                                        typeID = dssModel[index].id.toString();


                                        getProduct(categoryID, typeID);

                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: WidgetUtils.appTextWidget(
                                          context: context,
                                          title: dssModel[index].title ?? "",
                                          fontSize: 16,
                                          family: 'Graphik'),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          border: Border.all(width: 1,
                                              color: Colors.grey.shade300)),
                                    ));
                              },
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ));
          });
        });
  }
}
