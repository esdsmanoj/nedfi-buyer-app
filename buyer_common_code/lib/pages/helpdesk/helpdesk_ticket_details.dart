import 'package:buyer_common_code/app_imports.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../../model/helpdesk_ticket_model.dart';

class HelpDeskTicketDetails extends StatefulWidget {
  final String ticketId;
  final String helpdeskUserId;
  final String messageId;

  const HelpDeskTicketDetails({super.key, required this.ticketId, required this.helpdeskUserId, required this.messageId});

  @override
  State<HelpDeskTicketDetails> createState() => _HelpDeskTicketDetailsState();
}

class _HelpDeskTicketDetailsState extends State<HelpDeskTicketDetails> {
  ValueNotifier<HelpDeskTicketModel?> helpdeskTicketDetails = ValueNotifier(null);
  var unescape = HtmlUnescape();
  String? extension;
  List<Attachment> ticketDetails = [];
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    isLoading.value = true;
    setState(() {});
    getDetails();
    isLoading.value = false;
    setState(() {});
    super.initState();
  }

  Future getDetails() async {
    await getAllAttachments(widget.ticketId, widget.messageId);
    helpdeskTicketDetails.value = await checkTickets(userId: widget.helpdeskUserId, ticketId: widget.ticketId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, "true");
          return true;
        },
        child: CustomProgressHandler(
          loadingText: '',
          isLoading: isLoading.value,
          child: SafeArea(
              child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(context: context, title: 'Ticket'.tr + " " + widget.ticketId, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.keyboard_backspace_sharp),
                onPressed: () {
                  Navigator.pop(context, "true");
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ValueListenableBuilder(
                  valueListenable: helpdeskTicketDetails,
                  builder: (BuildContext context, HelpDeskTicketModel? value, Widget? child) {
                    int? statusColor;
                    if (value != null) {
                      statusColor = helpdeskTicketDetails.value!.tickets![0].statusName != null
                          ? helpdeskTicketDetails.value!.tickets![0].statusName!.toLowerCase() == "open"
                              ? 0xFFE70000
                              : helpdeskTicketDetails.value!.tickets![0].statusName!.toLowerCase() == "closed"
                                  ? 0xFF27914F
                                  : helpdeskTicketDetails.value!.tickets![0].statusName!.toLowerCase() == "resolved"
                                      ? 0xFF27914F
                                      : helpdeskTicketDetails.value!.tickets![0].statusName!.toLowerCase() == "reopened"
                                          ? 0xFFE88700
                                          : helpdeskTicketDetails.value!.tickets![0].statusName!.toLowerCase() == "reopen"
                                              ? 0xFFE88700
                                              : 0xffffffff
                          : 0xffffffff;
                    }
                    return value != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetUtils.appTextWidget(
                                      context: context, title: "Ticket".tr + " " + "#${value!.tickets![0].id!}", color: Colors.black, family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500),
                                  Container(
                                    height: 20,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color(statusColor!)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: WidgetUtils.appTextWidget(
                                        context: context, title: value.tickets![0].statusName!, fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12, family: 'Graphik'),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(value.tickets![0].subject ?? "",
                                  maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF3F3F3F), fontSize: 14, fontFamily: 'Graphik')),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Html(
                                  data: unescape.convert(value.tickets![0].description ?? ""),
                                  style: {
                                    'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                    'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                    'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                    "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                    "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(value.tickets![0].userFullname ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.w400, color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 12, fontFamily: 'Graphik')),
                                  Text(value.tickets![0].date ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.w400, color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 12, fontFamily: 'Graphik')),
                                ],
                              ),
                              helpdeskTicketDetails.value!.tickets![0].ticketReopenDate != null && (helpdeskTicketDetails.value!.tickets![0].ticketReopenDate?.isNotEmpty ?? false)
                                  ? const SizedBox(height: 12)
                                  : const SizedBox(),
                              helpdeskTicketDetails.value!.tickets![0].ticketReopenDate != null && (helpdeskTicketDetails.value!.tickets![0].ticketReopenDate?.isNotEmpty ?? false)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Reopened Date".tr,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontWeight: FontWeight.w400, color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 12, fontFamily: 'Graphik')),
                                        Text(value.tickets![0].ticketReopenDate ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontWeight: FontWeight.w400, color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 12, fontFamily: 'Graphik')),
                                      ],
                                    )
                                  : Container(),
                              helpdeskTicketDetails.value!.tickets![0].ticketResolveDate != null && (helpdeskTicketDetails.value!.tickets![0].ticketResolveDate?.isNotEmpty ?? false)
                                  ? const SizedBox(height: 12)
                                  : const SizedBox(),
                              helpdeskTicketDetails.value!.tickets![0].ticketResolveDate != null && (helpdeskTicketDetails.value!.tickets![0].ticketResolveDate?.isNotEmpty ?? false)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Resolved Date".tr,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontWeight: FontWeight.w400, color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 12, fontFamily: 'Graphik')),
                                        Text(value.tickets![0].ticketResolveDate ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontWeight: FontWeight.w400, color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 12, fontFamily: 'Graphik')),
                                      ],
                                    )
                                  : Container(),
                              helpdeskTicketDetails.value!.tickets![0].ticketResolveDate != null && (helpdeskTicketDetails.value!.tickets![0].ticketResolveDate?.isNotEmpty ?? false)
                                  ? const SizedBox(height: 12)
                                  : const SizedBox(),
                              const SizedBox(height: 12),
                              helpdeskTicketDetails.value!.replyFlag != 1
                                  ? Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Center(
                                        child: Text("No replies available".tr,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontWeight: FontWeight.w400, color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 12, fontFamily: 'Graphik')),
                                      ),
                                    )
                                  : Container(
                                      child: ToggleList(
                                          shrinkWrap: true,
                                          trailing: const Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.black)),
                                          children: [
                                            ToggleListItem(
                                              headerDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                                              itemDecoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                                              expandedHeaderDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                                              content: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: helpdeskTicketDetails.value!.tickets!.length,
                                                    itemBuilder: (ctx, listIndex) {
                                                      //print("Staff:${helpdeskTicketDetails.value!.tickets![listIndex].staffId}");
                                                      return InkWell(
                                                          onTap: () {},
                                                          child: Container(
                                                            alignment: Alignment.centerLeft,
                                                            // height: 40,
                                                            width: double.maxFinite,
                                                            child: helpdeskTicketDetails.value!.tickets![listIndex].staffId != "0"
                                                                ? Column(
                                                                    children: [
                                                                      Html(
                                                                        data: unescape.convert(helpdeskTicketDetails.value!.tickets![listIndex].description ?? ""),
                                                                        style: {
                                                                          'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                                          'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                                          'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                                          "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                                          "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                                                                        },
                                                                      ),
                                                                      const SizedBox(height: 8),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text("Replied Date:".tr,
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Color(int.parse(themeColor.value.barColor!.color!)),
                                                                                  fontSize: 12,
                                                                                  fontFamily: 'Graphik')),
                                                                          Text(helpdeskTicketDetails.value!.tickets![listIndex].msgDate ?? "",
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Color(int.parse(themeColor.value.barColor!.color!)),
                                                                                  fontSize: 12,
                                                                                  fontFamily: 'Graphik')),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(height: 8),
                                                                    ],
                                                                  )
                                                                : Container(),
                                                          ));
                                                    }),
                                              ),
                                              title: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                    height: 60,
                                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    alignment: Alignment.centerLeft,
                                                    child: WidgetUtils.appTextWidget(
                                                        color: Colors.black, context: context, title: "Replies".tr, family: 'Graphik', fontWeight: FontWeight.w500, fontSize: 16)),
                                              ),
                                            )
                                          ]),
                                    ),
                              const SizedBox(height: 12),
                              //   WidgetUtils.appTextWidget(context: context, title: 'Support Team Comments'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                              // const SizedBox(height: 12),
                              // SizedBox(
                              //   width: MediaQuery.of(context).size.width * 0.7,
                              //   child: Column(
                              //     children: [
                              //       Html(
                              //         data: unescape.convert(value.tickets![0].description ?? ""),
                              //         style: {
                              //           'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: const FontSize(14), letterSpacing: 0.0),
                              //           'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: const FontSize(14), letterSpacing: 0.0),
                              //           'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: const FontSize(14), letterSpacing: 0.0),
                              //           "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: const FontSize(14), letterSpacing: 0.0),
                              //           "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                              //         },
                              //       ),
                              //       Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           Text("Reply Date".tr,
                              //               maxLines: 2,
                              //               overflow: TextOverflow.ellipsis,
                              //               style: TextStyle(fontWeight: FontWeight.w400, color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 12, fontFamily: 'Graphik')),
                              //           Text(value.tickets![0].msgDate ?? "",
                              //               maxLines: 2,
                              //               overflow: TextOverflow.ellipsis,
                              //               style: TextStyle(fontWeight: FontWeight.w400, color: Color(int.parse(themeColor.value.barColor!.color!)), fontSize: 12, fontFamily: 'Graphik')),
                              //         ],
                              //       )
                              //     ],
                              //   ),
                              // ),
                              // const SizedBox(height: 12),
                              WidgetUtils.appTextWidget(context: context, title: 'Attachment'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                              const SizedBox(height: 12),
                              (ticketDetails != null && ticketDetails.isNotEmpty)
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 1, color: const Color(0xffCFCFCF))),
                                      height: 162,
                                      child: extension == ".pdf"
                                          ? Image.asset("assets/images/pdf.png", fit: BoxFit.cover)
                                          : extension == ".mp3"
                                              ? Image.asset("assets/images/mp3.png", fit: BoxFit.cover)
                                              : extension == ".png" || extension == ".jpeg"
                                                  ? Image.network(
                                                      "https://dev.famrut.com/support/upload/attachments/" + ticketDetails[selectedIndex].enc.toString(),
                                                      errorBuilder: (ctx, obj, stc) => const Icon(Icons.image, size: 140),
                                                    )
                                                  : extension == ".mp4"
                                                      ? Image.asset("assets/images/mp4.png", fit: BoxFit.cover)
                                                      : Image.network(
                                                          "https://dev.famrut.com/support/upload/attachments/" + ticketDetails[selectedIndex].enc.toString(),
                                                          errorBuilder: (ctx, obj, stc) => const Icon(Icons.image, size: 140),
                                                        ))
                                  : Container(
                                      child: Center(
                                        child: WidgetUtils.appTextWidget(context: context, title: 'No attachments is available'.tr, fontWeight: FontWeight.w400, family: 'Graphik', fontSize: 14),
                                      ),
                                    ),
                              const SizedBox(height: 12),
                              ticketDetails != null && (ticketDetails.isNotEmpty)
                                  ? Container(
                                      height: 90,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (documentCtx, documentIndex) {
                                            String? ext;
                                            ext = p.extension(ticketDetails[documentIndex].name!);
                                            return InkWell(
                                              onTap: () {
                                                extension = p.extension(ticketDetails[documentIndex].name!);
                                                selectedIndex = documentIndex;
                                                setState(() {});
                                              },
                                              child: Container(
                                                height: 67,
                                                width: 66,
                                                margin: const EdgeInsets.only(right: 8),
                                                child: ext == ".mp3"
                                                    ? Image.asset("assets/images/mp3.png", fit: BoxFit.cover)
                                                    : ext == ".pdf"
                                                        ? Image.asset("assets/images/pdf.png", fit: BoxFit.cover)
                                                        : ext == ".png" || ext == ".jpeg"
                                                            ? Image.network(
                                                                "https://dev.famrut.com/support/upload/attachments/" + ticketDetails[selectedIndex].enc.toString(),
                                                                errorBuilder: (ctx, obj, stc) => const Icon(Icons.image, size: 60),
                                                              )
                                                            : ext == ".mp4"
                                                                ? Image.asset("assets/images/mp4.png", fit: BoxFit.cover)
                                                                : Image.network("https://dev.famrut.com/support/upload/attachments/" + ticketDetails[documentIndex].enc.toString()),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey)),
                                              ),
                                            );
                                          },
                                          itemCount: ticketDetails.length))
                                  : Container()
                            ],
                          )
                        : Container();
                  },
                ),
              ),
            ),
            bottomNavigationBar: helpdeskTicketDetails.value != null
                ? (helpdeskTicketDetails.value!.tickets![0].statusName!.toLowerCase() == "closed" || helpdeskTicketDetails.value!.tickets![0].statusName!.toLowerCase() == "resolved")
                    ? SizedBox(
                        height: 80,
                        child: Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 12),
                            child: InkWell(
                              onTap: () async {
                                isLoading.value = true;
                                setState(() {});
                                await updateStatus();
                                helpdeskTicketDetails.value = await checkTickets(userId: widget.helpdeskUserId, ticketId: widget.ticketId);
                                isLoading.value = false;
                                setState(() {});
                              },
                              child: Container(
                                  width: double.maxFinite,
                                  height: 58,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xffFDA11E))),
                                  child: SizedBox(
                                    width: 90,
                                    child: Row(children: [
                                      SvgPicture.asset("assets/images/file_edit.svg", height: 18),
                                      const SizedBox(width: 8),
                                      WidgetUtils.appTextWidget(context: context, title: "Reopen".tr, color: const Color(0xffFDA11E), family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500),
                                    ]),
                                  )),
                            )),
                      )
                    : Container(height: 80)
                : Container(
                    height: 80,
                  ),
          )),
        ));
  }

  Future updateStatus() async {
    try {
      final params = {'ticket_id': widget.ticketId, 'status': "2", 'user_lang': lang};
      http.Response response = await http.post(Uri.parse("https://dev.famrut.com/support/api/tickets/updateStatus"), body: params, headers: headerParams).timeout(const Duration(minutes: 1));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == 1) {
          WidgetUtils.successDialog(context, result['message']);
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

  Future getAllAttachments(String ticketId, String? messageId) async {
    try {
      final params = {'ticket_id': ticketId, 'msg_id': messageId ?? ''};
      http.Response response = await http.post(Uri.parse("https://dev.famrut.com/support/api/attachments/getAttachment"), body: params, headers: headerParams).timeout(const Duration(minutes: 1));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == 1) {
          List<Attachment> tickets = [];
          if (result['files'] != null) {
            tickets = <Attachment>[];
            result['files'].forEach((v) {
              tickets.add(Attachment.fromJson(v));
            });
            ticketDetails = tickets;
            if (tickets.isNotEmpty) {
              extension = p.extension(ticketDetails[0].name!);
            }
          }
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
}
