import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';

import '../../model/home_page_model.dart';

class ServicesScreen extends StatefulWidget {
  final List<Services> services;

  const ServicesScreen({Key? key, required this.services}) : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<Services> services = [];

  @override
  void initState() {
    isLoading.value = true;
    getDetails();
    isLoading.value = false;
    super.initState();
  }

  Future getDetails() async {
    if (widget.services.isEmpty) {
      services = await HelperUtils().getCategory(context);
      // print(services);
      setState(() {});
    } else {
      services = widget.services;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold( backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
          centerTitle: true,
          title: WidgetUtils.appTextWidget(context: context, title: 'Services'.tr, color: Colors.white, fontSize: 18),
          leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
        ),
        body: CustomProgressHandler(
            isLoading: isLoading.value,
            loadingText: 'Loading...',
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16,left:16,right:16),
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: services.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12.0, mainAxisSpacing: 15.0, childAspectRatio: 1),
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Map<String, dynamic> params = {
                          'id': homeConfigurableModel.value!.data!.services![index].catId,
                          'name': HeaderSingleton().local == 'en' ? homeConfigurableModel.value!.data!.services![index].name! : homeConfigurableModel.value!.data!.services![index].nameMr!
                        };
                        HelperUtils().navigateToScreens(call: () => setState(() {}), context: context, mapKey: homeConfigurableModel.value!.data!.services![index].mapKey!, params: params);
                      },
                      child: Container(
                        /* height: MediaQuery.of(context).size.height * 0.086,
                            width: MediaQuery.of(context).size.height * 0.090,*/
                        alignment: Alignment.center,
                        padding:const EdgeInsets.symmetric(horizontal:9,vertical:12),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                            color:  Color(int.parse(themeColor.value.barColor!.color!)).withOpacity(0.17)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              height: MediaQuery.of(context).size.height * 0.045,
                              width: MediaQuery.of(context).size.height * 0.045,
                              fit: BoxFit.fill,
                              imageUrl: "${HeaderSingleton().configurationDetails!.categoryImgUrl}/${services[index].mobIcon}",
                              imageBuilder: (context, imageProvider) =>
                                  Image(image: imageProvider, height: MediaQuery.of(context).size.height * 0.045, width: MediaQuery.of(context).size.height * 0.045, fit: BoxFit.contain),
                              placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                              errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 90,
                              height: MediaQuery.of(context).size.height * 0.035,
                              child: Text(services[index].name!,
                                  maxLines: 2,
                                  style: const TextStyle(fontFamily: 'Graphik', fontSize: 12, color: Color(0xff3F3F3F), fontWeight: FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )),
      ),
    );
  }
}
