import 'package:buyer_common_code/app_imports.dart';

import '../../model/home_page_model.dart';

class BlogsDetailsScreen extends StatefulWidget {
  Blogs blogData;
  String baseUrl;
  final String categorySelected;

  BlogsDetailsScreen(this.blogData, this.baseUrl, {Key? key, required this.categorySelected}) : super(key: key);

  @override
  State<BlogsDetailsScreen> createState() => _BlogsDetailsScreenState();
}

class _BlogsDetailsScreenState extends State<BlogsDetailsScreen> {
  var unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    getBlogDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BlogsProvider>(builder: (context, blogsModel, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(
                context: context, title: widget.categorySelected, color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis, family: 'Graphik'),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),
                        child: Hero(
                          tag: "widget.destination.imageUrl",
                          child: FadeInImage.assetNetwork(
                              height: MediaQuery.of(context).size.height * 0.3,
                              imageErrorBuilder: (ctx, obj, st) => Image.file(File(imgPlaceHolder), fit: BoxFit.fill, height: 200, width: 200),
                              placeholder: ApiURL.imgPlaceHolder,
                              image: widget.baseUrl + "/" + widget.blogData.logo!,
                              fit: BoxFit.fill),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          widget.blogData.blogsTitle!,
                          maxLines: 3,
                          style: const TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'Graphik', fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width, child: _htmlText(blogsModel.blogDetailsList.isNotEmpty ? blogsModel.blogDetailsList[0].blogsDescription : "")),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _htmlText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Html(
        shrinkWrap: true,
        data: unescape.convert(text),
        style: {
          'h1': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
          'h2': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
          'h3': Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
          "body": Style(fontFamily: 'Graphik', fontWeight: FontWeight.w400, fontSize: FontSize(14), letterSpacing: 0.0),
          "table": Style(backgroundColor: Colors.white, fontFamily: 'Graphik'),
          "tr": Style(border: Border.all(color: Colors.black), fontFamily: 'Graphik', fontWeight: FontWeight.w400),
          "th": Style(border: Border.all(color: Colors.black), fontFamily: 'Graphik', fontWeight: FontWeight.w400),
          // "td": Style(padding: EdgeInsets.all(2), border: Border.all(color: Colors.black), fontFamily: 'Graphik', fontWeight: FontWeight.w400),
        },
       /* onLinkTap: (value, ctx, mapValues, element) {
          launchURL(url: value.toString().substring(2, value.toString().length - 2));
        },*/
        /*customRender: {
          "table": (context, child) {
            return SingleChildScrollView(scrollDirection: Axis.horizontal, child: (context.tree as TableLayoutElement).toWidget(context));
          }
        },*/
      ),
    );
  }

  Future getBlogDetails() async {
    isLoading.value = true;
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getBlogDetails + "/" + widget.blogData.blogsId!);
      final res = BlogDetailsResponse.fromJson(json.decode(response.body));
      if (res.status == 1) {
        var homeDashboardModel = Provider.of<BlogsProvider>(context, listen: false);
        homeDashboardModel.setBlogDetailsList(res.data);
        homeDashboardModel.setSimilerBlogDetailsList(res.similarBlogs);
      }
      isLoading.value = false;
      setState(() {});
    } catch (e) {
      isLoading.value = false;
      setState(() {});
    }
  }
}
