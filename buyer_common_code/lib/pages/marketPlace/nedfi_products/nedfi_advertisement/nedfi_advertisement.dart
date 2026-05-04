import 'package:buyer_common_code/model/nedfi_advertise_model.dart';
import 'package:get/get.dart';

import '../../../../app_imports.dart';

class NedfiAdvertisement extends StatefulWidget {
  const NedfiAdvertisement({super.key});

  @override
  State<NedfiAdvertisement> createState() => _NedfiAdvertisementState();
}

class _NedfiAdvertisementState extends State<NedfiAdvertisement> {
  ValueNotifier<List<NedfiAdvertiseData>?> advertisementList = ValueNotifier(null);

  @override
  void initState() {
    // TODO: implement initState
    isLoading.value = true;
    getAdvertisement();
    isLoading.value = false;
    setState(() {});
    super.initState();
  }

  Future getAdvertisement() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.advertise);
      NedfiAdvertiseModel result = NedfiAdvertiseModel.fromJson(jsonDecode(response.body));
      if (result.success == 1) {
        advertisementList.value = result.data;
      }
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold( backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          title: WidgetUtils.appTextWidget(context: context, title: 'Advertisement'.tr, color: Colors.white, fontSize: 18),
          leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ValueListenableBuilder(
            valueListenable: advertisementList,
            builder: (BuildContext context, value, Widget? child) {
              return value != null
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return InkWell(
                          onTap:()async{
                            final url =  (value[index].linkUrl ?? "");
                            //print(url);
                            if (url != null && url.isNotEmpty) {
                              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                            } else {
                              WidgetUtils.errorDialog(context, "No Url Found".tr);
                              setState(() {});
                              // throw 'Could not launch $url';
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  height: MediaQuery.of(context).size.height * 0.247,
                                  child: CachedNetworkImage(
                                    height: MediaQuery.of(context).size.height * 0.220,
                                    width: MediaQuery.of(context).size.width,
                                    imageUrl: HeaderSingleton().configurationDetails!.advertiseImageUrl! + "/" + (value[index].mobIcon ?? ""),
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
                                    ),
                                    placeholder: (context, url) => Container(
                                      child: Image.file(File(image), fit: BoxFit.fitHeight),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      child: Image.file(File(image)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                WidgetUtils.appTextWidget(context: context, title: value[index].name ?? "", fontSize: 16, fontWeight: FontWeight.w500, family: 'Graphik', textAlign: TextAlign.start),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: value.length,
                    )
                  : Center(
                      child: Text(
                        'No Advertisement Available'.tr,
                        style: const TextStyle(color: Colors.black, fontFamily: 'Graphik', fontWeight: FontWeight.w500, fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
