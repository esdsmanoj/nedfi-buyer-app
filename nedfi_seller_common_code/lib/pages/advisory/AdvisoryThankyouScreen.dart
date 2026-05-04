import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:get/get.dart';

class AdvisoryThankYouScreen extends StatefulWidget {
  final String textMessage;

  const AdvisoryThankYouScreen(this.textMessage, {super.key});

  @override
  _AdvisoryThankYouScreenState createState() => _AdvisoryThankYouScreenState();
}

class _AdvisoryThankYouScreenState extends State<AdvisoryThankYouScreen> {

  dynamic onBackPressed(BuildContext context) async {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => onBackPressed(context),
        child: Scaffold( backgroundColor: Colors.white,
            //  backgroundColor: ColorsConst.backgroundColor,
            resizeToAvoidBottomInset: true,
            body: Container(
                color: ColorsConst.backgroundColor,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/advisorThanks.png", height: 191, width: 260),
                    const SizedBox(height: 10),
                    const Text(
                      'Your call Request has been sent ',
                      style: TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.textMessage,
                        style: const TextStyle(color: Colors.grey, fontSize: 14.0, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                )),
            bottomNavigationBar: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyBookingScreen()));
              },
              child: Container(
                width: double.maxFinite,
                height: 45,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'My Booking'.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'Graphik', fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward, color: Colors.white)
                  ],
                ),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xff27914F)),
              ),
            )));
  }
}
