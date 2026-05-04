import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/components/widgets/base_widget.dart';
import 'package:buyer_common_code/model/BlogTypeResponse.dart';
import 'package:get/get.dart';

import '../../model/home_page_model.dart';

class BlogListScreen extends StatefulWidget {
  String? blogType;
  String? cropID;
  String? from;
  String? serviceType;

  BlogListScreen({super.key, this.blogType, this.cropID, this.from, this.serviceType = 'Normal'});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  int blogTypeSelection = 0;
  bool isDataNotFound = false;
  int page = 1;
  bool nextFlag = false;
  dynamic selectedBlogId;
  dynamic details;
  late String title;
  ValueNotifier<List<Blogs>> blogTypes = ValueNotifier([]);
  ValueNotifier<List<BlogType>> blogTypesList = ValueNotifier([]);

  @override
  void initState() {
    if (widget.serviceType == 'Normal') {
      title = 'All'.tr + " " + 'Blogs'.tr;
      getBlogType();
    } else {
      title = 'Other Services'.tr;
      getBlogs(cropId: 'ALL', blogType: widget.blogType).then((value) => setState(() {}));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseWidget(
          //  backgroundColor: ColorsConst.backgroundColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, title: title, color: Colors.white, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          child: blogTypes.value != null
              ? NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                      refreshBlog();
                    }
                    return true;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        widget.serviceType == 'Normal' ? buildBlogList() : Container(),
                        blogTypes.value.isEmpty
                            ? Center(
                                child: Text(
                                  'No Blog Available'.tr,
                                  style: const TextStyle(color: Colors.black, fontFamily: 'Graphik', fontWeight: FontWeight.w500, fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: blogTypes.value.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return blogMain(blogTypes.value[index]);
                                },
                              ),
                      ],
                    ),
                  ),
                )
              : Container()),
    );
  }

  Widget blogMain(Blogs blogData) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BlogsDetailsScreen(
                  blogData,
                  HeaderSingleton().configurationDetails!.createdBlogsUrl!,
                  categorySelected:
                      blogTypeSelection == 0 ? 'All'.tr + " " + 'Blogs'.tr : (lang == 'en' ? blogTypesList.value[blogTypeSelection - 1].name : blogTypesList.value[blogTypeSelection - 1].nameMr),
                )),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.32,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white, border: Border.all(color: const Color(0xFFCFCFCF))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.247,
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.height * 0.247,
                width: MediaQuery.of(context).size.width,
                imageUrl: HeaderSingleton().configurationDetails!.createdBlogsUrl! + "/" + (blogData.logo ?? ""),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                ),
                placeholder: (context, url) => Container(
                  child: Image.file(File(image), fit: BoxFit.fitHeight),
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Container(
                  width: 200,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: WidgetUtils.appTextWidget(context: context, title: '${blogData.blogsTitle}', overflow: TextOverflow.ellipsis, fontSize: 14.0, family: 'Graphik', fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBlogList() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      margin: const EdgeInsets.only(bottom: 28, left: 19),
      child: blogTypesList.value.isNotEmpty
          ? ListView.builder(
              itemCount: blogTypesList.value.length == 1 ? blogTypesList.value.length : blogTypesList.value.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return buildBlogItem(blogTypesList.value[index == 0 ? 0 : index - 1], index);
              },
            )
          : Container(),
    );
  }

  Widget buildBlogItem(BlogType categoryResponse, int index) {
    return GestureDetector(
      onTap: () async {
        nextFlag = false;
        if (index == 0) {
          isLoading.value = true;
          selectedBlogId = 'ALL';
          title = 'All'.tr + " " + 'Blogs'.tr;
          page = 1;
          blogTypeSelection = 0;
          await getBlogs(cropId: 'ALL', blogType: 'ALL');
          isLoading.value = false;
        } else {
          page = 1;
          blogTypeSelection = index;
          isLoading.value = true;
          selectedBlogId = categoryResponse.blogsTypesId;
          details = categoryResponse.blogsTypesId;
          title = lang == 'en' ? categoryResponse.name : categoryResponse.nameMr + " " + 'Blogs'.tr;
          blogTypes.value = [];
          await getBlogs(blogType: categoryResponse.blogsTypesId);
          isLoading.value = false;
        }
        setState(() {});
      },
      child: Container(
          height: 30,
          margin: const EdgeInsets.only(top: 14, right: 12),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: blogTypeSelection == index ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.white, border: Border.all(color: const Color(0xFFCFCFCF))),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              index == 0
                  ? Container()
                  : CachedNetworkImage(
                      imageUrl: HeaderSingleton().configurationDetails!.blogsTypesUrl! + categoryResponse.mobIcon,
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
                  title: blogTypesList.value.length == 1
                      ? lang == 'en'
                          ? categoryResponse.name
                          : categoryResponse.nameMr
                      : index == 0
                          ? 'All'.tr
                          : lang == 'en'
                              ? categoryResponse.name
                              : categoryResponse.nameMr,
                  textAlign: TextAlign.center,
                  color: blogTypeSelection == index ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
                  fontSize: 14.0,
                  family: 'Graphik',
                  fontWeight: FontWeight.w400),
            ],
          )),
    );
  }

  Future refreshBlog() async {
    List<Blogs> blogsTemp = blogTypes.value;
    if (!nextFlag) {
      isDataNotFound = false;
      page += 1;
      isLoading.value = true;
      if (widget.from == "home") {
        if (blogTypeSelection == 0) {
          details = null;
        }
        final data = await getBlogs(cropId: details ?? 'ALL', blogType: 'ALL');
        if (data.isNotEmpty) {
          for (final result in data) {
            blogsTemp.add(result);
          }
          isDataNotFound = false;
          nextFlag = false;
          blogTypes.value = blogsTemp;
        }
        isLoading.value = false;
        setState(() {});
        // title = 'All'.tr + " " + 'Blogs'.tr;
      } else {
        final data = await getBlogs();
        if (data.isNotEmpty) {
          for (final result in data) {
            blogsTemp.add(result);
          }
          blogTypes.value = blogsTemp;
          return true;
        }
        isLoading.value = false;
        setState(() {});
      }
    }
  }

  Future getBlogType() async {
    isLoading.value = true;
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getBlogType);
      final data = json.decode(response.body);
      var res = BlogTypeResponse.fromJson(data);
      if (res.status == 1) {
        if (widget.from == "home") {
          blogTypesList.value = res.data;
          await getBlogs(cropId: details ?? 'ALL', blogType: 'ALL');
        } else {
          List<BlogType> typeList = [];
          blogTypesList.value = typeList;
          for (int i = 0; i < res.data.length; i++) {
            final title = lang.toLowerCase() == 'en' ? res.data[i].name.toLowerCase() : res.data[i].nameMr.toLowerCase();
            if (widget.blogType!.toLowerCase() == title) {
              blogTypeSelection = i;
              typeList.add(res.data[i]);
              selectedBlogId = res.data[i].blogsTypesId;
              blogTypesList.value = typeList;
            }
          }
          if (typeList.isEmpty) {
            typeList.add(res.data[0]);
          }
          await getBlogs();
        }
      }
      isLoading.value = false;
      setState(() {});
    } catch (e) {
      isLoading.value = false;
      setState(() {});
    }
    return blogTypesList.value;
  }

  Future getBlogs({String? cropId = "ALL", String? blogType = 'ALL'}) async {
    List<Blogs> res = [];
    try {
      final cropIdValue = (widget.from == "home") ? cropId : widget.cropID!;
      final blogTypeValue = (widget.from == "home") ? selectedBlogId ?? blogType : selectedBlogId;
      final blogIdentity = (widget.serviceType == "Normal") ? '' : 2;
      final response = await APIService.getAPIMethod(url: ApiURL.allBlogDetails + "/${blogTypeValue!}/${page.toString()}/${cropIdValue!}/$blogIdentity");
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        if (data['data'].isNotEmpty) {
          for (final result in data['data']) {
            res.add(Blogs.fromJson(result));
          }
          blogTypes.value = res;
          isDataNotFound = true;
          isLoading.value = false;
          nextFlag = false;
        } else {
          if (data['data'].isEmpty) {
            nextFlag = true;
          }
        }
        setState(() {});
      }
    } catch (e) {
      isLoading.value = true;
      setState(() {});
    }
    return blogTypes.value.isNotEmpty ? res : blogTypes;
  }
}
