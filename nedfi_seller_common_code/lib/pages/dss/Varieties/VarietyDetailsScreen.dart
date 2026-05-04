import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:nedfi_seller_common_code/components/widgets/base_widget.dart';
import 'package:get/get.dart';

import '../../../components/image_previewer.dart';

class VarietyDetailsScreen extends StatefulWidget {
  String? cropID, from, cropName;
  VaritesData? veritiesData;

  VarietyDetailsScreen({Key? key, this.cropID, this.from, this.cropName, this.veritiesData}) : super(key: key);

  @override
  _VarietyDetailsScreenState createState() => _VarietyDetailsScreenState();
}

class _VarietyDetailsScreenState extends State<VarietyDetailsScreen> with SingleTickerProviderStateMixin {
  late final double? elevation = 3.0;
  bool isDataNotFound = false;
  var unescape = HtmlUnescape();

  List<Widget> myTabs = [
    Tab(text: 'Pictures'.tr),
    Tab(text: 'Characteristics'.tr),
    // Tab(text: 'Traits'.tr),
    // Tab(text: 'Other Information'.tr),
  ];

  List<Widget> _pagerList = [];
  List<String> _imageList = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // getVarites();
    _imageList = widget.veritiesData!.cropVarietyIcon.split(",");
    _tabController = TabController(vsync: this, length: myTabs.length);
    _pagerList = [
      _images(),
      _htmlText(widget.veritiesData!.characteristics),
      // _htmlText(widget.varitesData!.traits), _htmlText(widget.varitesData!.otherInformantion)
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DSSProvider>(//                    <--- Consumer
        builder: (context, dSSModel, child) {
      return BaseWidget(
          appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(
                  context: context,
                  title: lanLocale == "en"
                      ? widget.veritiesData!.nameEn
                      : lanLocale == "mr"
                          ? widget.veritiesData!.nameMr
                          : widget.veritiesData!.nameHi,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              iconTheme: const IconThemeData(color: Colors.white)),
          child: isDataNotFound
              ? Center(
                  child: Text('No Variety Available'.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14), textAlign: TextAlign.left),
                )
              : Scaffold( backgroundColor: Colors.white,
                  appBar: TabBar(labelColor: Color(int.parse(themeColor.value.textColor!.color!)), controller: _tabController, tabs: myTabs),
                  body: TabBarView(controller: _tabController, children: _pagerList)));
    });
  }

  _htmlText(String text) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: text.isNotEmpty
            ? Html(
                data: unescape.convert(text),
                style: {"body": Style(fontSize:  FontSize(16), letterSpacing: 0.0, fontWeight: FontWeight.w400, fontFamily: 'Graphik')},
              )
            : Text("No Data Found".tr),
      ),
    );
  }

  _images() {
    return Container(
      child: GridView.builder(
        itemCount: _imageList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return catagoryItem(_imageList[index], index);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1.0, crossAxisSpacing: 2, mainAxisSpacing: 2, crossAxisCount: 2),
      ),
    );
  }

  catagoryItem(String urlImage, int index) {
    return Container(
      height: 150,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => ImagePreviewer(urlImage: HeaderSingleton().configurationDetails!.cropVerityImgUrl! + "/" + urlImage)));
              },
              child: Column(
                children: [
                  Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: const Color(0xfff5f5f5),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            imageUrl: HeaderSingleton().configurationDetails!.cropVerityImgUrl! + "/" + urlImage,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              child: Image.file(File(image), fit: BoxFit.fill),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              child: Image.file(File(image)),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ))),
    );
  }
}
