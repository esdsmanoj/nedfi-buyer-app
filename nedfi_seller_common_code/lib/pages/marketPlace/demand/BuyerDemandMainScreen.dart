import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/pages/marketPlace/demand/BuyerIntrestScreen.dart';

import '../../../app_imports.dart';
import 'BuyerDemandScreen.dart';

class BuyerDemandMainScreen extends StatefulWidget {
  const BuyerDemandMainScreen({super.key});

  @override
  State<BuyerDemandMainScreen> createState() => _BuyerDemandMainScreenState();
}

class _BuyerDemandMainScreenState extends State<BuyerDemandMainScreen> {
  int tabFlag = 0;

  var screenArray = [const BuyerDemandScreen(), const BuyerIntrestScreen()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomProgressHandler(
        loadingText: '',
        isLoading: isLoading.value,
        child: DefaultTabController(
            length: 5,
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  centerTitle: false,
                  backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
                  title: WidgetUtils.appTextWidget(context: context, title: 'Buyers Demand/Interest'.tr, family: 'Graphik', fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
                  iconTheme: const IconThemeData(color: Colors.white),
                  leading: IconButton(
                    icon: const Icon(Icons.keyboard_backspace_sharp),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: Column(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width) - 30,
                      height: 60,
                      child: AnimatedToggleNew(
                        initialPosition: tabFlag,
                        values: ['BUYER DEMAND'.tr, 'BUYER INTEREST'.tr],
                        onToggleCallback: (value) {
                          setState(() {
                            tabFlag = value;
                          });
                        },
                        buttonColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                        backgroundColor: const Color(0xFFFFFFFF),
                        textColor: const Color(0xFFFFFFFF),
                        borderColor: Color(int.parse(themeColor.value.buttonColor!.color!)),
                      ),
                    ),
                    Expanded(child: screenArray[tabFlag]),
                  ],
                ))),
      ),
    );
  }
}

class AnimatedToggleNew extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;
  int? initialPosition;

  AnimatedToggleNew({
    super.key,
    required this.values,
    required this.onToggleCallback,
    required this.initialPosition,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
    this.borderColor = const Color(0xFFe7e7e8),
  });

  @override
  _AnimatedToggleStateNew createState() => _AnimatedToggleStateNew();
}

class _AnimatedToggleStateNew extends State<AnimatedToggleNew> {
  bool initialPosition = false;

  @override
  void initState() {
    super.initState();
    initialPosition = widget.initialPosition == 0 ? true : false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.1,
      height: Get.width * 0.13,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              initialPosition = !initialPosition;
              var index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
              setState(() {});
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 15,
              height: Get.width * 0.13,
              decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  /*border: Border.all(color: widget.borderColor),*/
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.values.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.13),
                    child: Text(
                      widget.values[index],
                      style: const TextStyle(fontFamily: 'Graphik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xAA000000)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment: initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: (MediaQuery.of(context).size.width / 2) - 20,
              height: Get.width * 0.13,
              decoration: ShapeDecoration(
                color: widget.buttonColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                initialPosition ? widget.values[0] : widget.values[1],
                style: TextStyle(fontFamily: 'Graphik', fontSize: 14, color: widget.textColor, fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
