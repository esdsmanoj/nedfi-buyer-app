import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../model/trade_product_model/NewProducts.dart';
import '../../model/ProductResponse.dart';
import '../../model/dynamic_theme.dart' as themeApp;
import '../../model/home_page_model.dart';
import '../../model/trade_product_model/master_listing_model.dart';
import '../../model/trade_product_model/statistics_filter.dart';
import '../../model/trade_product_model/statistics_report_model.dart';
import '../../model/trade_product_model/trade_product_info.dart';
import '../../providers/advisory_provider.dart';
import '../../providers/announcement_provider.dart';
import '../../providers/blog_provider.dart';
import '../../providers/chat_history_provider.dart';
import '../../providers/commodity_provider.dart';
import '../../providers/dss_provider.dart';
import '../../providers/home_dashboard_provider.dart';
import '../../providers/land_crop_advisor.dart';
import '../../providers/loan_provider.dart';
import '../../providers/loan_type_provider.dart';
import '../../providers/market_place_provider.dart';
import '../../providers/master_provider.dart';
import '../../providers/media_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/npk_provider.dart';
import '../../providers/partner_provider.dart';
import '../../providers/user_loan_profile_provider.dart';

const textColor = Color(0xff2f2e3a);
const backgroundColor = Color(0xffF5F6F8);
const cartTextColor = Color(0xffaaaaaa);
const secondaryTextColor = Color(0xff802f2e3a);
const primaryColor = Color(0xff7cb342);
const dropdownBackColor = Color(0xfff5f6f8);
const borderColor = Color(0xff79768d);
const lightBorderColor = Color(0xff8079768d);
const lightShadowColor = Color(0xffe7eaf0);
const profileTextColor = Color(0xff515c6f);
const orderIdColor = Color(0xffaeacba);
const Color primaryExtraLight1 = Color(0xffe1ffb1);
ValueNotifier<bool> isLocation = ValueNotifier(false);

class ColorsConst {
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Colors.white; //Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF3A5160);
  static Color backgroundColor = const Color(0xFFF2F3F8);
}

