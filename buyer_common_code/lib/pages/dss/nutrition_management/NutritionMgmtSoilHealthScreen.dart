import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../model/MasterResponse.dart';
import 'package:buyer_common_code/app_imports.dart';

class NutritionMgmtSoilHealthScreen extends StatefulWidget {
  String? cropID, from, cropName;

  NutritionMgmtSoilHealthScreen({super.key, this.cropID, this.from, this.cropName});

  @override
  _NutritionMgmtBlanketScreenState createState() => _NutritionMgmtBlanketScreenState();
}

class _NutritionMgmtBlanketScreenState extends State<NutritionMgmtSoilHealthScreen> {
  bool? _isLoading;
  late String _loadingText;
  late final double? elevation = 3.0;
  bool _isBackPress = false;
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
    return Consumer<LandCropProvider>(builder: (context, landCropModel, child) {
      return CustomProgressHandler(
        isLoading: false,
        loadingText: "",
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              'Nutrition Management - Blanket'.tr,
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
              : ListView(
                  children: [
                    ListView.builder(
                        itemCount: landCropModel.soilType.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _loanTypeItem(landCropModel.soilType[index], index);
                        }),
                  ],
                ),
        )),
      );
    });
  }

  _loanTypeItem(SoilType varitesData, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SoilHealthDetailsScreen(
                        from: "dss",
                        cropID: widget.cropID,
                        cropName: widget.cropName,
                        soilType: varitesData,
                      )));
        },
        child: Container(
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Color(0xff92b89e).withOpacity(0.7), offset: Offset(0, 15), blurRadius: 16.0),
              ],
              border: Border.all(color: Color(0xff10ad42), width: 1.0, style: BorderStyle.solid),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        child: Center(
                            child: Container(
                          child: Image.file(
                            File(imgPlaceHolder),
                            fit: BoxFit.fill,
                          ),
                          width: 50,
                          height: 50,
                        )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 220,
                        child: Text(
                          varitesData.value.toUpperCase(),
                          maxLines: 2,
                          style: TextStyle(color: Color(0XFF000000), fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios_outlined)
                ],
              ),
            )),
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
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.getMasterData);

        // //print(fetchSchoolsUri);

        http.Response response = await http.get(fetchSchoolsUri, headers: headerParams);
        var data = json.decode(response.body);
        MasterResponse masterResponse = MasterResponse.fromJson(data);
        if (masterResponse.status != 1) {
          WidgetUtils.errorDialog(context, data["msg"] ?? "");
          setState(() {
            isDataNotFound = true;
          });
        } else {
          if (masterResponse.soilType.isEmpty) {
            setState(() {
              isDataNotFound = true;
            });
          } else {
            var landCropModel = Provider.of<LandCropProvider>(context, listen: false);
            landCropModel.setFarmType(masterResponse.farmType);
            landCropModel.setTopology(masterResponse.topology);
            landCropModel.setSoilType(masterResponse.soilType);
            landCropModel.setUnit(masterResponse.unit);
            landCropModel.setIrriSrc(masterResponse.irriSrc);
            landCropModel.setIrriFaty(masterResponse.irriFaty);
            landCropModel.setCrop(masterResponse.crop);
            landCropModel.setCropType(masterResponse.cropType);
          }
        }
      } else {
        /* WidgetUtils.errorDialog(context,
            AppTranslations.of(context)?.text("key_connection_lost") ??
                'key_connection_lost'.tr,
            2);*/
        setState(() {
          isDataNotFound = true;
        });
      }
    } on SocketException {
      /* WidgetUtils.errorDialog(context,
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
