import 'package:buyer_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../components/widgets/base_widget.dart';
import '../../model/DSSCropResponse.dart' as dcr;

class CropListScreen extends StatefulWidget {
  final String isStatus;

  const CropListScreen({Key? key, required this.isStatus}) : super(key: key);

  @override
  State<CropListScreen> createState() => _CropListScreenState();
}

class _CropListScreenState extends State<CropListScreen> {
  List<AdvisoryProvider> dSSCropList = [];
  ValueNotifier<dcr.CropDetails?> cropAdvisoryDetails = ValueNotifier(null);
  ValueNotifier<List<dcr.AllCrops>> searchCropList = ValueNotifier([]);
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future getDetails() async {
    await getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          title: WidgetUtils.appTextWidget(context: context, title: 'Select Crop'.tr, color: Colors.white, family: 'Graphik', fontSize: 18, fontWeight: FontWeight.w500),
          leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Theme(
              data: Theme.of(context).copyWith(hintColor: Colors.white),
              child: Container(
                color: Color(int.parse(themeColor.value.barColor!.color!)),
                width: double.maxFinite,
                height: 55,
                margin: const EdgeInsets.only(bottom: 15),
                alignment: Alignment.center,
                child: Container(
                  width: double.maxFinite,
                  height: 43,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  // margin: const EdgeInsets.only(right: 16),
                  child: TextField(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      List<dcr.AllCrops> crops = [];
                      if (value.isNotEmpty) {
                        for (final details in cropAdvisoryDetails.value!.data!.allCrops!) {
                          if (details.name!.toLowerCase().contains(value.toLowerCase())) {
                            crops.add(details);
                          }
                        }
                        searchCropList.value = crops;
                        // //print(crops.toString());
                        return;
                      } else {
                        searchCropList.value = [];
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, size: 22, color: Colors.grey),
                      hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Graphik', fontSize: 14, fontWeight: FontWeight.w400),
                      hintText: 'Search anything..'.tr,
                      border: InputBorder.none,
                      counterText: "",
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    ),
                    style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
        ),
        child: SingleChildScrollView(
            child: ValueListenableBuilder(
          valueListenable: searchCropList,
          builder: (BuildContext context, value, Widget? child) {
            return value.isNotEmpty
                ? buildSearchCrops()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      ValueListenableBuilder(
                          valueListenable: cropAdvisoryDetails,
                          builder: (BuildContext context, dcr.CropDetails? value, Widget? child) {
                            return value != null && value.data!.myCrops!.isNotEmpty
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: WidgetUtils.appTextWidget(
                                            context: context,
                                            title: 'selectedCrops'.tr,
                                            family: 'Graphik',
                                            fontSize: 16,
                                            softWrap: true,
                                            color: const Color(0xff3F3F3F),
                                            fontWeight: FontWeight.w500,
                                            textAlign: TextAlign.center),
                                      ),
                                      buildMyCrops(value),
                                    ],
                                  )
                                : Container();
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: WidgetUtils.appTextWidget(
                            context: context,
                            title: 'allCrops'.tr,
                            family: 'Graphik',
                            fontSize: 16,
                            softWrap: true,
                            color: const Color(0xff3F3F3F),
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center),
                      ),
                      buildAllCrops()
                    ],
                  );
          },
        )));
  }

  Widget buildMyCrops(dcr.CropDetails value) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
            scrollDirection: Axis.vertical,
            itemCount: value.data!.myCrops!.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10.0, mainAxisSpacing: 5.0, childAspectRatio: 12 / 18),
            itemBuilder: (ctx, index) {
              return Stack(
                children: [
                  InkWell(
                      onTap: () {
                        final details = value.data!;
                        if (widget.isStatus == 'DSS') {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DSSMainScreen(dssMyCrops: details.myCrops![index])));
                        } else if (widget.isStatus == 'MyCrops') {
                          // showAddCropDialog(details, index);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => DSSMainScreen(details)));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (newCtx) => SuggestCall(cropId: value.data!.allCrops![index].cropId!)));
                        }
                      },
                      child: SizedBox(
                        height: (MediaQuery.of(context).size.height * 0.18),
                        width: double.maxFinite,
                        child: Column(
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.height * 0.1,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(border: Border.all(color: const Color(0xff27914F)), borderRadius: BorderRadius.circular(17), color: Colors.white),
                              child: CachedNetworkImage(
                                height: MediaQuery.of(context).size.height * 0.085,
                                width: MediaQuery.of(context).size.height * 0.085,
                                fit: BoxFit.fill,
                                imageUrl: "${HeaderSingleton().configurationDetails!.cropImageUrl}/${value.data!.myCrops![index].logo!}",
                                imageBuilder: (context, imageProvider) => Container(
                                  height: MediaQuery.of(context).size.height * 0.085,
                                  width: MediaQuery.of(context).size.height * 0.085,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: imageProvider, fit: BoxFit.contain)
                                  ),
                                ),
                                placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                                errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                width: 80,
                                height: MediaQuery.of(context).size.height * 0.036,
                                child: WidgetUtils.appTextWidget(
                                    context: context,
                                    title: value.data!.myCrops![index].name ?? 'Crop $index',
                                    family: 'Graphik',
                                    fontSize: 12,
                                    softWrap: true,
                                    color: const Color(0xff3F3F3F),
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center),
                              ),
                            )
                          ],
                        ),
                      )),
                  Positioned(
                      top: 1,
                      right: 1,
                      child: InkWell(
                          onTap: () {
                            HelperUtils().showNormalDialog(
                                context: context,
                                title: 'Are_you_sure'.tr,
                                content: 'Do you want to delete the Crop'.tr,
                                onYesTapped: (valueCtx) async {
                                  Navigator.pop(valueCtx);
                                  await deleteCropDetails(value.data!.myCrops![index].id!);
                                });
                          },
                          child: SvgPicture.asset("assets/images/cross_design.svg", height: 18)))
                ],
              );
            }));
  }

  Future fetchMyCrops() async {
    try {
      isLoading.value = false;
      List<dcr.MyCrops> myCropsList = [];
      final params = {'client_id': HeaderSingleton().paramsMaps!.userId!};
      // //print(params);
      final response = await APIService.postAPIMethod(url: ApiURL.myCropsList, params: params);
      final data = json.decode(response.body);
      if (data['success'] == 1) {
        for (final value in data['data']) {
          myCropsList.add(dcr.MyCrops.fromJson(value));
        }
        List<dcr.AllCrops>? tempCrops = cropAdvisoryDetails.value!.data!.allCrops;
        cropAdvisoryDetails.value = dcr.CropDetails(success: data['success'], data: dcr.CropData(allCrops: tempCrops, myCrops: myCropsList));
      }

      isLoading.value = false;
      setState(() {});
    } catch (e) {
      isLoading.value = false;
      setState(() {});
      rethrow;
    }
  }

  Future addCropDetails(final details, int index) async {
    try {
      isLoading.value = true;
      setState(() {});
      final params = {'client_id': HeaderSingleton().paramsMaps!.userId!, 'crop_id': details.allCrops![index].cropId, 'crop_type': "0", 'btn_submit': "submit"};
      final response = await APIService.postAPIMethod(url: ApiURL.addMyCrops, params: params);
      final data = json.decode(response.body);
      if (data['success'] == 1) {
        await getCategory();
        WidgetUtils.successDialog(context, data['message']);
        setState(() {});
      } else {
        WidgetUtils.errorDialog(context, data['message']);
        setState(() {});
      }

      isLoading.value = false;
      setState(() {});
    } catch (e) {
      isLoading.value = false;
      setState(() {});
      rethrow;
    }
  }

  Future deleteCropDetails(String id) async {
    // isLoading.value = true;
    try {
      final response = await http.put(Uri.parse(baseURL + ApiURL.deleteMyCrop + "/" + id), headers: headerParams);
      final details = json.decode(response.body);
      if (details['status'] == 1) {
        WidgetUtils.successDialog(context, details['message']);
        // myCrops.removeAt(index);
        getCategory();
        setState(() {});
      }
      // isLoading.value = false;
    } catch (e) {
      // // isLoading.value = false;
      setState(() {});
      rethrow;
    }
  }

  Widget buildAllCrops() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ValueListenableBuilder(
        valueListenable: cropAdvisoryDetails,
        builder: (BuildContext context, dcr.CropDetails? value, Widget? child) {
          return value != null
              ? GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: value.data!.allCrops!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10.0, mainAxisSpacing: 5.0, childAspectRatio: 12 / 18),
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        final details = value.data!;
                        if (widget.isStatus == 'DSS') {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DSSMainScreen(dssCropData: details.allCrops![index])));
                        } else if (widget.isStatus == 'MyCrops') {
                          showAddCropDialog(details, index);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => DSSMainScreen(details)));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (newCtx) => SuggestCall(cropId: value.data!.allCrops![index].cropId!)));
                        }
                      },
                      child: SizedBox(
                        height: (MediaQuery.of(context).size.height * 0.18),
                        width: double.maxFinite,
                        child: Column(
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.height * 0.1,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xff27914F)),
                                borderRadius: BorderRadius.circular(17),
                                color: Colors.white,
                              ),
                              child: CachedNetworkImage(
                                height: MediaQuery.of(context).size.height * 0.085,
                                width: MediaQuery.of(context).size.height * 0.085,
                                fit: BoxFit.fill,
                                imageUrl: "${HeaderSingleton().configurationDetails!.cropImageUrl}/${value.data!.allCrops![index].mobIcon}",
                                imageBuilder: (context, imageProvider) => Container(
                                  height: MediaQuery.of(context).size.height * 0.085,
                                  width: MediaQuery.of(context).size.height * 0.085,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                                  ),
                                ),
                                placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                                errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                  width: 80,
                                  height: MediaQuery.of(context).size.height * 0.036,
                                  child: WidgetUtils.appTextWidget(
                                      context: context,
                                      title: value.data!.allCrops![index].name!,
                                      family: 'Graphik',
                                      fontSize: 12,
                                      softWrap: true,
                                      color: const Color(0xff3F3F3F),
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.center)),
                            )
                          ],
                        ),
                      ),
                    );
                  })
              : Center(child: WidgetUtils.appTextWidget(context: context, title: "No data found".tr));
        },
      ),
    );
  }

  void showAddCropDialog(final details, int index) {
    HelperUtils().showNormalDialog(
        context: context,
        title: 'Are_you_sure'.tr,
        content: 'Do you want to Add this Crop?'.tr,
        onYesTapped: (valueCtx) async {
          Navigator.pop(valueCtx);
          setState(() {});
          await addCropDetails(details, index);
        });
  }

  Widget buildSearchCrops() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ValueListenableBuilder(
        valueListenable: searchCropList,
        builder: (BuildContext context, List<dcr.AllCrops> searchCrops, Widget? child) {
          return GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: searchCrops.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 1.0, mainAxisSpacing: 5.0),
              itemBuilder: (ctx, index) {
                final details = dcr.CropData(allCrops: searchCrops);
                return InkWell(
                  onTap: () {
                    if (widget.isStatus == 'DSS') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DSSMainScreen(dssCropData: details.allCrops![index])));
                    } else if (widget.isStatus == 'MyCrops') {
                      showAddCropDialog(details, index);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => DSSMainScreen(details)));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (newCtx) => SuggestCall(cropId: details.allCrops![index].cropId!)));
                    }
                  },
                  child: SizedBox(
                    height: (MediaQuery.of(context).size.height * 0.18),
                    width: double.maxFinite,
                    child: Column(
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.height * 0.1,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(border: Border.all(color: const Color(0xff27914F)), borderRadius: BorderRadius.circular(17), color: Colors.white),
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.085,
                            width: MediaQuery.of(context).size.height * 0.085,
                            fit: BoxFit.fill,
                            imageUrl: "${HeaderSingleton().configurationDetails!.cropImageUrl}/${details.allCrops![index].mobIcon}",
                            imageBuilder: (context, imageProvider) => Container(
                              height: MediaQuery.of(context).size.height * 0.085,
                              width: MediaQuery.of(context).size.height * 0.085,
                              decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.contain)),
                            ),
                            placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                            errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            width: 80,
                            height: MediaQuery.of(context).size.height * 0.036,
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                title: details.allCrops![index].name!,
                                family: 'Graphik',
                                fontSize: 12,
                                softWrap: true,
                                color: const Color(0xff3F3F3F),
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Future getCategory() async {
    isLoading.value = true;
    try {
      // HeaderModel().setClientID();
      headerParams['client_id'] = HeaderSingleton().paramsMaps!.userId!;
      final response = await APIService.getAPIMethod(url: ApiURL.getCropsList);
      final data = json.decode(response.body);
      // //print(data);
      var res = dcr.CropDetails.fromJson(data);
      if (res.status == 1) {
        cropAdvisoryDetails.value = res;
        setState(() {});
      }
      isLoading.value = false;
    } catch (e) {
      // //print(e.toString());
      isLoading.value = false;
      // WidgetUtils.errorDialog(context, 'Not_able_to_get_Menu'.tr, 2);
    }
  }
}
