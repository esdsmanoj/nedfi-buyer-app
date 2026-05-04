import 'package:get/get.dart';
import 'AnnouncementDetailScreen.dart';
import 'package:nedfi_seller_common_code/app_imports.dart';

class AnnouncementScreen extends StatefulWidget {
  final String type;

  const AnnouncementScreen(this.type, {super.key});

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  bool isDataNotFound = false;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String loadingText = 'Loading..';
  var unescape = HtmlUnescape();

  @override
  void initState() {
    var landCropModel = Provider.of<AnnouncementProvider>(context, listen: false);
    landCropModel.setAnnouncementList([]);
    if (widget.type == "Notice") {
      fetchNotice();
    } else {
      fetchAnnouncement();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AnnouncementProvider>(builder: (context, announcementModel, child) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(elevation:0,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(context:context,title: widget.type == "Notice".tr ? 'Notice'.tr : 'Announcement'.tr, color: Colors.white, fontSize: 18),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: CustomProgressHandler(
              isLoading: isLoading.value,
              loadingText: loadingText,
              child: SafeArea(
                  child: Scaffold( backgroundColor: Colors.white,
               //  backgroundColor: ColorsConst.backgroundColor,
                body: isDataNotFound
                    ? Center(
                        child: WidgetUtils.appTextWidget(context:context,title: 'No data found'.tr, color: Colors.black, fontSize: 18),
                      )
                    : ListView.builder(
                        itemCount: announcementModel.announcementList.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return buildAnnouncementItem(announcementModel.announcementList[index], index);
                        }),
              )),
            ));
      }),
    );
  }

  Widget buildAnnouncementItem(AnnouncementData data, int index) {
    final time = (int.parse(data.createdOn.substring(11, 13)) >= 12) ? "${data.createdOn.substring(11, 16)}PM" : "${data.createdOn.substring(11, 16)}AM";
    // print('Time: $time');
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final homeDashboardModel = Provider.of<HomeDashboardProvider>(context, listen: false);
        if (widget.type == "Notice") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementDetailScreen(data, homeDashboardModel.configUrl.notice, widget.type, HeaderSingleton().paramsMaps!.userId!)));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementDetailScreen(data, homeDashboardModel.configUrl.announcement, widget.type, HeaderSingleton().paramsMaps!.userId!)));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const CircleAvatar(
                  child: Icon(
                    Icons.notifications,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                            width: 200,
                            height: MediaQuery.of(context).size.height * 0.02,
                            child: WidgetUtils.appTextWidget(context:context,title: data.title, overflow: TextOverflow.ellipsis, color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.035,
                        child:_htmlText(data.description) /*Html(
                          data: unescape.convert(data.description),
                          style: {
                            "body":
                                Style(fontSize: const FontSize(10), textOverflow: TextOverflow.ellipsis, fontFamily: 'Graphik', width: 200, alignment: Alignment.centerLeft, textAlign: TextAlign.start)
                          },
                        ),*/
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: 120,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: data.priorityType.toLowerCase() == 'high'
                                ? Colors.red.shade50
                                : data.priorityType.toLowerCase() == 'medium'
                                    ? Colors.yellow.shade50
                                    : Colors.green.shade50),
                        child: WidgetUtils.appTextWidget(context:context,
                            title: "Priority : " + data.priorityType,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 10,
                            color: data.priorityType.toLowerCase() == 'high'
                                ? Colors.red
                                : data.priorityType.toLowerCase() == 'medium'
                                    ? Colors.yellow
                                    : Colors.green,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 50, child: WidgetUtils.appTextWidget(context:context,title: time, overflow: TextOverflow.ellipsis, color: Colors.green, fontSize: 12, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _htmlText(String text) {
    return SingleChildScrollView(
      /*     scrollDirection: Axis.horizontal,*/
      child: Html(
        shrinkWrap: true,
        data: unescape.convert(text),
        style: {
          "body": Style(fontSize:  FontSize(12), letterSpacing: 0.0),
          "table": Style(
            backgroundColor: Colors.white,
          ),
          // "tr": Style(padding: const EdgeInsets.all(2), border: Border.all(color: Colors.black)),
          // "th": Style(padding: const EdgeInsets.all(2), border: Border.all(color: Colors.black)),
          // "td": Style(padding: const EdgeInsets.all(2), border: Border.all(color: Colors.black)),
        },
        /*customRender: {
          "table": (context, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: (context.tree as TableLayoutElement).toWidget(context),
            );
          }
        },*/
      ),
    );
  }

  Future fetchAnnouncement() async {
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.getAPIMethod(url: ApiURL.getAnnouncement);
        var data = json.decode(response.body);
        print(data);
        AnnouncementResponse npkResponse = AnnouncementResponse.fromJson(data);
        if (npkResponse.status != 1) {
          WidgetUtils.errorDialog(context, npkResponse.message);
        } else {
          if (npkResponse.data.isNotEmpty) {
            var landCropModel = Provider.of<AnnouncementProvider>(context, listen: false);
            landCropModel.setAnnouncementList(npkResponse.data);
            isLoading.value = false;
            return;
          }
        }
        setState(() {
          isDataNotFound = true;
        });
        isLoading.value = false;
      }
    } catch (e) {
      // print(e);
      isLoading.value = false;
      // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future fetchNotice() async {
    try {
      isLoading.value = true;
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        var param = {"farmer_id": HeaderSingleton().paramsMaps!.userId};
        final response = await APIService.postAPIMethod(url: ApiURL.getNotice, params: param);
        var data = json.decode(response.body);
        print(param);
        print(data);
        AnnouncementResponse npkResponse = AnnouncementResponse.fromJson(data);
        if (npkResponse.status != 1) {
          WidgetUtils.errorDialog(context, npkResponse.message);
        } else {
          if (npkResponse.data.isNotEmpty) {
            var landCropModel = Provider.of<AnnouncementProvider>(context, listen: false);
            landCropModel.setAnnouncementList(npkResponse.data);
            isLoading.value = false;
            return;
          }
        }
      }
      setState(() {
        isDataNotFound = true;
      });
      isLoading.value = false;
    } catch (e) {
      // print(e);
      isLoading.value = false;
    }
  }
}
