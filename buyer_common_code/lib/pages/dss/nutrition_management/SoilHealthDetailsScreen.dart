import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/model/MasterResponse.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SoilHealthDetailsScreen extends StatefulWidget {
  String? cropID, from, cropName;
  SoilType? soilType;

  SoilHealthDetailsScreen({super.key, this.cropID, this.from, this.soilType, this.cropName});

  @override
  _SoilHealthDetailsScreenState createState() => _SoilHealthDetailsScreenState();
}

class _SoilHealthDetailsScreenState extends State<SoilHealthDetailsScreen> {
  bool? _isLoading;
  late String _loadingText;
  late final double? elevation = 3.0;
  bool isDataNotFound = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _loadingText = 'Loading . . .';
    fetchMaster();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DSSProvider>(//                    <--- Consumer
        builder: (context, dSSModel, child) {
      return CustomProgressHandler(
        isLoading: this._isLoading!,
        loadingText: this._loadingText,
        child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'Soil Health Card Details'.tr,
                  ),
                  leading: Transform.rotate(
                    angle: 0, //angle,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                      ),
                      onPressed: () {
                        // ZoomDrawer.of(context)!.toggle.call();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                //  backgroundColor: ColorsConst.backgroundColor,
                body: isDataNotFound
                    ? Center(
                        child: Text(
                          'No Data Available'.tr,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                          textAlign: TextAlign.left,
                        ),
                      )
                    : Container(
                        child: dSSModel.SoilHealthList.isNotEmpty
                            ? _htmlText(dSSModel.SoilHealthList.isNotEmpty ? dSSModel.SoilHealthList[0].information : "")
                            : Center(
                                child: Text(
                                  'No Data Available'.tr,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                      ))),
      );
    });
  }

  var unescape = HtmlUnescape();

  _htmlText(String text) {
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: SingleChildScrollView(
              /* scrollDirection: Axis.horizontal,*/
              child: Html(
                shrinkWrap: true,
                data: unescape.convert(text),
                style: {
                  "body": Style(fontSize: FontSize(16), letterSpacing: 0.0),
                  "table": Style(
                    backgroundColor: Colors.white,
                  ),
                  // "tr": Style(padding: EdgeInsets.all(2), border: Border.all(color: Colors.black)),
                  // "th": Style(padding: EdgeInsets.all(2), border: Border.all(color: Colors.black)),
                  // "td": Style(padding: EdgeInsets.all(2), border: Border.all(color: Colors.black)),
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
            ),
          ),
        ],
      ),
    );
  }

  fetchMaster() async {
    try {
      setState(() {
        _isLoading = true;
      });
      //var headerModel =
      //    Provider.of<HeaderModel>(context, listen: false);
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.soilHealthCardDetails + "/" + widget.soilType!.id);

        // //print(fetchSchoolsUri);

        http.Response response = await http.get(fetchSchoolsUri, headers: headerParams);
        var data = json.decode(response.body);
        // //print(data);
        SoilHealthResponse varitesResponse = SoilHealthResponse.fromJson(data);
        if (varitesResponse.status != 1) {
          WidgetUtils.errorDialog(context, data["msg"] ?? "");
          setState(() {
            isDataNotFound = true;
          });
        } else {
          if (varitesResponse.data.isEmpty) {
            setState(() {
              isDataNotFound = true;
            });
          } else {
            var dSSModel = Provider.of<DSSProvider>(context, listen: false);
            dSSModel.setSoilHealthList(varitesResponse.data);
          }
        }
      } else {
        setState(() {
          isDataNotFound = true;
        });
        /*  WidgetUtils.errorDialog(context,
            AppTranslations.of(context)?.text("key_connection_lost") ??
                'key_connection_lost'.tr,
            2);*/
      }
    } on SocketException {
      /*  WidgetUtils.errorDialog(context,
          AppTranslations.of(context)?.text("key_connection_lost") ??
              'key_connection_lost'.tr,
          2);*/
    } catch (e) {
      // //print(e);
      // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
    }
    setStateIfMounted(() {
      _isLoading = false;
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
