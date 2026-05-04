import 'package:get/get.dart';

import 'package:buyer_common_code/app_imports.dart';

class PestDiseaseScreen extends StatefulWidget {
  String? cropID, from, cropName;
  final String title;

  PestDiseaseScreen({super.key, this.cropID, this.from, this.cropName, required this.title});

  @override
  _PestDiseaseScreenState createState() => _PestDiseaseScreenState();
}

class _PestDiseaseScreenState extends State<PestDiseaseScreen> {
  bool? isLoading = false, _serviceEnabled;
  String loadingText = 'Loading..';
  bool? _isLoading, _large, _medium;
  double? _pixelRatio, bottom1;
  Size? size;
  String? _loadingText;
  final iosAppBarRGBAColor = TextEditingController(text: "#0080FF80");
  File? imageFileOne;
  bool isDataNotFound = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _loadingText = 'Loading . . .';
    getComponent();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var scrWidth = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(scrWidth, _pixelRatio!);
    _medium = ResponsiveWidget.isScreenMedium(scrWidth, _pixelRatio!);
    return Consumer<DSSProvider>(builder: (context, dSSModel, child) {
      return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(elevation:0,
              centerTitle: true,
              backgroundColor: const Color(0xff27914F),
              title: WidgetUtils.appTextWidget(context:context,title: 'Pest Disease'.tr, color: Colors.white, fontSize: 18),

              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: CustomProgressHandler(
              isLoading: _isLoading!,
              loadingText: _loadingText!,
              child: SafeArea(
                  child: Scaffold( backgroundColor: Colors.white,
                     //  backgroundColor: ColorsConst.backgroundColor,
                      body: Column(
                        children: [
                          const SizedBox(height: 20),
                          isDataNotFound
                              ? Container()
                              : Text(
                                  'Select crop component'.tr,
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                          dSSModel.pestDiseaseList.isEmpty
                              ? Center(
                                  child: Text(
                                    'No Data Available'.tr,
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                                    textAlign: TextAlign.left,
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: dSSModel.pestDiseaseList.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return categoryItem(dSSModel.pestDiseaseList[index], index);
                                    },
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.7, crossAxisSpacing: 10, mainAxisSpacing: 2, crossAxisCount: 3),
                                  ),
                                ),
                        ],
                      ))),
            )),
      );
    });
  }

  Widget categoryItem(PestDiseaseData catagoryResponse, int index) {
    var homeDashboardModel = Provider.of<HomeDashboardProvider>(context, listen: false);
    return InkWell(
        onTap: () {},
        child: InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => CropDiseaseScreen(cropID: widget.cropID, componentId: catagoryResponse.cropComponent, cropName: widget.cropName, from: "dss", title: widget.title)));
            },
            child: SizedBox(
              height: (MediaQuery.of(context).size.height * 0.18),
              width: double.maxFinite,
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.height * 0.15,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff27914F)),
                      borderRadius: BorderRadius.circular(17),
                      color: Colors.white,
                    ),
                    child: CachedNetworkImage(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.height * 0.1,
                      fit: BoxFit.fill,
                      imageUrl: catagoryResponse.componentImg,
                      imageBuilder: (context, imageProvider) => Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                        ),
                      ),
                      placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: 80,
                      height: MediaQuery.of(context).size.height * 0.036,
                      child: WidgetUtils.appTextWidget(context:context,
                          title: catagoryResponse.title.capitalize!,
                          family: 'Graphik',
                          fontSize: 12,
                          softWrap: true,
                          color: const Color(0xff3F3F3F),
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center),
                    ),
                  )
                ],
              ),
            )));
  }

  Future getComponent() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> params1 = {"crop_id": widget.cropID};
      final response = await APIService.postAPIMethod(url: ApiURL.getCropComponent, params: params1);
      final data = json.decode(response.body);
      // //print(PestDiseaseResponse.fromJson(data).toJson());
      var res = PestDiseaseResponse.fromJson(data);
      if (res.status == 1) {
        if (res.data.isEmpty) {
          setState(() {
            isDataNotFound = true;
          });
        } else {
          var dSSModel = Provider.of<DSSProvider>(context, listen: false);
          dSSModel.setPestDiseaseList(res.data);
        }
      } else {
        setState(() {
          isDataNotFound = true;
        });
        WidgetUtils.informationDialog(context, 'Not_able_to_get_Menu'.tr);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e, stacktrace) {
      // //print(e.toString());
      // //print(stacktrace);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
