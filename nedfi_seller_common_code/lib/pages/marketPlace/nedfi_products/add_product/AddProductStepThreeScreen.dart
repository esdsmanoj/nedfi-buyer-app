import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nedfi_seller_common_code/pages/marketPlace/nedfi_products/product_list/NedfiProductListScreen.dart';
import 'package:provider/provider.dart';

import '../../../../components/utils/Constants.dart';
import '../../../../components/utils/helper_utils.dart';
import '../../../../components/utils/widget_utils.dart';
import '../../../../model/trade_product_model/AddProductImage.dart';
import '../../../../model/trade_product_model/AddProductResponse.dart';
import '../../../../model/trade_product_model/trade_product_info.dart';
import '../../../../providers/master_provider.dart';
import '../../../../services/api_service.dart';
import '../../../../singleton/header_singleton.dart';

class AddProductStepThreeScreen extends StatefulWidget {
  String? id, buttonText;

  AddProductStepThreeScreen({super.key, this.id, this.buttonText});

  @override
  State<AddProductStepThreeScreen> createState() => _AddProductStepThreeScreenState();
}

class _AddProductStepThreeScreenState extends State<AddProductStepThreeScreen> {
  TextEditingController? certificateController = TextEditingController();
  List<File> certificatePicture = [], productPicture = [], productSamplePicture = [], productPackagingPicture = [];

  List<String> certificateUrl = [], productPictureUrl = [], productSamplePictureUrl = [], productPackagingPictureUrl = [];
  String id = "", proCatId = "";
  bool certificateFlag = false, packagingFlag = false;
  dynamic masterProvider;

  selectFileFromDevice(String type) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (type == "Certificate") {
        if (image.path.endsWith(".gif")) {
          WidgetUtils.errorDialog(context, 'GIF image not allowed'.tr);
        } else {
          File file = File(image.path);
          setState(() {
            certificateController!.text = file.path;
          });
          uploadImage(type);
        }
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
    masterProvider = Provider.of<MasterProvider>(context, listen: false);

    if (masterProvider.itemId != null || masterProvider.itemId != "") {
      id = masterProvider.treadProductCurrent!.id ?? "";
    } else {
      id = widget.id ?? "";
    }
    getProductList();
  }

