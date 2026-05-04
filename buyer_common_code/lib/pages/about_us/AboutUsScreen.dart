import 'package:buyer_common_code/app_imports.dart';
import 'package:get/get.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  var unescape = HtmlUnescape();
  AboutUs? aboutUsDetails;

  @override
  void initState() {
    super.initState();
    isLoading.value = true;
    setState(() {});
    getAboutDetails();
    isLoading.value = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold( backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, family: 'Graphik', title: 'key_aboutus'.tr, color: Colors.white, fontSize: 18),
            leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Image.file(File(image), fit: BoxFit.contain, width: MediaQuery.of(context).size.height * 0.558, height: MediaQuery.of(context).size.height * 0.32, errorBuilder: (ctx, obj, st) {
                  return Image.asset(HeaderSingleton().splashImage, fit: BoxFit.contain, width: MediaQuery.of(context).size.height * 0.558, height: MediaQuery.of(context).size.height * 0.18);
                }),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                aboutUsDetails != null
                    ? Column(
                        children: [
                          WidgetUtils.appTextWidget(context: context, title: 'Who We are?'.tr, color: Colors.black, family: 'Graphik', fontWeight: FontWeight.bold, fontSize: 18),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 31),
                            child: Text(
                              lang == 'en' ? aboutUsDetails!.data.aboutUs : aboutUsDetails!.data.aboutUsMr,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Graphik'),
                            ),
                          ),
                          Image.asset('assets/images/telemedicine.png', height: 50, width: 50),
                          WidgetUtils.appTextWidget(context: context, title: 'Contact Us'.tr, color: Colors.black, family: 'Graphik', fontWeight: FontWeight.bold, fontSize: 18),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          GestureDetector(
                              onTap: () => launchUrl(Uri(scheme: "tel", path: aboutUsDetails!.data.phone1)),
                              child:
                                  WidgetUtils.appTextWidget(context: context, title: aboutUsDetails!.data.phone1, color: Colors.black, family: 'Graphik', fontWeight: FontWeight.w300, fontSize: 14)),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          Image.asset('assets/images/email.png', height: 50, width: 50),
                          WidgetUtils.appTextWidget(context: context, title: 'Email us'.tr, color: Colors.black, family: 'Graphik', fontWeight: FontWeight.bold, fontSize: 18),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          GestureDetector(
                              onTap: () => launch("mailto:${aboutUsDetails!.data.email}"),
                              child: WidgetUtils.appTextWidget(context: context, title: aboutUsDetails!.data.email, color: Colors.black, family: 'Graphik', fontWeight: FontWeight.w300, fontSize: 14)),
                          Image.asset('assets/images/pin-point.png', height: 50, width: 50),
                          WidgetUtils.appTextWidget(context: context, title: "Location".tr, color: Colors.black, family: 'Graphik', fontWeight: FontWeight.bold, fontSize: 18),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          GestureDetector(
                            onTap: () => openMap(aboutUsDetails!.data.latitude, aboutUsDetails!.data.longitude),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child:
                                  WidgetUtils.appTextWidget(context: context, title: aboutUsDetails!.data.address, color: Colors.black, family: 'Graphik', fontWeight: FontWeight.w300, fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      )
                    : Center(child: WidgetUtils.appTextWidget(context: context, title: 'No data found'.tr, color: Colors.black, family: 'Graphik', fontSize: 18))
              ],
            ),
          )),
    );
  }

  /// Getting about us information
  Future getAboutDetails() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.aboutUs);
      final data = json.decode(response.body);
      AboutUs aboutUsData = AboutUs.fromJson(data);
      if (aboutUsData.success != 1) {
        WidgetUtils.errorDialog(context, data["msg"]);
      } else {
        aboutUsDetails = aboutUsData;
      }
      setState(() {});
    } catch (e) {
      isLoading.value = false;
      setState(() {});
      rethrow;
    }
  }

  /// Opening location map on tapping of address.
  Future openMap(final lat, final lng) async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final String appleMapsUrl = 'https://maps.apple.com/?q=$lat,$lng';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }

    if (await canLaunch(appleMapsUrl)) {
      await launch(appleMapsUrl);
    } else {
      throw 'Could not launch $appleMapsUrl';
    }

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }

    if (await canLaunch(appleMapsUrl)) {
      await launch(appleMapsUrl);
    } else {
      throw 'Could not launch $appleMapsUrl';
    }
  }
}