class GreenTheme {
  static const Color primary = Color(0xff7cb342);
  static const Color primaryDark = Color(0xff4b830d);
  static const Color primaryLight = Color(0xffaee571);
  static const Color primaryExtraLight1 = Color(0xffe1ffb1);
  static const Color primaryExtraLight2 = Color(0xfff8ffd7);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color textColor = Color(0xFFffffff);
  static const Color backgroundColor = Color(0x29F2F2F2);
  static const Color primaryButtonColor = Color(0xfffb8c00);
  static const Color primaryLightButtonColor = Color(0xffffa726);
  static const Color primaryExtraButtonLight1 = Color(0xffffffb0);
  static Color decorationHexColor = HexColor('#6A88E5');
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

Map<String, String> headerParams = {};
RegExp nameRegex = RegExp(r"^[a-zA-Z]+$");
RegExp spacialCharRegexp = RegExp(r"^[_A-z0-9]*((-|\s)*[_A-z0-9])*$");
RegExp expression = RegExp('^[1-9][0-9]{5}');
RegExp nameWithSpaceRegex = RegExp(r"^[a-zA-Z]+(?:\s[a-zA-Z]+)?$");
RegExp aadhaarExpression = RegExp(r'^[2-9]{1}[0-9]{3}\s[0-9]{4}\s[0-9]{4}$');
RegExp panExpression = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
RegExp brnExpression = RegExp(r'^([LUu]{1})([0-9]{5})([A-Za-z]{2})([0-9]{4})([A-Za-z]{3})([0-9]{6})$');
RegExp gstExpression = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
ValueNotifier<HomeConfigurableModel?> homeConfigurableModel = ValueNotifier(null);
ValueNotifier<List<ProductsList>> productDetailList = ValueNotifier([]);
ValueNotifier<List<StatisticsFilterData>> filterData = ValueNotifier([]);
ValueNotifier<List<StatisticsReportData>> productReport = ValueNotifier([]);
ValueNotifier<List<NewProductsData>> treandingproduct = ValueNotifier([]);
ValueNotifier<List<ProductCategory>> productCategory = ValueNotifier([]);
ValueNotifier<dynamic>? notificationResult = ValueNotifier(null);

bool isUserLogged = false;
String imgPlaceHolder = "",
    isLoginCompleted = "",
    statType = "",
    productCategoryTitle = "",
    userId = "",
    isProfileCompleted = "",
    lang = '',
    walkthroughEnabled = '',
    termsEnabled = "",
    lanLocale = "en",
    image = "",
    domainLink = "",
    step1 = "",
    step2 = "",
    step3 = "",
    baseURL = ApiURL.baseURL,
    sellerInvoicePath = "";
ValueNotifier<String> networkImageLogo = ValueNotifier("");
ValueNotifier<int> currentStep = ValueNotifier(1);

PageController pageController = PageController();
int pageNumber = 0;
ValueNotifier<bool> isLoading = ValueNotifier(false);
ValueNotifier<themeApp.Data> themeColor = ValueNotifier(themeApp.Data(
    barColor: themeApp.BarColor(key: "Bar_color", color: "0xff27914F"),
    textColor: themeApp.BarColor(key: "text_color", color: "0xff000000"),
    buttonTextColor: themeApp.BarColor(key: "button_text_color", color: "0xffFFFFFF"),
    iconColor: themeApp.BarColor(key: "icon_color", color: "0xff27914F"),
    hintTextColor: themeApp.BarColor(key: "hint_text_color", color: "0xff27914F"),
    errorLabelColor: themeApp.BarColor(key: "Error_label_color", color: "0xff27914F"),
    subLabelColor: themeApp.BarColor(key: "sublable_color", color: "0xff27914F"),
    buttonColor: themeApp.BarColor(key: "button_color", color: "0xff27914F")));

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
ValueNotifier<List<TradeProductData>?> productData = ValueNotifier(null);
dynamic farmAreaCoordinates;
MasterListing? masterListing;
num areaValue = 0;

List<SingleChildWidget> providerList = [
  ChangeNotifierProvider<MenuProvider>(create: (_) => MenuProvider()),
  ChangeNotifierProvider<ChatHistoryProvider>(create: (_) => ChatHistoryProvider()),
  ChangeNotifierProvider<HomeDashboardProvider>(create: (_) => HomeDashboardProvider()),
  ChangeNotifierProvider<DSSProvider>(create: (_) => DSSProvider()),
  ChangeNotifierProvider<MediaProvider>(create: (_) => MediaProvider()),
  ChangeNotifierProvider<LoanTypeProvider>(create: (_) => LoanTypeProvider()),
  ChangeNotifierProvider<LoanProvider>(create: (_) => LoanProvider()),
  ChangeNotifierProvider<PartnerProvider>(create: (_) => PartnerProvider()),
  ChangeNotifierProvider<AdvisoryProvider>(create: (_) => AdvisoryProvider()),
  ChangeNotifierProvider<BlogsProvider>(create: (_) => BlogsProvider()),
  ChangeNotifierProvider<NPKProvider>(create: (_) => NPKProvider()),
  ChangeNotifierProvider<LandCropProvider>(create: (_) => LandCropProvider()),
  ChangeNotifierProvider<CommodityProvider>(create: (_) => CommodityProvider()),
  ChangeNotifierProvider<UserLoanProfileProvider>(create: (_) => UserLoanProfileProvider()),
  ChangeNotifierProvider<MarketPlaceProvider>(create: (_) => MarketPlaceProvider()),
  ChangeNotifierProvider<NavigationProvider>(create: (_) => NavigationProvider()),
  ChangeNotifierProvider<AnnouncementProvider>(create: (_) => AnnouncementProvider()),
  ChangeNotifierProvider<MasterProvider>(create: (_) => MasterProvider())
];

class ApiURL {
  static String imgPlaceHolder = "assets/images/logo_round.webp";

  // static const baseURL="https://portal.famrut.com/agrieco_api/api/v11/";  // live
  // static const baseURL = "https://portal.famrut.com/agrieco_api/api/v12/"; // live

  static const baseURL = "https://api.nerace.in/api/v16/"; // live
 //  static const baseURL = "https://dev.famrut.com/agri-ecosystem-api/api/v16/"; // Development
  // static const baseURL = "https://dev.famrut.com/agri-ecosystem-api-uat/api/v16/"; // Development

