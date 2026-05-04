import 'package:buyer_common_code/model/ProductType.dart';
import 'package:buyer_common_code/model/master_listing_model.dart';
import 'package:buyer_common_code/pages/marketPlace/nedfi_products/add_product/AddProductStepTwoScreen.dart';
import 'package:get/get.dart';

import '../../../../app_imports.dart';
import '../../../../providers/master_provider.dart';
import 'AddProductStepOneScreen.dart';
import 'AddProductStepThreeScreen.dart';

class AddProductMainScreen extends StatefulWidget {
  String? type, id;

  AddProductMainScreen({this.type, this.id});

  @override
  State<AddProductMainScreen> createState() => _AddProductMainScreenState();
}

class _AddProductMainScreenState extends State<AddProductMainScreen> {
  bool _isLoading = false;
  int currentIndex = 0;
  var screenArray = [];

  Future<bool> onWillPop() async {
    var masterProvider = Provider.of<MasterProvider>(context, listen: false);
    if (masterProvider.productCurrentIndex == 3) {
      return (await HelperUtils().showNormalDialog(
          context: context,
          title: 'Are_you_sure'.tr,
          content: 'Do you want to go to step 2'.tr,
          onYesTapped: (value) async {
            Navigator.pop(value);
            masterProvider.setProductCurrentIndex(2);
            setState(() {

            });
          })) ??
          false;
    } else if (masterProvider.productCurrentIndex == 2) {
      return (await HelperUtils().showNormalDialog(
          context: context,
          title: 'Are_you_sure'.tr,
          content: 'Do you want to go to step 1'.tr,
          onYesTapped: (value) async {
            Navigator.pop(value);
            masterProvider.setProductCurrentIndex(1);
            setState(() {

            });
          })) ??
          false;
    } else {
      return (await HelperUtils().showNormalDialog(
          context: context,
          title: 'Are_you_sure'.tr,
          content: 'Do you want to exit from add product'.tr,
          onYesTapped: (value) async {
            Navigator.pop(value);
            Navigator.pop(context, true);

          })) ??
          false;
    }
  }

  @override
  void initState() {
    super.initState();
    screenArray = [AddProductStepOneScreen(id: widget.id,onPressed: (value){
      //print("masterProvider.value");
      //print(value);
      setState(() {

      });
    }), AddProductStepTwoScreen(id: widget.id,onPressed: (value){
      //print("masterProvider.value2");
      //print(value);
      setState(() {

      });
    }), AddProductStepThreeScreen(id: widget.id,bottonText: widget.type == "EDIT" ?"Update Product":"Add Product")];

    getMasterList();
    getProductType();
    var masterProvider = Provider.of<MasterProvider>(context, listen: false);
    masterProvider.setType(widget.type ?? "");
  }

  Future getMasterList() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getMasterListing);
      final data = json.decode(response.body);
      final res = MasterListing.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setMasterData(res.data!);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  Future getProductType() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.productType);
      final data = json.decode(response.body);
      final res = ProductType.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setProductTypeData(res.data ?? []);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MasterProvider>(builder: (context, masterProvider, child) {
      //print("masterProvider.productCurrentIndex");
      //print(masterProvider.productCurrentIndex);
      return WillPopScope(
          onWillPop: onWillPop,
          child: SafeArea(
              child: CustomProgressHandler(
                loadingText: '',
                isLoading: _isLoading,
                child: Scaffold( backgroundColor: Colors.white,
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    elevation: 0,
                    centerTitle: true,
                    backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
                    title: WidgetUtils.appTextWidget(context: context, title: widget.type == "EDIT" ? 'Edit Product'.tr : 'Add Product'.tr, color: Colors.white, fontSize: 18),
                    iconTheme: const IconThemeData(color: Colors.white),
                  ),
                  body: Column(
                    children: [stepCountWidget(masterProvider.productCurrentIndex), Expanded(child:screenArray[masterProvider.productCurrentIndex - 1] )],
                  ),
                ),
              )));
    });
  }

  stepCountWidget(int currentIndex) {
    return Container(
      padding: EdgeInsets.all(5),
      color: Color(int.parse(themeColor.value.barColor!.color!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 70,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: currentIndex > 0 ? Colors.white : Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "1",
                      style: TextStyle(color: currentIndex > 0 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                currentIndex == 1
                    ? RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                )
                    : Container()
              ],
            ),
          ),
          Container(
            height: 70,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: currentIndex > 1 ? Colors.white : Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "2",
                      style: TextStyle(color: currentIndex > 1 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                currentIndex == 2
                    ? RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                )
                    : Container()
              ],
            ),
          ),
          Container(
            height: 70,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: currentIndex > 2 ? Colors.white : Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "3",
                      style: TextStyle(color: currentIndex > 2 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                currentIndex == 3
                    ? RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
