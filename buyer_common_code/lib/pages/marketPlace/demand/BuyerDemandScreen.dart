import 'package:get/get.dart';

import '../../../app_imports.dart';
import '../../../model/BuyerDemand.dart';
import '../../../model/UpcomingProduct.dart';
import '../../../model/master_listing_model.dart';
import '../../../providers/master_provider.dart';

class BuyerDemandScreen extends StatefulWidget {
  const BuyerDemandScreen({super.key});

  @override
  State<BuyerDemandScreen> createState() => _BuyerDemandScreenState();
}

class _BuyerDemandScreenState extends State<BuyerDemandScreen> {
  TextEditingController? categoryController = TextEditingController();
  TextEditingController? cropController = TextEditingController();
  String categoryID="";
  String cropID="";

  @override
  void initState() {
    super.initState();
    getMasterList();
    getUpcomingProduct();
    getBuyersDemandProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MasterProvider>(builder: (context, masterProvider, child) {
      return Container(
child: Column(
  children: [
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
                  hintText: 'Category'.tr,
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
                showProductFilter(context);
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
    );});
  }

  productItem(BuyerDemandData item){
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
                      title: "₹" +(item.priceFrom ?? "")+"-"+ (item.priceTo ?? "") + "/" + (item.priceUnitTitle ?? ""),
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
                      context: context, title: "Variety - " + (item.productVarietyTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                  WidgetUtils.appTextWidget(
                      context: context, title: "Type - " + (item.productTypeTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                ],
              ),
              const SizedBox(height: 5),
              Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetUtils.appTextWidget(
                      context: context, title: "Category" , fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                  WidgetUtils.appTextWidget(
                      context: context, title:  (item.productCategoryTitle ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                ],
              ),
              const SizedBox(height: 5),
              Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetUtils.appTextWidget(
                      context: context, title: "Posted On" , fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                  WidgetUtils.appTextWidget(
                      context: context, title:  (item.postedOn ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                ],
              ),
              const SizedBox(height: 5),
              Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetUtils.appTextWidget(
                      context: context, title: "Posted By" , fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                  WidgetUtils.appTextWidget(
                      context: context, title:  (item.firstName ?? "")+" "+(item.lastName ?? ""), fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                ],
              ),
              const SizedBox(height: 5),
              Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                       InkWell(
                        onTap: () async {

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
        "prod_cat_id":categoryID,
        "product_id":cropID
      };
      final response = await APIService.postAPIMethod(url: ApiURL.buyersDemandProductList, params:param );
      final data = json.decode(response.body);
      final res = BuyerDemand.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setBuyerDemand(res.data!);
        }
      }
      setState(() {

      });
    } catch (e) {
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

  Future getUpcomingProduct() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.upcomingProductList+"/"+userId);
      final data = json.decode(response.body);
      final res = UpcomingProduct.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setUpcomingProduct(res.data!);
        }
      }
      setState(() {

      });
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5, // Change as per your requirement
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ListView(shrinkWrap: true, children: <Widget>[
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
                                      if (userDetail.productTitle!.toUpperCase().contains(text.toUpperCase()) || userDetail.productTitle!.toLowerCase().contains(text.toLowerCase())) _searchResultOne.add(userDetail);
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
                                        if (userDetail.productTitle!.contains("")) _searchResultOne.add(userDetail);
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
                              itemCount: _searchResultOne.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        cropController!.text = _searchResultOne[index].productTitle??"";
                                        cropID = _searchResultOne[index].id??"";
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
                                                  width:MediaQuery.of(context).size.width-20 ,
                                                  height: 40,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 5, vertical: 10),
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          4),
                                                      border: Border.all(width: 1,
                                                          color: Colors.grey.shade300)),
                                                  child: WidgetUtils.appTextWidget(
                                                      context: context, title: _searchResultOne[index].productTitle!, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, fontSize: 16.0),
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
                              itemCount: loanModel.upcomingProductList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        cropController!.text = loanModel.upcomingProductList[index].productTitle??"";
                                        cropID = loanModel.upcomingProductList[index].id??"";
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
                                                  width:MediaQuery.of(context).size.width-20 ,
                                                  height: 40,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 5, vertical: 10),
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(
                                                          4),
                                                      border: Border.all(width: 1,
                                                          color: Colors.grey.shade300)),
                                                  child: Text(
                                                    loanModel.upcomingProductList[index].productTitle??"",
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
                      ));
                });
              });
        });
  }
}
