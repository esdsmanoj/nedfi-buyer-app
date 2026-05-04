import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../app_imports.dart';
import '../../model/chatbot_model.dart';
import '../../model/helpdesk_login_model.dart';

class ChatBotScreen extends StatefulWidget {
  final String sellerName;

  const ChatBotScreen({super.key, required this.sellerName});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  List<Map<String, dynamic>> messageArray = [];
  List<String> questionArray = [];
  TextEditingController chatTextController = TextEditingController();
  HpUserId? hpUserId;
  bool isCalled = false;

  @override
  void initState() {
    isLoading.value = true;
    checkUserLogin();
    isLoading.value = false;
    isCalled = true;
    super.initState();
  }

  Future checkUserLogin() async {
    try {
      String userType = await SharePrefsHelper.getInstance(context)?.getStringValue("userType") ?? "0";
      final params = {
        'fullname': HeaderSingleton().profileDetails.value!.data[0].firstName! + " " + HeaderSingleton().profileDetails.value!.data[0].lastName!,
        'email': HeaderSingleton().profileDetails.value!.data[0].email ?? "null",
        'usertype': userType,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
        title: WidgetUtils.appTextWidget(context: context, title: widget.sellerName, fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20, family: 'Graphik'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBar: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return Container(
          height: isKeyboardVisible
              ? questionArray.isNotEmpty
                  ? MediaQuery.of(context).size.height * 0.77
                  : MediaQuery.of(context).size.height * 0.45
              : questionArray.isNotEmpty
                  ? MediaQuery.of(context).size.height * 0.43
                  : 75,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              /*       SizedBox(
                height: 36,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WidgetUtils.appTextWidget(context: context, title: "Need Help?".tr, color: const Color(0xFF2779F6), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => CreateTicketScreen(helpDeskId: hpUserId!.id!)));
                        if (result != null && result == "true") {
                          isLoading.value = true;
                          setState(() {});
                          await checkTickets(userId: hpUserId!.id!);
                          isLoading.value = false;
                          setState(() {});
                        }
                      },
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color(int.parse(themeColor.value.barColor!.color!))),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/ticket.svg", height: 18, width: 18),
                            const SizedBox(width: 6),
                            WidgetUtils.appTextWidget(
                                context: context, title: "Create Support Ticket".tr, color: const Color(0xffFFFFFF), fontWeight: FontWeight.w500, fontSize: 14, family: 'Graphik'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),*/
              questionArray.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Welcome to NEDFi - Information Repository of Products, Producers and Entrepreneurs of NER Portal", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),
                          const Text("Let us know what you are looking for?", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff575757))),
                          const SizedBox(height: 10),
                          questionArray.isNotEmpty
                              ? SizedBox(
                                  // width: 150,
                                  child: GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8.0, crossAxisSpacing: 8.0, childAspectRatio: 2.4),
                                      itemCount: questionArray.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            chatTextController.text = questionArray[index];
                                            isCalled = true;
                                            if (chatTextController.text.isNotEmpty) {
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            // alignment: Alignment.centerLeft,
                                            // height:70,
                                            padding: const EdgeInsets.all(8.0),
                                            // margin: const EdgeInsets.only(bottom: 10),
                                            child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(height: 16, width: 16, "assets/images/questions.svg", color: Color(int.parse(themeColor.value.barColor!.color!))),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: WidgetUtils.appTextWidget(
                                                      context: context,
                                                      title: questionArray[index],
                                                      color: Color(int.parse(themeColor.value.barColor!.color!)),
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      family: 'Graphik'),
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: Color(int.parse(themeColor.value.barColor!.color!)))),
                                          ),
                                        );
                                      }),
                                )
                              : Container()
                        ],
                      ))
                  : Container(),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0x33B4B6C4))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // SvgPicture.asset("assets/images/attachment.svg", height: 18, width: 18),
                    Expanded(
                      child: TextField(
                        controller: chatTextController,
                        decoration: InputDecoration(
                            hintText: 'Your Message'.tr,
                            hintStyle: TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)).withOpacity(0.6)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16.0)),
                        style: TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!))),
                      ),
                    ),
                    FlatActionButton(
                      icon: Icon(Icons.arrow_forward, size: 18.0, color: Color(int.parse(themeColor.value.barColor!.color!))),
                      onPressed: () {
                        if (chatTextController.text.isNotEmpty) {
                          isCalled = true;
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              FutureBuilder(
                future: getChatResponse(chatTextController.text.toString()),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return snapshot.hasData
                      ? messageArray.isNotEmpty
                          ? Container(
                              child: ListView.builder(
                                  itemCount: messageArray.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return chatListItem(messageArray[index]['msg'].toString(), index, messageArray[index]['isFrom'].toString(), messageArray[index]['date_time'].toString());
                                  }),
                            )
                          : Container()
                      : Container();
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }

  dynamic setDate(String dateTime) {
    DateTime dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateTime);
    final newFormat = DateFormat.yMMMd('en_US').add_jm().format(dateFormat);
    if (dateTime != null) {
      return newFormat.toString();
    }
  }

  Widget chatListItem(String message, int index, String messageType, String dateTime) {
    return FlatChatMessage(
      message: message,
      messageType: messageType == "sender" ? MessageType.sent : MessageType.received,
      showTime: true,
      time: setDate(dateTime),
    );
  }

  Future getChatResponse(String message) async {
    try {
      if (isCalled) {
        isCalled = false;
        if (message.isNotEmpty) {
          messageArray.add({"msg": message, "date_time": DateTime.now().toString(), "isFrom": "sender"});
        }
        final params = {'chat': message, 'id': ''};
        final response = await APIService.postAPIMethod(url: ApiURL.getChatBot, params: params);
        ChatBotModel jsonResult = ChatBotModel.fromJson(json.decode(response.body));
        if (jsonResult.success.toString() == "1") {
          if (jsonResult.data?.chatBotReplay != null) {
            messageArray.add({"msg": jsonResult.data?.chatBotReplay?[0].cbResponsedata ?? "", "date_time": DateTime.now().toString(), "isFrom": "receiver"});
          } else {
            if (jsonResult.data?.chatBotError != null) {
              messageArray.add({"msg": jsonResult.data?.chatBotError ?? "Please ask relevent question! or else type help", "date_time": DateTime.now().toString(), "isFrom": "receiver"});
            }
          }
          if (jsonResult.data?.chatBotResponse != null) {
            questionArray.clear();
            questionArray.add(jsonResult.data?.chatBotResponse?.s1 ?? "Help");
            questionArray.add(jsonResult.data?.chatBotResponse?.s2 ?? "Help");
            questionArray.add(jsonResult.data?.chatBotResponse?.s3 ?? "Help");
          } else {
            questionArray.clear();
          }
        }
        chatTextController.clear();
        setState(() {});
      }
      return messageArray;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    messageArray.clear();
    chatTextController.dispose();
    super.dispose();
  }
}
