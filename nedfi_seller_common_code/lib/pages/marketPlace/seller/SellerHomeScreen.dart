import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

// import 'package:nedfi_seller_common_code/app_imports.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../components/custom_progress_handler.dart';
import '../../../components/utils/Cache.dart';
import '../../../components/utils/Constants.dart';
import '../../../components/utils/button_styles.dart';
import '../../../components/utils/notification_utils.dart';
import '../../../components/utils/widget_utils.dart';
import '../../../model/Products.dart';
import '../../../singleton/header_singleton.dart';
import 'AddProductDetailsScreen.dart';

class SellerHomeScreen extends StatefulWidget {
  final void Function(int) onAddButtonTap;

  const SellerHomeScreen({Key? key, required this.onAddButtonTap}) : super(key: key);

  @override
  _SellerHomeScreenState createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  bool _isLoading = false;
  bool profileFlag = false, _allowWriteFile = false;
  List<ProductsData> productList = [];
  String progress = "", cropProductImage = "", cropImage = "", cropInvoiceUrl = "";
  late Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    _isLoading = true;
    fetchProduct();
    FirebaseMessaging.onMessage.listen((message) async {
      if (message != null) {
        Map<String, String> params = {
          "title": message.data["title"] ?? "",
          "body": message.data["body"] ?? "",
          "sound": message.data["sound"] ?? "",
          "image": message.data["image"] ?? "",
          "admno": message.data["admno"] ?? "",
          "type": message.data["type"] ?? "",
          "product_id": message.data["product_id"] ?? "",
          "route": message.data["route"] ?? ""
        };
        await NotificationUtils().createNotification(message, params);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomProgressHandler(
        loadingText: '',
        isLoading: _isLoading,
        child: DefaultTabController(
          length: 5,
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: Color(int.parse(themeColor.value.barColor!.color!)),
                title: WidgetUtils.appTextWidget(context: context, title: 'Products'.tr, color: Colors.white, fontSize: 18),
                iconTheme: const IconThemeData(color: Colors.white),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(30.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color(int.parse(themeColor.value.barColor!.color!)),
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Colors.white,
                      labelStyle: const TextStyle(fontFamily: 'Graphik', fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                      indicatorColor: Colors.white,
                      tabs: [Tab(text: 'All'.tr), Tab(text: 'Pending'.tr), Tab(text: 'Approved'.tr), Tab(text: 'Sold'.tr), Tab(text: 'Rejected'.tr)],
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                children: [productListItems("All"), productListItems("Pending"), productListItems("Approved"), productListItems("Sold"), productListItems("Rejected")],
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: InkWell(
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductDetailsScreen())).then((value) {
                      fetchProduct();
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.add, color: Colors.white),
                        WidgetUtils.appTextWidget(context: context, title: 'Add Product'.tr, color: Colors.white, family: 'Graphik', fontSize: 16, fontWeight: FontWeight.w500),
                      ],
                    ),
                    decoration: BoxDecoration(color: Color(int.parse(themeColor.value.barColor!.color!)), borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  productListItems(String page) {
    List<ProductsData> products = [];
    for (var element in productList) {
      if (page == "All") {
        products.add(element);
      } else if (page == "Pending") {
        if (element.producut_status == "1") {
          products.add(element);
        } else if (element.producut_status == "0") {
          products.add(element);
        }
      } else if (page == "Approved") {
        if (element.producut_status == "2") {
          products.add(element);
        }
      } else if (page == "Sold") {
        if (element.producut_status == "4") {
          products.add(element);
        }
      } else if (page == "Rejected") {
        if (element.producut_status == "3") {
          products.add(element);
        }
      }
    }
    return products.isNotEmpty
        ? RefreshIndicator(
            onRefresh: fetchProduct,
            child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 56),
                itemCount: products.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) => productItem(products[index], index)))
        : Center(
            child: Text("No product available".tr),
          );
  }

  productItem(ProductsData productsData, int index) {
    var size = MediaQuery.of(context).size;
    String extension = productsData.invoiceFile ?? "";
    bool isInvoice = false;
    String status;
    Color? statusColor = const Color(0xffa08b00);
    if (productsData.producut_status == "1") {
      if (productsData.price == null || productsData.price == "") {
        status = 'Price - Pending'.tr;
      } else if (productsData.weight == null || productsData.weight == "") {
        status = 'Weight - Pending'.tr;
      } else {
        status = 'Pending'.tr;
      }

      statusColor = const Color(0xffa08b00);
    } else if (productsData.producut_status == "2") {
      status = 'Approved'.tr;
      statusColor = const Color(0xff56c900);
    } else if (productsData.producut_status == "3") {
      status = 'Rejected'.tr;
      statusColor = const Color(0xffff0000);
    } else if (productsData.producut_status == "4") {
      status = 'Sold'.tr;
      statusColor = const Color(0xff56c900);
    } else if (productsData.producut_status == "5") {
      status = 'Paid'.tr;
      statusColor = const Color(0xff56c900);
    } else {
      status = 'Pending'.tr;
      statusColor = const Color(0xffa08b00);
    }

    if (productsData.invoiceFile != null) {
      isInvoice = true;
    }

    if (productsData.producut_status == "3") {
      isInvoice = false;
    }

    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: const Color(0xfff5f5f5),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProductDetailsScreen(productsData: productsData, cropProductImage: cropProductImage, cropImage: cropImage, cropInvoiceUrl: cropInvoiceUrl)));
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          imageDialog(productsData.cropImg1 != "" ? (cropProductImage) + productsData.cropImg1! : cropImage + productsData.mobIcon!);
                          imageDialog(productsData.cropImg1 != "" ? (cropProductImage) + productsData.cropImg1! : cropImage + productsData.mobIcon!);
                        },
                        child: Image.network(productsData.cropImg1 != "" ? cropProductImage + productsData.cropImg1! : cropImage + productsData.mobIcon!, width: 100, height: 100),
                      ),
                      InkWell(
                        onTap: () {
                          imageDialog(productsData.cropImg2 != "" ? cropProductImage + productsData.cropImg2! : cropImage + productsData.mobIcon!);
                        },
                        child: Image.network(productsData.cropImg2 != "" ? cropProductImage + productsData.cropImg2! : cropImage + productsData.mobIcon!, width: 100, height: 100),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Container(
                            height: 25,
                            decoration: const BoxDecoration(
                              color: Color(0xff42090e),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(50.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(("#" + productsData.id!), style: const TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.bold, fontSize: 20.0)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text((setDate(productsData.productAddDate!) ?? ""), style: const TextStyle(color: Colors.black, fontSize: 12.0)),
                          ),
                        ]),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(productsData.name!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0)),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Location'.tr + " : " + (productsData.market_name ?? "---"), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Varieties'.tr + "- " + productsData.cropVarietyName!, style: const TextStyle(color: Colors.black, fontSize: 12.0)),
                            Text('Price'.tr + "- " + (productsData.price ?? "NA"), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quantity'.tr + " - " + (productsData.weight ?? "NA"), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0)),
                            /* Text(
                              'Weight'.tr+"- " + (productsData.weight ?? "NA"),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            ),*/
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text((productsData.prodDesc ?? "NA"), style: const TextStyle(color: Colors.black, fontSize: 12.0)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.check_circle, color: statusColor),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text((status ?? "NA"), style: TextStyle(color: statusColor, fontSize: 18.0)),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: isInvoice,
                              child: Container(
                                  height: (size.width) * 0.10,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    gradient: const LinearGradient(colors: [GreenTheme.primaryButtonColor, GreenTheme.primaryLightButtonColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                    borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), offset: const Offset(8.0, 16.0), blurRadius: 16.0),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Icon(Icons.download, color: Colors.white),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: GestureDetector(
                                          // highlightColor: Colors.transparent,
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () async {
                                            getDirectoryPath().then((path) {
                                              File f = File(path + "/$extension");
                                              if (f.existsSync()) {
                                                /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  return PDFScreen(f.path);
                                                }));*/
                                                return;
                                              }
                                              downloadFile(cropInvoiceUrl + productsData.invoiceFile!, "$path/$extension", extension, path);
                                            });
                                          },
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 0, right: 20, top: 8, bottom: 8),
                                              child: Text('Invoice'.tr, style: ButtonStyles.getDarkButtonTextStyle(context)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddProductDetailsScreen(productsData: productsData, cropProductImage: cropProductImage, cropImage: cropImage, cropInvoiceUrl: cropInvoiceUrl)));
                              },
                              child: Row(
                                children: [
                                  Text('View'.tr, style: TextStyle(color: Colors.blue.shade300, fontWeight: FontWeight.bold, fontSize: 15.0)),
                                  Icon(Icons.arrow_forward_ios_outlined, color: Colors.blue.shade300)
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  setDate(String dateTime) {
    var dateFormat = DateFormat("dd MMM yyyy").format(DateTime.parse(dateTime));
    var timeFormat = DateFormat("hh:mm a").format(DateTime.parse(dateTime));
    return "Added on " + dateFormat + " at " + timeFormat;
  }

  Future<List<ProductsData>> fetchProduct() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1), () async {
      try {
        Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.getFarmerProduct + "/" + HeaderSingleton().paramsMaps!.userId!);
        http.Response response = await http.get(fetchSchoolsUri, headers: headerParams);
        var data = json.decode(response.body);
        Products products = Products.fromJson(data);
        Cache.getInstance().setVehicleType(products.vehicleType);
        if (products.success != 1) {
          WidgetUtils.errorDialog(context, data["message"] ?? "");
        } else {
          setState(() {
            List<ProductsData> productData = products.data;
            if (productData != null) {
              productList = products.data;
              cropProductImage = products.configUrl.cropProductImg;
              cropImage = products.configUrl.cropImageUrl ?? "";
              cropInvoiceUrl = products.configUrl.cropInvoiceUrl ?? "";
            }
          });
        }
      } catch (e) {
        rethrow;
      }
    });
    setState(() {
      _isLoading = false;
    });

    return productList;
  }

  imageDialog(String? images) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child:/* PhotoView(imageProvider: */Image.network(images ?? "")/*)*/,
    );
  }

  requestWritePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        _allowWriteFile = true;
      });
    } else {
      await [Permission.storage].request();
    }
  }

  Future<String> getDirectoryPath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory directory = await Directory(appDocDirectory.path + '/' + 'dir').create(recursive: true);
    return directory.path;
  }

  Future downloadFile(String url, path, extension, paths) async {
    var pro = 0.0;
    if (!_allowWriteFile) {
      requestWritePermission();
    }
    try {
      ProgressDialog progressDialog = ProgressDialog(context, dialogTransitionType: DialogTransitionType.Bubble, title: const Text("Downloading File"), dismissable: true, message: null);

      progressDialog.show();

      await dio.download(url, path, onReceiveProgress: (rec, total) {
        setState(() {
          pro = (rec / total) * 100;
          progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
          progressDialog.setMessage(Text("Downloading $progress"));
        });
      });
      progressDialog.dismiss();
      File f = File(paths + "/$extension");
      if (f.existsSync()) {
        /*Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PDFScreen(f.path);
        }));*/
      }
    } catch (e) {
      rethrow;
    }
  }
}

/*class PDFScreen extends StatelessWidget {
  String pathPDF = "";

  PDFScreen(this.pathPDF);

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.file(
      File(pathPDF),
      key: _pdfViewerKey,
    );
  }
}*/
