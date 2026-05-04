import 'package:buyer_common_code/app_imports.dart';
import 'package:buyer_common_code/components/widgets/base_widget.dart';
import 'package:buyer_common_code/model/HomeCatagoryResponse.dart' as con;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../components/utils/NotificationUtils.dart';
import '../../model/bottom_bar_menu.dart' as bottom;
import '../../model/dynamic_theme.dart';
import '../../model/home_page_model.dart';
import '../../model/profile_model.dart';
import '../chatbot_screen/chatbot_screen.dart';
import '../dashboard_screen/my_selected_crops.dart';
import '../notifications/notifications_pending.dart';

class NavigationHomeScreen extends StatefulWidget {
  const NavigationHomeScreen({Key? key}) : super(key: key);

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  UserData? paramsMaps;
  Map<String, String> params = <String, String>{};
  String netCarretURL = "", profileImage = "";
  ValueNotifier<String> selectedScreen = ValueNotifier("Home");
  bool joinFlag = false;
  List<SeasonData> seasonData = [];
  String? meetingID, advisoryID;
  ValueNotifier<int> selectedIndex = ValueNotifier(1);
  List<Menu> menuList = [];
  List<MyCrops> myCrops = [];
  dynamic homeDashboardModel;
  // late PackageInfo packageInfo;

  @override
  void initState() {
    /*getProductList(context).then((value) {
      productDetailList.value = value;
      Provider.of<MarketPlaceProvider>(context, listen: false).setCartProductList(productDetailList.value);
    });*/
    getTheme();
    getDetails();
  /*  NotificationUtils().listenerEvent(context, () {
      if (!mounted) {
        return;
      }
    }, advisoryID, (value) => value ? setState(() {}) : setState(() => joinFlag = false));*/
    if (!HeaderSingleton().isFirebaseActive && isLoginCompleted == "") {
      isLoginCompleted = "true";
      NotificationUtils().handleAllNotification(HeaderSingleton().navigatorKey, context);
      NotificationUtils().listenForegroundMessage(() => setState(() {}));
    }
    setState(() {});
    super.initState();
  }

  /// Getting profile image from the locale storage.
  Future<String> getProfileImage(BuildContext context) async {
    profileImage = (await SharePrefsHelper.getInstance(context)?.getStringValue("Profile"))!;
    return profileImage;
  }

  /// Getting details from the locale storage.
  Future getDetails() async {
    try {
      // packageInfo = await PackageInfo.fromPlatform();
      paramsMaps = await HeaderSingleton().getUserModel(context);
      userId = await SharePrefsHelper.getInstance(context)?.getStringValue("userId") ?? "";
      headerParams['client_id'] = paramsMaps!.userId!;
      fetchNetCarret();
      // await fetchNetCarret();
      final chatHistoryModel = Provider.of<MenuProvider>(context, listen: false);
      if (chatHistoryModel.page == 1) {
        chatHistoryModel.setCallToggle(0);
      }
      profileImage = await getProfileImage(context);
      getBottomMenu();
      getProfile();
      getNotificationsDetails();
      homeConfigurableDetails().then((value) => setState(() {}));
      HelperUtils().getStatFilter(() => setState(() {}));
      HelperUtils().getProductReport(() => setState(() {}));
      HelperUtils().getTrendingProduct(year: "1", () => setState(() {}));
      setState(() {});
      HelperUtils().initLocation((Tuple2<String, String> item) => HelperUtils().getWeather(item.item1, item.item2, () => setState(() {})), () => {});
      fetchSeason();
    } catch (e) {
      setState(() {});
    }
  }

