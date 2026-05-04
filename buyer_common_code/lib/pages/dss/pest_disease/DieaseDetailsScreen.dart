import 'package:buyer_common_code/app_imports.dart';
import 'package:get/get.dart';

import '../../../components/image_previewer.dart';

class DiseaseDetailsScreen extends StatefulWidget {
  String? cropID, from, cropName, componentId, diseaseID;
  DiseaseData? diseaseDetailsScreen;

  DiseaseDetailsScreen({Key? key, this.cropID, this.from, this.cropName, this.componentId, this.diseaseID, this.diseaseDetailsScreen}) : super(key: key);

  @override
  _DiseaseDetailsScreenState createState() => _DiseaseDetailsScreenState();
}

class _DiseaseDetailsScreenState extends State<DiseaseDetailsScreen> {
  var unescape = HtmlUnescape();
  String imagePath = "";

  @override
  void initState() {
    super.initState();
    imagePath = widget.diseaseDetailsScreen!.iconImg!;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DSSProvider>(builder: (context, dSSModel, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title:
                WidgetUtils.appTextWidget(context: context, title: widget.diseaseDetailsScreen?.diseaseName ?? "", color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500, family: 'Graphik'),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => ImagePreviewer(urlImage: imagePath)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  ),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Image.file(File(image), fit: BoxFit.contain, height: 58, width: 58),
                    errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.contain, height: 58, width: 58),
                    imageBuilder: (context, imageProvider) => Container(
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)))),
                    fit: BoxFit.cover,
                    imageUrl: imagePath,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(children: [
                    // Text(
                    //   widget.dieaseDetailsScreen!.diseaseName!,
                    //   style: const TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 20.0,
                    //     fontFamily: 'Graphik',
                    //     fontWeight: FontWeight.w500
                    //   ),
                    // ),
                    const SizedBox(height: 30),
                    Text(
                      'Related Images'.tr,
                      style: const TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.diseaseDetailsScreen!.images!.length,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: () => setState(() => imagePath = widget.diseaseDetailsScreen!.images![index]),
                              child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                                  width: 150,
                                  height: MediaQuery.of(context).size.height * 0.09,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover, height: 58, width: 58),
                                        errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover, height: 58, width: 58),
                                        imageBuilder: (context, imageProvider) => Container(
                                            height: 58,
                                            width: 58,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)))),
                                        fit: BoxFit.cover,
                                        imageUrl: widget.diseaseDetailsScreen!.images![index],
                                      ),
                                    ),
                                  )),
                            );
                          }),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    widget.diseaseDetailsScreen!.textData != null
                        ? SingleChildScrollView(
                            child: ListView.builder(
                                itemCount: widget.diseaseDetailsScreen!.textData!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.green.shade300)),
                                      child: ExpansionTile(
                                          tilePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                          backgroundColor: Colors.grey.shade100,
                                          expandedAlignment: Alignment.centerLeft,
                                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                          textColor: Colors.black,
                                          childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                                          title: WidgetUtils.appTextWidget(
                                            context: context,
                                            title: widget.diseaseDetailsScreen!.textData![index].title!,
                                            fontSize: 14,
                                            family: 'Graphik',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          initiallyExpanded: false,
                                          children: [
                                            widget.diseaseDetailsScreen!.textData![index].details != null
                                                ? Html(
                                                    data: unescape.convert(widget.diseaseDetailsScreen!.textData![index].details ?? ""),
                                                    style: {
                                                      'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                      'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                      'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                      "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
                                                      "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
                                                    },
                                                  )
                                                : Center(
                                                    child: WidgetUtils.appTextWidget(
                                                        context: context, title: 'No data found'.tr, color: Colors.black, fontSize: 14, family: 'Graphik', fontWeight: FontWeight.w500))
                                          ]),
                                    ),
                                  );
                                }),
                          )
                        : Container(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