  Future getProductList() async {
    try {
      var param = {"user_id": HeaderSingleton().paramsMaps!.userId, "id": id};
      final response = await APIService.postAPIMethod(url: ApiURL.tradeProduct, params: param);
      final data = json.decode(response.body);
      final res = TradeProductInfo.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setCurrentTreadProduct(res.data![0]);
          masterProvider.setType("EDIT");
          masterProvider.setItemId(id);
          if (masterProvider.type == "EDIT") {
            setState(() {
              id = masterProvider.treadProductCurrent!.id ?? "";
              proCatId = masterProvider.treadProductCurrent!.prodCatId ?? "";
              proCatId = masterProvider.treadProductCurrent!.prodCatId ?? "";
              if (masterProvider.treadProductCurrent!.prod_images != null && masterProvider.treadProductCurrent!.prod_images != null) {
                final images = json.decode(masterProvider.treadProductCurrent!.prod_images ?? "");
                setState(() {
                  if (images['certificate'] != null) {
                    certificateUrl = images['certificate'].cast<String>() ?? [];
                    if (certificateUrl.isNotEmpty) {
                      certificateController!.text = certificateUrl[0];
                    }
                  }
                  if (images['product'] != null) {
                    productPictureUrl = images['product'].cast<String>() ?? [];
                  }
                  if (images['sample_product'] != null) {
                    productSamplePictureUrl = images['sample_product'].cast<String>() ?? [];
                  }
                  if (images['packaging'] != null) {
                    productPackagingPictureUrl = images['packaging'].cast<String>() ?? [];
                  }
                });
              }

              if (masterProvider.treadProductCurrent!.certifcations == "t") {
                certificateFlag = true;
              } else {
                certificateFlag = false;
              }
              if (masterProvider.treadProductCurrent!.withPackging == "t") {
                packagingFlag = true;
              } else {
                packagingFlag = false;
              }
            });
          }
        }
      }
    } catch (e) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height - 165,
        child: ListView(children: [
          /*  Container(
            width: double.maxFinite,
            height: 58,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
            // margin: const EdgeInsets.only(right: 16),
            child: TextField(
              onTap: () {
                selectFileFromDeviec("Certificate");
              },
              controller: certificateController,
              keyboardType: TextInputType.text,
              readOnly: true,
              decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
                  hintText: 'pdf,jpg,png,jpeg | limit 2MB'.tr,
                  border: InputBorder.none,
                  counterText: "",
                  suffixIcon: const Icon(Icons.upload_file)),
              maxLines: 1,
              style: const TextStyle(color: Colors.black, fontSize: 16, overflow: TextOverflow.ellipsis, fontFamily: 'Graphik', fontWeight: FontWeight.w400),
            ),
          ),*/
          const SizedBox(height: 10),
          WidgetUtils.appTextWidget(
              context: context, title: 'Product Picture'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 20, color: Color(int.parse(themeColor.value.barColor!.color!))),
          const SizedBox(height: 20),
          cardImageSelection('Upload Product picture', productPictureUrl),
          const SizedBox(height: 20),

          // proCatId=="2"?Container(height: 80,):cardImageSelection('Upload Product Sample picture', product_Sample_picture_url),
          // const SizedBox(height: 20),
          proCatId == "2" || !packagingFlag ? Container(height: 0) : cardImageSelection('Upload Product Packaging picture', productPackagingPictureUrl),
          const SizedBox(height: 20),
          WidgetUtils.appTextWidget(
              context: context, title: 'Upload Certificate'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 20, color: Color(int.parse(themeColor.value.barColor!.color!))),
          const SizedBox(height: 08),
          cardImageSelection('Certificate'.tr, certificateUrl),
          const SizedBox(height: 20),
          WidgetUtils.buttonWidget(
              context: context,
              radius: 8,
              title: widget.buttonText?.tr ?? "Add Product".tr,
              size: 18,
              family: 'Graphik',
              weight: FontWeight.w500,
              callback: () {
                if (certificateFlag && certificateUrl.isEmpty) {
                  WidgetUtils.errorDialog(context, 'Please Select certificate Images'.tr);
                } else if (productPictureUrl.isEmpty) {
                  WidgetUtils.errorDialog(context, 'Please Select Product Images'.tr);
                }
                /*else if(product_Sample_picture.isEmpty){
                  WidgetUtils.errorDialog(context, 'Please Select Sample Product Images'.tr);
                }else if(product_Packaging_picture.isEmpty){
                  WidgetUtils.errorDialog(context, 'Please Select Packaging Product Images'.tr);
                }*/
                else {
                  Navigator.pop(context, true);
                  var loanModel = Provider.of<MasterProvider>(context, listen: false);
                  loanModel.setProductCurrentIndex(1);
                  //productCurrentIndex.value = 1;
                  loanModel.setItemId("");
                  setState(() {});
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NedfiProductListScreen(isFrom: '')));
                }
                setState(() {});
              },
              textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
              color: Color(int.parse(themeColor.value.buttonColor!.color!))),
          const SizedBox(height: 20),
        ]));
  }

  cardImageSelection(String title, List<String> productPictures) {
    return InkWell(
      onTap: () {
        if (title == 'Upload Product picture') {
          if (productPictures.length < 3) {
            selectPhotoFromDevice(title);
          }
        } else if (title == 'Certificate') {
          if (productPictures.isEmpty) {
            selectPhotoFromDevice(title);
          }
        } else {
          if (productPictures.length < 2) {
            selectPhotoFromDevice(title);
          }
        }
        setState(() {});
      },
      child: Container(
          width: double.maxFinite,
          height: 170,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
          // margin: const EdgeInsets.only(right: 16),
          child: productPictures.isNotEmpty
              ? buildPhoto(productPictures, title)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 08),
                    WidgetUtils.appTextWidget(context: context, title: title.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16),
                    const SizedBox(height: 08),
                    WidgetUtils.appTextWidget(context: context, title: "jpg,png,jpeg | limit 2MB".tr, fontWeight: FontWeight.normal, family: 'Graphik', color: Colors.grey, fontSize: 10),
                  ],
                )),
    );
  }

  selectPhotoFromDevice(String title) async {
    List<XFile> image = (await ImagePicker().pickMultiImage());
    setState(() {
      if (title == 'Upload Product picture') {
        for (int i = 0; i < image.length; i++) {
          if (i < 3) {
            if (image[i].path.endsWith(".gif")) {
              WidgetUtils.errorDialog(context, 'GIF image not allowed'.tr);
            } else {
              productPicture.add(File(image[i].path));
            }
          }
        }
        uploadImage(title);
      } else if (title == 'Upload Product Sample picture') {
        for (int i = 0; i < image.length; i++) {
          if (i < 2) {
            if (image[i].path.endsWith(".gif")) {
              WidgetUtils.errorDialog(context, 'GIF image not allowed'.tr);
            } else {
              productSamplePicture.add(File(image[i].path));
            }
          }
        }
        uploadImage(title);
      } else if (title == 'Certificate') {
        for (int i = 0; i < image.length; i++) {
          if (i < 1) {
            if (image[i].path.endsWith(".gif")) {
              WidgetUtils.errorDialog(context, 'GIF image not allowed'.tr);
            } else {
              certificatePicture.add(File(image[i].path));
            }
          }
        }
        uploadImage(title);
      } else {
        for (int i = 0; i < image.length; i++) {
          if (i < 2) {
            if (image[i].path.endsWith(".gif")) {
              WidgetUtils.errorDialog(context, 'GIF image not allowed'.tr);
            } else {
              productPackagingPicture.add(File(image[i].path));
            }
          }
        }
        uploadImage(title);
      }
    });
  }

  Widget buildPhoto(List<String> productPicture, String title) {
    int length = 3;
    if (title == 'Upload Product picture') {
      length = 3;
    } else if (title == 'Upload Product Sample picture') {
      length = 2;
    } else if (title == 'Certificate') {
      length = 1;
    } else {
      length = 2;
    }
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 110,
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: length, crossAxisSpacing: 10.0, mainAxisSpacing: 5.0, childAspectRatio: 12 / 18),
                  itemBuilder: (ctx, index) {
                    return Stack(
                      children: [
                        InkWell(
                            onTap: () {
                              if (title == 'Upload Product picture') {
                                if (productPicture.length < 3) {
                                  final details = productPicture;
                                  selectPhotoFromDevice(title);
                                }
                              } else {
                                if (productPicture.length < 2) {
                                  final details = productPicture;
                                  selectPhotoFromDevice(title);
                                }
                              }
                            },
                            child: SizedBox(
                              height: (MediaQuery.of(context).size.height * 0.18),
                              width: double.maxFinite,
                              child: Column(
                                // mainAxisSize: MainAxisSize.max,
                                children: [
                                  productPicture.length > index
                                      ? Stack(
                                          children: [
                                            Container(
                                                height: 80,
                                                width: 80,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(border: Border.all(color: const Color(0xff27914F)), borderRadius: BorderRadius.circular(17), color: Colors.white),
                                                child: Image.network("${HeaderSingleton().configurationDetails!.tradeProducts}/${productPicture[index]}")),
                                            Positioned(
                                                top: 1,
                                                right: 1,
                                                child: InkWell(
                                                    onTap: () {
                                                      HelperUtils().showNormalDialog(
                                                          context: context,
                                                          title: 'Are_you_sure'.tr,
                                                          content: 'Do you want to delete Image'.tr,
                                                          onYesTapped: (valueCtx) async {
                                                            Navigator.pop(valueCtx);
                                                            await deleteImageDetails(productPicture[index], title, index);
                                                            setState(() {});
                                                          });
                                                    },
                                                    child: SvgPicture.asset("assets/images/cross_design.svg", height: 18)))
                                          ],
                                        )
                                      : Container(
                                          height: 80,
                                          width: 80,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(border: Border.all(color: const Color(0xff27914F)), borderRadius: BorderRadius.circular(17), color: Colors.white),
                                          child: const Icon(Icons.add),
                                        ),
                                  const SizedBox(height: 08),
                                ],
                              ),
                            )),
                      ],
                    );
                  }),
            ),
            SizedBox(height: 20, child: WidgetUtils.appTextWidget(context: context, title: title.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 16)),
          ],
        ));
  }

  deleteImageDetails(String url, String type, int index) async {
    try {
      dynamic param;
      if (type == 'Upload Product picture') {
        param = {"id": id, "image": url, "type": "product"};
      } else if (type == 'Upload Product Sample picture') {
        param = {"id": id, "image": url, "type": "sample_product"};
      } else if (type == 'Certificate') {
        param = {"id": id, "image": url, "type": "certificate"};
      } else {
        param = {"id": id, "image": url, "type": "packaging"};
      }
      final response = await APIService.postAPIMethod(url: ApiURL.removeImage, params: param);
      final data = json.decode(response.body);
      final res = AddProductResponse.fromJson(data);
      if (res.success == 1) {
        WidgetUtils.successDialog(context, res.message ?? "");
        if (type == 'Upload Product picture') {
          productPictureUrl.removeAt(index);
          //product_picture.removeAt(index);
        } else if (type == 'Upload Product Sample picture') {
          productSamplePictureUrl.removeAt(index);
          // product_Sample_picture.removeAt(index);
        } else if (type == 'Certificate') {
          certificateUrl.removeAt(index);
          // product_Sample_picture.removeAt(index);
        } else {
          productPackagingPictureUrl.removeAt(index);
          //  product_Packaging_picture.removeAt(index);
        }
        certificatePicture = [];
        productPicture = [];
        productSamplePicture = [];
        productPackagingPicture = [];
        setState(() {});
      } else {
        WidgetUtils.successDialog(context, res.message ?? "");
      }
    } catch (e) {
      setState(() {});
    }
  }

  Future uploadImage(String title) async {
    isLoading.value = true;

    try {
      final request = http.MultipartRequest('POST', Uri.parse(baseURL + ApiURL.uploadTradeImages));
      if (title == 'Certificate') {
        request.files.add(await http.MultipartFile.fromPath('certificate[]', certificatePicture[0].path));
      } else if (title == 'Upload Product picture') {
        for (int i = 0; i < productPicture.length; i++) {
          if (i < 3) {
            request.files.add(await http.MultipartFile.fromPath('product[]', productPicture[i].path));
            print(productPicture[i].path);
            print(request.files[i].filename ?? "name");
          }
        }
      } else if (title == 'Upload Product Sample picture') {
        for (int i = 0; i < productSamplePicture.length; i++) {
          if (i < 2) {
            request.files.add(await http.MultipartFile.fromPath('sample_product[]', productSamplePicture[i].path));
          }
        }
      } else {
        for (int i = 0; i < productPackagingPicture.length; i++) {
          if (i < 2) {
            request.files.add(await http.MultipartFile.fromPath('packaging[]', productPackagingPicture[i].path));
          }
        }
      }
      request.headers["client-type"] = "seller";
      request.headers["X-API-KEY"] = HeaderSingleton().xAPIKey.value;
      request.headers["domain"] = HeaderSingleton().domain.value;
      request.headers["appname"] = HeaderSingleton().appName.value;
      request.headers["lang"] = HeaderSingleton().local;
      request.fields["id"] = id;
      request.fields["status"] = "1";

      Future.delayed(const Duration(milliseconds: 500), () async {
        await request.send().then((response) async {
          response.stream.transform(utf8.decoder).listen((value) {
            var data = json.decode(value);
            var res = AddProductImage.fromJson(data);
            if (res.success == 1) {
              WidgetUtils.successDialog(context, res.message ?? "");
              setState(() {
                certificateUrl = res.data?.uploadedImage?.certificate ?? [];
                productPictureUrl = res.data?.uploadedImage?.product ?? [];
                productSamplePictureUrl = res.data?.uploadedImage?.sampleProduct ?? [];
                productPackagingPictureUrl = res.data?.uploadedImage?.packaging ?? [];
              });
              certificatePicture = [];
              productPicture = [];
              productSamplePicture = [];
              productPackagingPicture = [];
              setState(() {});
            } else {
              WidgetUtils.errorDialog(context, res.message ?? "");
            }
          });
        }).catchError((e) {
          isLoading.value = false;
          if (e is SocketException) {
            //treat SocketException
            print("Socket exception: ${e.toString()}");
          } else if (e is TimeoutException) {
            //treat TimeoutException
            print("Timeout exception: ${e.toString()}");
          }

          print(e);
        });
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      //   }
    }
  }
}
