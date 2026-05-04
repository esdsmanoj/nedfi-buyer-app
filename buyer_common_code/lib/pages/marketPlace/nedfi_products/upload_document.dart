import 'package:buyer_common_code/pages/marketPlace/nedfi_products/incentive_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../app_imports.dart';
import '../../../model/view_receipt_model.dart';

class UploadDocument extends StatefulWidget {
  final String buyerName, bidderId, productId, bidDate, isFrom;

  const UploadDocument({super.key, required this.buyerName, required this.bidderId, required this.productId, required this.bidDate, this.isFrom = "upload"});

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  int? statusColor;
  String? addedDate, expiredDate;
  File? imagePath;
  ViewReceiptModel? viewReceipt;

  @override
  void initState() {
    changeStatusColor();
    if (widget.isFrom == "view") {
      isLoading.value = true;
      setState(() {});
      getBiddingDetails();
      isLoading.value = false;
      setState(() {});
    }
    super.initState();
  }

  Future getBiddingDetails() async {
    try {
      final params = {'product_id': widget.productId, 'start': '1', 'id': widget.bidderId};
      //print(params);
      final response = await APIService.postAPIMethod(url: ApiURL.biddingList, params: params);
      ViewReceiptModel viewReceiptModel = ViewReceiptModel.fromJson(jsonDecode(response.body));
      //print(response.body);
      //print(sellerInvoicePath+"/");
      if (viewReceiptModel.success == 1) {
        viewReceipt = viewReceiptModel;
      }
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  changeStatusColor() {
    statusColor = productData.value != null
        ? productData.value![0].statusTitle!.toLowerCase() == "pending"
        ? 0xffE8C600
        : productData.value![0].statusTitle!.toLowerCase() == "live"
        ? 0xff27914F
        : productData.value![0].statusTitle!.toLowerCase() == "rejected"
        ? 0xffE70000
        : productData.value![0].statusTitle!.toLowerCase() == "completed"
        ? 0xff0074E8
        : productData.value![0].statusTitle!.toLowerCase() == "expired"
        ? 0xFF808080
        : productData.value![0].statusTitle!.toLowerCase() == "sold"
        ? 0xffE88700
        : 0xffffffff
        : 0xffffffff;
  }

  @override
  Widget build(BuildContext context) {
    addedDate = getDateFormat(productData.value![0].addedDate!);
    expiredDate = getDateFormat(productData.value![0].expiryDate!);

    return SafeArea(
        child: CustomProgressHandler(
          loadingText: '',
          isLoading: isLoading.value,
          child: Scaffold( backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
              title: WidgetUtils.appTextWidget(context: context, title: 'View Receipt'.tr, fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20, family: 'Graphik'),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            WidgetUtils.appTextWidget(context: context, title: productData.value![0].productTitle!, color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20, family: 'Graphik'),
                            const SizedBox(width: 4),
                            Container(
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color(statusColor!)),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child:
                              WidgetUtils.appTextWidget(context: context, title: productData.value![0].statusTitle!, fontWeight: FontWeight.w500, color: Colors.white, fontSize: 12, family: 'Graphik'),
                            )
                          ],
                        ),
                        WidgetUtils.appTextWidget(
                            context: context,
                            title: "₹${productData.value![0].price!}/${productData.value![0].priceUnitTitle!}",
                            color: const Color(0xffFDA11E),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            family: 'Graphik'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            WidgetUtils.appTextWidget(context: context, title: "Variety -".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                            const SizedBox(width: 4),
                            WidgetUtils.appTextWidget(
                                context: context, title: productData.value![0].productVarietyTitle!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                          ],
                        ),
                        Row(
                          children: [
                            WidgetUtils.appTextWidget(context: context, title: "Type -".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                            const SizedBox(width: 4),
                            WidgetUtils.appTextWidget(
                                context: context, title: productData.value![0].productTypeTitle!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                          ],
                        ),
                      ],
                    ),
                    // const SizedBox(height: 1),
                    const Divider(),
                    // const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(context: context, title: "Quantity".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                        WidgetUtils.appTextWidget(
                            context: context,
                            title: (productData.value?[0].sellQty ?? "0")! + " " + (productData.value?[0].priceUnitTitle! ?? ""),
                            color: const Color(0xff3F3F3F),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            family: 'Graphik'),
                      ],
                    ),
                    // const SizedBox(height: 1),
                    const Divider(),
                    // const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(context: context, title: "Added".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                        WidgetUtils.appTextWidget(context: context, title: addedDate!, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                      ],
                    ),
                    // productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
                    productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const Divider() : Container(),
                    // productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
                    productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed"
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(context: context, title: "Bid Date".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                        WidgetUtils.appTextWidget(context: context, title:getDateFormat( productData.value![0].bidPlaceDate ?? ""), color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                      ],
                    )
                        : Container(),
                    // productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 1) : Container(),
                    productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const Divider() : Container(),
                    // productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed" ? const SizedBox(height: 3) : Container(),
                    productData.value![0].statusTitle!.toLowerCase() == "sold" || productData.value![0].statusTitle!.toLowerCase() == "completed"
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetUtils.appTextWidget(context: context, title: "Sold on".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                        WidgetUtils.appTextWidget(
                            context: context, title:getDateFormat( productData.value![0].soldOn ?? ""), color: const Color(0xff3F3F3F), fontWeight: FontWeight.w400, fontSize: 14, family: 'Graphik'),
                      ],
                    )
                        : Container(),
                    const SizedBox(height: 12),
                    widget.isFrom == "view"
                        ? Container()
                        : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        width: double.maxFinite,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 1, color: const Color(0xffCFCFCF))),
                        height: 162,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                HelperUtils().chooseFileSelection(0, context, getResult: (value) async {
                                  imagePath = value.item1;
                                  await uploadReceipt();
                                  await getProductInformation(context,widget.productId, () {
                                    isLoading.value = false;
                                    setState(() {});
                                  });
                                  changeStatusColor();
                                  setState(() {});
                                  Navigator.pop(value.item2);
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(80), border: Border.all(color: const Color(0xffCFCFCF))),
                                  alignment: Alignment.center,
                                  height: 80,
                                  width: 80,
                                  child: SvgPicture.asset("assets/images/camera.svg", height: 23, color: Color(0xff6F6F6F))),
                            ),
                            const SizedBox(height: 4),
                            WidgetUtils.appTextWidget(
                                context: context, title: "Upload Receipt/Document/Invoice".tr, color: const Color(0xff3F3F3F), fontWeight: FontWeight.w500, fontSize: 16, family: 'Graphik'),
                            const SizedBox(height: 4),
                            WidgetUtils.appTextWidget(
                                context: context, title: "jpg,png,jpeg | limit 5MB".tr, color: const Color(0xffA0A0A0), fontWeight: FontWeight.w400, fontSize: 12, family: 'Graphik'),
                          ],
                        )),
                    const SizedBox(height: 12),
                    widget.isFrom != "view"
                        ? (imagePath != null
                        ? Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xffCFCFCF))),
                        height: 214,
                        width: double.maxFinite,
                        child: Image(image: FileImage(imagePath!), fit: BoxFit.cover))
                        : Container())
                        : Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xffCFCFCF))),
                      height: 214,
                      width: double.maxFinite,
                      child: CachedNetworkImage(
                        height: 214,
                        imageUrl: sellerInvoicePath + "/" + (viewReceipt?.data?[0].sellerInvoice ?? ""),
                        imageBuilder: (context, imageProvider) =>
                            Container(height: 214, decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover), borderRadius: BorderRadius.circular(6))),
                        placeholder: (context, url) => Image.asset("assets/images/user.png", fit: BoxFit.contain),
                        errorWidget: (context, url, error) => Image.asset("assets/images/user.png", fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: widget.isFrom != "view"
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: WidgetUtils.buttonWidget(
                  context: context,
                  radius: 8,
                  title: 'View Incentives'.tr,
                  size: 16,
                  family: 'Graphik',
                  weight: FontWeight.w500,
                  callback: () {
                    if (imagePath != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => IncentiveScreen(bidderDate: widget.bidDate, bidderId: widget.bidderId, buyerName: widget.buyerName)));
                    } else {
                      WidgetUtils.errorDialog(context, "Please upload receipt First".tr);
                    }
                  },
                  textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
                  color: Color(int.parse(themeColor.value.buttonColor!.color!))),
            )
                : Container(height: 10),
          ),
        ));
  }

  Future performSellerAction(final params) async {
    try {
      final response = await APIService.postAPIMethod(url: ApiURL.buyerAction, params: params);
      final result = jsonDecode(response.body);
      if (result['success'] == 1) {
        if (result['data'] != null) {
          WidgetUtils.successDialog(context, result['message']);
        }
      }
    } catch (e) {
      setState(() => isLoading.value = false);
      rethrow;
    }
  }

  Future uploadReceipt() async {
    try {
      setState(() {
        isLoading.value = true;
      });
      final request = http.MultipartRequest('POST', Uri.parse(baseURL + ApiURL.uploadInvoice));
      request.files.add(await http.MultipartFile.fromPath('invoice', imagePath!.path));
      request.fields["trade_bidding_id"] = widget.bidderId;
      request.headers["client-type"] = "seller";
      request.headers["X-API-KEY"] = HeaderSingleton().xAPIKey.value;
      request.headers["domain"] = HeaderSingleton().domain.value;
      request.headers["appname"] = HeaderSingleton().appName.value;
      Future.delayed(const Duration(milliseconds: 500), () async {
        await request.send().then((response) async {
          response.stream.transform(utf8.decoder).listen((value) async {
            final data = json.decode(value);
            if (data['success'] == 1) {
              WidgetUtils.successDialog(context, data['message']);
              final params = {'id': widget.bidderId, 'status': "5", 'product_id': productData.value![0].id!, 'seller_id': userId, 'buyer_id': widget.bidderId!};
              await performSellerAction(params);
            } else {
              WidgetUtils.errorDialog(context, data['message']);
            }
            setState(() {});
          });
        }).catchError((e) {
          isLoading.value = false;
          // //print(e);
        });
      });
      setState(() {
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }
}
