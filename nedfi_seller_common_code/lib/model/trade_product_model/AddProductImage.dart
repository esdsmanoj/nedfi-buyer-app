class AddProductImage {
  int? success;
  AddProductImageData? data;
  String? message;
  dynamic error;

  AddProductImage({this.success, this.data, this.message, this.error});

  AddProductImage.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? AddProductImageData.fromJson(json['data']) : null;
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['error'] = error;
    return data;
  }
}

class AddProductImageData {
  UploadedImage? uploadedImage;

  AddProductImageData({this.uploadedImage});

  AddProductImageData.fromJson(Map<String, dynamic> json) {
    uploadedImage = json['uploaded_image'] != null ? UploadedImage.fromJson(json['uploaded_image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (uploadedImage != null) {
      data['uploaded_image'] = uploadedImage!.toJson();
    }
    return data;
  }
}

class UploadedImage {
  List<String>? product;
  List<String>? packaging;
  List<String>? certificate;
  List<String>? sampleProduct;

  UploadedImage({this.product, this.packaging, this.certificate, this.sampleProduct});

  UploadedImage.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = json['product'].cast<String>();
    }
    if (json['packaging'] != null) {
      packaging = json['packaging'].cast<String>();
    }
    if (json['certificate'] != null) {
      certificate = json['certificate'].cast<String>();
    }
    if (json['sample_product'] != null) {
      sampleProduct = json['sample_product'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['product'] = product;
    data['packaging'] = packaging;
    data['certificate'] = certificate;
    data['sample_product'] = sampleProduct;
    return data;
  }
}
