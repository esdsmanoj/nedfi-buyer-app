import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/model/HomeCatagoryResponse.dart';
import 'package:buyer_common_code/model/NewProducts.dart';
import 'package:get/get.dart';

import '../../components/dotted_border/dotted_border.dart';
import '../../model/home_page_model.dart';
import '../../model/master_listing_model.dart';
import '../../model/statistics_filter.dart';
import '../../model/statistics_report_model.dart';
import '../marketPlace/nedfi_products/add_product/AddProductMainScreen.dart';
import '../marketPlace/nedfi_products/nedfi_advertisement/nedfi_advertisement.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<HomeCatagoryData> homeCategoryList = [];
  List<BlogType> blogTypeList = [];
  List<AdsData> adsList = [];
  List<NewCommoditydata> tempCommodityList = [];

  dynamic weatherFlag = false;

  @override
  void initState() {
    super.initState();
    fetchCommoditynew("");
    HelperUtils().getNewProduct(() => setState(() {}), year: 1.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: homeConfigurableModel,
      builder: (BuildContext context, value, Widget? child) {
        return value != null && value.data != null
            ? ListView(shrinkWrap: true, children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                // buildStatWidget(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                buildNewProducts(),
                value.data!.weather!.display! ? Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: buildWeather()) : Container(),
                tempCommodityList.isNotEmpty ? getCommodity() : Container(),
                (value.data!.services?.isNotEmpty ?? false) ? buildCategory() : Container(),
                (value.data!.otherServices?.isNotEmpty ?? false) ? buildBlogsType() : Container(),
                (value.data!.advertise?.isNotEmpty ?? false) ? buildAdvertise() : Container(),
                (value.data!.recommended?.isNotEmpty ?? false) ? buildRecommendProducts() : Container(),
                buildTrendingProducts(),
                (value.data!.blogs?.isNotEmpty ?? false) ? buildBlogType() : Container(),
                (value.data!.media?.isNotEmpty ?? false) ? buildMediaList() : Container(),
                (value.data!.dssRecommended?.isNotEmpty ?? false) ? buildRecommendDSS() : Container(),
              ])
            : Container();
        // : Center(child: WidgetUtils.appTextWidget(context: context, title: 'No Data Available'.tr));
      },
    );
  }

  Widget buildMediaList() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              WidgetUtils.appTextWidget(
                context: context,
                title: 'Media'.tr,
                fontSize: 18,
                family: 'Graphik',
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 10),
              InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MediaScreen())),
                  child: Row(
                    children: [
                      WidgetUtils.appTextWidget(
                          context: context,
                          title: 'viewMore'.tr,
                          family: 'Graphik',
                          fontSize: 14,
                          color: Color(int.parse(themeColor.value.barColor!.color!)),
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w500),
                      const SizedBox(width: 6),
                      SvgPicture.asset(
                        "assets/images/view.svg",
                        height: 10,
                        color: Color(int.parse(themeColor.value.iconColor!.color!)),
                      )
                    ],
                  )),
            ])),
        const SizedBox(height: 15),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.16,
              width: double.maxFinite,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: homeConfigurableModel.value!.data!.media!.length,
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) => MediaDetailsScreen(homeConfigurableModel.value!.data!.media![index], HeaderSingleton().configurationDetails!.mediaThumbnails!)));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.107,
                          width: 210,
                          margin: const EdgeInsets.only(right: 16),
                          child: CachedNetworkImage(
                            imageUrl: HeaderSingleton().configurationDetails!.mediaThumbnails! + (homeConfigurableModel.value!.data!.media![index].thumbnails ?? 'NA'),
                            imageBuilder: (context, imageProvider) => Container(
                                height: MediaQuery.of(context).size.height * 0.107,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                )),
                            placeholder: (context, url) => Image.file(File(image), fit: BoxFit.fill),
                            errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.fill),
                          ),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                        ));
                  }),
            )),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildTrendingProducts() {
    return ValueListenableBuilder(
        valueListenable: trendingProduct,
        builder: (BuildContext context, List<NewProductsData> value, Widget? child) {
          return Wrap(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    WidgetUtils.appTextWidget(context: context, title: 'Trending Products'.tr, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                    const SizedBox(width: 8),

                    /* const SizedBox(height: 8),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ProductListScreen())),
                child: Row(
                  children: [
                    WidgetUtils.appTextWidget(
                        context: context,
                        title: 'viewMore'.tr,
                        family: 'Graphik',
                        fontSize: 14,
                        color: Color(int.parse(themeColor.value.barColor!.color!)),
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w500),
                    const SizedBox(width: 6),
                    SvgPicture.asset("assets/images/view.svg", height: 10, color: Color(int.parse(themeColor.value.iconColor!.color!)))
                  ],
                ),
              ),*/
                  ])),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: double.maxFinite,
                    height: 58,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF), width: 1.2), borderRadius: BorderRadius.circular(4)),
                    child: ValueListenableBuilder(
                        valueListenable: productCategory,
                        builder: (BuildContext context, List<ProductCategory> statsValue, Widget? child) {
                          return statsValue.isNotEmpty
                              ? DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      alignment: AlignmentDirectional.topStart,
                                      isDense: false,
                                      icon: const Icon(Icons.keyboard_arrow_down, size: 13.33),
                                      isExpanded: true,
                                      value: productCategoryTitle,
                                      items: statsValue.map((element) => DropdownMenuItem(child: Text(element.title!), value: element.title!)).toList(),
                                      onChanged: (value) async {
                                        setState(() => productCategoryTitle = value!);
                                        isLoading.value = true;
                                        setState(() {});
                                        for (final details in statsValue) {
                                          if (details.title == productCategoryTitle) {
                                            HelperUtils().getTrendingProduct(() => setState(() {}), year: details.id.toString());
                                            break;
                                          }
                                        }
                                        isLoading.value = false;
                                        setState(() {});
                                      }),
                                )
                              : Container();
                        })),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              value.isEmpty
                  ? Container(height: MediaQuery.of(context).size.height * 0.22, width: MediaQuery.of(context).size.width, child: Center(child: Text("No data found".tr)))
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: value.length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                                onTap: () async {},
                                child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.22,
                                    width: MediaQuery.of(context).size.width / 2,
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
                                                    imageUrl: value[index].prodThumbnail ?? "",
                                                    imageBuilder: (context, imageProvider) => Container(
                                                        height: 100,
                                                        width: 58,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
                                                    placeholder: (context, url) => Image.file(File(image), fit: BoxFit.contain, height: 100, width: 58),
                                                    errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.contain, height: 100, width: 58),
                                                  ),
                                                  height: MediaQuery.of(context).size.height * 0.15,
                                                  width: double.maxFinite,
                                                  decoration:
                                                      BoxDecoration(color: Colors.grey.shade300, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                                                child: SizedBox(
                                                    height: 18,
                                                    width: 200,
                                                    child: WidgetUtils.appTextWidget(context: context, title: value[index].productTitle ?? "", fontWeight: FontWeight.w500, fontSize: 12)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )));
                          })),
              const SizedBox(height: 15),
            ],
          );
        });
  }

  Widget buildNewProducts() {
    return ValueListenableBuilder(
        valueListenable: newProduct,
        builder: (BuildContext context, List<NewProductsData> value, Widget? child) {
          return Wrap(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    WidgetUtils.appTextWidget(context: context, title: 'New Products'.tr, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                    const SizedBox(width: 8),

                    /* const SizedBox(height: 8),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ProductListScreen())),
                child: Row(
                  children: [
                    WidgetUtils.appTextWidget(
                        context: context,
                        title: 'viewMore'.tr,
                        family: 'Graphik',
                        fontSize: 14,
                        color: Color(int.parse(themeColor.value.barColor!.color!)),
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w500),
                    const SizedBox(width: 6),
                    SvgPicture.asset("assets/images/view.svg", height: 10, color: Color(int.parse(themeColor.value.iconColor!.color!)))
                  ],
                ),
              ),*/
                  ])),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: double.maxFinite,
                    height: 58,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF), width: 1.2), borderRadius: BorderRadius.circular(4)),
                    child: ValueListenableBuilder(
                        valueListenable: productCategory,
                        builder: (BuildContext context, List<ProductCategory> statsValue, Widget? child) {
                          return statsValue.isNotEmpty
                              ? DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      alignment: AlignmentDirectional.topStart,
                                      isDense: false,
                                      icon: const Icon(Icons.keyboard_arrow_down, size: 13.33),
                                      isExpanded: true,
                                      value: productCategoryTitle,
                                      items: statsValue.map((element) => DropdownMenuItem(child: Text(element.title!), value: element.title!)).toList(),
                                      onChanged: (value) async {
                                        setState(() => productCategoryTitle = value!);
                                        isLoading.value = true;
                                        setState(() {});
                                        for (final details in statsValue) {
                                          if (details.title == productCategoryTitle) {
                                            HelperUtils().getNewProduct(() => setState(() {}), year: details.id.toString());
                                            break;
                                          }
                                        }
                                        isLoading.value = false;
                                        setState(() {});
                                      }),
                                )
                              : Container();
                        })),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              value.isEmpty
                  ? Container(height: MediaQuery.of(context).size.height * 0.22, width: MediaQuery.of(context).size.width, child: Center(child: Text("No data found".tr)))
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: value.length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                                onTap: () async {},
                                child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.22,
                                    width: MediaQuery.of(context).size.width / 2,
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
                                                    imageUrl: value[index].prodThumbnail ?? "",
                                                    imageBuilder: (context, imageProvider) => Container(
                                                        height: 100,
                                                        width: 58,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
                                                    placeholder: (context, url) => Image.file(File(image), fit: BoxFit.contain, height: 100, width: 58),
                                                    errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.contain, height: 100, width: 58),
                                                  ),
                                                  height: MediaQuery.of(context).size.height * 0.15,
                                                  width: double.maxFinite,
                                                  decoration:
                                                      BoxDecoration(color: Colors.grey.shade300, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                                                child: SizedBox(
                                                    height: 18,
                                                    width: 200,
                                                    child: WidgetUtils.appTextWidget(context: context, title: value[index].productTitle ?? "", fontWeight: FontWeight.w500, fontSize: 12)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )));
                          })),
              const SizedBox(height: 15),
            ],
          );
        });
  }

  Widget buildRecommendProducts() {
    return Wrap(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              WidgetUtils.appTextWidget(context: context, title: 'Recommended'.tr, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500, textAlign: TextAlign.center),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ProductListScreen())),
                child: Row(
                  children: [
                    WidgetUtils.appTextWidget(
                        context: context,
                        title: 'viewMore'.tr,
                        family: 'Graphik',
                        fontSize: 14,
                        color: Color(int.parse(themeColor.value.barColor!.color!)),
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w500),
                    const SizedBox(width: 6),
                    SvgPicture.asset("assets/images/view.svg", height: 10, color: Color(int.parse(themeColor.value.iconColor!.color!)))
                  ],
                ),
              ),
            ])),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: homeConfigurableModel.value!.data!.recommended!.length > 3 ? 4 : homeConfigurableModel.value!.data!.recommended!.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 5.0, childAspectRatio: 1),
                itemBuilder: (ctx, index) {
                  return InkWell(
                      onTap: () async {
                        final recommended = homeConfigurableModel.value!.data!.recommended![index];
                        ProductsList? item = ProductsList(
                            id: recommended.id!,
                            partnerId: recommended.partnerId!,
                            categoryId: recommended.categoryId!,
                            productName: recommended.productName!,
                            overview: recommended.overview ?? '',
                            brief: recommended.brief ?? '',
                            highlight: recommended.highlight ?? '',
                            usage: recommended.usage ?? '',
                            support: recommended.support ?? '',
                            logo: recommended.logo ?? '',
                            mrp: recommended.mrp ?? '0',
                            discount: recommended.discount ?? '0',
                            flatRate: recommended.flatRate ?? '0',
                            createdById: recommended.createdById ?? '',
                            createdOn: recommended.createdOn ?? '',
                            isDeleted: recommended.isDeleted ?? '',
                            userManual: recommended.userManual ?? '',
                            status: recommended.status!,
                            infraMinCost: recommended.infraMinCost!,
                            infraMaxCost: recommended.infraMaxCost!,
                            productType: recommended.productType!,
                            price: recommended.price ?? '',
                            inStock: recommended.inStock ?? '',
                            inStockAlert: recommended.inStockAlert ?? '',
                            purchaseLimit: recommended.purchaseLimit ?? '',
                            deliveryDays: recommended.deliveryDays ?? '',
                            qty: "1",
                            cartFlag: false,
                            quantity: "1",
                            rating: "4",
                            sub_total: "");
                        final details = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemDetailsScreen(item: item)));
                        setState(() {
                          isLoading.value = false;
                        });
                        HelperUtils().getProductList(context).then((value) {
                          productDetailList.value = value;
                        });
                      },
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.2,
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
                                          imageUrl: HeaderSingleton().configurationDetails!.marketCatImageUrl! + homeConfigurableModel.value!.data!.recommended![index].logo!,
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
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                                      child: SizedBox(
                                          height: 18,
                                          width: 200,
                                          child: WidgetUtils.appTextWidget(
                                              context: context, title: homeConfigurableModel.value!.data!.recommended![index].productName!, fontWeight: FontWeight.w500, fontSize: 12)),
                                    ),
                                    homeConfigurableModel.value!.data!.recommended![index].mrp != null
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text("₹${homeConfigurableModel.value!.data!.recommended![index].mrp ?? ""}",
                                                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w300, fontSize: 12, decoration: TextDecoration.lineThrough, fontFamily: 'Graphik')),
                                          )
                                        : Container(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: WidgetUtils.appTextWidget(
                                          context: context,
                                          title: "₹${homeConfigurableModel.value!.data!.recommended![index].price!}",
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          family: 'Graphik'),
                                    ),
                                  ],
                                ),
                                homeConfigurableModel.value!.data!.recommended![index].discount != null && homeConfigurableModel.value!.data!.recommended![index].discount != "0"
                                    ? Positioned(
                                        right: -2,
                                        top: 7,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 20,
                                          width: 50,
                                          child: Text("${(homeConfigurableModel.value!.data!.recommended![index].discount ?? "") + "%"}",
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 12, fontFamily: 'Graphik')),
                                          decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(16)), color: Colors.red.shade400),
                                        ))
                                    : Container()
                              ],
                            ),
                          )));
                })),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildBlogType() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              WidgetUtils.appTextWidget(context: context, title: 'blogsLabel'.tr, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500, textAlign: TextAlign.center),
              const SizedBox(width: 10),
              InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BlogListScreen(from: "home"))),
                  child: Row(
                    children: [
                      WidgetUtils.appTextWidget(
                          context: context,
                          title: 'viewMore'.tr,
                          family: 'Graphik',
                          fontSize: 14,
                          color: Color(int.parse(themeColor.value.barColor!.color!)),
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w500),
                      const SizedBox(width: 6),
                      SvgPicture.asset("assets/images/view.svg", height: 10, color: Color(int.parse(themeColor.value.iconColor!.color!)))
                    ],
                  )),
            ])),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
              decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(color: Color(0xFFFFFFFF), blurRadius: 2, spreadRadius: 0.2)], border: Border.all(color: const Color(0x26CFCFCF)), borderRadius: BorderRadius.circular(8)),
              height: MediaQuery.of(context).size.height * 0.29,
              width: double.maxFinite,
              child: CarouselSlider.builder(
                itemCount: homeConfigurableModel.value!.data!.blogs!.length,
                options: CarouselOptions(
                  disableCenter: true,
                  // enlargeCenterPage: true,
                  padEnds: true,
                  height: (MediaQuery.of(context).size.height * 0.2),
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  reverse: false,
                  aspectRatio: 1,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) async {
                    // _currentIndex = index;
                    // setState(() {});
                  },
                ),
                itemBuilder: (context, i, id) {
                  return homeConfigurableModel.value!.data!.blogs != null
                      ? GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: double.maxFinite,
                                height: MediaQuery.of(context).size.height * 0.190,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("${HeaderSingleton().configurationDetails!.createdBlogsUrl}/${homeConfigurableModel.value!.data!.blogs![i].logo}"),
                                    ),
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                                    border: Border.all(color: Colors.white)),
                              ),
                              Container(
                                // color: Colors.black12,
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                child:
                                    Text(maxLines: 3, homeConfigurableModel.value!.data!.blogs![i].blogsTitle!, style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500)),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlogsDetailsScreen(homeConfigurableModel.value!.data!.blogs![i], HeaderSingleton().configurationDetails!.createdBlogsUrl!,
                                    categorySelected: 'All'.tr + " " + 'Blogs'.tr),
                              ),
                            );
                          },
                        )
                      : Container();
                },
              )),
        ),
        const SizedBox(height: 15)
      ],
    );
  }

  Widget buildAdvertise() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => NedfiAdvertisement())),
                  child: Row(
                    children: [
                      WidgetUtils.appTextWidget(
                          context: context,
                          title: 'viewMore'.tr,
                          family: 'Graphik',
                          fontSize: 14,
                          color: Color(int.parse(themeColor.value.barColor!.color!)),
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w500),
                      const SizedBox(width: 6),
                      SvgPicture.asset("assets/images/view.svg", height: 10, color: Color(int.parse(themeColor.value.iconColor!.color!)))
                    ],
                  ),
                ),
              ])),
          const SizedBox(height: 10),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.23,
              width: double.maxFinite,
              child: CarouselSlider.builder(
                itemCount: homeConfigurableModel.value!.data!.advertise!.length,
                options: CarouselOptions(
                  // enlargeCenterPage: true,
                  padEnds: true,
                  height: (MediaQuery.of(context).size.height * 0.23),
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  reverse: false,
                  aspectRatio: 1000 / 400,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) async {
                    // _currentIndex = index;
                    // setState(() {});
                  },
                ),
                itemBuilder: (ctx, i, id) {
                  return homeConfigurableModel.value!.data!.advertise != null
                      ? GestureDetector(
                          child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: NetworkImage("${HeaderSingleton().configurationDetails!.advertiseImageUrl}/${homeConfigurableModel.value!.data!.advertise![i].mobIcon}"),
                                ),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.white)),
                          ),
                          onTap: () async {
                            final url = homeConfigurableModel.value!.data!.advertise![i].linkUrl;
                            //print(url);
                            if (url != null && url.isNotEmpty) {
                              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                            } else {
                              WidgetUtils.errorDialog(context, "No Url Found".tr);
                              setState(() {});
                              // throw 'Could not launch $url';
                            }
                          },
                        )
                      : Container();
                },
              )),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget buildBlogsType() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // WidgetUtils.appTextWidget(context:context,
          //   title: 'Other Services'.tr,
          //   fontSize: 18,
          //   family: 'Graphik',
          //   fontWeight: FontWeight.w500,
          //   textAlign: TextAlign.center,
          // ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          SizedBox(
            height: homeConfigurableModel.value!.data!.otherServices!.length >= 3 ? 130 : 50,
            // homeConfigurableModel.value!.data!.otherServices!.length >= 3 ? MediaQuery.of(context).size.height * 0.18 : MediaQuery.of(context).size.height * 0.1,
            child: GridView.builder(
              itemCount: homeConfigurableModel.value!.data!.otherServices!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return buildBlogItems(homeConfigurableModel.value!.data!.otherServices![index], index);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: homeConfigurableModel.value!.data!.otherServices!.length >= 3 ? 0.35 : 0.3,
                  crossAxisSpacing: homeConfigurableModel.value!.data!.otherServices!.length >= 3 ? 10 : 3,
                  mainAxisSpacing: homeConfigurableModel.value!.data!.otherServices!.length >= 3 ? 10 : 3,
                  crossAxisCount: homeConfigurableModel.value!.data!.otherServices!.length > 2 ? 2 : 1),
            ),
          ),
          const SizedBox(height: 15),
        ]));
  }

  Widget buildBlogItems(OtherServices serviceBlog, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => BlogListScreen(serviceType: 'Other', blogType: serviceBlog.blogsTypesId, from: "home")));
      },
      child: Container(
        height: 150,
        // width: 100,
        // margin: const EdgeInsets.all(l̥10.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey.shade100),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CachedNetworkImage(
                height: 40,
                width: 40,
                imageUrl: homeConfigurableModel.value!.configUrl!.blogsTypesUrl! + "/" + serviceBlog.blogsTypesLogo!,
                imageBuilder: (context, img) => Container(
                  decoration: BoxDecoration(image: DecorationImage(image: img, fit: BoxFit.fill)),
                ),
                placeholder: (context, url) => Image.file(File(image), height: 40, width: 40, fit: BoxFit.cover),
                errorWidget: (context, url, error) => Image.file(File(image), height: 40, width: 40, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 80,
                child: Text(
                  HeaderSingleton().local == "en" ? serviceBlog.blogsTypesName! : serviceBlog.blogsTypesNameMr!,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategory() {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            WidgetUtils.appTextWidget(context: context, title: 'serviceLabel'.tr, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500, textAlign: TextAlign.center),
            const SizedBox(width: 10),
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ServicesScreen(services: homeConfigurableModel.value!.data!.services!))),
              child: Row(
                children: [
                  WidgetUtils.appTextWidget(
                      context: context,
                      title: 'viewMore'.tr,
                      family: 'Graphik',
                      fontSize: 14,
                      color: Color(int.parse(themeColor.value.barColor!.color!)),
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500),
                  const SizedBox(width: 6),
                  SvgPicture.asset("assets/images/view.svg", height: 10, color: Color(int.parse(themeColor.value.iconColor!.color!)))
                ],
              ),
            ),
          ])),
      const SizedBox(height: 15),
      SizedBox(
        height: (MediaQuery.of(context).size.height * 0.14),
        width: double.maxFinite,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            return GestureDetector(
                onTap: () async {
                  Map<String, dynamic> params = {
                    'id': homeConfigurableModel.value!.data!.services![index].catId,
                    'name': HeaderSingleton().local == 'en' ? homeConfigurableModel.value!.data!.services![index].name! : homeConfigurableModel.value!.data!.services![index].nameMr!
                  };
                  HelperUtils().navigateToScreens(call: () => setState(() {}), context: context, mapKey: homeConfigurableModel.value!.data!.services![index].mapKey!, params: params);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.068,
                      width: MediaQuery.of(context).size.height * 0.068,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), color: Color(int.parse(themeColor.value.barColor!.color!)).withOpacity(0.17)),
                      child: CachedNetworkImage(
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.height * 0.055,
                        fit: BoxFit.fill,
                        imageUrl: "${HeaderSingleton().configurationDetails!.categoryImgUrl}/${homeConfigurableModel.value!.data!.services![index].mobIcon}",
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          height: MediaQuery.of(context).size.height * 0.055,
                          width: MediaQuery.of(context).size.height * 0.055,
                          fit: BoxFit.contain,
                        ),
                        placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                        errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    SizedBox(
                      width: 80,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: WidgetUtils.appTextWidget(
                          context: context,
                          title: homeConfigurableModel.value!.data!.services![index].name!,
                          family: 'Graphik',
                          fontSize: 12,
                          softWrap: true,
                          color: const Color(0xff3F3F3F),
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ));
          },
          itemCount: homeConfigurableModel.value!.data!.services!.length,
        ),
      ),
      const SizedBox(height: 15),
    ]);
  }

  Widget getCommodity() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            WidgetUtils.appTextWidget(
              context: context,
              title: 'Commodity Rates Updates'.tr,
              fontSize: 18,
              family: 'Graphik',
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 10),
            GestureDetector(
                onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CommodityScreen()))},
                child: Row(
                  children: [
                    WidgetUtils.appTextWidget(
                        context: context,
                        title: 'viewMore'.tr,
                        family: 'Graphik',
                        fontSize: 14,
                        color: Color(int.parse(themeColor.value.barColor!.color!)),
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w500),
                    const SizedBox(width: 6),
                    SvgPicture.asset("assets/images/view.svg", height: 10, color: Color(int.parse(themeColor.value.iconColor!.color!)))
                  ],
                )),
          ]),
        ),
        const SizedBox(height: 15),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 135,
              width: MediaQuery.of(context).size.width - 10,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: tempCommodityList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => CommodityDetailsScreen(commodityList: tempCommodityList[index]))),
                      child: Container(
                          width: 162,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.036,
                                      width: MediaQuery.of(context).size.height * 0.036,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(blurRadius: 0.7, color: Colors.grey, spreadRadius: 0.3)],
                                      ),
                                      child: CircleAvatar(
                                        radius: MediaQuery.of(context).size.height * 0.015,
                                        backgroundImage: NetworkImage(
                                          /* HeaderSingleton().configurationDetails!.cropImageUrl! +*/
                                          (tempCommodityList[index].logo ?? ""),
                                        ),
                                        backgroundColor: Colors.white,
                                        onBackgroundImageError: (obj, st) => Image.file(File(image), fit: BoxFit.cover, height: 36, width: 36),
                                      ),
                                    ),
                                    Container(
                                      width: 90,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          SvgPicture.asset("assets/images/marker.svg", height: 8),
                                          const SizedBox(width: 2),
                                          //const Icon(Icons.location_on, color: Colors.green, size: 18),
                                          Flexible(
                                              // width: 80,
                                              child: WidgetUtils.appTextWidget(
                                                  context: context,
                                                  softWrap: false,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.right,
                                                  maxLines: 1,
                                                  title: tempCommodityList[index].marketName!,
                                                  family: 'Graphik',
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff272727),
                                                  fontSize: 12))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6.0, left: 6),
                                child: SizedBox(
                                  height: 12,
                                  width: 100,
                                  child: WidgetUtils.appTextWidget(
                                      context: context,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      title: tempCommodityList[index].productName!,
                                      family: 'Graphik',
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff272727),
                                      fontSize: 12),
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: RichText(
                                      text: TextSpan(
                                    children: <TextSpan>[
                                      const TextSpan(
                                        text: 'Min:  ₹ ',
                                        style: TextStyle(fontSize: 12.0, color: Color(0xFF6F6F6F), fontWeight: FontWeight.w300, fontFamily: 'Graphik'),
                                      ),
                                      TextSpan(
                                          text: tempCommodityList[index].minimumprices!,
                                          style: const TextStyle(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: 12, color: Colors.orange)),
                                    ],
                                  ))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: RichText(
                                    text: TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Max: ₹ ',
                                      style: TextStyle(fontSize: 12.0, color: Color(0xFF575757), fontWeight: FontWeight.w300, fontFamily: 'Graphik'),
                                    ),
                                    TextSpan(
                                        text: tempCommodityList[index].maximumprices!, style: const TextStyle(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: 12, color: Colors.green)),
                                  ],
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: RichText(
                                    text: TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Model: ₹ ',
                                      style: TextStyle(fontSize: 12.0, color: Color(0xFF575757), fontWeight: FontWeight.w300, fontFamily: 'Graphik'),
                                    ),
                                    TextSpan(
                                        text: tempCommodityList[index].modalprices!, style: const TextStyle(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: 12, color: Colors.green)),
                                  ],
                                )),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: RichText(
                                      text: TextSpan(
                                    children: <TextSpan>[
                                      const TextSpan(
                                        text: 'Date: ',
                                        style: TextStyle(fontSize: 11.0, color: Colors.black, fontWeight: FontWeight.w300, fontFamily: 'Graphik'),
                                      ),
                                      TextSpan(
                                          text: tempCommodityList[index].marketwiseapmcpricedate,
                                          style: const TextStyle(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: 11, color: Colors.black)),
                                    ],
                                  ))),
                            ],
                          ),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFCFCFCF), width: 1.2))),
                    );
                  }),
            )),
        const SizedBox(height: 15)
      ],
    );
  }

  Widget buildWeather() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          WidgetUtils.appTextWidget(context: context, title: 'weatherToday'.tr, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500, textAlign: TextAlign.center),
          const SizedBox(width: 10),
          InkWell(
              onTap: () {
                if (HeaderSingleton().weatherStreamController.value != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => WeatherForecastScreen(weatherModel: HeaderSingleton().weatherStreamController.value!)));
                } else {
                  WidgetUtils.errorDialog(context, "No Weather details available".tr);
                }
              },
              child: Row(
                children: [
                  WidgetUtils.appTextWidget(
                      context: context,
                      title: 'viewMore'.tr,
                      family: 'Graphik',
                      fontSize: 14,
                      color: Color(int.parse(themeColor.value.barColor!.color!)),
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500),
                  const SizedBox(width: 6),
                  SvgPicture.asset("assets/images/view.svg", height: 10, color: Color(int.parse(themeColor.value.iconColor!.color!)))
                ],
              )),
        ]),
        const SizedBox(height: 16),
        ValueListenableBuilder(
            valueListenable: HeaderSingleton().weatherStreamController,
            builder: (ctx, WeatherModel? weatherDetails, child) {
              String imagePath = "";
              String? iconImage;
              if (weatherDetails != null) {
                iconImage = weatherDetails!.current!.condition!.icon!;
                if (iconImage.toLowerCase().contains("day")) {
                  imagePath = "day";
                } else if (iconImage.toLowerCase().contains("night")) {
                  imagePath = "night";
                }
              }
              return weatherDetails != null
                  ? InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => WeatherForecastScreen(weatherModel: HeaderSingleton().weatherStreamController.value!)));
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: '${weatherDetails.current!.tempC.toString().substring(0, 2)}°C',
                                      family: 'Graphik',
                                      fontSize: 28,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      textAlign: TextAlign.center),
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: weatherDetails.location!.name! + ", " + weatherDetails.location!.region! + ", " + weatherDetails.location!.country!,
                                      family: 'Graphik',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      textAlign: TextAlign.center),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      child: Image.asset("assets/weather_icons/$imagePath/${HeaderSingleton().weatherStreamController.value!.current!.condition!.text!}.png",
                                          fit: BoxFit.fill, height: 47, width: 60)
                                      // FadeInImage.assetNetwork(
                                      //     placeholder: "assets/images/weather_png.png",
                                      //     imageErrorBuilder: (ctx, obj, st) => Image.asset("assets/images/weather_png.png", fit: BoxFit.cover, height: 50, width: 50),
                                      //     image: "https:" + HeaderModel().weatherStreamController.value!.current!.condition!.icon!,
                                      //     fit: BoxFit.cover,
                                      //     height: 50,
                                      //     width: 50),
                                      ),
                                  SizedBox(
                                    width: 90,
                                    child: WidgetUtils.appTextWidget(
                                        context: context,
                                        overflow: TextOverflow.ellipsis,
                                        title: weatherDetails.current!.condition!.text!,
                                        family: 'Graphik',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        textAlign: TextAlign.center),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: WidgetUtils.appTextWidget(
                          context: context, title: 'No weather data available'.tr, family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black, textAlign: TextAlign.center),
                    );
            }),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildRecommendDSS() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              WidgetUtils.appTextWidget(context: context, title: 'Recommended DSS'.tr, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500, textAlign: TextAlign.center),
              const SizedBox(width: 10),
              InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => const CropListScreen(
                                isStatus: 'DSS',
                              ))),
                  child: Row(
                    children: [
                      WidgetUtils.appTextWidget(
                          context: context,
                          title: 'viewMore'.tr,
                          family: 'Graphik',
                          fontSize: 14,
                          color: Color(int.parse(themeColor.value.barColor!.color!)),
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w500),
                      const SizedBox(width: 6),
                      SvgPicture.asset("assets/images/view.svg", height: 10, color: Color(int.parse(themeColor.value.iconColor!.color!)))
                    ],
                  )),
            ])),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Container(
            height: MediaQuery.of(context).size.height * 0.2,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: homeConfigurableModel.value!.data!.dssRecommended!.length,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return InkWell(
                      onTap: () {},
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: const EdgeInsets.only(right: 16),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    child: CachedNetworkImage(
                                      imageUrl: '${HeaderSingleton().configurationDetails!.dssModuleImageurl}/${homeConfigurableModel.value!.data!.dssRecommended![index].logo!}',
                                      imageBuilder: (context, imageProvider) => Container(
                                          height: 78,
                                          width: 78,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
                                      placeholder: (context, url) => Image.file(File(image), fit: BoxFit.fill, height: 58, width: 58),
                                      errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.fill, height: 58, width: 58),
                                    ),
                                    height: MediaQuery.of(context).size.height * 0.14,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                                  child: WidgetUtils.appTextWidget(
                                      context: context, title: homeConfigurableModel.value!.data!.dssRecommended![index].blogsTitle!, fontWeight: FontWeight.w500, fontSize: 12),
                                ),
                              ],
                            ),
                          )));
                })),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildStatWidget() {
    return ValueListenableBuilder(
      valueListenable: productReport,
      builder: (BuildContext context, List<StatisticsReportData> value, Widget? child) {
        return value.isNotEmpty
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(children: [
                  Container(
                      width: double.maxFinite,
                      height: 58,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCFCFCF), width: 1.2), borderRadius: BorderRadius.circular(4)),
                      child: ValueListenableBuilder(
                          valueListenable: filterData,
                          builder: (BuildContext context, List<StatisticsFilterData> statsValue, Widget? child) {
                            return statsValue.isNotEmpty
                                ? DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        alignment: AlignmentDirectional.topStart,
                                        isDense: false,
                                        icon: const Icon(Icons.keyboard_arrow_down, size: 13.33),
                                        isExpanded: true,
                                        value: statType,
                                        items: statsValue.map((element) => DropdownMenuItem(child: Text(element.title!), value: element.title!)).toList(),
                                        onChanged: (value) async {
                                          setState(() => statType = value!);
                                          isLoading.value = true;
                                          setState(() {});
                                          for (final details in statsValue) {
                                            if (details.title == statType) {
                                              HelperUtils().getProductReport(() => setState(() {}), year: details.value);
                                              break;
                                            }
                                          }
                                          isLoading.value = false;
                                          setState(() {});
                                        }),
                                  )
                                : Container();
                          })),
                  const SizedBox(height: 8),
                  SizedBox(
                      height: 260,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.9, crossAxisCount: 3, mainAxisSpacing: 12.0),
                        // padding: const EdgeInsets.all(8.0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.length,
                        // total number of items
                        itemBuilder: (context, index) {
                          return buildStatsCard(
                              value[index].statusTitle!,
                              (value[index].statusTitle != "")
                                  ? value[index].statusTitle.toString().toLowerCase() == "expired"
                                      ? "assets/images/stat_expired.png"
                                      : value[index].statusTitle.toString().toLowerCase() == "completed"
                                          ? "assets/images/stat_completed.png"
                                          : value[index].statusTitle.toString().toLowerCase() == "published" || value[index].statusTitle.toString().toLowerCase() == "live"
                                              ? "assets/images/stat_publish.png"
                                              : value[index].statusTitle.toString().toLowerCase() == "approved"
                                                  ? "assets/images/stat_approve.png"
                                                  : value[index].statusTitle.toString().toLowerCase() == "pending" || value[index].statusTitle.toString().toLowerCase() == "draft"
                                                      ? "assets/images/stat_pending.png"
                                                      : value[index].statusTitle.toString().toLowerCase() == "sold"
                                                          ? "assets/images/stat_sold.png"
                                                          : "assets/images/stat_sold.png"
                                  : "assets/images/stat_sold.png",
                              value[index].rowCount!);
                        },
                      ))
                ]))
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: DottedBorder(
                  dashPattern: [8, 4],
                  strokeWidth: 1.5,
                  color: Color(int.parse(themeColor.value.barColor!.color!)),
                  child: Container(
                    height: 116,
                    width: double.maxFinite,
                    color: const Color(0xffFFF6E9),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        WidgetUtils.appTextWidget(
                          context: context,
                          title: "Add your first product to get started".tr,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          family: "Graphik",
                          color: Color(int.parse(themeColor.value.barColor!.color!)),
                        ),
                        const SizedBox(height: 12),
                        IconButton(
                          icon: Icon(Icons.add, size: 46, color: Color(int.parse(themeColor.value.barColor!.color!))),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductMainScreen(type: "NEW"))).then((value) {
                              HelperUtils().getProductReport(() => setState(() {
                                    statType = filterData.value[0].title!;
                                  }));
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ));
      },
    );
  }

  Widget buildStatsCard(String title, String imageName, String count) {
    return Container(
      height: 136,
      child: Stack(
        children: [
          Container(
              height: 104,
              width: 101,
              margin: const EdgeInsets.only(top: 25),
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xffCFCFCF))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  WidgetUtils.appTextWidget(context: context, title: count, family: 'Graphik', fontSize: 28, color: Colors.black, textAlign: TextAlign.center, fontWeight: FontWeight.w500),
                  const SizedBox(height: 5),
                  WidgetUtils.appTextWidget(
                      context: context, title: title.tr, family: 'Graphik', fontSize: 14, color: const Color(0xFF4B4B4B), textAlign: TextAlign.center, fontWeight: FontWeight.w500),
                ],
              )),
          Positioned(left: 11, top: 0, child: Image.asset(imageName, height: 50))
        ],
      ),
    );
  }

  fetchCommoditynew(String city, {bool isFrom = false}) async {
    try {
      final param = {"apmc_market": city, 'lat': HeaderSingleton().lat, 'long': HeaderSingleton().lng};
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        // //print(ApiURL.nearByMarketNewData);
        // //print("Params:$param");
        // final response = await APIService.postAPIMethod(url: ApiURL.nearByMarketNewData, params: param);
        final response = await APIService.postAPIMethod(url: ApiURL.commodityPrice, params: param);
        final data = json.decode(response.body);
        //print(data);
        if (data['success'] != 1) {
          WidgetUtils.errorDialog(context, data["msg"]);
        } else {
          if (data['data'].isEmpty) {
          } else {
            List<NewCommoditydata> tempList = [];
            for (final commodityData in data['data']) {
              tempList.add(NewCommoditydata.fromJson(commodityData));
            }

            tempCommodityList = tempList;
          }

          if (isFrom) {
            if (mounted) setState(() {});
          }
        }
      }
    } catch (e) {
      // //print(e);
      isLoading.value = false;
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
