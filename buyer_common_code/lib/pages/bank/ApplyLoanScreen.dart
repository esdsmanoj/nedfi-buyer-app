import 'package:buyer_common_code/app_imports.dart';
import 'package:get/get.dart';

class ApplyLoanScreen extends StatefulWidget {
  final LoanTypeData loanTypeData;

  const ApplyLoanScreen(this.loanTypeData, {super.key});

  @override
  _ApplyLoanScreenState createState() => _ApplyLoanScreenState();
}

class _ApplyLoanScreenState extends State<ApplyLoanScreen> {
  final pageController = PageController();
  int initialPage = 2;
  int loanSteps = 4;
  List<Widget> widgetList = [];
  List<String> titleList = [];
  final cropLoanScreens = [const CropLoanOneScreen(), const CropLoanTwoScreen(), const CropLoanThreeScreen(), const CropLoanFourScreen()];
  final cropLoanPageTitle = ['Crop Details'.tr, 'Personal Details'.tr, 'Co-Applicant Details'.tr, 'Document Upload'.tr];
  final tractorLoanScreens = [const TractorLoanScreen(), const CropLoanTwoScreen(), const CropLoanThreeScreen(), const CropLoanFourScreen()];
  var tractorLoanPageTitle = ['Tractor Details'.tr, 'Personal Details'.tr, 'Co-Applicant Details'.tr, 'Document Upload'.tr];

  var harvesterLoanScreens = [const HarvesterLoanScreen(), const CropLoanTwoScreen(), const CropLoanThreeScreen(), const CropLoanFourScreen()];
  var harvesterLoanPageTitle = ['Harvester Details'.tr, 'Personal Details'.tr, 'Co-Applicant Details'.tr, 'Document Upload'.tr];
  var pumpSetLoanScreens = [const PumpSetLoanScreen(), const CropLoanTwoScreen(), const CropLoanThreeScreen(), const CropLoanFourScreen()];
  var pumpSetLoanTitle = ['Pumpset Details'.tr, 'Personal Details'.tr, 'Co-Applicant Details'.tr, 'Document Upload'.tr];

  var personalScreens = [
    const PersonalLoanOneScreen(),
    const PersonalLoanTwoScreen(),
    const PersonalLoanThreeScreen(),
    const PersonalLoanFourScreen(),
    const PersonalLoanFiveScreen(),
    const CropLoanFourScreen()
  ];
  var personalPageTitle = ['Income details'.tr, 'Land details'.tr, 'Applicant details'.tr, 'Co-Applicant details'.tr, 'Identity proof(POI)'.tr, 'Document Upload'.tr];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var loanModel = Provider.of<LoanProvider>(context, listen: false);
      loanModel.setLoanTypeID(widget.loanTypeData.loanTypeId);
    });
    HelperUtils().getCountry((value) {}, context);
    HelperUtils().getState((value) {}, context);
    if (widget.loanTypeData.loanTypeId == "1") {
      widgetList = cropLoanScreens;
      titleList = cropLoanPageTitle;
      loanSteps = cropLoanScreens.length;
    } else if (widget.loanTypeData.loanTypeId == "3") {
      widgetList = tractorLoanScreens;
      titleList = tractorLoanPageTitle;
      loanSteps = tractorLoanScreens.length;
    } else if (widget.loanTypeData.loanTypeId == "5") {
      widgetList = harvesterLoanScreens;
      titleList = harvesterLoanPageTitle;
      loanSteps = harvesterLoanScreens.length;
    } else if (widget.loanTypeData.loanTypeId == "18") {
      widgetList = pumpSetLoanScreens;
      titleList = pumpSetLoanTitle;
      loanSteps = pumpSetLoanScreens.length;
    } else {
      widgetList = personalScreens;
      titleList = personalPageTitle;
      loanSteps = personalScreens.length;
    }
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Timer.periodic(
          const Duration(milliseconds: 350),
          (_) {
            if (mounted) {
              initialPage += 1;
              if (initialPage == loanSteps - 1) {
              } else {
                if (pageController.hasClients) {
                  pageController.jumpToPage(initialPage);
                }
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(builder: (context, loanModel, child) {
      if (pageController.hasClients) {
        pageController.jumpToPage(loanModel.pageIndex);
      }

      return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(
                  context: context,
                  title: HeaderSingleton().local == "en" ? widget.loanTypeData.name : widget.loanTypeData.nameMr,
                  color: Colors.white,
                  fontSize: 18,
                  family: 'Graphik',
                  fontWeight: FontWeight.w500),
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    HeaderSingleton().setStatusInfo(false);
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.white)),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(58.0),
                child: Container(
                  alignment: Alignment.topCenter,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: NumberStepper(
                      totalSteps: loanSteps,
                      width: MediaQuery.of(context).size.width,
                      curStep: loanModel.pageIndex,
                      stepCompleteColor: const Color(0xff27914F),
                      currentStepColor: Colors.grey.shade300,
                      inactiveColor: Colors.transparent,
                      lineWidth: 1.5),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: WidgetUtils.appTextWidget(context: context, title: titleList[loanModel.pageIndex - 1], fontSize: 18, fontWeight: FontWeight.w500, family: 'Graphik'),
              ),
              Expanded(child: SingleChildScrollView(child: Container(child: widgetList[loanModel.pageIndex - 1]))),
            ])),
      );
    });
  }
}
