class BlogDetailsResponse {
  BlogDetailsResponse({required this.status, required this.data, required this.similarBlogs, required this.resultTagsBlogs, required this.message});

  late final int status;
  late final List<BlogDetailsData> data;
  late final List<SimilarBlogs> similarBlogs;
  late final List<dynamic> resultTagsBlogs;
  late final String message;

  BlogDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = List.from(json['data']).map((e) => BlogDetailsData.fromJson(e)).toList();
    similarBlogs = List.from(json['similar_blogs']).map((e) => SimilarBlogs.fromJson(e)).toList();
    resultTagsBlogs = List.castFrom<dynamic, dynamic>(json['result_tags_blogs']);
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['similar_blogs'] = similarBlogs.map((e) => e.toJson()).toList();
    _data['result_tags_blogs'] = resultTagsBlogs;
    _data['message'] = message;
    return _data;
  }
}

class BlogDetailsData {
  BlogDetailsData({
    required this.blogsId,
    required this.logo,
    required this.blogsTagsId,
    required this.blogsTypesId,
    required this.id,
    required this.blogsTitle,
    required this.blogsSubTitle,
    required this.blogsDescription,
    required this.blogsSubDescription,
    required this.blogsCreatedOn,
    required this.blogsTypesName,
    required this.blogsTypesLogo,
    required this.blogsTypesMobIcon,
    required this.blogsTypesNameMr,
  });

  late final String blogsId;
  late final String logo;
  late final String blogsTagsId;
  late final String blogsTypesId;
  late final String id;
  late final String blogsTitle;
  late final String blogsSubTitle;
  late final String blogsDescription;
  late final String blogsSubDescription;
  late final String blogsCreatedOn;
  late final String blogsTypesName;
  late final String blogsTypesLogo;
  late final String blogsTypesMobIcon;
  late final String blogsTypesNameMr;

  BlogDetailsData.fromJson(Map<String, dynamic> json) {
    blogsId = json['blogs_id'] ?? "";
    logo = json['logo'] ?? "";
    blogsTagsId = json['blogs_tags_id'] ?? "";
    blogsTypesId = json['blogs_types_id'] ?? "";
    id = json['id'] ?? "";
    blogsTitle = json['blogs_title'] ?? "";
    blogsSubTitle = json['blogs_sub_title'] ?? "";
    blogsDescription = json['blogs_description'] ?? "";
    blogsSubDescription = json['blogs_sub_description'] ?? "";
    blogsCreatedOn = json['blogs_created_on'] ?? "";
    blogsTypesName = json['blogs_types_name'] ?? "";
    blogsTypesLogo = json['blogs_types_logo'] ?? "";
    blogsTypesMobIcon = json['blogs_types_mob_icon'] ?? "";
    blogsTypesNameMr = json['blogs_types_name_mr'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['blogs_id'] = blogsId;
    _data['logo'] = logo;
    _data['blogs_tags_id'] = blogsTagsId;
    _data['blogs_types_id'] = blogsTypesId;
    _data['id'] = id;
    _data['blogs_title'] = blogsTitle;
    _data['blogs_sub_title'] = blogsSubTitle;
    _data['blogs_description'] = blogsDescription;
    _data['blogs_sub_description'] = blogsSubDescription;
    _data['blogs_created_on'] = blogsCreatedOn;
    _data['blogs_types_name'] = blogsTypesName;
    _data['blogs_types_logo'] = blogsTypesLogo;
    _data['blogs_types_mob_icon'] = blogsTypesMobIcon;
    _data['blogs_types_name_mr'] = blogsTypesNameMr;
    return _data;
  }
}

class SimilarBlogs {
  SimilarBlogs({
    required this.id,
    required this.title,
    required this.logo,
  });

  late final String id;
  late final String title;
  late final String logo;

  SimilarBlogs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['logo'] = logo;
    return _data;
  }
}
