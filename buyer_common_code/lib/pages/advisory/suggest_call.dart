import 'package:buyer_common_code/app_imports.dart';
import 'package:get/get.dart';

import '../../components/widgets/base_widget.dart';
import '../../model/AgronomistResponse.dart';

class SuggestCall extends StatefulWidget {
  final String cropId;

  const SuggestCall({Key? key, required this.cropId}) : super(key: key);

  @override
  State<SuggestCall> createState() => SuggestCallState();
}

class SuggestCallState extends State<SuggestCall> {
  ValueNotifier<AgronomistResponse?> agronomistDetails = ValueNotifier(null);

  @override
  void initState() {
    // TODO: implement initState
    getAdvisorList();
    super.initState();
  }

  Future getAdvisorList() async {
    await getDetails(widget.cropId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color(0xff27914F),
          title: WidgetUtils.appTextWidget(context: context, title: 'Schedule a call'.tr, color: Colors.white, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
          leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
        ),
        child: ValueListenableBuilder(
          valueListenable: agronomistDetails,
          builder: (BuildContext context, AgronomistResponse? value, Widget? child) {
            return value != null
                ? SingleChildScrollView(
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: WidgetUtils.appTextWidget(
                                  context: context, title: 'scheduleMessage'.tr, overflow: TextOverflow.ellipsis, fontSize: 14, family: 'Graphik', fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              child: value.data.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: value.data.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (xt, index) {
                                        return Container(
                                          height: 147,
                                          width: double.maxFinite,
                                          margin: const EdgeInsets.only(bottom: 20),
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFffffff),
                                              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5.0, spreadRadius: 5.0, offset: const Offset(5.0, 5.0))],
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: const Color(0xFFE0E0E0), width: 1)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: 76,
                                                padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset('assets/images/advisor.png', height: 76, width: 76),
                                                    const SizedBox(width: 14),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: "${value.data[index].firstName} ${value.data[index].lastName}",
                                                            fontSize: 16,
                                                            family: 'Graphik',
                                                            fontWeight: FontWeight.w500),
                                                        // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery.of(context).size.height * 0.058,
                                                              width: 120,
                                                              child: GridView.builder(
                                                                  scrollDirection: Axis.horizontal,
                                                                  itemCount: value.data[index].expertise.split(",").length > 5 ? 4 : value.data[index].expertise.split(",").length,
                                                                  shrinkWrap: true,
                                                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                      crossAxisCount: 2, crossAxisSpacing: 1.5, mainAxisSpacing: 0.5, childAspectRatio: 0.3),
                                                                  itemBuilder: (ctx, newIndex) {
                                                                    return SizedBox(
                                                                      width: MediaQuery.of(context).size.height * 0.15,
                                                                      child: Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          const Text(
                                                                            "\u2022",
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(fontSize: 12),
                                                                          ),
                                                                          const SizedBox(width: 5),
                                                                          SizedBox(
                                                                            width: 55,
                                                                            child: Text(
                                                                              overflow: TextOverflow.ellipsis,
                                                                              value.data[index].expertise.split(",")[newIndex],
                                                                              style: const TextStyle(fontSize: 12, fontFamily: 'Graphik', fontWeight: FontWeight.w300),
                                                                              // maxLines: 9,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }),
                                                            ),
                                                            const SizedBox(width: 12),
                                                            InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context: context,
                                                                      barrierDismissible: true,
                                                                      builder: (BuildContext ctx) {
                                                                        return Dialog(
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                          child: SizedBox(
                                                                            height: 400,
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  width: double.maxFinite,
                                                                                  height: 50,
                                                                                  alignment: Alignment.center,
                                                                                  decoration: const BoxDecoration(
                                                                                      color: Colors.green, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                                                                  child: Text(
                                                                                    "${value.data[index].firstName} ${value.data[index].lastName}",
                                                                                    style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontFamily: 'Graphik'),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                                                                                  child: Text("Expertise".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                                                ),
                                                                                // const SizedBox(height: 20),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: SizedBox(
                                                                                      height: 250,
                                                                                      width: double.maxFinite,
                                                                                      child: GridView.builder(
                                                                                          scrollDirection: Axis.vertical,
                                                                                          itemCount: value.data[index].expertise.split(",").length,
                                                                                          shrinkWrap: true,
                                                                                          // physics: const NeverScrollableScrollPhysics(),
                                                                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                                              crossAxisCount: 3, crossAxisSpacing: 1.5, mainAxisSpacing: 0.5, childAspectRatio: 1.5),
                                                                                          itemBuilder: (ctx, advisorIndex) {
                                                                                            // //print(value.data[index].expertise.split(",")[advisorIndex]);
                                                                                            return SizedBox(
                                                                                              width: MediaQuery.of(context).size.height * 0.15,
                                                                                              child: Row(
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                children: [
                                                                                                  const Text(
                                                                                                    "\u2022",
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(fontSize: 12),
                                                                                                  ),
                                                                                                  const SizedBox(width: 5),
                                                                                                  SizedBox(
                                                                                                    width: 55,
                                                                                                    child: Text(
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      maxLines: 3,
                                                                                                      value.data[index].expertise.split(",")[advisorIndex],
                                                                                                      style: const TextStyle(fontSize: 12, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                                                                                                      // maxLines: 9,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            );
                                                                                          })),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                },
                                                                child: Align(
                                                                    alignment: Alignment.bottomRight,
                                                                    child: Text("View More".tr,
                                                                        style: const TextStyle(fontFamily: 'Graphik', color: Color(0xff27914F), fontWeight: FontWeight.bold, fontSize: 12)))),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    isLoading.value = true;
                                                    setState(() {});
                                                    final details = await bookSlot(value.data[index], widget.cropId);
                                                    if (details['status'] == 1) {
                                                      isLoading.value = false;
                                                      WidgetUtils.successDialog(context, details['message']);
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 36,
                                                    width: 98,
                                                    margin: const EdgeInsets.only(right: 14, bottom: 14, top: 7),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: const Color(0xFF27914F)),
                                                    child: WidgetUtils.appTextWidget(context: context, title: 'Book Now'.tr, fontSize: 14, color: Colors.white, fontWeight: FontWeight.w300),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                  : Center(child: Text('No Advisor available..'.tr)),
                            )
                          ],
                        )),
                  )
                : Center(child: Text('No Advisor available..'.tr));
          },
        ));
  }

  /// Getting all the advisor list details
  Future getDetails(String cropId) async {
    try {
      final response = await APIService.getAPIMethod(url: "${ApiURL.getAgronomist}/$cropId");
      final data = json.decode(response.body);
      final res = AgronomistResponse.fromJson(data);
      if (res.status == "1") {
        agronomistDetails.value = res;
      }
    } on SocketException {
      rethrow;
    } catch (e) {
      // //print(e.toString());
      rethrow;
    }
  }

  /// To Book an appointment with the agronomist
  Future bookSlot(AgronomistData details, String cropId) async {
    try {
      Map<String, dynamic> body = {"partner_id": details.userId, "farmer_id": HeaderSingleton().paramsMaps!.userId, "call_schedule_date": "", "crop_id": cropId};
      final response = await APIService.postAPIMethod(url: ApiURL.addVendorCallLeads, params: body);

      final data = json.decode(response.body);
      // //print(data);
      var res = CommonModel.fromJson(data);
      if (res.status == 1) {
        WidgetUtils.successDialog(context, res.message);

        Navigator.push(context, MaterialPageRoute(builder: (context) => AdvisoryThankYouScreen(res.message)));
      } else {
        WidgetUtils.informationDialog(context, res.message);
      }
      return data;
    } on SocketException {
      rethrow;
    } catch (e) {
      isLoading.value = false;
      // //print(e.toString());
      rethrow;
    }
  }
}
