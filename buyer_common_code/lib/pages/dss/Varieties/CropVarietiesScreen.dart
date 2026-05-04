import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:buyer_common_code/app_imports.dart';

class CropVarietiesScreen extends StatefulWidget {
  Map<String, dynamic>? varietyDetails;
  String? cropID, from, cropName, stateID, soilType, irrigationSrc, irrigationType, cropSeason;

  CropVarietiesScreen({super.key, this.varietyDetails, this.cropID, this.from, this.cropName, this.stateID, this.soilType, this.irrigationSrc, this.irrigationType, this.cropSeason});

  @override
  _CropVarietiesScreenState createState() => _CropVarietiesScreenState();
}

class _CropVarietiesScreenState extends State<CropVarietiesScreen> {
  bool? _isLoading;
  late String _loadingText;
  bool isDataNotFound = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _loadingText = 'Loading . . .';
    getVerities();
    getLocaliz(context).then((value) {
      lanLocale = value;
    });
  }

  Future<String> getLocaliz(BuildContext context) async {
    lanLocale = (await SharePrefsHelper.getInstance(context)?.getStringValue("locale")) ?? "en";
    return lanLocale;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<DSSProvider>(//                    <--- Consumer
          builder: (context, dSSModel, child) {
        return CustomProgressHandler(
          isLoading: _isLoading!,
          loadingText: _loadingText,
          child: SafeArea(
              child: Scaffold( backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(context: context, title: 'Select Variates'.tr, color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
           //  backgroundColor: ColorsConst.backgroundColor,
            body: isDataNotFound
                ? Center(
                    child: Text(
                      'No Variety Available'.tr,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: 'Graphikj'),
                      textAlign: TextAlign.left,
                    ),
                  )
                : ListView(
                    children: [
                      ListView.builder(
                          itemCount: dSSModel.varitesList.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _loanTypeItem(dSSModel.varitesList[index], index);
                          }),
                    ],
                  ),
          )),
        );
      }),
    );
  }

  Widget _loanTypeItem(VaritesData varitesData, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => VarietyDetailsScreen(from: "dss", cropID: widget.cropID, cropName: widget.cropName, veritiesData: varitesData)));
        },
        child: Container(
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: const Color(0xff92b89e).withOpacity(0.7), offset: const Offset(0, 15), blurRadius: 16.0),
              ],
              border: Border.all(color: Color(int.parse(themeColor.value.barColor!.color!)), width: 1.0, style: BorderStyle.solid),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: Center(child: Container(child: Image.file(File(image), fit: BoxFit.fill), width: 50, height: 50)),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 230,
                        child: Text(
                          lanLocale == "en" ? varitesData.nameEn.toUpperCase() : varitesData.nameMr,
                          maxLines: 2,
                          style: const TextStyle(color: Color(0XFF000000), fontSize: 14,fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios_outlined,size:20)
                ],
              ),
            )),
      ),
    );
  }

  Future getVerities() async {
    setState(() {
      _isLoading = true;
    });
    try {
      http.Response response = await http.post(Uri.parse(baseURL + ApiURL.varietyFilteredData /*+"/"+widget.cropID!*/), headers: headerParams, body: widget.varietyDetails);
      var data = json.decode(response.body);

      var res = VaritesResponse.fromJson(data);
      if (res.status == 1) {
        //setState(() {
        if (res.data.isEmpty) {
          isDataNotFound = true;
        } else {
          var dSSModel = Provider.of<DSSProvider>(context, listen: false);
          dSSModel.setVaritesList(res.data);
        }

        // });
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // //print(e.toString());
      setState(() {
        _isLoading = false;
      });
      /*WidgetUtils.errorDialog(context, 'Not_able_to_get_Menu'.tr,2);*/
    }
  }
}
