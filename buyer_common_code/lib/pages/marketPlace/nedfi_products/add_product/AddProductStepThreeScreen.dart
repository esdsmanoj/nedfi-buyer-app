import 'dart:convert';
import 'dart:io';

import 'package:buyer_common_code/pages/marketPlace/nedfi_products/product_list/NedfiProductListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../components/utils/Constants.dart';
import '../../../../components/utils/helper_utils.dart';
import '../../../../components/utils/widget_utils.dart';
import '../../../../model/AddProductImage.dart';
import '../../../../model/AddProductResponse.dart';
import '../../../../model/trade_product_info.dart';
import '../../../../providers/master_provider.dart';
import '../../../../services/api_service.dart';
import '../../../../singleton/header_singleton.dart';

class AddProductStepThreeScreen extends StatefulWidget {
  String? id;
  String? bottonText;
  AddProductStepThreeScreen({this.id,this.bottonText});

  @override
  State<AddProductStepThreeScreen> createState() => _AddProductStepThreeScreenState();
}

class _AddProductStepThreeScreenState extends State<AddProductStepThreeScreen> {
  TextEditingController? certificateController = TextEditingController();
  List<File> product_picture = [];
  List<File> product_Sample_picture = [];
  List<File> product_Packaging_picture = [];

  List<String> certificate_url = [];
  List<String> product_picture_url = [];
  List<String> product_Sample_picture_url = [];
  List<String> product_Packaging_picture_url = [];
  String id = "";
  String proCatId = "";
  bool certificateFlag = false;
  late var masterProvider;

  selectFileFromDeviec(String type) async {
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
          uploadimage(type);
        }
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
    masterProvider = Provider.of<MasterProvider>(context, listen: false);

