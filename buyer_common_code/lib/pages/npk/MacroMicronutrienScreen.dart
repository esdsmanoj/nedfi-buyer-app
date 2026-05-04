import 'package:buyer_common_code/model/MacroMicronutrientCal.dart';
import 'package:get/get.dart';
import 'package:buyer_common_code/app_imports.dart';

class MacroMicronutrienScreen extends StatefulWidget {
  String? nutrition_management, btn_submit, n, p, k, s, i, m, z, c, b, area, areaunit, banket, cropType, landArea, type;

  MacroMicronutrienScreen(
      {super.key, this.nutrition_management,
      this.btn_submit,
      this.n,
      this.p,
      this.k,
      this.s,
      this.i,
      this.m,
      this.z,
      this.c,
      this.b,
      this.area,
      this.areaunit,
      this.banket,
      this.cropType,
      this.landArea,
      this.type});

  @override
  _MacroMicronutrienScreenState createState() => _MacroMicronutrienScreenState();
}

class _MacroMicronutrienScreenState extends State<MacroMicronutrienScreen> {
  var _isLoading = false;
  List<DayWiseMultiplicationFactor> dayWiseList = [];

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CustomProgressHandler(
      loadingText: '',
      isLoading: _isLoading,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(elevation:0,
            centerTitle: true,
            backgroundColor: const Color(0xff27914F),
            iconTheme: const IconThemeData(color: Colors.white),
            title: WidgetUtils.appTextWidget(context:context,title: 'Macro Micronutrient'.tr, color: Colors.white, fontSize: 18),
          ),
          body: Container(
            child: ListView.builder(
              itemCount: dayWiseList.length,
              itemBuilder: (BuildContext context, int index) {
                return macroMicronutrient(dayWiseList[index]);
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            ),
          )),
    ));
  }

  macroMicronutrient(DayWiseMultiplicationFactor data) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 200,
                        child: WidgetUtils.appTextWidget(context:context,
                            title: "Day " + data.days.toString(), overflow: TextOverflow.ellipsis, textAlign: TextAlign.left, fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18.0)),
                    Container(
                        height: 30,
                        width: 140,
                        child: CustomDarkButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NPKListScreen(
                                            cropType: widget.cropType,
                                            landArea: widget.landArea,
                                            type: widget.type,
                                            n: data.n,
                                            p: data.p,
                                            k: data.k,
                                            s: data.s,
                                          )));
                            },
                            caption: 'Calculate'.tr))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetUtils.appTextWidget(context:context,title: "Nitrogen (N) ", textAlign: TextAlign.center, color: Colors.grey, fontSize: 15.0),
                            WidgetUtils.appTextWidget(context:context,
                                title: double.parse(data.n ?? "0").toStringAsFixed(2), textAlign: TextAlign.center, fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15.0),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetUtils.appTextWidget(context:context,title: "Potassium (K) ", textAlign: TextAlign.center, color: Colors.grey, fontSize: 15.0),
                            WidgetUtils.appTextWidget(context:context,
                                title: double.parse(data.k ?? "").toStringAsFixed(2), textAlign: TextAlign.center, fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetUtils.appTextWidget(context:context,title: "Phosphors (P) ", textAlign: TextAlign.center, color: Colors.grey, fontSize: 15.0),
                            WidgetUtils.appTextWidget(context:context,
                                title: double.parse(data.p ?? "0").toStringAsFixed(2), textAlign: TextAlign.center, fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15.0),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetUtils.appTextWidget(context:context,title: "Sulphur (S) ", textAlign: TextAlign.center, color: Colors.grey, fontSize: 15.0),
                            WidgetUtils.appTextWidget(context:context,
                                title: double.parse(data.s ?? "0").toStringAsFixed(2), textAlign: TextAlign.center, fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      late var params;
      if (widget.banket == "1") {
        params = {
          "nutrition_management": widget.nutrition_management ?? "",
          "btn_submit": "submit",
          "n": widget.n ?? "",
          "p": widget.p ?? "",
          "k": widget.k ?? "",
          "s": widget.s ?? "",
          "i": widget.i ?? "",
          "m": widget.m ?? "",
          "z": widget.z ?? "",
          "c": widget.c ?? "",
          "b": widget.b ?? "",
          "area": widget.landArea,
          "areaunit": widget.type,
          "banket": widget.banket
        };
      } else {
        params = {
          "nutrition_management": widget.nutrition_management ?? "",
          "btn_submit": "submit",
          "n": widget.n ?? "",
          "p": widget.p ?? "",
          "k": widget.k ?? "",
          "s": widget.s ?? "",
          "i": widget.i ?? "",
          "m": widget.m ?? "",
          "z": widget.z ?? "",
          "c": widget.c ?? "",
          "b": widget.b ?? "",
          "area": widget.landArea,
          "areaunit": widget.type
        };
      }

      final response = await APIService.postAPIMethod(url: ApiURL.macro_micronutrient_cal, params: params);
      var data = json.decode(response.body);
      // //print(data);
      // //print(baseURL + ApiURL.macro_micronutrient_cal);
      // //print(data);
      var res = MacroMicronutrientCal.fromJson(data);
      if (res.status == 1) {
        dayWiseList = res.data.dayWiseMultiplicationFactor;
        setState(() {});
      } else {}

      setState(() {
        _isLoading = false;
      });
    } on SocketException {
      /* WidgetUtils.errorDialog(context,
          AppTranslations.of(context)?.text("key_connection_lost") ??'key_connection_lost'.tr,2);*/
    } catch (e) {
      // //print(e.toString());
      setState(() {
        _isLoading = false;
      });
      /*WidgetUtils.errorDialog(context, 'Not_able_to_get_Menu'.tr,2);*/
    }
  }
}
