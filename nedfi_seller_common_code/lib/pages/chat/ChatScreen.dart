import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../app_imports.dart';
import '../../model/helpdesk_login_model.dart';
import '../../model/trade_product_model/BidChat.dart';

class ChatScreen extends StatefulWidget {
  String buyerId = "", farmerName = "", from = "";
  String? tradeProductBiddingId, prodId;

  ChatScreen({super.key, required this.farmerName, required this.from, required this.buyerId, this.tradeProductBiddingId, this.prodId = ""});

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatScreen> {
  final chatMsgTextController = TextEditingController();
  bool roundedCorners = true;
  TextEditingController? chatTextController;
  FocusNode? _mobileNoFocusNode;
  int? statusColor;
  BidChat? userChatDetails;
  String? addedDate, expiredDate, profileImagePath;
  HpUserId? hpUserId;
  ValueNotifier<List<BidChatData>?> bidChatDetails = ValueNotifier(null);
  ValueNotifier<List<ChatData>?> chatDetails = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    chatTextController = TextEditingController();
    _mobileNoFocusNode = FocusNode();
    isLoading.value = true;
    checkUserLogin();

    if (widget.from == "bid") {
      if (widget.prodId != null) {
        getProductInformation(context, widget.prodId!, () {
          isLoading.value = false;
          setState(() {});
        });
      }
      setUpTimedFetch(() => fetchBidChat());
    } else {
      setUpTimedFetch(() => fetchChat());
    }
    if (productData.value?.isNotEmpty ?? false) {
      changeStatusColor();
    }
    isLoading.value = false;
  }

