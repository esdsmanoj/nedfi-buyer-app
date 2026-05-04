import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:nedfi_seller_common_code/pages/helpdesk/create_ticket.dart';
import 'package:nedfi_seller_common_code/pages/helpdesk/helpdesk_ticket_details.dart';

import '../../model/helpdesk_login_model.dart';
import '../../model/helpdesk_ticket_model.dart';

ValueNotifier<List<Tickets>?> streamController = ValueNotifier(null);
ValueNotifier<List<TicketsCount>?> ticketStreamController = ValueNotifier(null);

class HelpDeskScreen extends StatefulWidget {
  const HelpDeskScreen({super.key});

  @override
  State<HelpDeskScreen> createState() => _HelpDeskScreenState();
}

class _HelpDeskScreenState extends State<HelpDeskScreen> {
  HpUserId? hpUserId;
  String isActive = "all";

  @override
  void initState() {
    isLoading.value = true;
    setState(() {});
    checkUserLogin();
    isLoading.value = false;
    setState(() {});
    super.initState();
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
                title: WidgetUtils.appTextWidget(context: context, title: 'Helpdesk'.tr, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
                iconTheme: const IconThemeData(color: Colors.white),
                leading: IconButton(
                  icon: const Icon(Icons.keyboard_backspace_sharp),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  child: ValueListenableBuilder(
                    valueListenable: streamController,
                    builder: (newCtx, snapshot, child) {
                      return snapshot != null
                          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              SizedBox(
                                child: ValueListenableBuilder(
                                    valueListenable: ticketStreamController,
                                    builder: (ticketCtx, ticketSnapshot, child) {
                                      return ticketSnapshot != null && (ticketSnapshot.isNotEmpty ?? false)
                                          ? GridView.builder(
                                              itemCount: ticketSnapshot.length,
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0),
                                              shrinkWrap: true,
                                              itemBuilder: (ctx, index) {
                                                return InkWell(
                                                    onTap: () async {
                                                      isLoading.value = true;
                                                      isActive = ticketSnapshot[index].status!.toLowerCase();
                                                      setState(() {});
                                                      await checkTickets(status: ticketSnapshot[index].statusId ?? "0", userId: hpUserId!.id!);
                                                      isLoading.value = false;
                                                      setState(() {});
                                                    },
                                                    child: buildStatusWidget(ticketSnapshot[index].status ?? "0", ticketSnapshot[index].statusName ?? ""));
                                              })
                                          : Container();
                                    }),
                              ),
                              const SizedBox(height: 11),
                              WidgetUtils.appTextWidget(context: context, title: 'Tickets'.tr, color: Colors.black, family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500),
                              const SizedBox(height: 8),
                              Expanded(
                                child: snapshot != null && (snapshot.isNotEmpty ?? false)
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.length,
                                        itemBuilder: (ticketContext, ticketIndex) {
                                          int? statusColor;
                                          statusColor = snapshot[ticketIndex].statusName != null
                                              ? snapshot[ticketIndex].statusName!.toLowerCase() == "open"
                                                  ? 0xFFE70000
                                                  : snapshot[ticketIndex].statusName!.toLowerCase() == "closed"
                                                      ? 0xFF27914F
                                                      : snapshot[ticketIndex].statusName!.toLowerCase() == "resolved"
                                                          ? 0xFF27914F
                                                          : snapshot[ticketIndex].statusName!.toLowerCase() == "reopened"
                                                              ? 0xFFE88700
                                                              : snapshot[ticketIndex].statusName!.toLowerCase() == "reopen"
                                                                  ? 0xFFE88700
                                                                  : 0xffffffff
                                              : 0xffffffff;

                                          return InkWell(
                                            onTap: () async {
                                              final result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (routeCtx) =>
                                                          HelpDeskTicketDetails(helpdeskUserId: hpUserId!.id!, ticketId: snapshot[ticketIndex].id!, messageId: snapshot[ticketIndex].msgId!)));
                                              if (result == "true") {
                                                isLoading.value = true;
                                                setState(() {});
                                                checkTickets(userId: hpUserId!.id!);
                                                isLoading.value = false;
                                                setState(() {});
                                              }
                                            },
                                            child: Container(
                                                margin: const EdgeInsets.only(bottom: 12),
                                                padding: const EdgeInsets.all(12),
                                                width: double.maxFinite,
                                                height: 112,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        WidgetUtils.appTextWidget(
                                                            context: context,
                                                            title: "#${snapshot[ticketIndex].id!}",
                                                            color: Colors.black,
                                                            family: 'Graphik',
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500),
                                                        Container(
                                                          height: 20,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color(statusColor)),
                                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                                          child: WidgetUtils.appTextWidget(
                                                              context: context,
                                                              title: snapshot[ticketIndex].statusName!,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              family: 'Graphik'),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(snapshot[ticketIndex].subject ?? "",
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.start,
                                                        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 14, fontFamily: 'Graphik')),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text((HeaderSingleton().profileDetails.value!.data[0].firstName ?? "") + " " + (HeaderSingleton().profileDetails.value!.data[0].lastName ?? ""),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF3F3F3F), fontSize: 10, fontFamily: 'Graphik')),
                                                        Text(snapshot[ticketIndex].date ?? "",
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF3F3F3F), fontSize: 10, fontFamily: 'Graphik')),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                decoration: BoxDecoration(color: const Color(0xFFFFFFFF), border: Border.all(color: const Color(0xFFCFCFCF)), borderRadius: BorderRadius.circular(8))),
                                          );
                                        })
                                    : Container(
                                        child: Center(
                                        child: WidgetUtils.appTextWidget(
                                            context: context, title: "No Support tickets available".tr, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16),
                                      )),
                              )
                            ])
                          : Container();
                    },
                  )),
              bottomNavigationBar: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => CreateTicketScreen(helpDeskId: hpUserId!.id!)));
                      if (result != null && result == "true") {
                        isLoading.value = true;
                        setState(() {});
                        checkTickets(userId: hpUserId!.id!);
                        isLoading.value = false;
                        setState(() {});
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(int.parse(themeColor.value.barColor!.color!))),
                        height: 58,
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          SvgPicture.asset("assets/images/CreateTicket.svg", height: 18),
                          const SizedBox(width: 8),
                          WidgetUtils.appTextWidget(context: context, title: "Create Support  Ticket".tr, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16)
                        ])),
                  )),
            )));
  }

  Future checkUserLogin() async {
    try {
      String userType = await SharePrefsHelper.getInstance(context)?.getStringValue("userType") ?? "0";
      final params = {
        'fullname': HeaderSingleton().profileDetails.value!.data[0].firstName! + " " + HeaderSingleton().profileDetails.value!.data[0].lastName!,
        'email': HeaderSingleton().profileDetails.value!.data[0].email ?? "null",
        'usertype': userType,
        'user_id': userId,
        'phone': HeaderSingleton().profileDetails.value!.data[0].phone!,
        'domain': HeaderSingleton().domain.value,
        'appname': HeaderSingleton().appName.value,
        'key': "CODEX@123",
        'user_lang': lang
      };
      http.Response response = await http.post(Uri.parse("https://dev.famrut.com/support/api/users/login"), body: params).timeout(const Duration(minutes: 1));
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
      setState(() {});
      rethrow;
    }
  }

  Widget buildStatusWidget(String ticketCount, String statusName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
            alignment: Alignment.center,
            height: 67,
            width: 94,
            child: WidgetUtils.appTextWidget(context: context, title: ticketCount, color: Colors.black, family: 'Graphik', fontSize: 28, fontWeight: FontWeight.w500),
            decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(6))),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: WidgetUtils.appTextWidget(context: context, title: statusName, color: Colors.white, overflow: TextOverflow.ellipsis, family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500),
        )
      ]),
      height: 100,
      // width: 100,
      decoration: BoxDecoration(color: Color(isActive == statusName.toLowerCase() ? 0xFFFDA11E : 0xFFFDB44B), borderRadius: BorderRadius.circular(8)),
    );
  }
}