  static const getTermsCondition = "users/settings/terms_conditions";
  static const walkthroughAPI = "users/intro_screen";
  static const isRegistered = "users/is_user_regsitered";
  static const dynamicTheme = "users/dynamic_theme_color";
  static const getNutritionManagement = "users/nutrient_management";
  static const getSeasonList = "users/season_list";
  static const getRegister = "users/register_otp";
  static const getMasterListing = "trade/get_listing";
  static const getTradeProducts = "trade/trade_product";
  static const homePage = "users/home_page";
  static const deleteTradeProduct = "trade/remove_trade_product";
  static const resendOTP = "users/resend_otp";
  static const getLoginOTP = "users/login_otp";
  static const addMyCrops = "users/add_mycrop";
  static const myCropsList = "users/my_crops_list";
  static const deleteCropDetails = "users/delete_client_crop_details";
  static const getMenu = "users/menu";
  static const splashScreen = "users/splash_screen";
  static const getPartnerCategories = "users/partner_categories";
  static const disconnectFarmer = "users/disconnect_farmer";
  static const startMeetingCall = "users/start_call_meeting";
  static const farmerList = "users/enquiry_list";
  static const getChatData = "users/user_chat";
  static const addChat = "users/add_user_chat";
  static const userLogout = "users/logout_check";
  static const getPartnerServices = "users/partner_services";
  static const aboutUs = "users/about_us";
  static const getAadhaarOTP = "users/get_aadhar_otp";
  static const verifyAadhaarOTP = "users/get_aadhar_verification";
  static const verifyPAN = "users/get_pan_verification";
  static const verifyBankDetail = "users/get_bank_verification";
  static const getFarmerBookedSlot = "users/farmer_booked_slot";
  static const getPartnerDashboard = "users/partner_dashboard";
  static const getCategories = "users/categories";
  static const advertise = "users/advertise";
  static const getCropsList = "users/crop_list";
  static const deleteMyCrop = "users/delete_mycrop";
  static const getLanguage = "users/language_list";
  static const npkRecommend = "users/recommended_npk";
  static const macro_micronutrient_cal = "users/macro_micronutrient_cal";
  static const getMediaList = "users/media_list";
  static const getMediaListType = "users/mediatype_list";
  static const getLoanType = "users/loan_types";
  static const addLoanDetailsNew = "users/add_loan_details"; //add_loan_details_new
  static const getCountries = "users/countries";
  static const getStates = "users/states";
  static const getCities = "users/city";
  static const getPartners = "users/partner_list";

  // static const addUserLeads = "users/add_user_leads";
  static const addUserLeads = "users/add_service_leads";
  static const eKYCStatus = "users/get_ekyc_verification_status";
  static const addProductLeads = "users/add_product_leads";
  static const getMyLoan = "users/my_loan";
  static const getAgronomistCrops = "users/agronomist_crops";
  static const getAgronomist = "users/agronomist";
  static const addVendorCallLeads = "users/add_vendor_call_leads";
  static const allBlogDetails = "users/all_blogs_details";
  static const getBlogType = "users/blogs_types";
  static const getBlogDetails = "users/blogs_details";
  static const addServiceLeads = "users/add_service_leads";

  // static const getCropNPK = "users/crop_npk";
  static const cropNPKDetails = "users/crop_npks_details";
  static const dssModule = "users/dss_module";
  static const getMyLandDetail = "users/my_land";
  static const getMasterData = "users/master_data";
  static const addLandDetailsNew = "users/add_land_details_new";
  static const updateLandDetails = "users/update_land_details";
  static const getLandDetailNew = "users/land_detail";
  static const getCropBlogsDetails = "users/crop_blogs_details";
  static const getCropAllBlogs = "users/all_blogs_details";
  static const updateCropDetails = "users/update_crop_details";
  static const addCropDetails = "users/add_crop_details";
  static const showCropCalendar = "users/show_crop_calander";
  static const cropVarietyMaster = "users/crop_variety_master";
  static const soilHealthCardDetails = "users/soil_healthcard_details";
  static const getCropComponent = "users/crop_components";
  static const cropDiseaseDetectionFiltered = "users/crop_disease_list_filter";
  static const nearByMarket = "users/nearby_market";
  static const nearByMarketNewData = "users/nearby_market_all_data_new";
  static const getMarkets = "users/markets";
  static const getMarketsList = "/chat/market_list";
  static const getStateList = "chat/commodity_state";
  static const sellerMarket = "users/saller_markets";
  static const getProfile = "users/profile";
  static const getUserProfile = "users/user_profile";
  static const getKYCStatus = "users/get_ekyc_verification_status";
  static const approvalSteps = "users/approval_steps";
  static const getMyLoans = "users/my_loan_new"; //my_loan_new
  static const ncAuth = "users/nc_auth";
  static const getProductCategoryEcom = "users/product_category_eccom";
  static const getAllProductWithPagination = "users/all_products_with_pagination";
  static const cropDeleteDetails = "users/delete_crop_details";
  static const deleteLandCrop = "users/delete_land_crop";
  static const commodityDetailsDataNew = "users/commodity_details_data_new";
  static const getOrderList = "users/order_list";
  static const addClientOrder = "users/add_client_order";
  static const updateProfile = "users/update_profile";
  static const profileStep1 = "users/complete_profile";
  static const documentUploadSteps = "users/document_upload_steps";
  static const getAnnouncement = "users/announcement";
  static const getNotice = "users/notice";
  static const announcementDetails = "users/announcement_details";
  static const noticeDetails = "users/notice_details";
  static const dynamicDomainDBConnection = "users/dynamic_domain_db_connection";
  static const productListing = "users/products_listing";
  static const generateReferralCode = "users/generate_referral_code";
  static const userOrderDetails = "users/user_order_details";
  static const clientChoice = "users/client_choice";
  static const checkPickupLocation = "users/check_pickup_location";
  static const checkReferralCode = "users/check_referral_code";
  static const homeProductsWithPagination = "users/home_products_with_pagination";
  static const homeAdvertise = "users/home_advertise";
  static const checkProductStock = "users/chk_product_stock";
  static const paymentGenerateOrder = "/payment/generate_order";
  static const paytmPaymentGenerateOrder = "/paytm_payment/generate_order";
  static const orderBeforeTime = "users/settings/order_before_time";
  static const statesCropWise = "users/states_crop_wise";
  static const paymentGateway = "users/payment_gateway";
  static const dynamicCropParams = "users/select_crop_params";
  static const varietyFilteredData = "users/crop_variety_master_filtered";
  static const paymentStatus = "payment/payment_status";
  static const cropCalendarData = "users/show_crop_calander_data";
  static const appMenu = "users/all_menu";
  static const updateClientOrder = "users/update_client_order";
  static const delivery_charges = "users/settings/delivery_charges";
  static const verifyPayments = "users/verify_payments";
  static const add_farm_new = "users/add_farm_new";
  static const edit_farm_new = "users/edit_farm_new";
  static const payment_status = "users/payment_status"; //payment
  static const show_crop_calander_data = "users/show_crop_calander_data";
  static const all_menu = "users/all_menu";
  static const update_client_order = "users/update_client_order";
  static const client_delivery_address = "users/client_delivery_address";
  static const crop_calender_action = "users/crop_calender_action";