    if (masterProvider.itemId != null || masterProvider.itemId != "") {
      id = masterProvider.itemId;

    } else {
      id = widget.id ?? "";
    }
    getProductList();
  }

  Future getProductList() async {
    try {
      var param = {"user_id": HeaderSingleton().paramsMaps!.userId, "id": id};
      final response = await APIService.postAPIMethod(url: ApiURL.getTradeProducts, params: param);
      final data = json.decode(response.body);
      final res = TradeProductInfo.fromJson(data);
      if (res.success == 1) {
        if (res.data != null) {
          var masterProvider = Provider.of<MasterProvider>(context, listen: false);
          masterProvider.setCurrentTreadProduct(res.data![0]);
          masterProvider.setType("EDIT" ?? "");
          masterProvider.setItemId(id ?? "");
          if (masterProvider.type == "EDIT") {
            setState(() {
            id = masterProvider.treadProductCurrent!.id ?? "";
            proCatId=masterProvider.treadProductCurrent!.prodCatId ?? "";
            if (masterProvider.treadProductCurrent!.prod_images != null && masterProvider.treadProductCurrent!.prod_images != null) {
              final images = json.decode(masterProvider.treadProductCurrent!.prod_images ?? "");
              setState(() {
                if (images['certificate'] != null) {
                  certificate_url = images['certificate'].cast<String>() ?? [];
                  certificateController!.text = certificate_url[0];
                }
                if (images['product'] != null) {
                  product_picture_url = images['product'].cast<String>() ?? [];
                }
                if (images['sample_product'] != null) {
                  product_Sample_picture_url = images['sample_product'].cast<String>() ?? [];
                }
                if (images['packaging'] != null) {
                  product_Packaging_picture_url = images['packaging'].cast<String>() ?? [];
                }
              });
            }

            if (masterProvider.treadProductCurrent!.certifcations == "t") {
              certificateFlag = true;
            } else {
              certificateFlag = false;
            }


            });
          }
        }
      }
    } catch (e) {
      //print(e);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height - 165,
        child: ListView(children: [
          const SizedBox(height: 10),
          WidgetUtils.appTextWidget(
              context: context, title: 'Upload Certificate'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 20, color: Color(int.parse(themeColor.value.barColor!.color!))),
          const SizedBox(height: 08),
          Container(
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
          ),
          const SizedBox(height: 10),
          WidgetUtils.appTextWidget(
              context: context, title: 'Product Picture'.tr, fontWeight: FontWeight.w500, family: 'Graphik', fontSize: 20, color: Color(int.parse(themeColor.value.barColor!.color!))),
          const SizedBox(height: 20),
          cardImageSelection('Upload Product picture', product_picture_url),
          const SizedBox(height: 20),
          proCatId=="2"?Container(height: 80,):cardImageSelection('Upload Product Sample picture', product_Sample_picture_url),
          const SizedBox(height: 20),
          proCatId=="2"?Container(height: 80,):cardImageSelection('Upload Product Packaging picture', product_Packaging_picture_url),
          const SizedBox(height: 20),
          WidgetUtils.buttonWidget(
              context: context,
              radius: 8,
              title: widget.bottonText?.tr??"Add Product".tr,
              size: 18,
              family: 'Graphik',
              weight: FontWeight.w500,
              callback: () {
                if (certificateFlag && certificateController!.text.toString().isEmpty) {
                  WidgetUtils.errorDialog(context, 'Please Select certificate Images'.tr);
                } else if (product_picture_url.isEmpty) {
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
                  setState(() {});
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NedfiProductListScreen(isFrom: '')));
                }
              },
              textColor: Color(int.parse(themeColor.value.buttonTextColor!.color!)),
              color: Color(int.parse(themeColor.value.buttonColor!.color!))),
          const SizedBox(height: 20),
        ]));
  }

  cardImageSelection(String title, List<String> product_pictures) {
    return InkWell(
      onTap: () {
        if (title == 'Upload Product picture') {
          if (product_pictures.length < 3) {
            selectPhotoFromDevice(title);
          }
        } else {
          if (product_pictures.length < 2) {
            selectPhotoFromDevice(title);
          }
        }
      },
      child: Container(
          width: double.maxFinite,
          height: 150,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
          // margin: const EdgeInsets.only(right: 16),
          child: product_pictures.isNotEmpty
              ? buildPhoto(product_pictures, title)
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

  selectPhotoFromDevice(
      String title,
      ) async {
    List<XFile> image = (await ImagePicker().pickMultiImage());
    setState(() {
      if (title == 'Upload Product picture') {
        for (int i = 0; i < image.length; i++) {
          if (i < 3) {
            if (image[i].path.endsWith(".gif")) {
              WidgetUtils.errorDialog(context, 'GIF image not allowed'.tr);
            } else {
              product_picture.add(File(image[i].path));
            }
          }
        }
        uploadimage(title);
      } else if (title == 'Upload Product Sample picture') {
        for (int i = 0; i < image.length; i++) {
          if (i < 2) {
            if (image[i].path.endsWith(".gif")) {
              WidgetUtils.errorDialog(context, 'GIF image not allowed'.tr);
            } else {
              product_Sample_picture.add(File(image[i].path));
            }
          }
        }
        uploadimage(title);
      } else {
        for (int i = 0; i < image.length; i++) {
          if (i < 2) {
            if (image[i].path.endsWith(".gif")) {
              WidgetUtils.errorDialog(context, 'GIF image not allowed'.tr);
            } else {
              product_Packaging_picture.add(File(image[i].path));
            }
          }
        }
        uploadimage(title);
      }
    });
  }

  Widget buildPhoto(List<String> product_picture, String title) {
    int lenght = 3;
    if (title == 'Upload Product picture') {
      lenght = 3;
    } else if (title == 'Upload Product Sample picture') {
      lenght = 2;
    } else {
      lenght = 2;
    }
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
            scrollDirection: Axis.vertical,
            itemCount: lenght,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: lenght, crossAxisSpacing: 10.0, mainAxisSpacing: 5.0, childAspectRatio: 12 / 18),
            itemBuilder: (ctx, index) {
              return Stack(
                children: [
                  InkWell(
                      onTap: () {
                        if (title == 'Upload Product picture') {
                          if (product_picture.length < 3) {
                            final details = product_picture;
                            selectPhotoFromDevice(title);
                          }
                        } else {
                          if (product_picture.length < 2) {
                            final details = product_picture;
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
                            product_picture.length > index
                                ? Stack(
                              children: [
                                Container(
                                    height: 80,
                                    width: 80,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(border: Border.all(color: const Color(0xff27914F)), borderRadius: BorderRadius.circular(17), color: Colors.white),
                                    child: Image.network("${HeaderSingleton().configurationDetails!.tradeProducts}/${product_picture[index]}")),
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
                                                await deleteImageDetails(product_picture[index], title, index);
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
                          ],
                        ),
                      )),
                ],
              );
            }));
  }

  deleteImageDetails(String url, String type, int index) async {
    try {
      late var param;
      if (type == 'Upload Product picture') {
        param = {"id": id, "image": url, "type": "product"};
      } else if (type == 'Upload Product Sample picture') {
        param = {"id": id, "image": url, "type": "sample_product"};
      } else {
        param = {"id": id, "image": url, "type": "packaging"};
      }

      final response = await APIService.postAPIMethod(url: ApiURL.removeImage, params: param);
      final data = json.decode(response.body);
      //print(data);
      final res = AddProductResponse.fromJson(data);
      if (res.success == 1) {
        WidgetUtils.successDialog(context, res.message ?? "");
        if (type == 'Upload Product picture') {
          product_picture_url.removeAt(index);
          //product_picture.removeAt(index);
        } else if (type == 'Upload Product Sample picture') {
          product_Sample_picture_url.removeAt(index);
          // product_Sample_picture.removeAt(index);
        } else {
          product_Packaging_picture_url.removeAt(index);
          //  product_Packaging_picture.removeAt(index);
        }
        product_picture = [];
        product_Sample_picture = [];
        product_Packaging_picture = [];
        setState(() {});
      } else {
        WidgetUtils.successDialog(context, res.message ?? "");
      }
    } catch (e) {
      //print(e);
      setState(() {});
    }
  }

  Future uploadimage(String title) async {
    isLoading.value = true;

    try {
      final request = http.MultipartRequest('POST', Uri.parse(baseURL + ApiURL.uploadTradeImages));
      if (title == 'Certificate') {
        request.files.add(await http.MultipartFile.fromPath('certificate[]', certificateController!.text));
      } else if (title == 'Upload Product picture') {
        for (int i = 0; i < product_picture.length; i++) {
          if (i < 3) {
            request.files.add(await http.MultipartFile.fromPath('product[]', product_picture[i].path));
          }
        }
      } else if (title == 'Upload Product Sample picture') {
        for (int i = 0; i < product_Sample_picture.length; i++) {
          if (i < 2) {
            request.files.add(await http.MultipartFile.fromPath('sample_product[]', product_Sample_picture[i].path));
          }
        }
      } else {
        for (int i = 0; i < product_Packaging_picture.length; i++) {
          if (i < 2) {
            request.files.add(await http.MultipartFile.fromPath('packaging[]', product_Packaging_picture[i].path));
          }
        }
      }
      request.headers["client-type"] = "buyer";
      request.headers["X-API-KEY"] = HeaderSingleton().xAPIKey.value;
      request.headers["domain"] = HeaderSingleton().domain.value;
      request.headers["appname"] = HeaderSingleton().appName.value;
      request.headers["lang"] = HeaderSingleton().local;
      request.fields["id"] = id;
      Future.delayed(const Duration(milliseconds: 500), () async {
        await request.send().then((response) async {
          response.stream.transform(utf8.decoder).listen((value) {
            var data = json.decode(value);
            //print(data);
            var res = AddProductImage.fromJson(data);
            if (res.success == 1) {
              WidgetUtils.successDialog(context, res.message ?? "");
              setState(() {
                certificate_url = res.data?.uploadedImage?.certificate ?? [];
                product_picture_url = res.data?.uploadedImage?.product ?? [];
                product_Sample_picture_url = res.data?.uploadedImage?.sampleProduct ?? [];
                product_Packaging_picture_url = res.data?.uploadedImage?.packaging ?? [];
              });
              product_picture = [];
              product_Sample_picture = [];
              product_Packaging_picture = [];
              setState(() {});
            } else {
              WidgetUtils.errorDialog(context, res.message ?? "");
            }
          });
        }).catchError((e) {
          isLoading.value = false;
          // //print(e);
        });
        isLoading.value = false;
      });
    } catch (e) {
      //print(e.toString());
      isLoading.value = false;
      //   }
    }
  }
}
