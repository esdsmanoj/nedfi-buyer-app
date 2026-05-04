import 'package:get/get.dart';

import '../../../components/widgets/base_widget.dart';
import 'DieaseDetailsScreen.dart';
import 'package:nedfi_seller_common_code/app_imports.dart';

class CropDiseaseScreen extends StatefulWidget {
  String? cropID, from, cropName, componentId;
  final String title, logo;

  CropDiseaseScreen({super.key, this.cropID, this.from, this.cropName, this.componentId, required this.title, required this.logo});

  @override
  _CropDiseaseScreenState createState() => _CropDiseaseScreenState();
}

class _CropDiseaseScreenState extends State<CropDiseaseScreen> {
  File? imageFileOne;
  ValueNotifier<int> selected = ValueNotifier(2);
  List<FilterData> filterList = [];

  @override
  void initState() {
    super.initState();
    if (widget.from!.toLowerCase() == 'nutrition_deficiency') {
      filterList = [FilterData(title: "Nutrition Deficiency".tr, id: 1)];
      selected.value = 1;
    }
    // if (widget.title.toLowerCase() == 'pest') {
    //   selected.value = 2;
    // } else if (widget.title.toLowerCase() == 'disease') {
    //   selected.value = 3;
    // } else if (widget.title.toLowerCase() == 'deficiency') {
    //   selected.value = 1;
    // } else {
    //   selected.value = 0;
    // }
    // var dSSModel = Provider.of<DSSModel>(context, listen: false);
    // dSSModel.setDiseaseFilterList([]);
    getDiseaseFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DSSProvider>(builder: (context, dSSModel, child) {
      return BaseWidget(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          title: WidgetUtils.appTextWidget(context:context,title: '${widget.cropName}', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500, family: 'Graphik'),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Center(
              //     child: Container(
              //         height: MediaQuery.of(context).size.height * 0.2,
              //         width: double.maxFinite,
              //         alignment: Alignment.center,
              //         color: const Color(0xffE7F3EB),
              //         child: Column(
              //           children: [
              //             SizedBox(height: MediaQuery.of(context).size.height*0.01),
              //             ClipOval(
              //               child: CachedNetworkImage(
              //                 imageUrl:widget.from!.toLowerCase() == 'nutrition_deficiency'? widget.logo: "${HeaderModel().configurationDetails!.cropImageUrl}"  +widget.logo,
              //                 imageBuilder: (context, imageProvider) => CircleAvatar(
              //                   radius: 50,
              //                   child: Container(
              //                       decoration: BoxDecoration(
              //                     image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              //                   )),
              //                 ),
              //                 placeholder: (context, url) => Image.asset(image, fit: BoxFit.cover, height: 58, width: 58),
              //                 errorWidget: (context, url, error) => Image.asset(image, fit: BoxFit.cover, height: 58, width: 58),
              //               ),
              //             ),
              //             SizedBox(height: MediaQuery.of(context).size.height*0.01),
              //             // height: MediaQuery.of(context).size.height * 0.12,
              //             // width: double.maxFinite,
              //             // decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(16))),
              //             SizedBox(
              //                 height: 25,
              //                 width: 200,
              //                 child: WidgetUtils.appTextWidget(context:context,textAlign: TextAlign.center, title: widget.cropName!, color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
              //           ],
              //         ))),
              // SizedBox(height: MediaQuery.of(context).size.height*0.01),
              filterList.isNotEmpty
                  ? ValueListenableBuilder(
                      valueListenable: selected,
                      builder: (BuildContext context, tapped, Widget? child) {
                        return filterList.length > 1
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      selected.value = filterList[0].id!;
                                      await getDiseaseFilter();
                                    },
                                    child: Container(
                                        height: 60,
                                        width: MediaQuery.of(context).size.width / 2,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: WidgetUtils.appTextWidget(context:context,
                                            title: filterList[0].title!,
                                            color: tapped == filterList[0].id ? Colors.white : Colors.black,
                                            fontSize: 16,
                                            family: 'Graphik',
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w400),
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.circular(8),
                                          color: tapped != filterList[0].id ? Colors.grey.shade400 : const Color(0xff27914F).withOpacity(0.7),
                                        )),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      selected.value = filterList[1].id!;
                                      await getDiseaseFilter();
                                    },
                                    child: Container(
                                        height: 60,
                                        width: MediaQuery.of(context).size.width / 2,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: WidgetUtils.appTextWidget(context:context,
                                            title: filterList[1].title!,
                                            color: tapped == filterList[1].id ? Colors.white : Colors.black,
                                            fontSize: 16,
                                            family: 'Graphik',
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w500),
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.circular(8),
                                          color: tapped != filterList[1].id ? Colors.grey.shade400 : const Color(0xff27914F).withOpacity(0.7),
                                        )),
                                  )
                                ],
                              )
                            : InkWell(
                                onTap: () async {
                                  selected.value = filterList[0].id!;
                                  await getDiseaseFilter();
                                },
                                child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: WidgetUtils.appTextWidget(context:context,
                                        title: filterList[0].title!, color: tapped == filterList[0].id ? Colors.white : Colors.black, fontSize: 18, textAlign: TextAlign.center),
                                    decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(8),
                                      color: tapped != filterList[0].id ? Colors.grey.shade400 : const Color(0xff27914F).withOpacity(0.7),
                                    )),
                              );
                      },
                    )
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              dSSModel.diseaseList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dSSModel.diseaseList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return categoryItem(dSSModel.diseaseList[index], index);
                        },
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1.12, crossAxisSpacing: 16, mainAxisSpacing: 16, crossAxisCount: 2),
                      ),
                    )
                  : Center(
                      child: WidgetUtils.appTextWidget(context:context,title: 'No data found'.tr, color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, family: 'Grapihk'),
                    ),
            ],
          ),
        ),
      );
    });
  }

  Widget categoryItem(DiseaseData categoryResponse, int index) {
    return SizedBox(
        height: 131,
        width: MediaQuery.of(context).size.width * 0.26,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiseaseDetailsScreen(
                        cropID: widget.cropID, cropName: widget.cropName, componentId: widget.componentId, from: "dss", diseaseID: categoryResponse.diseaseId, diseaseDetailsScreen: categoryResponse)));
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: CachedNetworkImage(
                      imageUrl: categoryResponse.iconImg!,
                      imageBuilder: (context, imageProvider) => Container(
                          height: 97,
                          // width: 58,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: imageProvider, fit: BoxFit.fill), borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
                      placeholder: (context, url) => Image.file(File(image), fit: BoxFit.fill, height: 97, width: 58),
                      errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.fill, height: 97, width: 58),
                    ),
                    height: 97,
                    width: double.maxFinite,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Container(
                    alignment: Alignment.center,
                      // height: 35,
                      width: 200,
                      child: WidgetUtils.appTextWidget(context:context,
                          textAlign: TextAlign.center,
                          title: categoryResponse.diseaseName??"",
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          softWrap: false,
                          family: 'Graphik',
                          overflow: TextOverflow.ellipsis)),
                ),
              ],
            ),
          ),
        ));

    // GestureDetector(
    //   onTap: () {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => DieaseDetailsScreen(
    //                 cropID: widget.cropID, cropName: widget.cropName, componentId: widget.componentId, from: "dss", diseaseID: catagoryResponse.diseaseId, dieaseDetailsScreen: catagoryResponse)));
    //   },
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       SizedBox(
    //         height: MediaQuery.of(context).size.height * 0.18,
    //         width: MediaQuery.of(context).size.height * 0.26,
    //         child: Card(
    //             elevation: 2,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(5.0),
    //             ),
    //             clipBehavior: Clip.antiAliasWithSaveLayer,
    //             color: const Color(0xfff5f5f5),
    //             child: SizedBox(
    //               child: FadeInImage.assetNetwork(
    //                 placeholder: image,
    //                 imageErrorBuilder: (ctx, obj, sTrace) => Image.file(
    //                   File(imgPlaceHolder),
    //                   fit: BoxFit.fill,
    //                   height: MediaQuery.of(context).size.height * 0.2,
    //                   width: MediaQuery.of(context).size.height * 0.15,
    //                 ),
    //                 image: catagoryResponse.iconImg!,
    //                 fit: BoxFit.cover,
    //               ),
    //               height: 80,
    //             )),
    //       ),
    //       Text(
    //         catagoryResponse.diseaseName!,
    //         textAlign: TextAlign.center,
    //         overflow: TextOverflow.ellipsis,
    //         style: const TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
    //       ),
    //     ],
    //   ));
  }

  Future getDiseaseFilter() async {
    setState(() {
      isLoading.value = true;
    });
    try {
      Map<String, dynamic> params1 = {"crop_id": widget.cropID, 'disease_type': selected.value == 99 ? 'all' : selected.value.toString()};
      final response = await APIService.postAPIMethod(url: ApiURL.cropDiseaseDetectionFiltered, params: params1);
      final data = json.decode(response.body);
      final res = DiseaseFilterModel.fromJson(data);
      if (res.status == 1) {
        DSSProvider dSSModel = Provider.of<DSSProvider>(context, listen: false);
        // dSSModel.setDiseaseFilterList([]);
        dSSModel.setDiseaseList(res.data ?? []);
        if (widget.from!.toLowerCase() == 'nutrition_deficiency') {
          filterList = [FilterData(title: "Nutrition Deficiency".tr, id: 1)];
        } else {
          dSSModel.setDiseaseFilterList(res.filterData ?? []);
          filterList = res.filterData ?? [];
        }
      }
      setState(() {
        isLoading.value = false;
      });
    } catch (e) {
      // print(e.toString());
      setState(() {
        isLoading.value = false;
      });
    }
  }
}
