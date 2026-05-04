import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:buyer_common_code/components/utils/NotificationTopics.dart' as notification;
import 'package:buyer_common_code/pages/helpdesk/helpdesk_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_callkit_incoming/entities/android_params.dart';
// import 'package:flutter_callkit_incoming/entities/call_event.dart';
// import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
// import 'package:flutter_callkit_incoming/entities/ios_params.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../app_imports.dart';
import '../../model/home_page_model.dart';
import '../../pages/marketPlace/nedfi_products/manage_trade_product_details.dart';
import '../../pages/marketPlace/seller/AddProductDetailsScreen.dart';
import '../../pages/notice/AnnouncementDetailScreen.dart';
import '../../pages/webView/PWAIframe.dart';
import '../../pages/webView/video_meeting_screen.dart';

/**
 * @Author: Ajinkya Aher, Bhushan Lambole
 * @Date: 19-12-2023
 */

class NotificationUtils {
  dynamic _currentUuid;
  final _uuid = const Uuid();
  bool schedulesFullControl = false;
  Map<NotificationPermission, bool> scheduleChannelPermissions = {};
  List<NotificationPermission> channelPermissions = [NotificationPermission.FullScreenIntent];

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  /// Handling background message and notification messages.
  Future getNotificationBackground(final message) async {
    try {
      if (message.data.containsKey("type")) {
        dynamic result;
        if (message.data['custom_array'] != null) {
          result = jsonDecode(message.data['custom_array'].toString());
        }

        var body = message.data['type'];
        Map<String, String> params = {
          "send_from_id": result["from_id"] ?? "",
          "trade_prod_id": result["trade_id"] ?? "",
          "meeting_link": message.data["meeting_link"] ?? "",
          "farmer_id": message.data["farmer_id"] ?? "",
          "farmer_image": message.data["farmer_image"] ?? "",
          "route": message.data["route"] ?? "",
          "body": message.data["body"] ?? "",
          "id": message.data["id"] ?? "",
          "title": message.data['title'] ?? "",
          "image": message.data['image'] ?? ""
        };
        if (body == NotificationTopics.video) {
          makeFakeCallInComing(params);
        } else {
          createNotification(message, params);
        }
      }

      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          dynamic result;
          if (message.data['custom_array'] != null) {
            result = jsonDecode(message.data['custom_array'].toString());
          }
          Map<String, String> params = {
            "send_from_id": result["from_id"] ?? "",
            "trade_prod_id": result["trade_id"] ?? "",
            "meeting_link": message.data["meeting_link"] ?? "",
            "farmer_id": message.data["farmer_id"] ?? "",
            "farmer_image": message.data["farmer_image"] ?? "",
            "route": message.data["route"] ?? "",
            "body": message.data["body"] ?? "",
            "id": message.data["id"] ?? "",
            "title": message.data['title'] ?? "",
            "image": message.data['image'] ?? ""
          };
          String routePage = message.data["route"] ?? "";
          if (routePage == NotificationTopics.video) {
            makeFakeCallInComing(params);
          } else {
            createNotification(message, params);
          }
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Creating the default notification.
  Future createNotification(final message, final params, {bool isStatus = false}) async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: message.hashCode,
      channelKey: "new_channel",
      title: message.data["title"],
      body: message.data["body"],
      payload: params,
      bigPicture: isStatus ? message.data["image"] : null,
      notificationLayout: isStatus ? NotificationLayout.BigPicture : null,
    ));
  }

  ///Initializing values and permission for notifications
  Future<void> initialiseValuesAndPermissions() async {
    AwesomeNotifications().initialize(
      'resource://drawable/nerace',
      [
        NotificationChannel(
            channelKey: 'new_channel',
            channelName: 'New Channel',
            channelDescription: 'Channel with call ringtone',
            defaultColor: const Color(0xFFFFFFFF00),
            importance: NotificationImportance.High,
            ledColor: Colors.white,
            channelShowBadge: true,
            locked: false,
            playSound: false,
            enableVibration: true,
            vibrationPattern: mediumVibrationPattern,
            defaultRingtoneType: null)
      ],
    );

    if (!kIsWeb) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

      await FirebaseMessaging.instance.requestPermission(alert: true, announcement: true, badge: true, carPlay: false, criticalAlert: true, provisional: false, sound: true);

      // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }
  }

  Future listenForegroundMessage(Function callBack) async {
    HeaderSingleton().isFirebaseActive = true;

    ///foreground work
    FirebaseMessaging.onMessage.listen((message) async {
      if (message != null && isLoginCompleted == "true") {
        dynamic result;
        if (message.data['custom_array'] != null) {
          result = jsonDecode(message.data['custom_array'].toString());
        }

        Map<String, String> params = {
          "send_from_id": result["from_id"] ?? "",
          "trade_prod_id": result["trade_id"] ?? "",
          "meeting_link": message.data["meeting_link"] ?? "",
          "farmer_id": message.data["farmer_id"] ?? "",
          "farmer_image": message.data["farmer_image"] ?? "",
          "route": message.data["route"] ?? "",
          "body": message.data["body"] ?? "",
          "id": message.data["id"] ?? "",
          "title": message.data['title'] ?? ""
        };

        String routePage = message.data["type"] ?? "";
        if (routePage == notification.NotificationTopics.VIDEO) {
          makeFakeCallInComing(params);
        } else {
          await NotificationUtils().createNotification(message, params);
        }
      }
    });
    refreshScheduleChannelPermissions(callBack);
  }

  /// helps to remind water notification for the user.
  Future<void> createWaterReminderNotification(int hashCode, String map) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: hashCode,
        channelKey: 'new_channel',
        title: '${Emojis.food_onion} $map',
        body: 'Click on notification to receive video call.',
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'accept',
          label: 'Accept',
        ),
        NotificationActionButton(
          key: 'reject',
          label: 'Reject',
        )
      ],
    );
    late Map<String, String> params;
    AwesomeNotifications().actionStream.listen((notification) {
      params = notification.payload!;
      if (params["route"] == NotificationTopics.chat) {
        // Navigator.push(
        //   navigatorKey!.currentContext!,
        //   MaterialPageRoute(
        //       builder: (context) => ChatScreen(
        //         params["farmer_id"]!,
        //         params["farmer_image"]!,
        //       )),
        // );
      } else if (params["route"] == NotificationTopics.video) {
        if (notification.buttonKeyPressed == "accept") {
          if (params.isNotEmpty) {
            /*Navigator.push(navigatorKey!.currentContext!,
              new MaterialPageRoute(builder: (context) => HomeScreen()));*/
          }
        } else if (notification.buttonKeyPressed == "cancel") {
          //_disconnectCall(params["farmer_id"], params["meeting_link"]);
        }
      }
    });
  }

  /// Calling a fake notification for incoming call
  Future<void> makeFakeCallInComing(Map<String, String> para) async {
    await Future.delayed(const Duration(seconds: 1), () async {
      _currentUuid = _uuid.v4();
      var names = para["partner_name"]?.replaceAll(" ", "+") ?? "F+R";
      /* var paramss = CallKitParams(
          id: _currentUuid,
          nameCaller: para["body"],
          appName: 'AgriEco vendor',
          avatar: "https://eu.ui-avatars.com/api/?name=" + names + "&size=100",
          handle: '',
          type: 1,
          duration: 30000,
          extra: para,
          headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
          android: AndroidParams(
              isCustomNotification: true,
              isShowLogo: true,
              ringtonePath: 'ringtone_default',
              backgroundColor: '#0955fa',
              backgroundUrl: "https://eu.ui-avatars.com/api/?name=" + names + "&size=250",
              actionColor: '#4CAF50'),
          ios: IOSParams(
              iconName: 'AppIcon40x40',
              handleType: '',
              supportsVideo: true,
              maximumCallGroups: 2,
              maximumCallsPerCallGroup: 1,
              audioSessionMode: 'default',
              audioSessionActive: true,
              audioSessionPreferredSampleRate: 44100.0,
              audioSessionPreferredIOBufferDuration: 0.005,
              supportsDTMF: true,
              supportsHolding: true,
              supportsGrouping: false,
              supportsUngrouping: false,
              ringtonePath: 'Ringtone.caf'));
      await FlutterCallkitIncoming.showCallkitIncoming(paramss);*/
    });
  }

  /// Refreshing the scheduled channel permission.
  void refreshScheduleChannelPermissions(Function callBack) {
    AwesomeNotifications().checkPermissionList(channelKey: 'new_channel', permissions: channelPermissions).then((List<NotificationPermission> permissionsAllowed) {
      schedulesFullControl = true;
      for (NotificationPermission permission in channelPermissions) {
        scheduleChannelPermissions[permission] = permissionsAllowed.contains(permission);
        schedulesFullControl = schedulesFullControl && scheduleChannelPermissions[permission]!;
      }
      callBack.call();
    });
  }

  ///Handling all the new notification received in the device.
  Future handleAllNotification(final navigatorKey, BuildContext context) async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    try {
      AwesomeNotifications().actionStream.listen((ReceivedNotification receivedNotification) {
        print(receivedNotification.payload);
        if (receivedNotification.payload!["route"]?.toLowerCase() == notification.NotificationTopics.CHAT.toString().toLowerCase()) {
          Navigator.push(
            navigatorKey!.currentContext ?? context,
            // MaterialPageRoute(builder: (context) => ChatScreen(receivedNotification.payload!["farmer_id"]!, receivedNotification.payload!["partner_name"]! ?? 'Default', "chat")),
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      buyerId: receivedNotification.payload!["send_from_id"]!,
                      (HeaderSingleton().profileDetails.value?.data[0].firstName ?? "") + " " + (HeaderSingleton().profileDetails.value?.data[0].lastName ?? ""),
                      "bid",
                      /*isManage: 'manage',*/
                      prodId: receivedNotification.payload!["id"],
                      tradeProductBiddingId: receivedNotification.payload!["trade_prod_id"],
                    )),
          );
        } else if (receivedNotification.payload!["route"].toString().toLowerCase() == "helpdesk") {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => const HelpDeskScreen()));
        } else if (receivedNotification.payload!["route"].toString().toLowerCase() == "product_details") {
          print("payload:${receivedNotification.payload!}");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => ManageTradeProductDetails(
                      productId: receivedNotification.payload!["id"].toString(), productTitle: receivedNotification.payload!["product_title"].toString(), isFrom: 'manage_product')));
        } else if (receivedNotification.payload!["route"].toString().toLowerCase() == "profile") {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ProfileScreen()));
        } else if (receivedNotification.payload!["route"].toString().toLowerCase() == notification.NotificationTopics.Notice.toString().toLowerCase()) {
          var notice = AnnouncementData(
            id: receivedNotification.payload!["id"].toString(),
            title: '',
            description: '',
            isNotificationSent: '',
            priorityType: '',
            createdOn: '',
            updatedOn: '',
            deletedOn: '',
            isDeleted: '',
            isActive: '',
            createdById: '',
          );
          Navigator.push(navigatorKey!.currentContext!, MaterialPageRoute(builder: (context) => AnnouncementDetailScreen(notice, "", "Notice", "")));
        } else if (receivedNotification.payload!["route"].toString().toLowerCase() == notification.NotificationTopics.Announcement.toString().toLowerCase()) {
          var notice = AnnouncementData(
            id: receivedNotification.payload!["id"].toString(),
            title: '',
            description: '',
            isNotificationSent: '',
            priorityType: '',
            createdOn: '',
            updatedOn: '',
            deletedOn: '',
            isDeleted: '',
            isActive: '',
            createdById: '',
          );
          Navigator.push(navigatorKey!.currentContext, MaterialPageRoute(builder: (context) => AnnouncementDetailScreen(notice, "", "Announcement", "")));
        } else if (receivedNotification.payload!["route"].toString().toLowerCase() == notification.NotificationTopics.order.toString().toLowerCase()) {
          final orderData = MyOrderData(
            id: receivedNotification.payload!["id"].toString(),
            clientId: '',
            invoiceId: '',
            orderNum: '',
            planId: '',
            qty: '',
            planDetails: '',
            orderDate: '',
            nextInvoiceDate: '',
            status: '',
            createdById: '',
            createdOn: '',
            updatedById: '',
            updatedOn: '',
            deletedById: '',
            isDeleted: '',
            deletedOn: '',
            minFrequency: '',
            orderCompletionDate: '',
            ipaddress: '',
            promoCode: '',
            promoType: '',
            promoValue: '',
            remark: '',
            billingAddress1: '',
            billingCity: '',
            billingPinCode: '',
            shippingAddress1: '',
            shippingCity: '',
            shippingState: '',
            shippingPinCode: '',
            firstName: '',
            lastName: '',
            companyName: '',
            emailId: '',
            billingVillage: '',
            cphone: '',
            billingCountry: '',
            shippingCountry: '',
            billingState: '',
            paymentMethod: '',
            payment_status: '',
            amount: '',
          );
          Navigator.push(navigatorKey!.currentContext!, MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderData)));
        } else if (receivedNotification.payload!["route"].toString().toLowerCase() == notification.NotificationTopics.Blog.toLowerCase()) {
          final blogData = Blogs(
              blogsId: receivedNotification.payload!["id"].toString(),
              logo: receivedNotification.payload!["image"].toString(),
              blogsTagsId: '',
              blogsTypesId: '',
              blogsTitle: receivedNotification.payload!["title"].toString(),
              blogsSubTitle: '',
              id: '',
              blogsSubDescription: receivedNotification.payload!["body"].toString(),
              blogsDescription: receivedNotification.payload!["body"].toString(),
              blogsCreatedOn: '',
              blogsTypesName: '',
              blogsTypesLogo: '',
              blogsTypesMobIcon: '',
              blogsTypesNameMr: '');
          Navigator.push(navigatorKey!.currentContext!, MaterialPageRoute(builder: (context) => BlogsDetailsScreen(blogData, baseURL, categorySelected: 'All'.tr + " " + 'Blogs'.tr)));
        } else if (receivedNotification.payload!["route"].toString().toLowerCase() == notification.NotificationTopics.product.toLowerCase()) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductDetailsScreen()));
        } else if (receivedNotification.payload!["route"].toString().toLowerCase() == notification.NotificationTopics.myOrders.toLowerCase()) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PWAIFrame(routeName: 'myorders')));
        } else {}
      });
    } catch (e) {
      // print(e);
    }
  }

  /// This helps to listens the events as per the notifications comes in foreground/background
  Future<void> listenerEvent(BuildContext context, Function callBack, String? advisoryID, Function(bool) stateCallBack) async {
    try {
      /* FlutterCallkitIncoming.onEvent.listen((event) async {
        Map<String, String> params = Map<String, String>.from(event?.body["extra"]);
        callBack.call();
        switch (event!.event) {
          case Event.ACTION_CALL_INCOMING:
            break;
          case Event.ACTION_CALL_START:
            // TODO: started an outgoing call
            // TODO: show screen calling in Flutter
            break;
          case Event.ACTION_CALL_ACCEPT:
            VideoCall video = VideoCall();
            video.title = params["meeting_link"];
            video.meeting_link = params["meeting_link"];
            video.farmer_id = params["farmer_id"];
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VideoMeetingIFrame(
                        farmerId: video.farmer_id, userId: HelperUtils().paramsMaps.userId ?? "", meetingID: video.meeting_link ?? "", name: HelperUtils().paramsMaps.firstName ?? "")));
            // _joinMeeting(video, paramsMaps["farmer_id"] ?? "");
            break;
          case Event.ACTION_CALL_DECLINE:
            stateCallBack.call(true);
            final details = await _disconnectCall(params["farmer_id"], params["meeting_link"], advisoryID, context);
            if (details != null) {
              stateCallBack.call(true);
            }
            break;
          case Event.ACTION_CALL_ENDED:
            // TODO: ended an incoming/outgoing call
            break;
          case Event.ACTION_CALL_TIMEOUT:
            // TODO: missed an incoming call
            break;
          case Event.ACTION_CALL_CALLBACK:
            // TODO: only Android - click action `Call back` from missed call notification
            break;
          case Event.ACTION_CALL_TOGGLE_HOLD:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_MUTE:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_DMTF:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_GROUP:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
            // TODO: only iOS
            break;
          case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
            // TODO: Handle this case.
            break;
        }
      });*/
    } on Exception {
      rethrow;
    }
  }

  ///  Helps to disconnect the call when user taps on cancel.
  Future _disconnectCall(String? farmerId, String? meetLink, String? advisoryID, BuildContext context) async {
    try {
      // var headerModel() = Provider.of<HeaderModel()>(context, listen: false);
      String connectionServerMsg = NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri getUserDetailsUri = Uri.parse(baseURL + ApiURL.disconnectFarmer);
        var request = http.MultipartRequest('POST', getUserDetailsUri);
        request.headers["client-type"] = "buyer";
        request.headers["X-API-KEY"] = HeaderSingleton().xAPIKey.value;
        request.headers["domain"] = HeaderSingleton().domain.value;
        request.headers["appname"] = HeaderSingleton().appName.value;
        request.fields['farmer_id'] = farmerId!;
        request.fields['user_id'] = HelperUtils().paramsMaps.userId!;
        request.fields['meeting_link'] = meetLink!;
        request.fields['call_status_flag'] = "5";
        request.fields['meeting_duration'] = "0";
        request.fields['lead_id'] = advisoryID ?? "";
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        var data = json.decode(response.body);
        if (data["success"] != 1) {
          WidgetUtils.errorDialog(context, data["msg"]);
        } else {
          WidgetUtils.successDialog(context, data["msg"]);
        }
        return data;
        //fetchProduct();
      }
    } catch (e) {
      // print(e);
    }
  }
}
