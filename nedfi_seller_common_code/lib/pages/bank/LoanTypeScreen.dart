import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';

import '../../components/widgets/base_widget.dart';
import 'MyLoanScreen.dart';

class LoanTypeScreen extends StatefulWidget {
  const LoanTypeScreen({Key? key}) : super(key: key);

  @override
  _LoanTypeScreenState createState() => _LoanTypeScreenState();
}

class _LoanTypeScreenState extends State<LoanTypeScreen> {
  @override
  void initState() {
    super.initState();
    getTypes();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<LoanTypeProvider>(builder: (context, loanModel, child) {
        return BaseWidget(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, title: 'Loan Type'.tr, family: 'Graphik', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
          ),
          child: Container(
              child: loanModel.loanTypeList.isEmpty
                  ? Center(
                      child: WidgetUtils.appTextWidget(context: context, title: 'No data found'.tr, fontSize: 14, family: 'Graphik', fontWeight: FontWeight.w400, color: Colors.black),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 34.0),
                      child: ListView.builder(
                          itemCount: loanModel.loanTypeList.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return _loanTypeItem(loanModel.loanTypeList[index], index);
                          }),
                    )),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingButton: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: InkWell(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyLoanScreen()));
                },
                child: Container(
                  height: 50,
                  width: 150,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.account_balance, color: Colors.white),
                      WidgetUtils.appTextWidget(context: context, title: 'My Loans'.tr, color: Colors.white, family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500),
                    ],
                  ),
                  decoration: BoxDecoration(color:Color(int.parse(themeColor.value.barColor!.color!)), borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _loanTypeItem(LoanTypeData loanTypeData, int index) {
    return InkWell(
      onTap: () {
        var loanModel = Provider.of<LoanProvider>(context, listen: false);
        loanModel.pageIndex = 1;
        loanModel.setClearAll();
        Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyLoanScreen(loanTypeData)));
      },
      child: Container(
        width: double.maxFinite,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: Colors.grey.shade300, width: 1.0, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 36,
              width: 36,
              child: CachedNetworkImage(
                height: 36,
                imageUrl: HeaderSingleton().configurationDetails!.loanTypeUrl! + loanTypeData.mobIcon,
                imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.fill))),
                placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                errorWidget: (context, url, error) => Image.file(File(image), fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              width: 200,
              child: WidgetUtils.appTextWidget(
                  context: context,
                  title: lanLocale == "en" ? loanTypeData.name : loanTypeData.nameMr,
                  softWrap: true,
                  color: Colors.black,
                  fontSize: 14,
                  family: 'Graphik',
                  fontWeight: FontWeight.w500),
            ),
            const Icon(Icons.arrow_forward_ios_outlined, size: 13, color: Colors.grey)
          ],
        ),
      ),
    );
  }

  Future getTypes() async {
    isLoading.value = true;
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getLoanType);
      final data = json.decode(response.body);
      var res = LoanTypeResponse.fromJson(data);
      if (res.status == 1) {
        var homeDashboardModel = Provider.of<LoanTypeProvider>(context, listen: false);
        homeDashboardModel.setLoanTypeList(res.data);
      }
      isLoading.value = false;
    } catch (e) {
      // print(e.toString());
      isLoading.value = false;
    }
  }
}
