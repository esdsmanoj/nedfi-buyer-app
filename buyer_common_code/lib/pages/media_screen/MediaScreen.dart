import 'package:buyer_common_code/model/media_type_model.dart';
import 'package:get/get.dart';
import '../../model/MediaResponse.dart';
import '../../model/home_page_model.dart';
import 'package:buyer_common_code/app_imports.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  late String _loadingText, baseUrl;
  int page = 1;
  ValueNotifier<List<MediaData>> mediaList = ValueNotifier([]);
  List<MediaData> tempMediaList = [];
  ValueNotifier<List<Featured>> featureList = ValueNotifier([]);
  TextEditingController searchController = TextEditingController();
  ValueNotifier<List<MediaTypeData>> mediaTypes = ValueNotifier([]);
  ValueNotifier<int> selectedIndex = ValueNotifier(0);
  bool nextFlag = false, isTabsLoaded = false, isScrolled = false;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadingText = 'Loading . . .';
    getMediaList(0, page);
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (!isScrolled) {
          isScrolled = true;
          page = page + 1;
          isLoading.value = true;
          // mediaList.value.clear();
          tempMediaList.clear();
          if (selectedIndex.value == 0) {
            // mediaList.value.clear();
            getMediaList(0, page).then((value) {
              setState(() {});
            });
            isLoading.value = false;
          } else {
            getMediaList(selectedIndex.value - 1, page).then((value) {
              setState(() {});
            });
            isLoading.value = false;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xFFF3F7F9),
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(context: context, title: 'Media'.tr, color: Colors.white, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
              leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
            ),
            body: CustomProgressHandler(
              isLoading: isLoading.value,
              loadingText: _loadingText,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  // child: NotificationListener<ScrollNotification>(
                  //     onNotification: (scrollNotification) {
                  //
                  //       return true;
                  //     },
                  //     child:
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // physics: const NeverScrollableScrollPhysics(),
                    children: [
                     // buildMediaTypes(),
                      // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      featureList.value.isNotEmpty && mediaList.value.isNotEmpty ? buildMediaList() : Container(),
                      mediaList.value.isNotEmpty
                          ? WidgetUtils.appTextWidget(
                              context: context, title: "Recommended Videos".tr, fontWeight: FontWeight.w500, family: "Graphik", fontSize: 20, overflow: TextOverflow.ellipsis, softWrap: true)
                          : Container(),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      Expanded(child: featureList.value.isNotEmpty ? buildMediaTypeList() : Container())
                    ],
                  )),
              // )),
            )));
  }

  Widget buildMediaList() {
    return Container(
      // height: 300,
      margin: const EdgeInsets.only(bottom:24,top:23),
      child: ValueListenableBuilder(
          valueListenable: featureList,
          builder: (ctx, List<Featured> value, child) {
            return value.isNotEmpty
                ? SizedBox(height:310,
                  child: ListView.builder(
                      itemCount: value.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (listCtx, index) {
                        late String elapse;
                        if (value[index].publishedOn != null) {
                          DateTime dateTime = DateTime.parse(value[index].publishedOn!);
                          elapse = getTimePassed(dateTime, full: true);
                        }
                        return GestureDetector(
                          onTap: () {
                            Media mediaData = Media(
                                urlType: value[index].urlType,
                                url: value[index].url,
                                isHome: value[index].isHome,
                                description: value[index].description,
                                title: value[index].title,
                                partnerId: value[index].partnerId,
                                publishedOn: value[index].publishedOn,
                                viewCount: value[index].viewCount,
                                isFeatured: value[index].isFeatured,
                                thumbnails: value[index].thumbnails,
                                category: value[index].category);
                            Navigator.push(context, MaterialPageRoute(builder: (ctxBuilder) => MediaDetailsScreen(mediaData, baseUrl)));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: baseUrl + (value[index].thumbnails ?? ''),
                                    imageBuilder: (context, imageProvider) => Container(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width - 40,
                                      margin: const EdgeInsets.only(right: 17),
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(4),
                                        color: Colors.grey.shade100,
                                        image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        Image.file(File(image), fit: BoxFit.fill, height: 200, width: MediaQuery.of(context).size.width - 40,),
                                    errorWidget: (context, url, error) =>
                                        Image.file(File(image), fit: BoxFit.fill, height: 200, width: MediaQuery.of(context).size.width - 40,),
                                  ),
                                  Container(color: Colors.transparent, padding: const EdgeInsets.all(8), child: SvgPicture.asset("assets/images/youtube.svg",height:50))
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  width: MediaQuery.of(context).size.width * 0.88,
                                  child: WidgetUtils.appTextWidget(
                                      context: context, title: value[index].title!, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16, overflow: TextOverflow.ellipsis, softWrap: true)),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                width: MediaQuery.of(context).size.width * 0.88,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        decoration:
                                            BoxDecoration(border: Border.all(color: const Color(0xfff3f3f3)), color: Colors.grey.shade200, borderRadius: const BorderRadius.all(Radius.circular(10))),
                                        padding: const EdgeInsets.all(10),
                                        child: WidgetUtils.appTextWidget(
                                            context: context,
                                            title: (value[index].viewCount ?? "0") + " Views",
                                            fontWeight: FontWeight.w400,
                                            family: 'Graphik',
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true)),
                                    Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color: const Color(0xfff3f3f3)), color: const Color(0xfff3f3f3), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                        padding: const EdgeInsets.all(10),
                                        child: WidgetUtils.appTextWidget(
                                            context: context,
                                            title: elapse != null ? elapse.split(',').first + " ago" : 'unknown',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10,
                                            family: 'Graphik',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                )
                : Center(
                    child: WidgetUtils.appTextWidget(context: context, title: 'No Data Available'),
                  );
          }),
    );
  }

  Widget buildMediaTypeList() {
    return ValueListenableBuilder(
        valueListenable: mediaList,
        builder: (ctx, List<MediaData> featuredValue, child) {
          return featuredValue.isNotEmpty
              ? GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: featuredValue.length,
                  shrinkWrap: true,
                  controller: controller,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 16 / 12, crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
                  itemBuilder: (ctx, index) {
                    return InkWell(
                        onTap: () {
                          Media mediaData = Media(
                              urlType: featuredValue[index].urlType,
                              url: featuredValue[index].url,
                              isHome: featuredValue[index].isHome,
                              description: featuredValue[index].description,
                              title: featuredValue[index].title,
                              partnerId: featuredValue[index].partnerId,
                              publishedOn: featuredValue[index].publishedOn,
                              viewCount: featuredValue[index].viewCount,
                              isFeatured: featuredValue[index].isFeatured,
                              thumbnails: featuredValue[index].thumbnails,
                              category: featuredValue[index].category);
                          Navigator.push(context, MaterialPageRoute(builder: (ctxBuilder) => MediaDetailsScreen(mediaData, baseUrl)));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                          child: CachedNetworkImage(
                            imageUrl: baseUrl + (featuredValue[index].thumbnails ?? ''),
                            imageBuilder: (context, imageProvider) => Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                              ),
                            ),
                            placeholder: (context, url) => Image.file(
                              File(image),
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.3,
                            ),
                            errorWidget: (context, url, error) => Image.file(
                              File(image),
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.3,
                            ),
                          ),
                        ));
                  })
              : Center(
                  child: WidgetUtils.appTextWidget(context: context, title: 'No data found'.tr),
                );
        });
  }

  Widget buildMediaTypes() {
    return ValueListenableBuilder(
      valueListenable: mediaTypes,
      builder: (BuildContext context, List<MediaTypeData> value, Widget? child) {
        return value.isNotEmpty
            ? Container(
          height: MediaQuery.of(context).size.height * 0.08,

                child: ListView.builder(
                    itemCount: value.length + 1,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      // //print(index != 0 ? HeaderModel().configurationDetails!.mediaTypesUrl! + value[index - 1].mobIcon : "0");
                      return GestureDetector(
                        onTap: () async {
                          selectedIndex.value = index;
                          tempMediaList.clear();
                          mediaList.value.clear();
                          page = 1;
                          if (index == 0) {
                            await getMediaList(0, page).then((value) => setState(() {
                                  controller.jumpTo(0);
                                }));
                          } else {
                            getMediaList(int.parse(value[index - 1].mediaTypesId!), page).then((value) => setState(() {
                                  controller.jumpTo(0);
                                }));
                          }
                          // setState(() {});
                        },
                        child: Container(
                            height: 30,
                            margin: const EdgeInsets.only(top: 14, right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: selectedIndex.value == index ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.white, border: Border.all(color: const Color(0xFFCFCFCF))),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                index == 0
                                    ? Container()
                                    : CachedNetworkImage(
                                  imageUrl: HeaderSingleton().configurationDetails!.mediaTypesUrl! + (value[index - 1].mobIcon ?? ''),
                                  imageBuilder: (context, imageProvider) => Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                                  ),
                                  placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover, height: 15, width: 15),
                                  errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover, height: 15, width: 15),
                                ),
                                index == 0 ? Container() : const SizedBox(width: 10),
                                WidgetUtils.appTextWidget(
                                    context: context,
                                    title: index == 0 ? 'All' : value[index - 1].name!,
                                    textAlign: TextAlign.center,
                                    fontSize: 14.0,
                                    family: 'Graphik',
                                    fontWeight: FontWeight.w400),
                              ],
                            ))
                      );
                    }),
              )
            : Container();
      },
    );
  }

  Future getMediaList(int? type, int? pageIndex) async {
    isLoading.value = true;
    try {
      if (!isTabsLoaded) {
        await getMediaTypes();
        isTabsLoaded = true;
      }
      final response = await APIService.postAPIMethod(url: ApiURL.getMediaList, params: {'media_type': type!.toString(), 'page': pageIndex!.toString()});
      final data = json.decode(response.body);
      final res = MediaList.fromJson(data);
      // //print("Media:$data");
      if (data['status'] == 1) {
        isScrolled = false;
        baseUrl = res.baseUrl!;
        for (final mediaDetails in res.data!) {
          tempMediaList.add(mediaDetails);
        }
        mediaList.value.addAll(tempMediaList);
        featureList.value = res.featured!;
      } else {
        // WidgetUtils.informationDialog(context, data['msg']);
      }

      isLoading.value = false;
      setState(() {});
    } catch (e) {
      // //print(e.toString());
      isLoading.value = false;
    }
  }

  Future getMediaTypes() async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.getMediaListType, params: {});
      final data = json.decode(response.body);
      // // //print(MediaResponse.fromJson(data).toJson());
      final res = MediaListType.fromJson(data);
      if (res.success == 1) {
        mediaTypes.value = res.data!;
      }
    } catch (e) {
      // //print(e.toString());
      isLoading.value = false;
      rethrow;
    }
  }

  String getTimePassed(DateTime datetime, {bool full = true}) {
    DateTime now = DateTime.now();
    DateTime ago = datetime;
    Duration dur = now.difference(ago);
    int days = dur.inDays;
    int years = days ~/ 365;
    int months = (days - (years * 365)) ~/ 30;
    int weeks = (days - (years * 365 + months * 30)) ~/ 7;
    int rdays = days - (years * 365 + months * 30 + weeks * 7).toInt();
    int hours = (dur.inHours % 24).toInt();
    int minutes = (dur.inMinutes % 60).toInt();
    int seconds = (dur.inSeconds % 60).toInt();
    var diff = {"d": rdays, "w": weeks, "m": months, "y": years, "s": seconds, "i": minutes, "h": hours};

    Map str = {
      'y': 'year',
      'm': 'month',
      'w': 'week',
      'd': 'day',
      'h': 'hour',
      'i': 'minute',
      's': 'second',
    };

    str.forEach((k, v) {
      if (diff[k]! > 0) {
        str[k] = diff[k].toString() + ' ' + v.toString() + (diff[k]! > 1 ? 's' : '');
      } else {
        str[k] = "";
      }
    });
    str.removeWhere((index, ele) => ele == "");
    List<String> tlist = [];
    str.forEach((k, v) {
      tlist.add(v);
    });
    if (full) {
      return str.isNotEmpty ? tlist.join(", ") + " ago" : "Just Now";
    } else {
      return str.isNotEmpty ? tlist[0] + " ago" : "Just Now";
    }
  }
}
