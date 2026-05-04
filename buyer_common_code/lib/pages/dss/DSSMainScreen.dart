import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/components/widgets/base_widget.dart';
import 'package:get/get.dart';

import '../../model/DSSCropResponse.dart';
import 'nutrition_management/NutritionMgmtMenuScreen.dart';

class DSSMainScreen extends StatefulWidget {
  AllCrops? dssCropData;
  MyCrops? dssMyCrops;
  String? image;

  DSSMainScreen({Key? key, this.image, this.dssCropData, this.dssMyCrops}) : super(key: key);

  @override
  _DSSMainScreenState createState() => _DSSMainScreenState();
}

class _DSSMainScreenState extends State<DSSMainScreen> {
  Size? size;

  final iosAppBarRGBAColor = TextEditingController(text: "#0080FF80");

  @override
  void initState() {
    super.initState();
    // fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DSSProvider>(builder: (context, dSSModel, child) {
      return BaseWidget(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, title: 'DSS Menu'.tr, color: Colors.white, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 125,
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    color: const Color(0xffE7F3EB),
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        Container(
                          height: 70,
                          width: 70,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              "${HeaderSingleton().configurationDetails!.cropImageUrl}/${widget.dssCropData != null ? widget.dssCropData!.mobIcon : widget.dssMyCrops!.logo}",
                            ),
                            onBackgroundImageError: (obj, stc) => Image.file(File(image), fit: BoxFit.cover, height: 70, width: 70),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        SizedBox(
                            height: 25,
                            width: 200,
                            child: WidgetUtils.appTextWidget(
                                context: context,
                                textAlign: TextAlign.center,
                                title: "${widget.dssCropData != null ? widget.dssCropData!.name! : widget.dssMyCrops!.name!}",
                                color: Colors.black,
                                family: 'Graphik',
                                fontWeight: FontWeight.w500,
                                fontSize: 14)),
                      ],
                    )),
                buildDSSMenu(dSSModel)
              ],
            ),
          ));
    });
  }

  Widget buildDSSMenu(DSSProvider dssModel) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: GridView.builder(
            itemCount: HeaderSingleton().bottomMenu.value!.data!.dssMenu!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
              mainAxisExtent: 104,
            ),
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {
                  if (HeaderSingleton().bottomMenu.value!.data!.dssMenu![index].mapKey!.toLowerCase() == 'farm') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FarmListScreen(dssCropData: widget.dssCropData)));
                  } /*else if (HeaderSingleton().bottomMenu.value!.data!.dssMenu![index].mapKey!.toLowerCase() == 'cropcalender') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectDateScreen(
                                  cropID: widget.dssCropData != null ? widget.dssCropData!.cropId : widget.dssMyCrops!.cropId!,
                                  from: "dss",
                                  cropName: widget.dssCropData != null ? widget.dssCropData!.name! : widget.dssMyCrops!.name,
                                  image: HeaderSingleton().configurationDetails!.cropImageUrl! + "/" + (widget.dssCropData != null ? widget.dssCropData!.mobIcon! : widget.dssMyCrops!.logo!),
                                )));
                  } */
                  else if (HeaderSingleton().bottomMenu.value!.data!.dssMenu![index].mapKey!.toLowerCase() == 'cropmanual') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlogListScreen(
                                  cropID: widget.dssCropData != null ? widget.dssCropData!.cropId : widget.dssMyCrops!.cropId!,
                                  from: "dss",
                                  blogType: HeaderSingleton().bottomMenu.value!.data!.dssMenu![index].title!,
                                )));
                  } else if (HeaderSingleton().bottomMenu.value!.data!.dssMenu![index].mapKey!.toLowerCase() == 'nutrientmanagement') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NutritionMgmtMenuScreen(
                                  cropID: widget.dssCropData != null ? widget.dssCropData!.cropId : widget.dssMyCrops!.cropId,
                                  cropName: widget.dssCropData != null ? widget.dssCropData!.name! : widget.dssMyCrops!.name,
                                  from: "dss",
                                  n: widget.dssCropData != null ? widget.dssCropData!.n : widget.dssMyCrops!.n,
                                  p: widget.dssCropData != null ? widget.dssCropData!.p : widget.dssMyCrops!.p,
                                  k: widget.dssCropData != null ? widget.dssCropData!.k : widget.dssMyCrops!.k,
                                  s: widget.dssCropData != null ? widget.dssCropData!.s : widget.dssMyCrops!.s,
                                  image: HeaderSingleton().configurationDetails!.cropImageUrl! + "/" + (widget.dssCropData != null ? widget.dssCropData!.mobIcon! : widget.dssMyCrops!.logo!),
                                )));
                  } else if (HeaderSingleton().bottomMenu.value!.data!.dssMenu![index].mapKey!.toLowerCase() == 'varieties') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VarietyMasterScreen(
                                  cropID: widget.dssCropData != null ? widget.dssCropData!.cropId : widget.dssMyCrops!.cropId!,
                                  from: "dss",
                                  cropName: widget.dssCropData != null ? widget.dssCropData!.name! : widget.dssMyCrops!.name,
                                )));
                  } else if (HeaderSingleton().bottomMenu.value!.data!.dssMenu![index].mapKey!.toLowerCase() == 'pest&amp;disease') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CropDiseaseScreen(
                                  logo: widget.dssCropData != null ? widget.dssCropData!.mobIcon! : widget.dssMyCrops!.logo!,
                                  cropID: widget.dssCropData != null ? widget.dssCropData!.cropId : widget.dssMyCrops!.cropId!,
                                  cropName: widget.dssCropData != null ? widget.dssCropData!.name! : widget.dssMyCrops!.name,
                                  title: HeaderSingleton().bottomMenu.value!.data!.dssMenu![index].title!,
                                  from: "",
                                )));
                  }
                },
                child: Container(
                  // height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 10),
                        child: SvgPicture.network(HeaderSingleton().bottomMenu.value!.data!.dssMenu![index].icon!,
                            placeholderBuilder: (ctx) => Image.file(File(image), fit: BoxFit.cover, height: 48, width: 48),
                            color: Color(int.parse(themeColor.value.iconColor!.color!)),
                            height: 48,
                            width: 48),
                      ),
                      Container(
                          height: 30,
                          // padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: WidgetUtils.appTextWidget(
                              context: context,
                              title: HeaderSingleton().bottomMenu.value!.data!.dssMenu![index].title!,
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              family: 'Graphik'),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(int.parse(themeColor.value.barColor!.color!)), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))))
                    ],
                  ),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.grey.shade200, blurRadius: 2, spreadRadius: 0.2),
                  ], borderRadius: BorderRadius.circular(16)),
                ),
              );
            }) //catagory(dSSSModel)
        );
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }
}
