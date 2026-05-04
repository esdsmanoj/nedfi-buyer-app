import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../app_imports.dart';
import '../../components/dot_indicator/dots_decorator.dart';
import '../../components/widgets/introduction_widget/introduction_screen.dart';
import '../../components/widgets/introduction_widget/model/page_decoration.dart';
import '../../components/widgets/introduction_widget/model/page_view_model.dart';
import '../../model/walkthough_model.dart';
import '../login_screen/DomainScreen.dart';
import '../login_screen/LoginScreen.dart';

class OnBoardingPage extends StatefulWidget {
  final String route;

  const OnBoardingPage({Key? key, required this.route}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  WalkThroughModel? walkThroughModel;

  dynamic isLogin = false;

  @override
  void initState() {
    WidgetUtils.getUserModel(context).then((value) => isLogin = value);
    getIntroDetails();
    super.initState();
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.network(assetName, width: width);
  }

  dynamic getIntroDetails() async {
    final response = await APIService.getAPIMethod(url: ApiURL.walkthroughAPI);
    final data = json.decode(response.body);
    final result = WalkThroughModel.fromJson(data);
    if (result.status == 1) {
      walkThroughModel = result;
    }
    setState(() {});
  }

  Future<void> _onIntroEnd(context) async {
    await startTime();
    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => WhiteLableSplashScreen(image, isFrom: true)), (Route<dynamic> route) => false));
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0, fontFamily: 'Graphik', fontWeight: FontWeight.w400, color: Color(0xff707070));

    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500, fontFamily: 'Graphik'),
        bodyTextStyle: bodyStyle,
        bodyPadding: EdgeInsets.fromLTRB(16.0, 10.0, 10.0, 16.0),
        pageColor: Colors.white,
        imagePadding: EdgeInsets.zero);

    return walkThroughModel != null
        ? SafeArea(
          child: IntroductionScreen(
              key: introKey,
              globalBackgroundColor: Colors.white,
              allowImplicitScrolling: true,
              autoScrollDuration: 3000,
              infiniteAutoScroll: true,
              globalFooter: InkWell(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(int.parse(themeColor.value.buttonColor!.color!))),
                  width: double.infinity,
                  height: 58,
                  alignment: Alignment.center,
                  child: Text('Get Started'.tr, style: TextStyle(fontFamily: 'Graphik', fontSize: 16.0, fontWeight: FontWeight.w500, color: Color(int.parse(themeColor.value.buttonTextColor!.color!)))),
                ),
                onTap: () => _onIntroEnd(context),
              ),

              pages: List.generate(
                walkThroughModel!.data!.length,
                (index) => PageViewModel(
                  title: walkThroughModel!.data![index].title!,
                  body: walkThroughModel!.data![index].description!,
                  image: _buildImage(walkThroughModel!.data![index].image!),
                  decoration: pageDecoration,
                ),
              ),
              onDone: () => _onIntroEnd(context),
              onSkip: () => _onIntroEnd(context),
              showSkipButton: false,
              skipOrBackFlex: 0,
              nextFlex: 0,
              showNextButton: false,
              showBackButton: false,
              showDoneButton: false,
              curve: Curves.fastLinearToSlowEaseIn,
              // controlsMargin: const EdgeInsets.all(16),
              controlsPadding: kIsWeb ? const EdgeInsets.all(12.0) : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
              dotsDecorator: DotsDecorator(
                size: const Size(10.0, 10.0),
                color: const Color(0xFFBDBDBD),
                activeColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                activeSize: const Size(30.0, 15.0),
                activeShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
              ),
              dotsContainerDecorator: const ShapeDecoration(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
              ),
            ),
        )
        : const Scaffold( backgroundColor: Colors.white,);
  }

  Future startTime() async {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => widget.route == 'famrut' || widget.route == 'icar' || widget.route == 'nedfi' ? const LoginScreen() : const DomainScreen()));
    });
  }
}
