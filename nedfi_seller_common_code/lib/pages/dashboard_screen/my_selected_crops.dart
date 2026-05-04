import 'dart:convert';

import 'package:nedfi_seller_common_code/model/DSSCropResponse.dart' as dssCrops;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../components/utils/Constants.dart';
import '../../components/utils/helper_utils.dart';
import '../../components/utils/widget_utils.dart';
import '../../model/home_page_model.dart';
import '../../services/api_service.dart';
import '../../singleton/header_singleton.dart';
import '../crop_list/crop_list.dart';
import '../dss/DSSMainScreen.dart';

class MySelectedCrops extends StatefulWidget {
  final Function(List<MyCrops>) getCropList;
  final List<MyCrops> myCrops;

  const MySelectedCrops({Key? key, required this.myCrops, required this.getCropList}) : super(key: key);

  @override
  State<MySelectedCrops> createState() => _MySelectedCropsState();
}

class _MySelectedCropsState extends State<MySelectedCrops> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: WidgetUtils.appTextWidget(context: context, title: 'My Crops'.tr, fontSize: 16, family: 'Graphik', color: Colors.white, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 10),
      Container(
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 16),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 100,
                child: widget.myCrops.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.myCrops.length,
                        itemBuilder: (ctx, index) {
                          return Stack(children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: InkWell(
                                onTap: () {
                                  dssCrops.MyCrops crops = dssCrops.MyCrops(
                                      id: widget.myCrops[index].id,
                                      clientId: widget.myCrops[index].clientId,
                                      landId: widget.myCrops[index].landId,
                                      crop: widget.myCrops[index].crop,
                                      cropType: widget.myCrops[index].cropType,
                                      areaUnderCultivation: widget.myCrops[index].areaUnderCultivation,
                                      unit: widget.myCrops[index].unit,
                                      calculatedArea: widget.myCrops[index].calculatedArea,
                                      createdById: widget.myCrops[index].createdById,
                                      createdOn: widget.myCrops[index].createdOn,
                                      updatedOn: widget.myCrops[index].updatedOn,
                                      updatedById: widget.myCrops[index].updatedById,
                                      isDeleted: widget.myCrops[index].isDeleted,
                                      deletedById: widget.myCrops[index].deletedById,
                                      deletedOn: widget.myCrops[index].deletedOn,
                                      durationFrom: widget.myCrops[index].durationFrom,
                                      durationTo: widget.myCrops[index].durationTo,
                                      cropName: widget.myCrops[index].cropName,
                                      cropNameMr: widget.myCrops[index].cropNameMr,
                                      cropImage: widget.myCrops[index].cropImage,
                                      name: widget.myCrops[index].name,
                                      cropId: widget.myCrops[index].cropId,
                                      n: widget.myCrops[index].n,
                                      p: widget.myCrops[index].p,
                                      k: widget.myCrops[index].k,
                                      s: widget.myCrops[index].s,
                                      logo: widget.myCrops[index].logo);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DSSMainScreen(dssMyCrops: crops)));
                                },
                                child: SizedBox(
                                  width: 70,
                                  height: 110,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 70, width: 70, child: CircleAvatar(backgroundImage: NetworkImage(HeaderSingleton().configurationDetails!.cropImageUrl! + widget.myCrops[index].logo!))),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: 80,
                                        height: 20,
                                        child: Text(
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            widget.myCrops[index].name ?? 'Crop $index',
                                            style: const TextStyle(fontFamily: 'Graphik', fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 2,
                                right: 10,
                                child: InkWell(
                                  onTap: () {
                                    HelperUtils().showNormalDialog(
                                        context: context,
                                        title: 'Are_you_sure'.tr,
                                        content: 'Do you want to delete the Crop'.tr,
                                        onYesTapped: (value) async {
                                          Navigator.pop(value);
                                          await deleteCropDetails(index);
                                        });
                                  },
                                  child: SvgPicture.asset("assets/images/cross_design.svg", height: 18),
                                ))
                          ]);
                        })
                    : WidgetUtils.appTextWidget(context: context, title: 'Add New Crop'.tr, fontSize: 16, color: Colors.white)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CropListScreen(isStatus: 'MyCrops')));
                  if (result == null) {
                    await fetchMyCrops();
                  }
                },
                child: Column(children: [
                  ClipOval(
                      child: Container(
                          height: 70,
                          width: 70,
                          color: Colors.white12,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20
                          ))),
                  const SizedBox(height: 8),
                  WidgetUtils.appTextWidget(context: context, title: 'Add'.tr, fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                ]),
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      )
    ]);
  }

  Future fetchMyCrops() async {
    try {
      List<MyCrops> myCropsList = [];
      final params = {'client_id': HeaderSingleton().paramsMaps!.userId!};
      // print(params);0
      final response = await APIService.postAPIMethod(url: ApiURL.myCropsList, params: params);
      final data = json.decode(response.body);
      if (data['success'] == 1) {
        for (final value in data['data']) {
          myCropsList.add(MyCrops.fromJson(value));
        }
      }
      widget.getCropList(myCropsList);
      setState(() {});
    } catch (e) {
      setState(() {});
      rethrow;
    }
  }

  Future deleteCropDetails(int index) async {
    try {
      final response = await http.put(Uri.parse(baseURL + ApiURL.deleteMyCrop + "/${widget.myCrops[index].id!}"), headers: headerParams);
      final details = json.decode(response.body);
      if (details['status'] == 1) {
        WidgetUtils.successDialog(context, details['message']);
        widget.myCrops.removeAt(index);
        widget.getCropList(widget.myCrops);
        setState(() {});
      }
    } catch (e) {
      setState(() {});
      rethrow;
    }
  }
}
