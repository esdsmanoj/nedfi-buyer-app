class AddProductImage {
  int? success;
  AddProductImageData? data;
  String? message;
  List<String>? error;

  AddProductImage({this.success, this.data, this.message, this.error});

  AddProductImage.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new AddProductImageData.fromJson(json['data']) : null;
    message = json['message'];
    error = json['error'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}

class AddProductImageData {
  UploadedImage? uploadedImage;

  AddProductImageData({this.uploadedImage});

  AddProductImageData.fromJson(Map<String, dynamic> json) {
    uploadedImage = json['uploaded_image'] != null
        ? new UploadedImage.fromJson(json['uploaded_image'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uploadedImage != null) {
      data['uploaded_image'] = this.uploadedImage!.toJson();
    }
    return data;
  }
}

class UploadedImage {
  List<String>? product;
  List<String>? packaging;
  List<String>? certificate;
  List<String>? sampleProduct;

  UploadedImage(
      {this.product, this.packaging, this.certificate, this.sampleProduct});

  UploadedImage.fromJson(Map<String, dynamic> json) {

    if(json['product']!=null){
      product = json['product'].cast<String>();
    }
    if(json['packaging']!=null) {
      packaging = json['packaging'].cast<String>();
    }
    if(json['certificate']!=null) {
      certificate = json['certificate'].cast<String>();
    }
    if(json['sample_product']!=null) {
      sampleProduct = json['sample_product'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['product'] = this.product;
    data['packaging'] = this.packaging;
    data['certificate'] = this.certificate;
    data['sample_product'] = this.sampleProduct;
    return data;
  }
}