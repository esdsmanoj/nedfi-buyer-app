import 'package:get/get.dart';
import 'package:nedfi_seller_common_code/app_imports.dart';

class AdvisoryCropScreen extends StatelessWidget {
  const AdvisoryCropScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.white,
      body: const SafeArea(child: Padding(padding: EdgeInsets.only(bottom: 60), child: CropListScreen(isStatus: 'advisory'))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (newCtx) => const MyBookingScreen())),
        child: Container(
            height: 50,
            width: double.maxFinite,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Color(int.parse(themeColor.value.buttonColor!.color!))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [WidgetUtils.appTextWidget(context:context,title: 'My_Booking'.tr, color: Color(int.parse(themeColor.value.buttonTextColor!.color!)), fontSize: 20), const SizedBox(width: 10),  Icon(Icons.arrow_forward, color: Color(int.parse(themeColor.value.iconColor!.color!)))])),
      ),
    );
  }
}
