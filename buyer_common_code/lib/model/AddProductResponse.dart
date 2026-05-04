class AddProductResponse{
  AddProductResponse({
    required this.success,
    required this.data,
    required this.error,
    required this.message,
  });

  late final int success;
  late final dynamic data;
  late final dynamic error;
  late final String message;


  AddProductResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'].toString();
    error = json['error'];
    message = json['message'];

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data;
    _data['error'] = error;
    _data['message'] = message;

    return _data;
  }

}

class AddProductData {
  List<String>? product;
  List<String>? packaging;
  List<String>? certificate;
  List<String>? sampleProduct;

  AddProductData(
      {this.product, this.packaging, this.certificate, this.sampleProduct});

  AddProductData.fromJson(Map<String, dynamic> json) {

    product = json['product'].cast<String>();
    packaging = json['packaging'].cast<String>();
    certificate = json['certificate'].cast<String>();
    sampleProduct = json['sample_product'].cast<String>();
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