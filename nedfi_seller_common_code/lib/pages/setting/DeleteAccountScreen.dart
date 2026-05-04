
import 'package:get/get.dart';

import '../../app_imports.dart';
import '../login_screen/LoginScreen.dart';

class Deleteaccountscreen extends StatefulWidget {
  const Deleteaccountscreen({super.key});

  @override
  State<Deleteaccountscreen> createState() => _DeleteaccountscreenState();
}

class _DeleteaccountscreenState extends State<Deleteaccountscreen> {
  // Function to delete the account and show feedback
  void _deleteAccount(BuildContext context) async {
    var check = await SharePrefsHelper.getInstance(context)
        ?.getBoolValue("isDeleteAccount")??false;
    if (!check ) {
      try {
        final response = await APIService.getAPIMethod(
            url: ApiURL.sellerDelete + "/" +
                HeaderSingleton().paramsMaps!.userId!);
        final data = json.decode(response.body);
        final res = CommonModel.fromJson(data);
        if (res.success == 1) {
          SharePrefsHelper.getInstance(context)
              ?.saveBoolValue("isDeleteAccount", true);
          WidgetUtils.successDialog(
              context, res.message ?? ''.tr);
          var marketPlaceModel = Provider.of<MarketPlaceProvider>(context, listen: false);
          marketPlaceModel.setClearCart();
          SQLiteDbProvider.db.deleteAll();
          await SharePrefsHelper.getInstance(context)?.saveStringValue("step1", "");
          await SharePrefsHelper.getInstance(context)?.saveStringValue("step2", "");
          await SharePrefsHelper.getInstance(context)?.saveStringValue("step3", "");
          await SharePrefsHelper.getInstance(context)?.saveStringValue("mobile", "");
          await SharePrefsHelper.getInstance(context)?.saveStringValue("step1_data", "");
          await SharePrefsHelper.getInstance(context)?.saveStringValue("step2_data", "");
          await SharePrefsHelper.getInstance(context)?.saveStringValue("userType", "0");
          await SharePrefsHelper.getInstance(context)?.saveStringValue("userTypeSelected", "");
          await SharePrefsHelper.getInstance(context)?.saveBoolValue("is_user_log", false);
          await SharePrefsHelper.getInstance(context)?.saveBoolValue("isLogin", false);
          await SharePrefsHelper.getInstance(context)?.saveBoolValue("isLogin", false);
          await  SharePrefsHelper.getInstance(context)?.saveUserModel(UserData());
          await SharePrefsHelper.getInstance(context)?.saveStringValue("Profile", "");
          await SharePrefsHelper.getInstance(context)?.saveStringValue("whitelabel", "");
          await SharePrefsHelper.getInstance(context)?.saveStringValue("logo", "");
          await SharePrefsHelper.getInstance(context)?.saveStringValue("locale", "en");
          await SharePrefsHelper.getInstance(context)?.saveStringValue("address_check", "");

          lang = 'en';
          HeaderSingleton().setLang('en');
          Get.updateLocale(const Locale('en', 'US'));
          isLoading.value = false;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);

          HeaderSingleton().paramsMaps = null;
          setState(() {});
        }
      } catch (e) {
        setState(() {});
      }
    }else{
      WidgetUtils.successDialog(
          context,  'Account deletion request has already been submitted.'.tr);
      setState(() {});
    }

    // Navigate back to the settings screen after account deletion
    Navigator.pop(context);
  }

  // Function to show the confirmation dialog before deleting the account
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text(
            "Are you sure you want to delete your account? All your data will be permanently deleted.",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            // Cancel button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            // Confirm button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteAccount(context); // Proceed with the deletion
              },
              child: Text("Delete Account", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
        title: WidgetUtils.appTextWidget(context: context, title: 'Delete Account'.tr, color: Colors.white, fontSize: 18),
        leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Are you sure you want to delete your account? All your data will be permanently deleted.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        child:       Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cancel button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the settings screen
              },
              child: Text("Cancel",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Grey color for cancel
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(width: 20),
            // Delete Account button
            ElevatedButton(
              onPressed: () {
                _showDeleteConfirmationDialog(context); // Show the confirmation dialog
              },
              child: Text("Delete Account",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(int.parse(themeColor.value.buttonColor!.color!)), // Red color for delete
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