 /* /// Getting all market product list details from SQFLite.
  Future<List<ProductsList>> getProductList(BuildContext context) async {
    return SQLiteDbProvider.db.getAllProducts();
  }
*/
  /// Getting Configurable home/Dashboard contents from the API.
  Future homeConfigurableDetails() async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.homePage, params: {});
      final result = HomeConfigurableModel.fromJson(json.decode(response.body));
      if (result.status == 1) {
        HeaderSingleton().setConfigDetails(result.configUrl);
        homeConfigurableModel.value = result;
        myCrops = homeConfigurableModel.value!.data!.myCrops!;
      }
    } catch (e) {
      setState(() {});
      rethrow;
    }
  }

  /// Getting all menus list from the locale storage.
  Future<List<Menu>> getMenuList(BuildContext context) async {
    menuList = (await SharePrefsHelper.getInstance(context)?.getMenu())!.cast<Menu>();
    return menuList;
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      isFromHome: "home",
      drawer: Drawer(
          child: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: HeaderSingleton().bottomMenu,
          builder: (BuildContext menuCTX, bottom.BottomMenuModel? value, Widget? child) {
            return value != null
                ? Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: double.maxFinite,
                        decoration: BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!))),
                        child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: ValueListenableBuilder(
                              valueListenable: HeaderSingleton().profileDetails,
                              builder: (ctx, ProfileModel? valueProfile, child) {
                                return valueProfile != null && valueProfile.data != null
                                    ? SizedBox(
                                        height: 300,
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              child: WidgetUtils.appTextWidget(
                                                  context: context,
                                                  title: "${valueProfile.data[0].firstName} ${valueProfile.data[0].lastName}",
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  overflow: TextOverflow.ellipsis,
                                                  family: 'Graphik',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            WidgetUtils.appTextWidget(
                                                context: context, title: "${valueProfile.data[0].phone}", color: Colors.white, fontSize: 14, family: 'Graphik', fontWeight: FontWeight.w300),
                                            SizedBox(
                                                height: 40,
                                                width: 150,
                                                child: WidgetUtils.appTextWidget(
                                                    context: context,
                                                    title: HeaderSingleton().userAddress.isNotEmpty ? HeaderSingleton().userAddress : "${valueProfile.data[0].address1}",
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    overflow: TextOverflow.ellipsis,
                                                    family: 'Graphik')),
                                          ]),
                                          Stack(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  scaffoldKey.currentState!.closeDrawer();
                                                  final result = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ProfileScreen()));
                                                  if (result == null) {
                                                    setState(() {});
                                                  }
                                                },
                                                child: SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child: ClipOval(
                                                    child: (HeaderSingleton().imageValue.value is File)
                                                        ? Image(image: FileImage(HeaderSingleton().imageValue.value), fit: BoxFit.cover)
                                                        : CachedNetworkImage(
                                                            imageUrl: HeaderSingleton().configurationDetails!.partnerImgUrl! + HeaderSingleton().imageValue.value,
                                                            imageBuilder: (context, imageProvider) => Container(
                                                              decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                                                            ),
                                                            placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                                                            errorWidget: (context, url, error) => Image.asset('assets/images/user.png'),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              (homeConfigurableModel.value != null && homeConfigurableModel.value!.configFlag!.showQr!)
                                                  ? Positioned(
                                                      bottom: 3,
                                                      right: 4,
                                                      child: InkWell(
                                                        onTap: () {
                                                          scaffoldKey.currentState!.closeDrawer();
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (ctx) => QRCodeScreen(
                                                                      profileImageUrl: HeaderSingleton().configurationDetails!.partnerImgUrl! + valueProfile.data[0].profileImage!,
                                                                      userName: "${valueProfile.data[0].firstName} ${valueProfile.data[0].lastName}",
                                                                      qrImagePath: HeaderSingleton().qrImage)));
                                                        },
                                                        child: const CircleAvatar(
                                                          backgroundColor: Colors.grey,
                                                          child: Icon(Icons.qr_code, size: 30, color: Colors.black),
                                                        ),
                                                      ))
                                                  : Container()
                                            ],
                                          )
                                        ]),
                                      )
                                    : Container();
                              },
                            )),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: value.data!.sidebarMenu!.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return InkWell(
                              onTap: () async {
                                Navigator.pop(ctx);
                                await HelperUtils().navigateToScreens(
                                    seasonData: seasonData,
                                    context: context,
                                    call: () => setState(() {}),
                                    mapKey: value.data!.sidebarMenu![index].mapKey!,
                                    weather: HeaderSingleton().weatherStreamController.value,
                                    url: netCarretURL);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 10, top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                      SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: SvgPicture.network(value.data!.sidebarMenu![index].icon!,
                                            placeholderBuilder: (ctx) => Image.file(File(image), fit: BoxFit.cover, height: 25, width: 25),
                                            color: Color(int.parse(themeColor.value.iconColor!.color!)),
                                            height: 25,
                                            width: 25),
                                      ),
                                      const SizedBox(width: 20),
                                      WidgetUtils.appTextWidget(
                                          context: context,
                                          title: value.data!.sidebarMenu![index].title!,
                                          family: 'Graphik',
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontSize: 14,
                                          softWrap: true,
                                          textAlign: TextAlign.left),
                                    ]),
                                    const Icon(Icons.keyboard_arrow_right_outlined, size: 30, color: Colors.grey)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      ListTile(
                        dense: true,
                        title: Text(
                          'App version 1.0.0',
                          style: TextStyle(color: Color(int.parse(themeColor.value.barColor!.color!)), fontFamily: 'Graphik'),
                        ),
                      ),
                    ],
                  )
                : Container();
          },
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingButton: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ClipOval(
              child: Image.file(File(image), fit: BoxFit.contain, width: 45, height: 45, errorBuilder: (ctx, obj, st) {
                return Image.asset(HeaderSingleton().splashImage, fit: BoxFit.cover, width: 45, height: 45);
              }),
            ),
            width: 65,
            height: 65,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Color(int.parse(themeColor.value.barColor!.color!))),
                boxShadow: [BoxShadow(color: Color(int.parse(themeColor.value.barColor!.color!)).withOpacity(0.2), spreadRadius: 5, blurRadius: 7, offset: const Offset(0, 2))]),
          )),
      child: Column(
        children: [
          Container(
            // height: MediaQuery.of(context).size.height * 0.3,
            child: Align(
                alignment: Alignment.topCenter,
                child: (homeConfigurableModel.value != null && homeConfigurableModel.value!.configFlag!.showCrop!)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                            // height: 42,
                            width: double.maxFinite,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    HeaderSingleton().imageValue.value != null && HeaderSingleton().configurationDetails != null
                                        ? GestureDetector(
                                            onTap: () {
                                              scaffoldKey.currentState!.openDrawer();
                                            },
                                            child: /*true?Icon(Icons.menu,color: Colors.white,size: 30,):*/ SizedBox(
                                                height: 42,
                                                width: 42,
                                                child: ClipOval(
                                                  child: (HeaderSingleton().imageValue.value is File)
                                                      ? Image(image: FileImage(HeaderSingleton().imageValue.value), fit: BoxFit.cover)
                                                      : CachedNetworkImage(
                                                          imageUrl: HeaderSingleton().configurationDetails!.partnerImgUrl! + HeaderSingleton().imageValue.value,
                                                          imageBuilder: (context, imageProvider) => Container(
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                            ),
                                                          ),
                                                          placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                                                          errorWidget: (context, url, error) => Image.asset('assets/images/user.png'),
                                                        ),
                                                )),
                                          )
                                        : Container(),
                                    const SizedBox(width: 10),
                                    HeaderSingleton().paramsMaps != null
                                        ? WidgetUtils.appTextWidget(
                                            context: context,
                                            title: "Welcome".tr + (HeaderSingleton().profileDetails.value != null ? (" ${HeaderSingleton().profileDetails.value!.data[0].firstName}") : " "),
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            family: 'Graphik')
                                        : const Text(''),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) => ChatBotScreen(
                                                      sellerName:
                                                          (HeaderSingleton().profileDetails.value?.data[0].firstName ?? "") + " " + (HeaderSingleton().profileDetails.value?.data[0].lastName ?? ""))));
                                        },
                                        child: Image.asset(
                                          'assets/images/chat_bot.png',
                                          fit: BoxFit.fill,
                                          height: MediaQuery.of(context).size.height * 0.04,
                                          width: MediaQuery.of(context).size.height * 0.04,
                                        )),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(context, MaterialPageRoute(builder: (ctx) => const PendingNotifications())).then((value) async {
                                          await getNotificationsDetails();
                                          setState(() {});
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          Image.asset('assets/images/new_alert.png',
                                              fit: BoxFit.contain, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.height * 0.05),
                                          notificationResult?.value != null
                                              ? (notificationResult?.value['unread_count'][0]['count'] != "0")
                                                  ? Positioned(
                                                      top: MediaQuery.of(context).size.height * 0.005,
                                                      right: 0,
                                                      child: CircleAvatar(
                                                        radius: 10,
                                                        backgroundColor: Colors.red,
                                                        child: Text(
                                                          notificationResult!.value['unread_count'][0]['count'],
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.w500),
                                                        ),
                                                      ))
                                                  : Positioned(top: MediaQuery.of(context).size.height * 0.005, right: 0, child: Container())
                                              : Container()
                                        ],
                                      ),
                                    ),
                                /*    (homeConfigurableModel.value != null && homeConfigurableModel.value!.configFlag!.showCart!) ? const SizedBox(width: 10) : Container(),
                                    (homeConfigurableModel.value != null && homeConfigurableModel.value!.configFlag!.showCart!)
                                        ? Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10.0),
                                                child: IconButton(
                                                  onPressed: () async {
                                                    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const CartItemsScreen()));
                                                    getProductList(context).then((value) {
                                                      productDetailList.value = value;
                                                      setState(() {});
                                                    });
                                                  },
                                                  icon: const Icon(Icons.shopping_cart, size: 25.0, color: Colors.white),
                                                ),
                                              ),
                                              Provider.of<MarketPlaceProvider>(context, listen: true).cartProductList.isNotEmpty
                                                  ? Positioned(
                                                      top: 8,
                                                      right: 3,
                                                      child: CircleAvatar(
                                                        radius: 10,
                                                        backgroundColor: Colors.red,
                                                        child: Text(
                                                          Provider.of<MarketPlaceProvider>(context, listen: true).cartProductList.length.toString(),
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.w500),
                                                        ),
                                                      ))
                                                  : Container()
                                            ],
                                          )
                                        : Container(),*/
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 17),
                          MySelectedCrops(
                              getCropList: (value) {
                                myCrops = value;
                                setState(() {});
                              },
                              myCrops: myCrops)
                        ],
                      )
                    : homeConfigurableModel.value != null
                        ? Container(
                            margin: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                            // height: 42,
                            width: double.maxFinite,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    HeaderSingleton().imageValue.value != null && HeaderSingleton().configurationDetails != null
                                        ? GestureDetector(
                                            onTap: () {
                                              scaffoldKey.currentState!.openDrawer();
                                            },
                                            child: /*true?Icon(Icons.menu,color: Colors.white,size: 30,):*/ SizedBox(
                                                height: 42,
                                                width: 42,
                                                child: ClipOval(
                                                  child: (HeaderSingleton().imageValue.value is File)
                                                      ? Image(image: FileImage(HeaderSingleton().imageValue.value), fit: BoxFit.cover)
                                                      : CachedNetworkImage(
                                                          imageUrl: HeaderSingleton().configurationDetails!.partnerImgUrl! + HeaderSingleton().imageValue.value,
                                                          imageBuilder: (context, imageProvider) => Container(
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                            ),
                                                          ),
                                                          placeholder: (context, url) => Image.file(File(image), fit: BoxFit.cover),
                                                          errorWidget: (context, url, error) => Image.asset('assets/images/user.png'),
                                                        ),
                                                )),
                                          )
                                        : Container(),
                                    const SizedBox(width: 10),
                                    HeaderSingleton().paramsMaps != null
                                        ? WidgetUtils.appTextWidget(
                                            context: context, title: "Welcome".tr + " ${(HeaderSingleton().profileDetails.value?.data[0].firstName ?? "")}", color: Colors.white, fontSize: 16)
                                        : const Text(''),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) => ChatBotScreen(
                                                        sellerName: (HeaderSingleton().profileDetails.value?.data[0].firstName ?? "") +
                                                            " " +
                                                            (HeaderSingleton().profileDetails.value?.data[0].lastName ?? ""))));
                                          },
                                          child: Image.asset('assets/images/chat_bot.png',
                                              fit: BoxFit.fill, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.height * 0.05)),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () async {
                                          await Navigator.push(context, MaterialPageRoute(builder: (ctx) => const PendingNotifications())).then((value) async {
                                            await getNotificationsDetails();
                                            setState(() {});
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Image.asset('assets/images/new_alert.png',
                                                fit: BoxFit.contain, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.height * 0.05),
                                            notificationResult != null
                                                ? (notificationResult?.value['unread_count'][0]['count'] != "0")
                                                    ? Positioned(
                                                        top: MediaQuery.of(context).size.height * 0.005,
                                                        right: 0,
                                                        child: CircleAvatar(
                                                          radius: 10,
                                                          backgroundColor: Colors.red,
                                                          child: Text(
                                                            notificationResult!.value['unread_count'][0]['count'],
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.w500),
                                                          ),
                                                        ))
                                                    : Positioned(top: MediaQuery.of(context).size.height * 0.005, right: 0, child: Container())
                                                : Container()
                                          ],
                                        ),
                                      ),
                                 /*     (homeConfigurableModel.value != null && homeConfigurableModel.value!.configFlag!.showCart!) ? const SizedBox(width: 10) : Container(),
                                      (homeConfigurableModel.value != null && homeConfigurableModel.value!.configFlag!.showCart!)
                                          ? Stack(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10.0),
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const CartItemsScreen()));
                                                      getProductList(context).then((value) {
                                                        productDetailList.value = value;
                                                        setState(() {});
                                                      });
                                                    },
                                                    icon: const Icon(Icons.shopping_cart, size: 25.0, color: Colors.white),
                                                  ),
                                                ),
                                                Provider.of<MarketPlaceProvider>(context, listen: true).cartProductList.isNotEmpty
                                                    ? Positioned(
                                                        top: MediaQuery.of(context).size.height * 0.005,
                                                        right: 3,
                                                        child: CircleAvatar(
                                                          radius: 10,
                                                          backgroundColor: Colors.red,
                                                          child: Text(
                                                            Provider.of<MarketPlaceProvider>(context, listen: true).cartProductList.length.toString(),
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.w500),
                                                          ),
                                                        ))
                                                    : Container()
                                              ],
                                            )
                                          : Container()*/
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container()),
            decoration: (homeConfigurableModel.value != null && homeConfigurableModel.value!.configFlag!.showCrop!)
                ? BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!)), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)))
                : BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!))),
          ),
          (homeConfigurableModel.value != null && homeConfigurableModel.value!.configFlag!.showCrop!) ? SizedBox(height: MediaQuery.of(context).size.height * 0.037) : Container(),
          const Expanded(child: DashboardScreen()),
        ],
      ),
      bottomNavBar: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: ValueListenableBuilder(
          valueListenable: HeaderSingleton().bottomMenu,
          builder: (BuildContext context, bottom.BottomMenuModel? bottomMenuValue, Widget? child) {
            return Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.08,
              child: bottomMenuValue?.data != null
                  ? ValueListenableBuilder(
                      valueListenable: selectedIndex,
                      builder: (BuildContext context, int value, Widget? child) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            InkWell(
                              onTap: () => onTappedBar(1, bottomMenuValue.data!.bottomMenu![0].title!, bottomMenuValue.data!.bottomMenu![0].mapKey!),
                              child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.network(bottomMenuValue!.data!.bottomMenu![0].icon!,
                                          placeholderBuilder: (ctx) => Image.file(File(image), height: 25, width: 25, fit: BoxFit.fill),
                                          color: /*value == 1 ?*/ Color(int.parse(themeColor.value.iconColor!.color!))/* : Colors.grey*/,
                                          height: 25,
                                          width: 25,
                                          fit: BoxFit.fill),
                                      const SizedBox(height: 6),
                                      WidgetUtils.appTextWidget(
                                        context: context,
                                        title: bottomMenuValue.data!.bottomMenu![0].title!,
                                        family: 'Graphik',
                                        fontSize: 12,
                                        softWrap: true,
                                        color: /*value == 1 ? */Color(int.parse(themeColor.value.barColor!.color!)) /*: Colors.black*/,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => onTappedBar(2, bottomMenuValue.data!.bottomMenu![1].title!, bottomMenuValue.data!.bottomMenu![1].mapKey!),
                              child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.network(bottomMenuValue.data!.bottomMenu![1].icon!,
                                          placeholderBuilder: (ctx) => Image.file(File(image), height: 25, width: 25, fit: BoxFit.fill),
                                          color: /*value == 2 ? Color(int.parse(themeColor.value.iconColor!.color!)) :*/ Colors.grey,
                                          height: 25,
                                          width: 25,
                                          fit: BoxFit.fill),
                                      const SizedBox(height: 6),
                                      WidgetUtils.appTextWidget(
                                          context: context,
                                          title: bottomMenuValue.data!.bottomMenu![1].title!,
                                          family: 'Graphik',
                                          fontSize: 12,
                                          softWrap: true,
                                          color: /*value == 2 ? Color(int.parse(themeColor.value.barColor!.color!)) :*/ Colors.black,
                                          textAlign: TextAlign.center)
                                    ],
                                  )),
                            ),
                            const SizedBox(width: 10),
                            const SizedBox(height: 60, width: 60),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => onTappedBar(4, bottomMenuValue.data!.bottomMenu![3].title!, bottomMenuValue.data!.bottomMenu![3].mapKey!),
                              child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.network(bottomMenuValue.data!.bottomMenu?[3].icon ?? "",
                                          placeholderBuilder: (ctx) => Image.file(File(image), height: 25, width: 25, fit: BoxFit.fill),
                                          color: /*value == 4 ? Color(int.parse(themeColor.value.iconColor!.color!)) :*/ Colors.grey,
                                          height: 25,
                                          width: 25,
                                          fit: BoxFit.fill),
                                      const SizedBox(height: 6),
                                      WidgetUtils.appTextWidget(
                                        context: context,
                                        title: bottomMenuValue.data!.bottomMenu![3].title!,
                                        family: 'Graphik',
                                        fontSize: 12,
                                        softWrap: true,
                                        color:/* value == 4 ? Color(int.parse(themeColor.value.barColor!.color!)) :*/ Colors.black,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => onTappedBar(5, bottomMenuValue.data!.bottomMenu?[4].title ?? "", bottomMenuValue.data!.bottomMenu![4].mapKey!),
                              child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.network(bottomMenuValue.data!.bottomMenu?[4].icon ?? "",
                                          placeholderBuilder: (ctx) => Image.file(File(image), height: 25, width: 25, fit: BoxFit.fill),
                                          color: /*value == 5 ? Color(int.parse(themeColor.value.iconColor!.color!)) :*/ Colors.grey,
                                          height: 25,
                                          width: 25,
                                          fit: BoxFit.fill),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        width: 60,
                                        height: 20,
                                        child: Text(
                                          bottomMenuValue.data!.bottomMenu![4].title!,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Graphik',
                                            fontSize: 12,
                                            color: /*value == 5 ? Color(int.parse(themeColor.value.barColor!.color!)) : */Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ]),
                        );
                      },
                    )
                  : ValueListenableBuilder(
                      valueListenable: selectedIndex,
                      builder: (BuildContext context, int value, Widget? child) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            InkWell(
                              onTap: () => onTappedBar(1, 'Home', 'Home'),
                              child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/Home_fill.png',
                                          color: value == 1 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.black, height: 25, width: 25, fit: BoxFit.fill),
                                      WidgetUtils.appTextWidget(
                                        context: context,
                                        title: 'Home',
                                        family: 'Graphik',
                                        fontWeight: value == 1 ? FontWeight.w500 : FontWeight.w300,
                                        fontSize: 11,
                                        softWrap: true,
                                        color: value == 1 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.black,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => onTappedBar(2, '', ''),
                              child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/category.png',
                                          color: value == 2 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.black, height: 25, width: 25, fit: BoxFit.fill),
                                      WidgetUtils.appTextWidget(
                                        context: context,
                                        title: 'serviceLabel'.tr,
                                        family: 'Graphik',
                                        fontSize: 11,
                                        fontWeight: value == 2 ? FontWeight.w500 : FontWeight.w300,
                                        softWrap: true,
                                        color: value == 2 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.black,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(width: 10),
                            const SizedBox(height: 60, width: 60),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => onTappedBar(4, '', ''),
                              child: SizedBox(
                                  height: 60,
                                  width: 63,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/marketplace.png',
                                          color: value == 4 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.black, height: 25, width: 25, fit: BoxFit.fill),
                                      WidgetUtils.appTextWidget(
                                        context: context,
                                        title: 'MarketPlace',
                                        family: 'Graphik',
                                        fontSize: 11,
                                        fontWeight: value == 4 ? FontWeight.w500 : FontWeight.w300,
                                        softWrap: true,
                                        color: value == 4 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.black,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => onTappedBar(5, "settings", 'settings'),
                              child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/User_fill.png',
                                          color: value == 5 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.black, height: 25, width: 25, fit: BoxFit.fill),
                                      WidgetUtils.appTextWidget(
                                        context: context,
                                        title: 'Settings',
                                        family: 'Graphik',
                                        fontSize: 11,
                                        fontWeight: value == 1 ? FontWeight.w500 : FontWeight.w300,
                                        softWrap: true,
                                        color: value == 5 ? Color(int.parse(themeColor.value.barColor!.color!)) : Colors.black,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                          ]),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  /// Helps to collects the configurable bottom menu's
  Future getBottomMenu() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.appMenu);
      final data = json.decode(response.body);
      final res = bottom.BottomMenuModel.fromJson(data);
      if (res.status == 1) {
        HeaderSingleton().setAppBottomMenu(res);
        HeaderSingleton().setPrivacyPolicy(res.privacy_policy);
        HeaderSingleton().setTermsAndCondtion(res.terms_conditions);
        setState(() {});
      }
    } catch (e) {
      setState(() {});
    }
  }

  /// Fetching net carret view as per the authentication.
  Future fetchNetCarret() async {
    try {
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        final response = await APIService.getAPIMethod(url: ApiURL.ncAuth + "/" + HeaderSingleton().paramsMaps!.phone!);
        final data = json.decode(response.body);
        if (data["status"] == 1) {
          setState(() => netCarretURL = data["data"]);
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  /// This helps to perform the on Tap operation on clicking of menu's
  void onTappedBar(int value, String title, String mapKey) async {
    if (value == 3) return;
    if (value == 1) {
      selectedIndex.value = value;
      return;
    }
    selectedIndex.value = value;
    final data = await HelperUtils().navigateToScreens(seasonData: seasonData, call: () => setState(() {}), context: context, mapKey: mapKey);
    if (data == null) {
      selectedIndex.value = 1;
      homeConfigurableDetails().then((value) => setState(() {}));
    }
    isLoading.value = false;
    setState(() {});
  }

  /// Getting the app theme as per the domain choosen..
  Future getTheme() async {
    try {
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        if (HeaderSingleton().paramsMaps?.userId != null) {
          headerParams['client_id'] = HeaderSingleton().paramsMaps!.userId!;
        }
        final response = await APIService.getAPIMethod(url: ApiURL.dynamicTheme);
        final data = DynamicTheme.fromJson(json.decode(response.body));
        if (data.success == 1 && data.data != null) {
          themeColor.value = data.data!;
        }
      }
    } catch (e) {
      rethrow;
    }
    setStateIfMounted(() {
      isLoading.value = false;
    });
  }

  // Future<List<AdvisoryData>> fetchProduct() async {
  //   // isLoading.value = true;
  //   dynamic productList;
  //   await Future.delayed(const Duration(seconds: 1), () async {
  //     try {
  //       // var headerModel() = Provider.of<HeaderModel()>(context, listen: false);
  //       Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.get_vendor_booked_slot);
  //       // print(fetchSchoolsUri);
  //       Map<String, dynamic> params1 = {"partner_id": paramsMaps!.userId, "crop_id": "", "status": ""};
  //       final response = await http.post(fetchSchoolsUri, body: params1, headers: headerParams);
  //       var data = json.decode(response.body);
  //       Advisory farmerss = Advisory.fromJson(data);
  //       // print(farmerss.toJson());
  //       if (farmerss.status != 1) {
  //         WidgetUtils.errorDialog(context, data["msg"], 3);
  //       } else {
  //         setState(() {
  //           List<AdvisoryData> farmerData = farmerss.data;
  //           if (farmerData != null) {
  //             productList = farmerss.data;
  //           }
  //         });
  //       }
  //     } catch (e) {
  //       // print(e.toString());
  //       // isLoading.value = false;
  //       // WidgetUtils.errorDialog(context, e.toString(),backgroundColor: primaryExtraLight1);
  //     }
  //   });
  //   // isLoading.value = false;
  //
  //   return productList;
  // }
  ///Checking the SMS gateway key for the JITSI calling.
  Future smsGatewayFcmKey() async {
    final FirebaseApp app = await Firebase.initializeApp();
    final DatabaseReference db = FirebaseDatabase.instanceFor(app: app).ref("jitsiCallLog");
    /*db.child(meetingID!).child('ongoingCall').once().then((value) {
      // print(value);
      // print("ongingCall121  "+value.snapshot.value.toString());
      // print("ongingCall121  "+jsonEncode(value.snapshot.value));
      setState(() {
         joinflag = true;
      });
    });*/
    var dbb = FirebaseDatabase.instance.ref("jitsiCallLog").child(meetingID ?? '');
    /*dbb.once().then((snapshot){
      if(snapshot.snapshot.value!=null) {
        Map<dynamic, dynamic> values = snapshot.snapshot.value as Map<dynamic, dynamic>;
        // print("ongingCall121  ");
        // print(values["ongoingCall"].toString());
        if (values["ongoingCall"].toString() == "1") {
          setState(() {
            joinflag = true;
          });
        }
      }
    });*/

    dbb.onValue.listen(
      (DatabaseEvent event) {
        setState(() {
          Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
          if (values["ongoingCall"].toString() == "1") {
            setState(() {
              joinFlag = true;
            });
          } else if (values["ongoingCall"].toString() == "2") {
            _disconnectCall(paramsMaps!.userId, meetingID);
          }
        });
      },
      onError: (Object o) => setState(() {}),
    );
  }

  /// It helps to disconnect call once get called.
  Future<void> _disconnectCall(String? farmerId, String? meetLink) async {
    try {
      // var headerModel() = Provider.of<HeaderModel()>(context, listen: false);
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri getUserDetailsUri = Uri.parse(baseURL + ApiURL.disconnectFarmer);
        var request = http.MultipartRequest('POST', getUserDetailsUri);
        request.headers["client-type"] = "seller";
        request.headers["X-API-KEY"] = HeaderSingleton().xAPIKey.value;
        request.headers["domain"] = HeaderSingleton().domain.value;
        request.headers["appname"] = HeaderSingleton().appName.value;
        request.fields['farmer_id'] = farmerId!;
        request.fields['user_id'] = paramsMaps!.userId!;
        request.fields['meeting_link'] = meetLink!;
        request.fields['call_status_flag'] = "5";
        request.fields['meeting_duration'] = "0";
        request.fields['lead_id'] = advisoryID ?? "";
        http.StreamedResponse streamedResponse = await request.send();
        http.Response response = await http.Response.fromStream(streamedResponse);
        var data = json.decode(response.body);
        // if (data["success"] != 1) {
        // WidgetUtils.errorDialog(context, data["msg"]);
        // } else {
        //WidgetUtils.successDialog(context, data["msg"]);
        // }
        setState(() => joinFlag = false);

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NavigationHomeScreen()), (Route<dynamic> route) => false);
        //fetchProduct();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Getting profile details from SERVER.
  Future getProfile() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getProfile + "/" + HeaderSingleton().paramsMaps!.userId!);
      final data = json.decode(response.body);
      final res = ProfileModel.fromJson(data);
      if (res.status == 1) {
        HeaderSingleton().setProfileDetails(res);
        // Provider.of<ProfileProvider>(context,listen: false).setData(res.data);
        var homeDashboardModel = Provider.of<HomeDashboardProvider>(context, listen: false);
        con.ConfigUrl configUrl = con.ConfigUrl(
            categoryImgUrl: res.configUrl!.categoryImgUrl ?? "",
            partnerImgUrl: res.configUrl!.partnerImgUrl ?? "",
            aadharNoDocUrl: res.configUrl!.aadharNoDocUrl ?? "",
            panNoDocUrl: res.configUrl!.panNoDocUrl ?? "",
            farmImageUrl: res.configUrl!.farmImageUrl ?? "",
            ProductImageUrl: res.configUrl!.productImageUrl ?? "",
            marketCatImageUrl: res.configUrl!.marketCatImageUrl ?? "",
            serviceImageUrl: res.configUrl!.serviceImageUrl ?? "",
            blogsTypesUrl: res.configUrl!.blogsTypesUrl ?? "",
            blogsTagsUrl: res.configUrl!.blogsTagsUrl ?? "",
            createdBlogsUrl: res.configUrl!.createdBlogsUrl ?? "",
            farmerDocumentsUrl: res.configUrl!.farmerDocumentsUrl ?? "",
            advertiseImageUrl: res.configUrl!.advertiseImageUrl ?? "",
            whitelabelImageUrl: res.configUrl!.whitelabelImageUrl ?? "",
            termsSheet: res.configUrl!.termsSheet ?? "",
            farmDoc: res.configUrl!.farmDoc ?? "",
            insuranceCompany: res.configUrl!.insuranceCompany ?? "",
            cropImageUrl: res.configUrl!.cropImageUrl ?? "",
            cropTypeUrl: res.configUrl!.cropTypeUrl ?? "",
            notice: res.configUrl!.notice ?? "",
            announcement: res.configUrl!.announcement ?? "",
            cropHealthPredictApi: res.configUrl!.cropHealthPredictApi ?? "",
            dssModuleImageurl: res.configUrl!.dssModuleImageurl ?? "",
            bottomMenuIcon: res.configUrl!.bottomMenuIcon ?? "",
            cropVerityImgUrl: res.configUrl!.cropVerityImgUrl ?? "",
            cropFertiImgUrl: res.configUrl!.cropFertiImgUrl ?? "",
            soilHealthImage: res.configUrl!.soilHealthImage ?? "");
        homeDashboardModel.setConfigUrl(configUrl);
        setState(() {});
        // Provider.of<ProfileModel>(context, listen: false).setData(res.data);
      }
    } catch (e) {
      setState(() {});
      rethrow;
    }
  }

  /// Fetching season details as per the configuration.
  Future fetchSeason() async {
    try {
      final response = await APIService.getAPIMethod(url: ApiURL.getSeasonList);
      final seasonModel = SeasonModel.fromJson(json.decode(response.body));
      if (seasonModel.status == 1) {
        seasonData = seasonModel.data!;
      }
      setState(() {});
    } catch (e) {
      setState(() {});
      rethrow;
    }
  }
}