  //Seller
  static const get_farmer_crop_list = "farmer/get_crop_list";
  static const get_farmer_crop_variety_get = "farmer/get_crop_variety";
  static const addCropProduct = "farmer/add_crop_product";
  static const getCropVarietyPrice = "farmer/get_crop_variety_price";
  static const getFarmerProduct = "farmer/get_farmer_product";
  static const updateCropProductStatus = "farmer/update_crop_product_status";
  static const getFarmerProductInvoice = "farmer/get_farmer_product_invoice";
  static const productInvoiceList = "farmer/product_invoice_list";
  static const getFarmerDashboard = "farmer/get_farmer_dashboard";
  static const getFarmerProfile = "farmer/get_farmer_profile";
  static const checkProfile = "farmer/chk_profile";
  static const getCropVariety = "farmer/get_crop_variety";
  static String imgGIF = "assets/images/leafrs.gif";
  static const sellerDelete = "users/delete_seller";
  static const checkActive = "users/logout_seller";

  ///trade product API.
  static const biddingList = "trade/trade_bidding";
  static const sellerAction = "trade/seller_action";
  static const selfSold = "trade/self_sold";
  static const productType = "trade/product_type";
  static const productData = "trade/product_data";
  static const productVariety = "trade/product_variety";
  static const packagingList = "trade/packaging_list";
  static const addTradeProduct = "trade/add_trade_product";
  static const storageType = "trade/storage_type";
  static const uploadTradeImages = "trade/upload_trade_images";
  static const tradeProduct = "trade/trade_product";
  static const tradeIncentives = "trade/incentive_list";
  static const applyIncentive = "trade/apply_for_incentive";
  static const uploadInvoice = "trade/upload_invoice";
  static const getListing = "trade/get_listing";
  static const getHomeFilter = "trade/get_home_filter";
  static const getProductReport = "trade/trade_product_report";
  static const removeImage = "trade/remove_image";
  static const upcomingProductList = "trade/upcoming_product_list";
  static const buyersDemandProductList = "trade/buyers_demand_product_list";
  static const buyersInterestProductList = "trade/buyers_interest_product_list";
  static const incentiveBeneficiariesList = "users/incentive_beneficiaries_list/";
  static const marketableSurplus = "trade/marketable_surplus";
  static const trendingProduct = "buyer/trending_product";
  static const commodityPrice = "chat/commodity_price";
  static const productRating = "buyer/add_trade_product_rating";
  static const productList = "/trade/product_list";

  /// Chat Module API
  static const userBidChat = "chat/user_chat";
  static const manageChatList = "chat/manage_chat";
  static const addBidUserChat = "chat/add_user_chat";
  static const getChatBot = "chat/chat_bot";

  /// Notification module API.
  static const userNotifications = 'notification/userwise_notification_data';
  static const notifyUser = 'notification/notifyuser';
  static const readNotifications = 'notification/read_notification';
  static const notificationCount = 'notification/userwise_notification_count';
}

const paymentURL = "YOUR_FUNCTIONS_URL/payment";

const orderData = {"custID": "USER_1122334455", "custEmail": "someemail@gmail.com", "custPhone": "7777777777"};

const statusLoading = "PAYMENT_LOADING";
const statusSuccessful = "PAYMENT_SUCCESSFUL";
const statusPending = "PAYMENT_PENDING";
const statusFailed = "PAYMENT_FAILED";
const statusChecksumFailed = "PAYMENT_CHECKSUM_FAILED";

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
