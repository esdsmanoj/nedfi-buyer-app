import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/model/manage_chat_model.dart';

import '../../app_imports.dart';
import '../../components/widgets/trade_button_widget.dart';
import '../../components/widgets/trade_content_widget.dart';

class ManageChatListingScreen extends StatefulWidget {
  const ManageChatListingScreen({super.key});

  @override
  State<ManageChatListingScreen> createState() => _ManageChatListingScreenState();
}

class _ManageChatListingScreenState extends State<ManageChatListingScreen> {
  TextEditingController searchController = TextEditingController();

  Future getChatList({String? search = ''}) async {
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
                        contentPadding: const EdgeInsets.only(top: 15),
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
                                          int? statusColor;
                                          if (snapshot.data != null) {
                                            statusColor = snapshot.data?[0].statusTitle != null
                                                ? snapshot.data[index].statusTitle!.toLowerCase() == "pending"
                                                    ? 0xffE8C600
                                                    : snapshot.data[index].statusTitle!.toLowerCase() == "live"
                                                        ? 0xff27914F
                                                        : snapshot.data[index].statusTitle!.toLowerCase() == "rejected"
                                                            ? 0xffE70000
                                                            : snapshot.data[index].statusTitle!.toLowerCase() == "completed"
                                                                ? 0xff0074E8
                                                                : snapshot.data[index].statusTitle!.toLowerCase() == "expired"
                                                                    ? 0xFF808080
                                                                    : snapshot.data[index].statusTitle!.toLowerCase() == "sold"
                                                                        ? 0xffE88700
                                                                        : 0xffffffff
                                                : 0xffffffff;
                                          }
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
                                                        Container(
                                                          height: 20,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color(statusColor!)),
                                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                                          child: WidgetUtils.appTextWidget(
                                                              context: context,
                                                              title: snapshot.data[index].statusTitle ?? "",
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              family: 'Graphik'),
                                                        )
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
                                              TradeContentWidget(
                                                  isStart: true,
                                                  isActive: true,
                                                  textTitle: "Variety -".tr + (snapshot.data[index].productVarietyTitle ?? ""),
                                                  textContent: "Type".tr + " - " + (snapshot.data[index].productTypeTitle ?? "")),
                                              TradeContentWidget(
                                                  isActive: true,
                                                  textTitle: snapshot.data[index].prodCatId == "2" ? "Expected Yield".tr : "Quantity".tr,
                                                  textContent: snapshot.data[index].prodCatId == "2"
                                                      ? ((snapshot.data[index].otherDetails?.yieldFrom ?? "0") +
                                                          " " +
                                                          (snapshot.data[index].otherDetails?.yieldFromUnitText ?? "") +
                                                          " - " +
                                                          (snapshot.data[index].otherDetails?.yieldTo ?? "0") +
                                                          " " +
                                                          (snapshot.data[index].otherDetails?.yieldToUnitText ?? ""))
                                                      : ((snapshot.data[index].sellQty ?? "0") + " " + (snapshot.data[index].priceUnitTitle ?? ""))),
                                              snapshot.data[index].prodCatId == "2"
                                                  ? TradeContentWidget(
                                                      isActive: snapshot.data[index].prodCatId == "2",
                                                      textTitle: "Availability".tr,
                                                      textContent: (snapshot.data[index].otherDetails?.availableFrom ?? "") + " - " + (snapshot.data[index].otherDetails?.availableTo ?? ""))
                                                  : Container(),
                                              snapshot.data[index].prodCatId == "2"
                                                  ? TradeContentWidget(
                                                      isActive: snapshot.data[index].prodCatId == "2", textTitle: "Product Type".tr, textContent: (snapshot.data[index].prod_details_title ?? ""))
                                                  : Container(),
                                              TradeContentWidget(isActive: true, textTitle: "Added".tr, textContent: getDateFormat(snapshot.data[index].addedDate!)),
                                              TradeContentWidget(
                                                  isActive: snapshot.data[index].prodCatId != "2", textTitle: "Bid Date".tr, textContent: getDateFormat(snapshot.data[index].bidDate ?? "")),
                                              snapshot.data[index].statusTitle!.toLowerCase() == "rejected"
                                                  ? TradeContentWidget(
                                                      isActive: snapshot.data[index].prodCatId == "2",
                                                      textTitle: snapshot.data[index].statusTitle!.toLowerCase() == "rejected" ? "Rejected".tr : "Expires".tr,
                                                      textContent: getDateFormat(
                                                          snapshot.data[index].statusTitle!.toLowerCase() == "rejected" ? snapshot.data[index].rejectedDate! : snapshot.data[index].expiryDate!))
                                                  : Container(),
                                              TradeContentWidget(
                                                  isActive: snapshot.data[index].statusTitle!.toLowerCase() == "sold" || snapshot.data[index].statusTitle!.toLowerCase() == "completed",
                                                  textTitle: "Sold to".tr,
                                                  textContent: snapshot.data[index].soldTO ?? ""),
                                              TradeContentWidget(
                                                  isActive: snapshot.data[index].statusTitle!.toLowerCase() == "sold" || snapshot.data[index].statusTitle!.toLowerCase() == "completed",
                                                  textTitle: "Sold on".tr,
                                                  textContent: getDateFormat(snapshot.data[index].soldOn ?? "")),
                                              const SizedBox(height: 8),
                                              Align(
                                                  alignment: Alignment.centerRight,
                                                  child: SizedBox(
                                                    width: 80,
                                                    child: TradeButtonWidget(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (chatCTX) => ChatScreen(
                                                                    buyerId: snapshot.data[index].sendToId == HeaderSingleton().paramsMaps!.userId
                                                                        ? snapshot.data[index].sendFromId
                                                                        : snapshot.data[index].sendToId,
                                                                    farmerName: snapshot.data[index].soldTO ?? "",
                                                                    from: "bid",
                                                                    prodId: snapshot.data[index].tradeProductId,
                                                                    tradeProductBiddingId: snapshot.data[index].tradeProductBiddingId)));
                                                      },
                                                      buttonName: "Chat".tr,
                                                      imagePath: 'chat.svg',
                                                      colorCode: 0xffFDA11E,
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
