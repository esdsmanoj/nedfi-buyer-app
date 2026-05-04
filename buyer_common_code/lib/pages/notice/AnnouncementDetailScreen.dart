import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:buyer_common_code/app_imports.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  AnnouncementData announcementData;
  String baseUrl;
  String type, farmerID;

  AnnouncementDetailScreen(this.announcementData, this.baseUrl, this.type, this.farmerID, {super.key});

  @override
  _AnnouncementDetailScreenState createState() => _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  bool? _isLoading;
  late String _loadingText;
  var unescape = HtmlUnescape();
  late UserData paramsMaps;

  @override
  void initState() {
    super.initState();
  //  var homeDashboardModel = Provider.of<AnouncementModel>(context, listen: false);
 //   homeDashboardModel.setAnnouncementDetailsList(AnnouncementDetailData(title: "", description: "", priorityType: "", createdOn: "", attachedDocument: []));
    _isLoading = false;
    _loadingText = 'Loading . . .';
    getBlogDetails();
    getUserModel(context).then((value) {
      paramsMaps = value;

    });
  }

  Future<UserData> getUserModel(BuildContext context) async {
    paramsMaps = (await SharePrefsHelper.getInstance(context)?.getUserModel())!;
    return paramsMaps;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AnnouncementProvider, HomeDashboardProvider>(builder: (context, anouncementModel, homeDashboardModel, child) {
      ////print(homeDashboardModel.configUrl.announcement + "/" + anouncementModel.announcementDetailsList.attachedDocument![0]);

      return CustomProgressHandler(
        isLoading: _isLoading!,
        loadingText: "loading..",
        child: SafeArea(
          child: Scaffold( backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                anouncementModel.announcementDetailsList != null && anouncementModel.announcementDetailsList.attachedDocument!.isNotEmpty
                    ? Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width - 100,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 0.8), borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
                            child: anouncementModel.announcementDetailsList.attachedDocument!.isNotEmpty
                                ? Hero(
                                    tag: "widget.destination.imageUrl",
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: FadeInImage.assetNetwork(
                                        imageErrorBuilder: (ctx, obj, st) => Image.file(File(image), fit: BoxFit.fill),
                                        placeholder: image,
                                        image: widget.type == "Notice"
                                            ? homeDashboardModel.configUrl.notice + "/" + anouncementModel.announcementDetailsList.attachedDocument![0]
                                            : homeDashboardModel.configUrl.announcement + "/" + anouncementModel.announcementDetailsList.attachedDocument![0],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  iconSize: 30.0,
                                  color: Colors.black,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
                    child: ListView(children: [
                      anouncementModel.announcementDetailsList.attachedDocument!.isEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  iconSize: 30.0,
                                  color: Colors.black,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            )
                          : Container(),
                      anouncementModel.announcementDetailsList.title!.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  anouncementModel.announcementDetailsList.title!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            )
                          : Center(child: WidgetUtils.appTextWidget(context:context,title: 'No data found'.tr, color: Colors.black, family: 'Graphik', fontSize: 18)),
                      anouncementModel.announcementDetailsList.description!.isNotEmpty ? _htmlText(anouncementModel.announcementDetailsList.description!) : Container(),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _htmlText(String text) {
    return SingleChildScrollView(
      /*     scrollDirection: Axis.horizontal,*/
      child: Html(
        shrinkWrap: true,
        data: unescape.convert(text),
        style: {
          "body": Style(fontSize: FontSize(16), letterSpacing: 0.0),
          "table": Style(
            backgroundColor: Colors.white,
          ),
          // "tr": Style(padding:  EdgeInsets.all(2), border: Border.all(color: Colors.black)),
          // "th": Style(padding:  EdgeInsets.all(2), border: Border.all(color: Colors.black)),
          // "td": Style(padding:  EdgeInsets.all(2), border: Border.all(color: Colors.black)),
        }/*,
        customRender: {
          "table": (context, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: (context.tree as TableLayoutElement).toWidget(context),
            );
          }
        }*/,
      ),
    );
  }

  Future getBlogDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      //var headerModel =
      //    Provider.of<HeaderModel>(context, listen: false);
      var param = {/*"id": widget.announcementData.id,*/ "notice_id": widget.announcementData.id, "farmer_id": HeaderSingleton().paramsMaps!.userId};
      var urls = ApiURL.announcementDetails;
      if (widget.type == "Notice") {
        urls = ApiURL.noticeDetails;
        param = {"notice_id": widget.announcementData.id, "farmer_id": HeaderSingleton().paramsMaps!.userId};
      } else {
        urls = ApiURL.announcementDetails;
        param = {"id": widget.announcementData.id,  "farmer_id": HeaderSingleton().paramsMaps!.userId};
      }
      //print(widget.type);
       //print(urls);
      http.Response response = await http.post(Uri.parse(baseURL + urls), headers: headerParams, body: param);
      var data = json.decode(response.body);
      //print(headerParams);
      //print(param);
       //print(data);
      var res = AnnouncementDetailsResponse.fromJson(data);
      if (res.status == 1) {
        if (res.data != null) {
          var homeDashboardModel = Provider.of<AnnouncementProvider>(context, listen: false);
          homeDashboardModel.setAnnouncementDetailsList(res.data!);
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
       //print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }
}
