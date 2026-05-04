import 'package:dio/dio.dart';
import 'package:buyer_common_code/app_imports.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../model/DSSCropResponse.dart';
import '../../../model/Products.dart';
import 'SellerHomeScreen.dart';

class AddProductDetailsScreen extends StatefulWidget {
  ProductsData? productsData;
  String? cropProductImage, cropImage, cropInvoiceUrl;

  AddProductDetailsScreen({super.key, this.productsData, this.cropProductImage, this.cropImage, this.cropInvoiceUrl});

  @override
  _AddProductDetailsScreenState createState() => _AddProductDetailsScreenState();
}

class _AddProductDetailsScreenState extends State<AddProductDetailsScreen> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  File? imageFileOne, imageFileTwo;

  TextEditingController? productController, locationController, subProductController, productDetailsController, priseController, unitController, quantityController, userUnitController;
  List<CropVarietyData> cropVarietyList = [];
  String? cropID, cropVerityID, marketID;
  bool _allowWriteFile = false, addProductFlag = false, productControllerFlag = true, productDetailsControllerFlag = true;
  String status = 'Pending'.tr, productID = "", progress = "";
  Color statusColor = const Color(0xffa08b00);
  TextEditingController controllerOne = TextEditingController(), controller = TextEditingController(), controllerTwo = TextEditingController();
  List<AllCrops> searchResult = [], list = [], cropList = [];
  List<CropVarietyData> searchResultOne = [], listOne = [];
  List<MarketData> searchResultTwo = [], listTwo = [], cropMarketDataList = [];
  late Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    fetchCrops();
    fetchMarket();
    productController = TextEditingController();
    subProductController = TextEditingController();
    productDetailsController = TextEditingController();
    priseController = TextEditingController();
    unitController = TextEditingController();
    quantityController = TextEditingController();
    userUnitController = TextEditingController();
    locationController = TextEditingController();

    if (widget.productsData != null) {
      if (widget.productsData!.producut_status == "1") {
        if (widget.productsData!.price == null || widget.productsData!.price == "") {
          status = 'Price - Pending'.tr;
        } else if (widget.productsData!.weight == null || widget.productsData!.weight == "") {
          status = 'Weight - Pending'.tr;
        } else {
          status = 'Pending'.tr;
        }
        statusColor = const Color(0xffa08b00);
      } else if (widget.productsData!.producut_status == "2") {
        status = 'Approved'.tr;
        statusColor = const Color(0xff56c900);
      } else if (widget.productsData!.producut_status == "3") {
        status = 'Rejected'.tr;
        statusColor = const Color(0xffff0000);
      } else if (widget.productsData!.producut_status == "4") {
        status = 'Sold'.tr;
        statusColor = const Color(0xff56c900);
      } else if (widget.productsData!.producut_status == "5") {
        status = 'Paid'.tr;
        statusColor = const Color(0xff56c900);
      } else {
        status = 'Pending'.tr;
        statusColor = const Color(0xffa08b00);
      }
      // _getPrice();
      addProductFlag = true;
      productControllerFlag = false;
      productDetailsControllerFlag = false;
      imageFileOne = File("");
      imageFileTwo = File("");
      productController!.text = widget.productsData!.name!;
      subProductController!.text = widget.productsData!.cropVarietyName!;
      productDetailsController!.text = widget.productsData!.prodDesc!;
      quantityController!.text = widget.productsData?.weight ?? "---";
      userUnitController!.text = widget.productsData?.weightUnit ?? "---";
      if (widget.productsData?.weightUnit != null) {
        if (widget.productsData?.weightUnit == "") {
          userUnitController!.text = "---";
        }
      }
      priseController!.text = widget.productsData?.price ?? "---";
      unitController!.text = widget.productsData?.priceUnit ?? "---";
      locationController!.text = widget.productsData?.market_name ?? "---";
      productID = widget.productsData?.id ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    String? extension;
    bool isInvoice = false;
    if (widget.productsData != null) {
      if (widget.productsData!.invoiceFile != null) {
        extension = widget.productsData!.invoiceFile ?? "";
        isInvoice = true;
      }
      if (widget.productsData!.producut_status == "3") {
        isInvoice = false;
      }
    }

    return SafeArea(
      child: CustomProgressHandler(
        loadingText: '',
        isLoading: isLoading.value,
        child: Scaffold( backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor:Color(int.parse(themeColor.value.barColor!.color!)),
            title: WidgetUtils.appTextWidget(context: context, title: widget.productsData != null ? 'Product Details'.tr : 'Add Product details'.tr, color: Colors.white, fontSize: 18),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: <Widget>[
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(6.0), boxShadow: const [BoxShadow(color: Colors.blueAccent)]),
                                  child: imageFileOne != null
                                      ? InkWell(
                                          onTap: () {
                                            _showDialogZoomImageOne(context);
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(6.0),
                                            child: widget.productsData != null
                                                ? Image(
                                                    image: NetworkImage(widget.productsData!.cropImg1 != ""
                                                        ? ((widget.cropProductImage ?? "") + widget.productsData!.cropImg1!)
                                                        : ((widget.cropImage ?? "") + widget.productsData!.mobIcon!)),
                                                    fit: BoxFit.cover)
                                                : Image(image: FileImage(imageFileOne!), fit: BoxFit.cover),
                                          ),
                                        )
                                      : IconButton(
                                          icon:  Icon(Icons.camera_alt,color:Color(int.parse(themeColor.value.barColor!.color!))),
                                          iconSize: 50.0,
                                          onPressed: () {
                                            getImageFrom("one");
                                          },
                                        )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(6.0), boxShadow: const [BoxShadow(color: Colors.blueAccent)]),
                                child: imageFileTwo != null
                                    ? InkWell(
                                        onTap: () {
                                          _showDialogZoomImageTwo(context);
                                        },
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(6.0),
                                            child: widget.productsData != null
                                                ? Image(
                                                    image: NetworkImage(widget.productsData!.cropImg2 != ""
                                                        ? ((widget.cropProductImage ?? "") + widget.productsData!.cropImg2!)
                                                        : ((widget.cropImage ?? "") + widget.productsData!.mobIcon!)),
                                                    fit: BoxFit.cover)
                                                : Image(image: FileImage(imageFileTwo!), fit: BoxFit.cover)),
                                      )
                                    : IconButton(
                                        icon:  Icon(Icons.camera_alt,color:Color(int.parse(themeColor.value.barColor!.color!))),
                                        iconSize: 50.0,
                                        onPressed: () {
                                          getImageFrom("two");
                                        },
                                      )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: addProductFlag,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 25,
                            decoration: const BoxDecoration(color: Color(0xff42090e), shape: BoxShape.rectangle, borderRadius: BorderRadius.horizontal(right: Radius.circular(50.0))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                ("#" + productID),
                                style: const TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.bold, fontSize: 20.0),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: statusColor,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text((status), style: TextStyle(color: statusColor, fontSize: 18.0)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      child: Text(
                        'Product'.tr,
                        style: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.start,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.productsData == null) {
                                        showDialogCompanyFilter(context);
                                      }
                                    },
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      enabled: false,
                                      onTap: () {},
                                      textAlign: TextAlign.start,
                                      controller: productController,
                                      maxLength: 200,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        counter: Container(),
                                        border: InputBorder.none,
                                        hintText: ''.tr,
                                        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                              color: Colors.grey,
                                              fontSize: 20,
                                            ),
                                        labelStyle: Theme.of(context).textTheme.bodyLarge!
                                          ..copyWith(
                                            fontSize: 20,
                                          ),
                                      ),
                                      style: Theme.of(context).textTheme.bodyLarge!..copyWith(),
                                    ),
                                  )),
                            )
                          ],
                        )),
                    const SizedBox(height: 10),
                    Align(
                        child: Text('Product Variety'.tr, style: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.start),
                        alignment: Alignment.topLeft),
                    Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.productsData == null) {
                                        _showDailogComapnyFilterOne(context);
                                      }
                                    },
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      enabled: false,
                                      textAlign: TextAlign.start,
                                      controller: subProductController,
                                      maxLength: 200,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        counter: Container(),
                                        border: InputBorder.none,
                                        hintText: ''.tr,
                                        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey, fontSize: 20),
                                        labelStyle: Theme.of(context).textTheme.bodyLarge!
                                          ..copyWith(
                                            fontSize: 20,
                                          ),
                                      ),
                                      style: Theme.of(context).textTheme.bodyLarge!..copyWith(),
                                    ),
                                  )),
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        child: Text('Location'.tr, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15, fontWeight: FontWeight.w500), textAlign: TextAlign.start),
                        alignment: Alignment.topLeft),
                    Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.productsData == null) {
                                        showDialogAction(context);
                                      }
                                    },
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      enabled: false,
                                      textAlign: TextAlign.start,
                                      controller: locationController,
                                      maxLength: 200,
                                      decoration: InputDecoration(
                                        isCollapsed: false,
                                        counter: Container(),
                                        border: InputBorder.none,
                                        hintText: ''.tr,
                                        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey, fontSize: 20),
                                        labelStyle: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 20),
                                      ),
                                      style: Theme.of(context).textTheme.bodyLarge!..copyWith(),
                                    ),
                                  )),
                            )
                          ],
                        )),
                    const SizedBox(height: 10),
                    Align(
                      child: Text(
                        'Product Details'.tr,
                        style: Theme.of(context).textTheme.bodyLarge!
                          ..copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        textAlign: TextAlign.start,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  textAlign: TextAlign.start,
                                  enabled: productDetailsControllerFlag,
                                  controller: productDetailsController,
                                  maxLength: 200,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    isCollapsed: false,
                                    counter: Container(),
                                    border: InputBorder.none,
                                    hintText: 'Product Details'.tr,
                                    hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey, fontSize: 15),
                                    labelStyle: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 15),
                                  ),
                                  style: Theme.of(context).textTheme.bodyLarge!..copyWith(),
                                ),
                              ),
                            )
                          ],
                        )),
                    Visibility(
                        visible: addProductFlag,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Price'.tr, style: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 18, fontWeight: FontWeight.w300), textAlign: TextAlign.start),
                                      Text('Unit'.tr, style: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 16, fontWeight: FontWeight.w300), textAlign: TextAlign.start),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(priseController?.text.trim() ?? "---",
                                          style: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 20, fontWeight: FontWeight.w500), textAlign: TextAlign.start),
                                      Text(
                                        unitController?.text.trim() ?? "---",
                                        style: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                      visible: addProductFlag,
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 8.0, left: 8.0),
                                            child: Divider(height: 1, color: Colors.black),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Center(
                                                  child: Text('Quantity'.tr,
                                                      style: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 18, fontWeight: FontWeight.w300), textAlign: TextAlign.start),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Center(
                                                  child:
                                                      Text('Unit'.tr, style: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 18, fontWeight: FontWeight.w300), textAlign: TextAlign.start),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Center(
                                                  child: Text(quantityController?.text.trim() ?? "",
                                                      style: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 20, fontWeight: FontWeight.w500), textAlign: TextAlign.start),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Center(
                                                  child: Text(userUnitController?.text.trim() ?? "---",
                                                      style: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 20, fontWeight: FontWeight.w500), textAlign: TextAlign.start),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(right: 8.0, left: 8.0),
                                            child: Divider(
                                              height: 1,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Total'.tr, style: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.start),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(widget.productsData?.totalAmount ?? "---",
                                                  style: Theme.of(context).textTheme.bodyLarge!..copyWith(fontSize: 20, fontWeight: FontWeight.w500), textAlign: TextAlign.start),
                                            ],
                                          ),
                                        ],
                                      )),
                                  const SizedBox(height: 20),
                                ],
                              )),
                        )),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: isInvoice,
                          child: Center(
                            child: Container(
                                height: (MediaQuery.of(context).size.width) * 0.10,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  gradient: const LinearGradient(colors: [GreenTheme.primaryButtonColor, GreenTheme.primaryLightButtonColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), offset: const Offset(8.0, 16.0), blurRadius: 16.0),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Icon(Icons.download, color: Colors.white),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () async {
                                            getDirectoryPath().then((path) {
                                              File f = File(path + "/$extension");
                                              if (f.existsSync()) {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                //   return PDFScreen(f.path);
                                                // }));
                                                return;
                                              }

                                              downloadFile((widget.cropInvoiceUrl ?? "") + (widget.productsData!.invoiceFile ?? ""), "$path/$extension", extension, path);
                                            });
                                          },
                                          child: Center(
                                            child: Padding(
                                                padding: const EdgeInsets.only(left: 0, right: 20, top: 8, bottom: 8),
                                                child: Center(child: Text('Invoice'.tr, style: ButtonStyles.getDarkButtonTextStyle(context)))),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: widget.productsData != null
                          ? Container(
                              child: widget.productsData!.weight != null && widget.productsData!.producut_status == "1"
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              height: (MediaQuery.of(context).size.width) * 0.15,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                gradient: const LinearGradient(
                                                    colors: [GreenTheme.primaryButtonColor, GreenTheme.primaryLightButtonColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                                borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), offset: const Offset(8.0, 16.0), blurRadius: 16.0),
                                                ],
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: GestureDetector(
                                                  // highlightColor: Colors.transparent,
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () {
                                                    HelperUtils().showNormalDialog(
                                                        context: context,
                                                        title: 'Are_you_sure'.tr,
                                                        content: 'Do you want to Reject'.tr,
                                                        onYesTapped: (value) async {
                                                          Navigator.pop(value);
                                                          _updateStatus("3");
                                                        });
                                                  },
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                                                      child: Text('Reject'.tr, style: ButtonStyles.getDarkButtonTextStyle(context)),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                              height: (MediaQuery.of(context).size.width) * 0.15,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                gradient: const LinearGradient(
                                                    colors: [GreenTheme.primaryButtonColor, GreenTheme.primaryLightButtonColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                                borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), offset: const Offset(8.0, 16.0), blurRadius: 16.0),
                                                ],
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () {
                                                    HelperUtils().showNormalDialog(
                                                        context: context,
                                                        title: 'Are_you_sure'.tr,
                                                        content: 'Do you want to Accept'.tr,
                                                        onYesTapped: (value) async {
                                                          Navigator.pop(value);
                                                          _updateStatus("2");
                                                        });
                                                  },
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                                                      child: Text('Accept'.tr, style: ButtonStyles.getDarkButtonTextStyle(context)),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    )
                                  : Container(height: 15))
                          : CustomDarkButton(
                              onPressed: () {
                                setState(() {
                                  _addProduct();
                                });
                              },
                              caption: 'Add Product'.tr,
                            ),
                    ),
                  ])))), //
        ),
      ),
    );
  }

  Future<List<AllCrops>> fetchCrops() async {
    try {
      isLoading.value = true;

      Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.get_farmer_crop_list);
      http.Response response = await http.get(fetchSchoolsUri, headers: headerParams);
      var data = json.decode(response.body);
      if (data['success'] != 1) {
        WidgetUtils.successDialog(context, data["msg"] ?? "");
      } else {
        setState(() {
          data['data']!.forEach((v) {
            list.add(AllCrops.fromJson(v));
            cropList.add(AllCrops.fromJson(v));
          });
        });
      }
    } catch (e) {
      rethrow;
    }
    isLoading.value = false;

    return cropList;
  }

  Future<List<CropVarietyData>> fetchCropVariety(String cropId) async {
    try {
      isLoading.value = true;
      // // var headerModel = Provider.of<HeaderModel>(context, listen: false);
      Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.get_farmer_crop_variety_get + "/" + cropId);

      // //print(fetchSchoolsUri);

      http.Response response = await http.get(fetchSchoolsUri, headers: headerParams);
      var data = json.decode(response.body);
      // //print(data);
      CropVariety cropVariety = CropVariety.fromJson(data);
      if (cropVariety.success != 1) {
        WidgetUtils.successDialog(context, data["msg"] ?? "");
      } else {
        setState(() {
          // List<CropVarietyData> farmerData = cropVariety.data;
          cropVarietyList = cropVariety.data;
          listOne = cropVariety.data;
        });
      }
    } catch (e) {
      rethrow;
    }
    isLoading.value = false;

    return cropVarietyList;
  }

  Future<List<MarketData>> fetchMarket() async {
    try {
      isLoading.value = true;
      Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.sellerMarket);
      http.Response response = await http.get(fetchSchoolsUri, headers: headerParams);
      var data = json.decode(response.body);
      Market market = Market.fromJson(data);
      if (market.success != 1) {
        WidgetUtils.successDialog(context, data["msg"] ?? "");
      } else {
        setState(() {
          // List<MarketData> farmerData = market.data;
          cropMarketDataList = market.data;
          listTwo = market.data;
        });
      }
    } catch (e) {
      rethrow;
      // Get.snackbar("", e.toString(),backgroundColor: primaryExtraLight1);
    }
    isLoading.value = false;

    return cropMarketDataList;
  }

  _addProduct() async {
    if (cropID == null) {
      WidgetUtils.errorDialog(context, 'Please Select Crop'.tr);
    } else if (cropVerityID == null) {
      WidgetUtils.errorDialog(context, 'Please Select Crop variety'.tr);
    } else if (marketID == null) {
      WidgetUtils.errorDialog(context, 'Please Select Location'.tr);
    } else if (imageFileOne == null) {
      WidgetUtils.errorDialog(context, 'Please Crop One Photo Mandatory'.tr);
    } else {
      isLoading.value = true;

      try {
        var request = http.MultipartRequest('POST', Uri.parse(baseURL + ApiURL.addCropProduct));
        if (imageFileOne?.path != null) {
          request.files.add(await http.MultipartFile.fromPath('crop_img1', imageFileOne!.path));
        }
        if (imageFileTwo?.path != null) {
          request.files.add(await http.MultipartFile.fromPath('crop_img2', imageFileTwo!.path));
        }
        // var headerModel = Provider.of<HeaderModel>(context, listen: false);
        request.headers["client-type"] = "buyer";
        request.headers["X-API-KEY"] = HeaderSingleton().xAPIKey.value;
        request.headers["domain"] = HeaderSingleton().domain.value;
        request.headers["appname"] = HeaderSingleton().appName.value;
        request.fields["crop_id"] = cropID!;
        request.fields["btn_submit"] = "submit";
        request.fields["crop_variety_id"] = cropVerityID!;
        request.fields["farmer_id"] = HeaderSingleton().paramsMaps!.userId!;
        request.fields["market_id"] = marketID!;
        request.fields["prod_desc"] = productDetailsController!.text.toString();
        await request.send().then((response) async {
          response.stream.transform(utf8.decoder).listen((value) {
            var data = json.decode(value);
            var res = CommonModel.fromJson(data);
            if (res.success == 1) {
              WidgetUtils.successDialog(context, res.message);
              Navigator.pop(context);
            } else {
              WidgetUtils.errorDialog(context, res.message);
            }
          });
        }).catchError((e) {
          // rethrow;
        });
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
        rethrow;
      }
    }
  }

  void getImageFrom(String one) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 150,
              width: 328,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WidgetUtils.appTextWidget(context: context, title: 'Camera'.tr, color: Colors.black, fontSize: 18, family: 'Graphik', fontWeight: FontWeight.w500),
                          InkWell(
                              onTap: () {
                                Navigator.pop(ctx);
                              },
                              child: SvgPicture.asset(
                                "assets/images/cross.svg",
                                height: 20
                              ))
                        ],
                      )),
                  InkWell(
                      onTap: () async {
                        final filePath = await HelperUtils().getFromCamera(ctx, 0);
                        if (one == 'one') {
                          imageFileOne = File(filePath.path);
                        } else {
                          imageFileTwo = File(filePath.path);
                        }
                        setState(() {});
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.camera_alt, color: Color(int.parse(themeColor.value.iconColor!.color!))),
                            const SizedBox(width: 20),
                            WidgetUtils.appTextWidget(context: context, title: 'Take A New Picture'.tr, fontSize: 16, family: 'Graphik'),
                          ],
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(width: 1.2, color: Colors.grey)),
                      )),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  _updateStatus(String status) async {
    try {
      isLoading.value = true;

      Map<String, dynamic> params1 = {
        "id": widget.productsData!.id!,
        "btn_submit": "submit",
        "product_status": status,
      };
      Uri fetchSchoolsUri = Uri.parse(baseURL + ApiURL.updateCropProductStatus);
      http.Response response = await http.post(fetchSchoolsUri, body: params1, headers: headerParams);
      var data = json.decode(response.body);
      if (data["success"] == 1) {
        WidgetUtils.successDialog(context, data["message"]);
        Navigator.pop(context);
      } else {
        WidgetUtils.errorDialog(context, data["message"]);
      }
    } catch (e) {
      rethrow;
    }
    isLoading.value = false;
  }

  showDialogCompanyFilter(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return CupertinoAlertDialog(
                title: Text('Select Crop'.tr),
                content: SizedBox(
                  height: 350.0, // Change as per your requirement
                  width: 600.0,
                  child: ListView(shrinkWrap: true, children: <Widget>[
                    Card(
                      child: ListTile(
                          dense: true,
                          leading: const Icon(Icons.search),
                          title: TextField(
                            controller: controller,
                            decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                            onChanged: (text) {
                              searchResult.clear();
                              if (text.isEmpty) {
                                setState(() {});
                                return;
                              }
                              for (var userDetail in list) {
                                if (userDetail.name!.toUpperCase().contains(text.toUpperCase()) || userDetail.name!.toLowerCase().contains(text.toLowerCase())) searchResult.add(userDetail);
                              }
                              setState(() {});
                            },
                          ),
                          trailing: InkWell(
                              child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                              onTap: () {
                                controller.clear();
                                searchResult.clear();
                                if ("".isEmpty) {
                                  setState(() {});
                                  return;
                                }
                                for (var userDetail in list) {
                                  if (userDetail.name!.contains("")) searchResult.add(userDetail);
                                }
                                setState(() {});
                              })),
                    ),
                    SizedBox(
                      height: 350.0,
                      width: 550.0,
                      child: searchResult.isNotEmpty || controller.text.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: searchResult.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        productController!.text = searchResult[index].name!;
                                        fetchCropVariety(searchResult[index].cropId!);
                                        cropID = searchResult[index].cropId!;
                                        subProductController!.text = "";
                                        cropVerityID = null;
                                      });
                                    },
                                    child: Card(
                                      elevation: 5,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  searchResult[index].name!,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 16.0),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ]),
                                    ));
                              },
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: list.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        productController!.text = list[index].name!;
                                        fetchCropVariety(list[index].cropId!);
                                        cropID = list[index].cropId!;
                                        subProductController!.text = "";
                                        cropVerityID = null;
                                      });
                                    },
                                    child: Card(
                                      elevation: 5,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  list[index].name!,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 16.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ));
                              },
                            ),
                    ),
                  ]),
                ));
          });
        });
  }

  _showDailogComapnyFilterOne(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return CupertinoAlertDialog(
                title: Text('Select Crop Variety'.tr),
                content: SizedBox(
                  height: 350.0, // Change as per your requirement
                  width: 600.0,
                  child: ListView(shrinkWrap: true, children: <Widget>[
                    Card(
                      child: ListTile(
                          dense: true,
                          leading: const Icon(Icons.search),
                          title: TextField(
                            controller: controllerOne,
                            decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                            onChanged: (text) {
                              searchResultOne.clear();
                              if (text.isEmpty) {
                                setState(() {});
                                return;
                              }
                              for (var userDetail in listOne) {
                                if (userDetail.name.toUpperCase().contains(text.toUpperCase()) || userDetail.name.toLowerCase().contains(text.toLowerCase())) searchResultOne.add(userDetail);
                              }

                              setState(() {});
                            },
                          ),
                          trailing: InkWell(
                              child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                              onTap: () {
                                controllerOne.clear();
                                searchResultOne.clear();
                                if ("".isEmpty) {
                                  setState(() {});
                                  return;
                                }
                                for (var userDetail in listOne) {
                                  if (userDetail.name.contains("")) searchResultOne.add(userDetail);
                                }
                                setState(() {});
                              })),
                    ),
                    SizedBox(
                      height: 350.0, // Change as per your requirement
                      width: 550.0,
                      child: searchResultOne.isNotEmpty || controllerOne.text.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: searchResultOne.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        subProductController!.text = searchResultOne[index].name + "/" + searchResultOne[index].nameMr;
                                        cropVerityID = searchResultOne[index].cropVarietyId;
                                      });
                                    },
                                    child: Card(
                                      elevation: 5,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  searchResultOne[index].name + "/" + searchResultOne[index].nameMr,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 16.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ));
                              },
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: listOne.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        subProductController!.text = listOne[index].name + "/" + listOne[index].nameMr;
                                        cropVerityID = listOne[index].cropVarietyId;
                                      });
                                    },
                                    child: Card(
                                      elevation: 5,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  listOne[index].name + "/" + listOne[index].nameMr,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 16.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ));
                              },
                            ),
                    ),
                  ]),
                ));
          });
        });
  }

  showDialogAction(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return CupertinoAlertDialog(
                title: Text('Select location'.tr),
                content: SizedBox(
                  height: 350.0, // Change as per your requirement
                  width: 600.0,
                  child: ListView(shrinkWrap: true, children: <Widget>[
                    Card(
                      child: ListTile(
                          dense: true,
                          leading: const Icon(Icons.search),
                          title: TextField(
                            controller: controllerTwo,
                            decoration: InputDecoration(hintText: 'Search'.tr, border: InputBorder.none),
                            onChanged: (text) {
                              searchResultTwo.clear();
                              if (text.isEmpty) {
                                setState(() {});
                                return;
                              }
                              for (var userDetail in listTwo) {
                                if (userDetail.name!.toUpperCase().contains(text.toUpperCase()) || userDetail.name!.toLowerCase().contains(text.toLowerCase())) searchResultTwo.add(userDetail);
                              }
                              setState(() {});
                            },
                          ),
                          trailing: InkWell(
                              child: SvgPicture.asset("assets/images/cross.svg", height: 20),
                              onTap: () {
                                controllerTwo.clear();
                                searchResultTwo.clear();
                                if ("".isEmpty) {
                                  setState(() {});
                                  return;
                                }
                                for (var userDetail in listTwo) {
                                  if (userDetail.name!.contains("")) searchResultTwo.add(userDetail);
                                }
                                setState(() {});
                              })),
                    ),
                    SizedBox(
                      height: 350.0, // Change as per your requirement
                      width: 550.0,
                      child: searchResultTwo.isNotEmpty || controllerTwo.text.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: searchResultTwo.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        locationController!.text = searchResultTwo[index].name ?? "" "/" + (searchResultTwo[index].nameMr ?? "");
                                        marketID = searchResultTwo[index].marketId;
                                      });
                                    },
                                    child: Card(
                                      elevation: 5,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  searchResultTwo[index].name ?? "" "/" + (searchResultTwo[index].nameMr ?? ""),
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 16.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ));
                              },
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: listTwo.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        locationController!.text = listTwo[index].name ?? "" "/" + (listTwo[index].nameMr ?? "");
                                        marketID = listTwo[index].marketId;
                                      });
                                    },
                                    child: Card(
                                      elevation: 5,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(listTwo[index].name ?? "" "/" + (listTwo[index].nameMr ?? ""),
                                                    textAlign: TextAlign.start, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ));
                              },
                            ),
                    ),
                  ]),
                ));
          });
        });
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
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return PDFScreen(f.path);
        // }));
        // return;
      }
    } catch (e) {
      rethrow;
    }
  }

  _showDialogZoomImageOne(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return CupertinoAlertDialog(
                content: SizedBox(
              height: 350.0, // Change as per your requirement
              width: 400.0,
              child: Container(
                child: widget.productsData != null
                    ? Image(
                        image: NetworkImage(
                          widget.productsData!.cropImg1 != "" ? ((widget.cropProductImage ?? "") + widget.productsData!.cropImg1!) : ((widget.cropImage ?? "") + widget.productsData!.mobIcon!),
                        ),
                        fit: BoxFit.cover)
                    : Image(image: FileImage(imageFileOne!), fit: BoxFit.cover),
              ),
            ));
          });
        });
  }

  _showDialogZoomImageTwo(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return CupertinoAlertDialog(
                content: SizedBox(
              height: 350.0, // Change as per your requirement
              width: 400.0,
              child: Container(
                child: widget.productsData != null
                    ? Image(
                        image: NetworkImage(
                            widget.productsData!.cropImg2 != "" ? ((widget.cropProductImage ?? "") + widget.productsData!.cropImg2!) : ((widget.cropImage ?? "") + widget.productsData!.mobIcon!)),
                        fit: BoxFit.cover)
                    : Image(image: FileImage(imageFileOne!), fit: BoxFit.cover),
              ),
            ));
          });
        });
  }
}
