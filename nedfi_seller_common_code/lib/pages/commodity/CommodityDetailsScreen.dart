import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../components/image_previewer.dart';
import '../../components/widgets/base_widget.dart';
import '../../model/home_page_model.dart';

class CommodityDetailsScreen extends StatefulWidget {
  final NewCommoditydata commodityList;

  const CommodityDetailsScreen({Key? key, required this.commodityList}) : super(key: key);

  @override
  _CommodityDetailsScreenState createState() => _CommodityDetailsScreenState();
}

class _CommodityDetailsScreenState extends State<CommodityDetailsScreen> {
  int pageValue = 0;
  List<NewCommoditydata> listDetails = [];

  @override
  void initState() {
    super.initState();
    //fetchCommodityDetails();
    fetchCommodity();
  }

   fetchCommodity() async {
    try {

      final param = { "id": widget.commodityList.id};
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        // print(ApiURL.nearByMarketNewData);
        // print("Params:$param");
        // final response = await APIService.postAPIMethod(url: ApiURL.nearByMarketNewData, params: param);
        final response = await APIService.postAPIMethod(url: ApiURL.commodityPrice, params: param);
        final data = json.decode(response.body);
        // print(data);
        if (data['success'] != 1) {
          WidgetUtils.errorDialog(context, data["msg"]);

        } else {
          if (data['data'].isEmpty) {

          } else {
            List<NewCommoditydata> tempList = [];
            for (final commodityData in data['more_details']) {
              tempList.add(NewCommoditydata.fromJson(commodityData));
            }
            listDetails = tempList;
          }

         setState(() {

         });
        }
      }
    } catch (e) {
      // print(e);
      isLoading.value = false;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Consumer<CommodityProvider>(builder: (context, commodityModel, child) {
      return BaseWidget(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, title: widget.commodityList.productName! + " " + 'priceTrend'.tr, color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                // fetchCommodityDetails();
              }
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text('Prediction Graph'.tr, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ImagePreviewer(urlImage: commodityModel.graph_image))),
                      child: CachedNetworkImage(
                        height: 300,
                        imageUrl: commodityModel.graph_image,
                        imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.fill))),
                        placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                        errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                      height: 60,
                      width: double.maxFinite,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!)), borderRadius: BorderRadius.circular(4)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        SizedBox(
                            width: 100,
                            child: WidgetUtils.appTextWidget(
                                context: context, title: 'Date'.tr, fontSize: 14, family: 'Graphik', color: Colors.white, fontWeight: FontWeight.w500, textAlign: TextAlign.center)),
                        SizedBox(
                            width: 100,
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: "Model Price".tr + "\n" + "model_qty".tr,
                                fontSize: 14,
                                family: 'Graphik',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center)),
                        SizedBox(
                            width: 100,
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: 'Arrivals'.tr + "\n" + "ton".tr,
                                fontSize: 14,
                                family: 'Graphik',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center)),
                      ])),
                  const SizedBox(height: 10),
                  listDetails.length!= 0
                      ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listDetails.length,
                      itemBuilder: (ctx, index) {

                        return Container(
                            height: 54,
                            width: MediaQuery.of(context).size.width - 100,
                            // padding:const EdgeInsets.symmetric(horizontal: 8),
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width / 3 - 20,
                                    child: WidgetUtils.appTextWidget(
                                        color:  Colors.black ,
                                        context: context,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        title: listDetails[index].marketwiseapmcpricedate??"",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14)),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3 - 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.appTextWidget(
                                          context: context,
                                          textAlign: TextAlign.center,
                                          title: '₹${listDetails[index].modalprices}/Q',
                                          color: const Color(0xff27914F),
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                      // const Icon(Icons.arrow_downward_outlined, color: Colors.red, size: 15)
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3 - 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.appTextWidget(
                                          context: context,
                                          textAlign: TextAlign.center,
                                          title: '${listDetails[index].arrivals}T',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 14),
                                      // const Icon(Icons.arrow_upward_outlined, color: Colors.green, size: 15)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Color(0xffCFCFCF), width: 1)));
                      })
                      : Container(),
                  pageValue != 0
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: pageValue,
                          itemBuilder: (ctx, index) {
                            DateTime dateTrend = DateTime.parse(commodityModel.commodityDetailList[index].newdateformat);
                            final DateFormat formatter = DateFormat('dd MMM yy');
                            final String formatted = formatter.format(dateTrend);
                            // final arrivalDate= snapshot[index].arrivalDate!.split("-");
                            final predictionDate = dateTrend;
                            final currentDate = DateTime.now();
                            final difference = predictionDate.difference(currentDate).inDays;
                            return Container(
                                height: 54,
                                width: MediaQuery.of(context).size.width - 100,
                                // padding:const EdgeInsets.symmetric(horizontal: 8),
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width / 3 - 20,
                                        child: WidgetUtils.appTextWidget(
                                            color: (difference < 0) ? Colors.black : Colors.orange,
                                            context: context,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            title: formatted,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14)),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3 - 20,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          WidgetUtils.appTextWidget(
                                              context: context,
                                              textAlign: TextAlign.center,
                                              title: '₹${commodityModel.commodityDetailList[index].modalprices}/Q',
                                              color: const Color(0xff27914F),
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                          // const Icon(Icons.arrow_downward_outlined, color: Colors.red, size: 15)
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3 - 20,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          WidgetUtils.appTextWidget(
                                              context: context,
                                              textAlign: TextAlign.center,
                                              title: '${commodityModel.commodityDetailList[index].arrivals}T',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 14),
                                          // const Icon(Icons.arrow_upward_outlined, color: Colors.green, size: 15)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Color(0xffCFCFCF), width: 1)));
                          })
                      : Container(),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      if (pageValue < commodityModel.commodityDetailList.length) {
                        if ((pageValue + 5) > commodityModel.commodityDetailList.length) {
                          final diff = commodityModel.commodityDetailList.length - pageValue;
                          pageValue = pageValue + diff;
                        } else {
                          pageValue = pageValue + 5;
                        }
                        setState(() {});
                      } else {
                        final diff = commodityModel.commodityDetailList.length - pageValue;
                        pageValue = pageValue + diff;
                        if (diff == 0) {
                          WidgetUtils.errorDialog(context, 'No more records available'.tr);
                        }
                      }
                    },
                    child: Container(
                      height: 53.21,
                      width: 113,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetUtils.appTextWidget(context: context, title: "View More".tr, family: 'Graphik', fontWeight: FontWeight.w500, fontSize: 14, color: const Color(0xff27914F)),
                          SvgPicture.asset(
                            "assets/images/down_arrow.svg",
                            height: 10,
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color(0xffF9F9F9),
                          border: Border.all(
                            width: 1,
                            color: const Color(0xff27914F),
                          )),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ));
    });
  }

  Future fetchCommodityDetails() async {
    try {
      isLoading.value = true;
      Provider.of<HomeDashboardProvider>(context, listen: false);
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      var param = {
       /* "commodity_name": stringToBase64.encode(widget.commodityList.mapKey!),
        "market_name": stringToBase64.encode(widget.commodityList.market!),*/
        "varity": stringToBase64.encode(widget.commodityList.variety!),
        "is_encode": "1"
      };
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.postAPIMethod(url: ApiURL.commodityDetailsDataNew, params: param);
        var data = json.decode(response.body);
        // // print(data);
        CommodityDetailsResponse commodityDetailsResponse = CommodityDetailsResponse.fromJson(data);
        if (commodityDetailsResponse.status != 1) {
          WidgetUtils.errorDialog(context, data["msg"] ?? "");
        } else {
          var dSSModel = Provider.of<CommodityProvider>(context, listen: false);
          dSSModel.setCommodityDetailsData(commodityDetailsResponse.costArray);
          dSSModel.setCommodityDetailsCostArray(commodityDetailsResponse.costArray);
          dSSModel.setCommodityDetailsGraphArray(commodityDetailsResponse.graphArray);
          dSSModel.setGraph_image(commodityDetailsResponse.graphImage);
          if (commodityDetailsResponse.costArray.length >= 5) {
            pageValue = 5;
          } else {
            pageValue = commodityDetailsResponse.costArray.length;
          }
        }
      }
      isLoading.value = false;
    } catch (e) {
      // print(e);
      isLoading.value = false;
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
