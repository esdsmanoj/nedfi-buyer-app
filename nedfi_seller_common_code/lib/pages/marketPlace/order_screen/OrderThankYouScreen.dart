import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';

class OrderThankYouScreen extends StatefulWidget {
  String? massage;

  OrderThankYouScreen({super.key, this.massage});

  @override
  _OrderThankYouScreenState createState() => _OrderThankYouScreenState();
}

class _OrderThankYouScreenState extends State<OrderThankYouScreen> {
  _exitApp(BuildContext context) async {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
  }

  var isFarmer = 0;

  @override
  void initState() {
    super.initState();
    HelperUtils().getIsFarmer(context).then((value) {
      setState(() {
        isFarmer = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _exitApp(context),
        child: Scaffold( backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: Container(
            color: Colors.white,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset("assets/images/thankyou.png", alignment: Alignment.center, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 220,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: Text(widget.massage ?? "", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.left),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CustomDarkButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
                    },
                    caption: 'Go To Home'.tr,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}
