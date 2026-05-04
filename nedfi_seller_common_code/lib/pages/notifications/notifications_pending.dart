import 'package:get/get.dart';

import '../../app_imports.dart';
import '../../model/Notification_model/notifications_list_model.dart';

/**
 * @Author: Ajinkya Aher, Bhushan Lambole
 * @Date: 22-12-2023
 */

class PendingNotifications extends StatefulWidget {
  const PendingNotifications({super.key});

  @override
  State<PendingNotifications> createState() => _PendingNotificationsState();
}

class _PendingNotificationsState extends State<PendingNotifications> {
  ValueNotifier<NotificationListModel?> notificationListModel = ValueNotifier(null);

  @override
  void initState() {
    // TODO: implement initState
    notifyUserNotifications();
    getNotificationsDetails();
    super.initState();
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
            title: WidgetUtils.appTextWidget(context: context,
                title: 'Notifications'.tr,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 20,
                family: 'Graphik'),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: ValueListenableBuilder(
              valueListenable: notificationListModel,
              builder: (BuildContext context, value, Widget? child) {
                return value != null
                    ? (value.notificationData?.isNotEmpty ?? false)
                    ? ListView.builder(
                  itemBuilder: (ctx, index) {
                    String? createdDate;
                    String imageName = (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "profile_completion"
                        ? "assets/images/DefaultAvatar.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "prod_approved_by_admin"
                        ? "assets/images/add_product.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "prod_rejected_by_admin"
                        ? "assets/images/delete_bid.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "updated_prod_approved_by_admin"
                        ? "assets/images/add_product.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "updated_prod_rejected_by_admin"
                        ? "assets/images/delete_bid.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "product_expired"
                        ? "assets/images/delete_bid.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "bid_received"
                        ? "assets/images/add_bid.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "bid_accepted_by_seller"
                        ? "assets/images/add_bid.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "other_buyer_bid_accepted"
                        ? "assets/images/add_bid.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "bid_revoked_by_buyer"
                        ? "assets/images/bid_reject.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "product_bid_expired"
                        ? "assets/images/bid_reject.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "bid_revoked_by_seller"
                        ? "assets/images/bid_reject.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "bid_rejected_by_seller"
                        ? "assets/images/bid_reject.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "product_sold"
                        ? "assets/images/sold.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "other_buyer_bid_sold"
                        ? "assets/images/sold.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "bid_cancelled"
                        ? "assets/images/bid_reject.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "receipt_uploaded"
                        ? "assets/images/upload.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "interest_received"
                        ? "assets/images/icentive_rewarded.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "interest_revoked"
                        ? "assets/images/icentive_rewarded.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "availability_enddate_of_upcoming_product"
                        ? "assets/images/delete_bid.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "availability_enddate_of_upcoming_product"
                        ? "assets/images/delete_bid.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "availability_startdate_of_upcoming_product"
                        ? "assets/images/add_product.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "demand_placed_by_the_buyer "
                        ? "assets/images/demand.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "chat_notification_by_seller"
                        ? "assets/images/chat.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "chat_notification"
                        ? "assets/images/chat.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "update_profile "
                        ? "assets/images/DefaultAvatar.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "buyer_profile_completion "
                        ? "assets/images/DefaultAvatar.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "ticket_created "
                        ? "assets/images/ticket.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "ticket_closed "
                        ? "assets/images/ticket.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "ticket_reopened "
                        ? "assets/images/ticket.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "incentive_awarded "
                        ? "assets/images/incentive_awarded.svg"
                        : (value.notificationData?[index].otherDetails?.mapKey?.toLowerCase() ?? "") == "incentive_redemed "
                        ? "assets/images/incentive_awarded.svg"
                        : "assets/images/bell.svg";
                    final result=value.notificationData?[index].createdOn?.split(".");
                    createdDate=result?[0]??"";
                    return GestureDetector(
                      onTap: () async {
                        isLoading.value = true;
                        setState(() {});
                        await readNotificationsDetails(value.notificationData?[index].notificationId ?? "");
                        await getNotificationsDetails();
                        isLoading.value = false;
                        setState(() {});
                      },
                      child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                              color: value.notificationData?[index].isRead == "1" ? Colors.white : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xffCFCFCF), width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height: 50,
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!)).withOpacity(0.17), borderRadius: BorderRadius.circular(100)),
                                  child: SvgPicture.asset(imageName, height: 24, width: 24)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text( value.notificationData?[index].message?.toString() ?? "", style:const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                    const SizedBox(width: 12),
                                    Padding(
                                      padding: const EdgeInsets.only(top:8.0),
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: WidgetUtils.appTextWidget(
                                              context: context, title: getDateFormat(createdDate), fontSize: 10, fontWeight: FontWeight.w400)),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                    );
                  },
                  itemCount: value.notificationData!.length,
                )
                    : Container()
                    : Center(
                  child: WidgetUtils.appTextWidget(context: context, title: 'No Data Available'.tr),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Getting notification details from API for user.
  Future getNotificationsDetails() async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.userNotifications, params: {'user_id': userId});
      final result = NotificationListModel.fromJson(jsonDecode(response.body));
      if (result.success == 1) {
        notificationListModel.value = result;
        isLoading.value = false;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Reading notifications as per the notification details clicked
  Future readNotificationsDetails(String notificationID) async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.readNotifications, params: {'user_id': userId, 'notification_id': notificationID});
      final result = jsonDecode(response.body);
      if (result['success'] == 1) {
        // WidgetUtils.successDialog(context, result['message']);
        setState(() {});
        // isLoading.value = false;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Reading notifications as per the notification details clicked
  Future notifyUserNotifications() async {
    try {
      await APIService.postAPIMethod(url: ApiURL.notifyUser, params: {'user_id': userId});
    } catch (e) {
      rethrow;
    }
  }

  /// Reading notifications on loading
  Future readNotifications(String notificationId) async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.readNotifications, params: {'user_id': userId, 'notification_id': notificationId});
      final result = NotificationListModel.fromJson(jsonDecode(response.body));
      if (result.success == 1) {
        isLoading.value = false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