  setUpTimedFetch(Function() chatCall) {
    Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      chatCall.call();
    });
  }

  changeStatusColor() {
    statusColor = (productData.value != null)
        ? (productData.value?[0].statusTitle?.toLowerCase() == "pending"
            ? 0xffE8C600
            : productData.value?[0].statusTitle?.toLowerCase() == "live"
                ? 0xff27914F
                : productData.value?[0].statusTitle?.toLowerCase() == "rejected"
                    ? 0xffE70000
                    : productData.value?[0].statusTitle?.toLowerCase() == "completed"
                        ? 0xff0074E8
                        : productData.value?[0].statusTitle?.toLowerCase() == "sold"
                            ? 0xffE88700
                            : 0xffffffff)
        : 0xffffffff;
  }

  double cornerRadius() {
    if (roundedCorners == true) {
      return 60.0;
    } else {
      return 0.0;
    }
  }

  double padding() {
    if (roundedCorners == true) {
      return 12.0;
    } else {
      return 8.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (productData.value?.isNotEmpty ?? false) {
      addedDate = productData.value != null ? getDateFormat(productData.value![0].addedDate!) : "";
      expiredDate = productData.value != null ? getDateFormat(productData.value![0].expiryDate!) : "";
    }
    return SafeArea(
        child: CustomProgressHandler(
            isLoading: isLoading.value,
            loadingText: "",
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  centerTitle: false,
                  backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
                  title: WidgetUtils.appTextWidget(
                      context: context,
                      title: (productData.value!.isNotEmpty) ? (productData.value?[0].soldTO ?? "") : widget.farmerName,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 20,
                      family: 'Graphik'),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                body: (productData.value?.isNotEmpty ?? false)
                    ? SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      WidgetUtils.appTextWidget(
                                          context: context, title: productData.value?[0].productTitle ?? "", color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20, family: 'Graphik'),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 20,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color(statusColor ?? 0xffffffff)),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: WidgetUtils.appTextWidget(
                                            context: context, title: productData.value?[0].statusTitle ?? "", fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12, family: 'Graphik'),
                                      )
                                    ],
                                  ),
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: "₹${productData.value?[0].price!}/${productData.value?[0].priceUnitTitle!}",
                                      color: const Color(0xffFDA11E),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      family: 'Graphik'),
                                ],
                              ),
                              const Divider(height: 5),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetUtils.appTextWidget(context: context, title: "Sold Price".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                  const SizedBox(width: 4),
                                  WidgetUtils.appTextWidget(
                                      context: context,
                                      title: "₹${userChatDetails?.tradeProductDetails?.bidPrice ?? ""}",
                                      color: const Color(0xff3F3F3F),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      family: 'Graphik'),
                                ],
                              ),
                              const Divider(height: 5),
                              /*   const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    WidgetUtils.appTextWidget(context: context, title: "Variety -".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                    const SizedBox(width: 4),
                                    WidgetUtils.appTextWidget(
                                        context: context,
                                        title: productData.value?[0].productVarietyTitle ?? "",
                                        color: const Color(0xff3F3F3F),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        family: 'Graphik'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    WidgetUtils.appTextWidget(context: context, title: "Type -".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                    const SizedBox(width: 4),
                                    WidgetUtils.appTextWidget(
                                        context: context,
                                        title: productData.value?[0].productTypeTitle ?? "",
                                        color: const Color(0xff3F3F3F),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        family: 'Graphik'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 1),
                            const Divider(),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetUtils.appTextWidget(context: context, title: "Category".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                WidgetUtils.appTextWidget(
                                    context: context,
                                    title: productData.value?[0].productCategoryTitle ?? "",
                                    color: const Color(0xff3F3F3F),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    family: 'Graphik'),
                              ],
                            ),
                            const SizedBox(height: 1),
                            const Divider(),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetUtils.appTextWidget(context: context, title: "Quantity".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                WidgetUtils.appTextWidget(
                                    context: context,
                                    title: (productData.value?[0].sellQty ?? "") + " " + (productData.value?[0].priceUnitTitle ?? ""),
                                    color: const Color(0xff3F3F3F),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    family: 'Graphik'),
                              ],
                            ),
                            const SizedBox(height: 1),
                            const Divider(),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetUtils.appTextWidget(context: context, title: "Added".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                WidgetUtils.appTextWidget(context: context, title: addedDate!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                              ],
                            ),
                            productData.value?[0].statusTitle!.toLowerCase() != "pending" ? const SizedBox(height: 1) : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() != "pending" ? const Divider() : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() != "pending" ? const SizedBox(height: 3) : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() != "pending"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      WidgetUtils.appTextWidget(
                                          context: context,
                                          title: productData.value?[0].statusTitle!.toLowerCase() == "rejected" ? "Rejected".tr : "Expires".tr,
                                          color: const Color(0xff3F3F3F),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          family: 'Graphik'),
                                      WidgetUtils.appTextWidget(context: context, title: expiredDate!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                    ],
                                  )
                                : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() == "sold" || productData.value?[0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() == "sold" || productData.value?[0].statusTitle!.toLowerCase() == "completed" ? const Divider() : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() == "sold" || productData.value?[0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() == "sold" || productData.value?[0].statusTitle!.toLowerCase() == "completed"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      WidgetUtils.appTextWidget(context: context, title: "Sold to".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                      WidgetUtils.appTextWidget(
                                          context: context, title: productData.value?[0].soldTO ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                    ],
                                  )
                                : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() == "sold" || productData.value?[0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() == "sold" || productData.value?[0].statusTitle!.toLowerCase() == "completed" ? const Divider() : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() == "sold" || productData.value?[0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() == "sold" || productData.value?[0].statusTitle!.toLowerCase() == "completed"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      WidgetUtils.appTextWidget(context: context, title: "Sold on".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                      WidgetUtils.appTextWidget(
                                          context: context, title: productData.value?[0].soldOn ?? "", color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                    ],
                                  )
                                : Container(),
                            const SizedBox(height: 12),
                            productData.value?[0].statusTitle!.toLowerCase() != "live" ? const SizedBox(height: 1) : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() != "live" ? const Divider() : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() != "live" ? const SizedBox(height: 3) : Container(),
                            productData.value?[0].statusTitle!.toLowerCase() != "live"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      WidgetUtils.appTextWidget(context: context, title: "Sold Price".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                                      WidgetUtils.appTextWidget(
                                          context: context,
                                          title: productData.value?[0].soldPrice ?? "NA",
                                          color: const Color(0xff3F3F3F),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          family: 'Graphik'),
                                    ],
                                  )
                                : Container(),*/
                              const SizedBox(height: 12),
                              Container(
                                child: ValueListenableBuilder(
                                  valueListenable: bidChatDetails,
                                  builder: (context, dynamic value, child) {
                                    return value != null
                                        ? ListView.builder(
                                            padding: EdgeInsets.only(bottom: 100),
                                            itemCount: widget.from == "bid" ? value.length : value.length,
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return _chatListItem(widget.from == "bid" ? value[index] : value[index], index!);
                                            })
                                        : Container();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        child: Center(
                          child: WidgetUtils.appTextWidget(context: context, title: 'No Data Available'.tr),
                        ),
                      ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: (productData.value?.isEmpty ?? false)
                    ? null
                    : (productData.value?[0].statusTitle!.toLowerCase() != "live")
                        ? (productData.value?.isNotEmpty ?? false)
                            ? (productData.value?[0].statusTitle?.toLowerCase()) == "completed"
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: const Color(0x33B4B6C4))),
                                      child: Container(
                                        height: 70,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            // InkWell(onTap: () {}, child: SvgPicture.asset("assets/images/attachment.svg", height: 18, width: 18)),
                                            Expanded(
                                              child: TextField(
                                                controller: chatTextController,
                                                focusNode: _mobileNoFocusNode,
                                                decoration: InputDecoration(
                                                    hintText: 'Your Message'.tr,
                                                    hintStyle: TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)).withOpacity(0.6)),
                                                    border: InputBorder.none,
                                                    contentPadding: const EdgeInsets.all(16.0)),
                                                style: TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!))),
                                              ),
                                            ),
                                            FlatActionButton(
                                              icon: Icon(
                                                Icons.arrow_forward,
                                                size: 18.0,
                                                color: Color(int.parse(themeColor.value.barColor!.color!)),
                                              ),
                                              onPressed: () {
                                                if (chatTextController!.text.isNotEmpty) {
                                                  if (widget.from == "bid") {
                                                    addBidChat();
                                                  } else {
                                                    addChat();
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                            : null
                        : null)));
  }

  _chatListItem(chatHistoryData, int index) {
    dynamic msgType;
    if (widget.from == "bid") {
      if (HeaderSingleton().paramsMaps!.userId! == chatHistoryData.sendFromId) {
        msgType = MessageType.sent;
      } else {
        msgType = MessageType.received;
      }
    } else {
      if (HeaderSingleton().paramsMaps!.userId! == chatHistoryData.sendFromId) {
        msgType = MessageType.sent;
      } else {
        msgType = MessageType.received;
      }
    }

    return FlatChatMessage(
      imageUser: profileImagePath,
      message: widget.from == "bid" ? chatHistoryData.msgText : chatHistoryData.msg,
      messageType: msgType,
      showTime: true,
      time: setDate(chatHistoryData.createdOn),
    );
  }

  setDate(String dateTime) {
    DateTime dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTime);
    final newFormat = DateFormat.yMMMd('en_US').add_jm().format(dateFormat);
    if (dateTime != null) {
      return newFormat.toString();
      /* var date = dateTime.split(" ")[0];
      var time = dateTime.split(" ")[1].substring(0, 5);
      final format = dateFormat.format(DateTime.now());
      if (date == dateFormat.format(DateTime.now()).split(" ")[0]) {
        return "$time ${format.split(" ")[2]}";
      } else if (date == dateFormat.format(DateTime.now().subtract(const Duration(days: 1))).split(" ")[0]) {
        return "Yesterday $time ${format.split(" ")[2]}";
      } else {
        return "$date  $time ${format.split(" ")[2]}";
      }*/
    }
  }

  Future checkUserLogin() async {
    try {
      String userType = await SharePrefsHelper.getInstance(context)?.getStringValue("userType") ?? "0";
      final params = {
        'fullname': HeaderSingleton().profileDetails.value!.data[0].firstName! + " " + HeaderSingleton().profileDetails.value!.data[0].lastName!,
        'email': HeaderSingleton().profileDetails.value!.data[0].email ?? "null",
        'usertype': userType,
        'user_id': userId,
        'phone': HeaderSingleton().profileDetails.value!.data[0].phone!
      };
      http.Response response = await http.post(Uri.parse("https://dev.famrut.com/support/api/users/login"), body: params, headers: headerParams).timeout(const Duration(minutes: 1));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        HelpDeskLoginModel helpDeskLoginModel = HelpDeskLoginModel.fromJson(result);
        if (helpDeskLoginModel.success == 1) {
          hpUserId = helpDeskLoginModel.hpUserId;
          await checkTickets(userId: hpUserId!.id!);
        } else {
          WidgetUtils.errorDialog(context, result['message']);
        }
      }
      setState(() {});
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  fetchChat() async {
    try {
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params1 = {"outgoing_id": HeaderSingleton().paramsMaps!.userId, "incoming_id": widget.buyerId};
        http.Response response = await APIService.postAPIMethod(url: ApiURL.getChatData, params: params1);
        var data = json.decode(response.body);
        // print(data);
        Chat chat = Chat.fromJson(data);
        if (chat.success != 1) {
          WidgetUtils.errorDialog(context, data["msg"]);
        } else {
          List<ChatData> farmerData = chat.data;
          if (farmerData != null) {
            chatDetails.value = chat.data;
            return chat.data;
          }
        }
      }
    } catch (e) {
      rethrow;
    }
    setStateIfMounted(() {
      // isLoading.value = false;
    });
  }

  fetchBidChat() async {
    try {
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params1 = {'send_from_id': HeaderSingleton().paramsMaps!.userId, 'send_to_id': widget.buyerId, 'trade_product_bidding_id': widget.tradeProductBiddingId};
        http.Response response = await APIService.postAPIMethod(url: ApiURL.userBidChat, params: params1);
        var data = json.decode(response.body);
        BidChat chat = BidChat.fromJson(data);
        userChatDetails = chat;
        profileImagePath = chat.sendToCilentDetails?.profileImage ?? "";
        if (chat.success == 1) {
          List<BidChatData> farmerData = chat.data ?? [];
          if (farmerData != null) {
            bidChatDetails.value = farmerData;
          }
          setState(() {});
          return farmerData;
        }
      }
      setState(() {});
    } catch (e) {
      setState(() {});
      rethrow;
    }
  }

  addChat() async {
    try {
      setState(() {
        isLoading.value = true;
      });

      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        // var headerModel = Provider.of<HeaderSingleton>(context, listen: false);
        Map<String, dynamic> params1 = {
          "partner_id": widget.buyerId,
          "farmer_id": HeaderSingleton().paramsMaps!.userId,
          "incoming_msg_id": widget.buyerId,
          "outgoing_msg_id": HeaderSingleton().paramsMaps!.userId,
          "msg": chatTextController!.text.toString()
        };
        final response = await APIService.postAPIMethod(url: ApiURL.addChat, params: params1);
        var data = json.decode(response.body);

        if (data["success"] != 1) {
          WidgetUtils.errorDialog(context, data["message"]);
        } else {
          chatTextController!.text = "";
          fetchChat();
        }
      }
    } catch (e) {
      rethrow;
    }
    setStateIfMounted(() {
      isLoading.value = false;
    });
  }

  addBidChat() async {
    try {
      setState(() {
        isLoading.value = true;
      });

      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params1 = {
          'send_from_id': HeaderSingleton().paramsMaps!.userId,
          'send_to_id': widget.buyerId,
          'msg_text': chatTextController!.text.toString(),
          'trade_product_bidding_id': widget.tradeProductBiddingId
        };

        http.Response response = await APIService.postAPIMethod(url: ApiURL.addBidUserChat, params: params1);
        var data = json.decode(response.body);
        if (data["success"] != 1) {
          WidgetUtils.errorDialog(context, data["message"]);
        } else {
          chatTextController!.text = "";
          fetchBidChat();
        }
      }
    } catch (e) {
      rethrow;
    }
    setStateIfMounted(() {
      isLoading.value = false;
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
