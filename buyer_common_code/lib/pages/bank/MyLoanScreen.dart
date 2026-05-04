import 'package:get/get.dart';
import 'package:buyer_common_code/app_imports.dart';

class MyLoanScreen extends StatefulWidget {
  const MyLoanScreen({Key? key}) : super(key: key);

  @override
  State<MyLoanScreen> createState() => _MyLoanScreenState();
}

class _MyLoanScreenState extends State<MyLoanScreen> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  late String _loadingText;

  @override
  void initState() {
    super.initState();
    _loadingText = 'Loading . . .';
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanTypeProvider>(//                    <--- Consumer
        builder: (context, loanModel, child) {
      return CustomProgressHandler(
        isLoading: isLoading.value,
        loadingText: _loadingText,
        child: Scaffold( backgroundColor: Colors.white,
          appBar: AppBar(elevation:0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context:context,title: 'Loan Applications'.tr, color: Colors.white, fontSize: 18),
            leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
          ),
         //  backgroundColor: ColorsConst.backgroundColor,
          body: loanModel.loanDetailsList.isNotEmpty
              ? ListView.builder(
                  itemCount: loanModel.loanDetailsList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _loanTypeItem(loanModel.loanDetailsList[index], index);
                  })
              : Center(
                  child: Text("No data found".tr),
                ),
        ),
      );
    });
  }

  Widget _loanTypeItem(LoanDetailsData loanDetailsData, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyLoanDetailsScreen(loanDetailsData)));
      },
      child: Container(
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.grey, width: 1.0, style: BorderStyle.solid)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                // height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetUtils.appTextWidget(context:context,title: 'Application Id'.tr, textAlign: TextAlign.start, color: const Color(0XFF000000), fontSize: 12, fontWeight: FontWeight.bold),
                    WidgetUtils.appTextWidget(context:context,title: 'Loan Type'.tr, textAlign: TextAlign.start, color: const Color(0XFF000000), fontSize: 12, fontWeight: FontWeight.bold),
                    WidgetUtils.appTextWidget(context:context,title: 'Status'.tr, textAlign: TextAlign.start, color: const Color(0XFF000000), fontSize: 12, fontWeight: FontWeight.bold),
                    WidgetUtils.appTextWidget(context:context,title: 'Date'.tr, textAlign: TextAlign.start, color: const Color(0XFF000000), fontSize: 12, fontWeight: FontWeight.bold),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                  // height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetUtils.appTextWidget(context:context,title: loanDetailsData.loan_app_id.tr, color: const Color(0XFF000000), fontSize: 15, fontWeight: FontWeight.bold),
                      SizedBox(
                        width: 180,
                        child: WidgetUtils.appTextWidget(context:context,title: loanDetailsData.loan_name.tr, color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                      ),
                      WidgetUtils.appTextWidget(context:context,title: loanDetailsData.status.tr, color: Colors.red, fontSize: 11, fontWeight: FontWeight.w400),
                      WidgetUtils.appTextWidget(context:context,title: loanDetailsData.created_on.tr, color: Colors.green, fontSize: 11, fontWeight: FontWeight.w300),
                    ],
                  )),
            ],
          )),
    );
  }

  Future getCategory() async {
    isLoading.value = true;
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getMyLoan + "/" + HeaderSingleton().paramsMaps!.userId!);
      final data = json.decode(response.body);
      // //print(data);
      var res = LoanDetailsResponse.fromJson(data);
      if (res.status == 1) {
        //setState(() {
        var homeDashboardModel = Provider.of<LoanTypeProvider>(context, listen: false);
        homeDashboardModel.setLoanDetailsList(res.data);
      }

      isLoading.value = false;
      setState(() {});
    } catch (e) {
      // //print(e.toString());
      isLoading.value = false;
      setState(() {});
    }
  }
}
