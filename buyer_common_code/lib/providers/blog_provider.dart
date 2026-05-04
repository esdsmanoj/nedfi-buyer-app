import 'package:buyer_common_code/model/BlogDetailsResponse.dart';
import 'package:flutter/material.dart';

import '../model/BlogTypeResponse.dart';
import '../model/home_page_model.dart' as br;

class BlogsProvider extends ChangeNotifier {
  List<BlogType> blogTypeList = List<BlogType>.empty();
  List<br.Blogs> blogList = [];
  List<BlogDetailsData> blogDetailsList = List<BlogDetailsData>.empty();
  List<SimilarBlogs> similarBlogDetailsList = List<SimilarBlogs>.empty();
  ConfigUrl configUrl = ConfigUrl(
      categoryImgUrl: "",
      partnerImgUrl: "",
      aadharNoDocUrl: "",
      panNoDocUrl: "",
      farmImageUrl: "",
      ProductImageUrl: "",
      marketCatImageUrl: "",
      serviceImageUrl: "",
      blogsTypesUrl: "",
      blogsTagsUrl: "",
      createdBlogsUrl: "",
      farmerDocumentsUrl: "",
      advertiseImageUrl: "",
      whitelabelImageUrl: "",
      termsSheet: "",
      farmDoc: "",
      insuranceCompany: "",
      cropImageUrl: "",
      cropTypeUrl: "",
      notice: "",
      announcement: "",
      cropHealthPredictApi: "",
      dssModuleImageurl: "",
      bottomMenuIcon: "",
      cropVerityImgUrl: "",
      cropFertiImgUrl: "",
      soilHealthImage: "",
      loanImageUrl: '');

  setConfigUrl(ConfigUrl list) {
    configUrl = list;
    notifyListeners();
  }

  setBlogTypeList(List<BlogType> list) {
    blogTypeList = List<BlogType>.empty();
    blogTypeList = list;
    notifyListeners();
  }

  setBlogsList(List<br.Blogs> list) {
    // blogList=List<br.BlogData>.empty();
    blogList.addAll(list);
    notifyListeners();
  }

  setBlogsClear() {
    blogList = [];
    notifyListeners();
  }

  setBlogDetailsList(List<BlogDetailsData> list) {
    blogDetailsList = List<BlogDetailsData>.empty();
    blogDetailsList = list;
    notifyListeners();
  }

  setSimilerBlogDetailsList(List<SimilarBlogs> list) {
    similarBlogDetailsList = List<SimilarBlogs>.empty();
    similarBlogDetailsList = list;
    notifyListeners();
  }
}
