import 'package:buyer_common_code/model/manage_chat_model.dart';
import 'package:get/get.dart';

import '../../app_imports.dart';

class ManageChatListingScreen extends StatefulWidget {
  const ManageChatListingScreen({super.key});

  @override
  State<ManageChatListingScreen> createState() => _ManageChatListingScreenState();
}

class _ManageChatListingScreenState extends State<ManageChatListingScreen> {
  TextEditingController searchController = TextEditingController();

  Future getChatList({String? search = ''}) async {
    // //print(search);
    try {
      final params = {'send_from_id': userId, 'search': search};
      final response = await APIService.postAPIMethod(url: ApiURL.manageChatList, params: params);
      if (response.statusCode == 200) {
        ManageChatModel manageChatModel = ManageChatModel.fromJson(json.decode(response.body));
        if (manageChatModel.success == 1) {
          return manageChatModel.data;
        }
        return null;
      }
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomProgressHandler(
        loadingText: '',
        isLoading: isLoading.value,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(context: context, title: 'Chat'.tr, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.keyboard_backspace_sharp),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: WidgetUtils.appTextWidget(context: context, title: 'Conversation'.tr, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey)),
                    // margin: const EdgeInsets.only(right: 16),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15),
                        // prefixIcon: InkWell(onTap: () => setState(() {}), child: const Icon(Icons.search, size: 22, color: Colors.grey)),
                        suffixIcon: InkWell(
                            onTap: () {
                              searchController.clear();
                              setState(() {});
                            },
                            child: const Icon(Icons.clear, size: 22, color: Colors.grey)),
                        hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Graphik', fontSize: 14, fontWeight: FontWeight.w400),
                        hintText: 'Search product by name'.tr,
                        border: InputBorder.none,
                        counterText: "",
                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      ),
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: FutureBuilder(
                      future: getChatList(search: searchController.text),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        return snapshot.hasData
                            ? Container(
                                child: (snapshot.data?.isNotEmpty ?? false)
                                    ? ListView.builder(
                                        // physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                                            padding: const EdgeInsets.all(12),
                                            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                                            child: Column(children: [
                                              const SizedBox(height: 9),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                            child: WidgetUtils.appTextWidget(
                                                                context: context, title: snapshot.data[index].productTitle ?? "", fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 20)),
                                                        const SizedBox(width: 4),
                                                        // WidgetUtils.statusTextWidget(title: snapshot.data[index].statusTitle ?? ""),
                                                      ],
                                                    ),
                                                  ),
                                                  WidgetUtils.appTextWidget(
                                                      context: context,
                                                      title: "₹" + (snapshot.data[index].price ?? "") + "/" + (snapshot.data[index].priceUnitTitle ?? ""),
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
                                                      context: context,
                                                      title: "Variety -".tr + (snapshot.data[index].productVarietyTitle ?? ""),
                                                      fontWeight: FontWeight.w400,
                                                      family: 'Graphik',
                                                      fontSize: 14,
                                                      color: const Color(0xff3F3F3F)),
                                                  WidgetUtils.appTextWidget(
                                                      context: context,
                                                      title: "Type".tr + " - " + (snapshot.data[index].productTypeTitle ?? ""),
                                                      fontWeight: FontWeight.w400,
                                                      family: 'Graphik',
                                                      fontSize: 14,
                                                      color: const Color(0xff3F3F3F)),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)),
                                              const SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  WidgetUtils.appTextWidget(
                                                      context: context,
                                                      title: snapshot.data[index].prodCatId == "2" ? "Expected Yield".tr : "Quantity".tr,
                                                      fontWeight: FontWeight.w400,
                                                      family: 'Graphik',
                                                      fontSize: 14,
                                                      color: const Color(0xff3F3F3F)),
                                                  WidgetUtils.appTextWidget(
                                                      context: context,
                                                      title: snapshot.data[index].prodCatId == "2"
                                                          ? ((snapshot.data[index].otherDetails?.yieldFrom ?? "0") +
                                                              " " +
                                                              (snapshot.data[index].otherDetails?.yieldFromUnitText ?? "") +
                                                              " - " +
                                                              (snapshot.data[index].otherDetails?.yieldTo ?? "0") +
                                                              " " +
                                                              (snapshot.data[index].otherDetails?.yieldToUnitText ?? ""))
                                                          : ((snapshot.data[index].sellQty ?? "0") + " " + (snapshot.data[index].priceUnitTitle ?? "")),
                                                      fontWeight: FontWeight.w400,
                                                      family: 'Graphik',
                                                      fontSize: 14,
                                                      color: const Color(0xff3F3F3F)),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              snapshot.data[index].prodCatId == "2"
                                                  ? Container(
                                                      width: double.maxFinite,
                                                      height: 0.5,
                                                      color: Colors.black.withOpacity(0.3),
                                                    )
                                                  : Container(),
                                              snapshot.data[index].prodCatId == "2" ? const SizedBox(height: 5) : Container(),
                                              snapshot.data[index].prodCatId == "2"
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        WidgetUtils.appTextWidget(
                                                            context: context, title: "Availability".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                                                        WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: (snapshot.data[index].otherDetails!.availabilityFrom ?? "") + " - " + (snapshot.data[index].otherDetails!.availabilityTo ?? ""),
                                                            fontWeight: FontWeight.w400,
                                                            family: 'Graphik',
                                                            fontSize: 14,
                                                            color: const Color(0xff3F3F3F)),
                                                      ],
                                                    )
                                                  : Container(),
                                              const SizedBox(height: 5),
                                              snapshot.data[index].prodCatId == "2"
                                                  ? Container(
                                                      width: double.maxFinite,
                                                      height: 0.5,
                                                      color: Colors.black.withOpacity(0.3),
                                                    )
                                                  : Container(),
                                              snapshot.data[index].prodCatId == "2" ? const SizedBox(height: 5) : Container(),
                                              snapshot.data[index].prodCatId == "2"
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        WidgetUtils.appTextWidget(
                                                            context: context, title: "Product Type".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                                                        WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: (snapshot.data[index].prodDetailsTitle ?? ""),
                                                            fontWeight: FontWeight.w400,
                                                            family: 'Graphik',
                                                            fontSize: 14,
                                                            color: const Color(0xff3F3F3F)),
                                                      ],
                                                    )
                                                  : Container(),
                                              snapshot.data[index].prodCatId == "2" ? const SizedBox(height: 5) : Container(),
                                              Container(
                                                width: double.maxFinite,
                                                height: 0.5,
                                                color: Colors.black.withOpacity(0.3),
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  WidgetUtils.appTextWidget(
                                                      context: context, title: "Added".tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14, color: const Color(0xff3F3F3F)),
                                                  WidgetUtils.appTextWidget(
                                                      context: context,
                                                      title: getDateFormat(snapshot.data[index].addedDate!),
                                                      fontWeight: FontWeight.w400,
                                                      family: 'Graphik',
                                                      fontSize: 14,
                                                      color: const Color(0xff3F3F3F)),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              // snapshot.data[index].statusTitle!.toLowerCase() != "sold" || snapshot.data[index].statusTitle!.toLowerCase() != "completed"
                                              //     ?Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3)):Container(),
                                              const SizedBox(height: 5),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "rejected" ? const SizedBox(height: 1) : Container(),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "rejected"
                                                  ? Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3))
                                                  : Container(),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "rejected" ? const SizedBox(height: 3) : Container(),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "rejected"
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: snapshot.data[index].statusTitle!.toLowerCase() == "rejected" ? "Rejected".tr : "Expires".tr,
                                                            color: const Color(0xff3F3F3F),
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14,
                                                            family: 'Graphik'),
                                                        WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: getDateFormat(snapshot.data[index].expiryDate!),
                                                            color: const Color(0xff3F3F3F),
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14,
                                                            family: 'Graphik'),
                                                      ],
                                                    )
                                                  : Container(),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "sold" || snapshot.data[index].statusTitle!.toLowerCase() == "completed"
                                                  ? const SizedBox(height: 1)
                                                  : Container(),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "sold" || snapshot.data[index].statusTitle!.toLowerCase() == "completed"
                                                  ? Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3))
                                                  : Container(),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "sold" || snapshot.data[index].statusTitle!.toLowerCase() == "completed"
                                                  ? const SizedBox(height: 3)
                                                  : Container(),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "sold" || snapshot.data[index].statusTitle!.toLowerCase() == "completed"
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        WidgetUtils.appTextWidget(
                                                            context: context, title: "Sold to".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                                        WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: snapshot.data[index].soldTO ?? "",
                                                            color: const Color(0xff3F3F3F),
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14,
                                                            family: 'Graphik'),
                                                      ],
                                                    )
                                                  : Container(),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "sold" || snapshot.data[index].statusTitle!.toLowerCase() == "completed"
                                                  ? const SizedBox(height: 5)
                                                  : Container(),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "sold" || snapshot.data[index].statusTitle!.toLowerCase() == "completed"
                                                  ? const SizedBox(height: 1)
                                                  : Container(),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "sold" || snapshot.data[index].statusTitle!.toLowerCase() == "completed"
                                                  ? Container(width: double.maxFinite, height: 0.5, color: Colors.black.withOpacity(0.3))
                                                  : Container(),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "sold" || snapshot.data[index].statusTitle!.toLowerCase() == "completed"
                                                  ? const SizedBox(height: 3)
                                                  : Container(),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "sold" || snapshot.data[index].statusTitle!.toLowerCase() == "completed"
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        WidgetUtils.appTextWidget(
                                                            context: context, title: "Sold on".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                                        WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: getDateFormat(snapshot.data[index].soldOn ?? ""),
                                                            color: const Color(0xff3F3F3F),
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14,
                                                            family: 'Graphik'),
                                                      ],
                                                    )
                                                  : Container(),
                                              const SizedBox(height: 8),
                                              Align(
                                                  alignment: Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (chatCTX) => ChatScreen(
                                                                    buyerId: snapshot.data[index].sendToId == HeaderSingleton().paramsMaps!.userId
                                                                        ? snapshot.data[index].sendFromId
                                                                        : snapshot.data[index].sendToId,
                                                                    snapshot.data[index].sendToUsername ?? "",
                                                                    "bid",
                                                                    prodId: snapshot.data[index].tradeProductId,
                                                                    tradeProductBiddingId: snapshot.data[index].tradeProductBiddingId,
                                                                    isManage: "manage",
                                                                  )));
                                                    },
                                                    child: Container(
                                                      height: 36,
                                                      width: 98,
                                                      alignment: Alignment.center,
                                                      padding: const EdgeInsets.all(8),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          SvgPicture.asset("assets/images/chat.svg", height: 16),
                                                          const SizedBox(width: 6),
                                                          WidgetUtils.appTextWidget(
                                                              context: context, title: "Chat".tr, color: const Color(0xffFDA11E), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                                                        ],
                                                      ),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: (const Color(0xffFDA11E)))),
                                                    ),
                                                  ))
                                            ]),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: WidgetUtils.appTextWidget(
                                            context: context,
                                            title: "No Data available",
                                            fontWeight: FontWeight.w500,
                                            family: 'Graphik',
                                            color: Color(int.parse(themeColor.value.buttonColor!.color!)),
                                            fontSize: 14),
                                      ),
                              )
                            : Container(
                                child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('assets/images/plant_loader.gif', height: 80, width: 80),
                                    WidgetUtils.appTextWidget(context: context, title: 'Loading'.tr + '...', family: 'Graphik', fontWeight: FontWeight.w400),
                                  ],
                                ),
                              ));
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
