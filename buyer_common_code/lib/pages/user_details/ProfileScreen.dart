import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/model/kyc_status.dart';
import 'package:buyer_common_code/pages/user_details/business_details.dart';
import 'package:get/get.dart';

import '../../model/profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  String? _loadingText, category, smsAutoId, userName, userAddress, businessAddress;
  String aadharDoc = "", panDOC = "";
  ValueNotifier<String> profileImage = ValueNotifier('');
  File? uploadFile, imageFileOne, imageFileTwo, profileFile, adharFile, panFile, landFile;
  ValueNotifier<int> selectedPage = ValueNotifier(0);
  ValueNotifier<List<ProfileData>> profileData = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _loadingText = 'Loading . . .';
    isLoading.value = true;
    setState(() {});
    getProfile();
    isLoading.value = false;
  }

  Future<String?> getUserCategory(BuildContext context) async {
    category = (await SharePrefsHelper.getInstance(context)?.getStringValue("category"));
    return category;
  }

  Widget buildCurrentSteps(int currentIndex) {
    return Container(
      padding: const EdgeInsets.all(5),
      color: Color(int.parse(themeColor.value.barColor!.color!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 70,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: currentIndex > 0 ? Colors.white : Colors.white.withOpacity(0.5), shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      "1",
                      style: TextStyle(color: currentIndex > 0 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                currentIndex == 1
                    ? const RotatedBox(
                        quarterTurns: 1,
                        child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                      )
                    : Container()
              ],
            ),
          ),
          const SizedBox(width: 42),
          SizedBox(
            height: 70,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: currentIndex > 1 ? Colors.white : Colors.white.withOpacity(0.5), shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      "2",
                      style: TextStyle(color: currentIndex > 1 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                currentIndex == 2 ? const RotatedBox(quarterTurns: 1, child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20)) : Container()
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      loadingText: '',
      isLoading: isLoading.value,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(context: context, title: "Update Profile".tr, fontWeight: FontWeight.w500, family: 'Graphik', color: Colors.white, fontSize: 18),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(91),
                child: ValueListenableBuilder(
                    valueListenable: currentStep,
                    builder: (BuildContext context, indexValue, Widget? child) {
                      return buildCurrentSteps(indexValue);
                    }),
              ),
              leading: InkWell(
                  onTap: () async {
                    HeaderSingleton().setProfileImage(profileImage.value.isNotEmpty ? profileImage.value : profileFile ?? '');
                    if (currentStep.value == 2) {
                      currentStep.value = 1;
                    } else if (currentStep.value == 1) {
                      await HelperUtils().showNormalDialog(
                          context: context,
                          title: 'Are_you_sure'.tr,
                          content: 'Do you want to abort profile updating'.tr,
                          onYesTapped: (value) async {
                            currentStep.value == 1;
                            Navigator.pop(value);
                            Navigator.pop(context);
                          });
                    } else {}
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.white)),
            ),
            body: CustomProgressHandler(
              isLoading: isLoading.value,
              loadingText: _loadingText!,
              child: SafeArea(
                  child: Scaffold( backgroundColor: Colors.white,
                key: Key("profile"),
                body: Column(
                  children: [
                    const SizedBox(height: 12),
                    ValueListenableBuilder(
                        valueListenable: currentStep,
                        builder: (BuildContext context, indexValue, Widget? child) {
                          return WidgetUtils.appTextWidget(
                              context: context,
                              title: indexValue == 1
                                  ? 'Personal Details'.tr
                                  : indexValue == 2
                                      ? "Business Details".tr
                                      : "E-KYC".tr,
                              fontWeight: FontWeight.w500,
                              family: 'Graphik',
                              fontSize: 18);
                        }),
                    const SizedBox(height: 12),
                    Expanded(
                      child: profileData.value != null && profileData.value.isNotEmpty
                          ? ValueListenableBuilder(
                          key: Key('profile'),
                              valueListenable: currentStep,
                              builder: (BuildContext context, indexValue, Widget? child) {
                                return indexValue == 1
                                    ? RegistrationScreen(profileData.value[0].phone!, profileData.value[0].myRefferalCode ?? "", profileData.value[0].userType!, false)
                                    : indexValue == 2
                                        ? const BusinessDetails(true)
                                        : Container();
                              })
                          : Container(),
                    )
                  ],
                ),
              )),
            )),
      ),
    );
  }

  Future<String>? getFarmerImageUrl() async {
    final networkResult = await NetworkHandler.getServerWorkingUrlss();
    dynamic value;
    if (networkResult != "key_check_internet") {
      value = Uri.parse(profileImage.value).toString();
    }
    return value;
  }

  Future getProfile() async {
    try {
      final response = await APIService.getAPIMethod(url: "${ApiURL.getProfile}/${HeaderSingleton().paramsMaps!.userId!}");
      final res = ProfileModel.fromJson(json.decode(response.body));
      if (res.status == 1) {
        profileData.value = res.data;
        Provider.of<UserLoanProfileProvider>(context, listen: false).setData(res.data);
        selectedPage.value = 0;
        if (profileData.value[0].profileImage != null) {
          SharePrefsHelper.getInstance(context)?.saveStringValue("Profile", profileData.value[0].profileImage ?? "");
          // profileImage.value = HeaderModel().configurationDetails!.partnerImgUrl! + "/" + profileData.value[0].profileImage!;
          profileImage.value = profileData.value[0].profileImage!;
        }
        if (profileData.value[0].aadharNoDoc != null) {
          aadharDoc = HeaderSingleton().configurationDetails!.partnerImgUrl! + "/" + profileData.value[0].aadharNoDoc!;
        }
        if (profileData.value[0].panNoDoc != null) {
          panDOC = HeaderSingleton().configurationDetails!.partnerImgUrl! + "/" + profileData.value[0].panNoDoc!;
        }
        await getFarmerImageUrl();
        await getKYCStatus();
        isLoading.value = false;
        // });
      }
    } catch (e) {
      // //print(e.toString());
      isLoading.value = false;
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future getKYCStatus() async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.getKYCStatus, params: {"user_id": HeaderSingleton().paramsMaps!.userId!});
      final res = EKYCStatus.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        HeaderSingleton().setEKYCStatus(res);
        // //print(HeaderModel().ekycStatus.value.toString());
        setState(() {});
      }
      // isLoading.value=true;
    } catch (e) {
      // //print(e.toString());
      isLoading.value = false;
    }
  }
}
