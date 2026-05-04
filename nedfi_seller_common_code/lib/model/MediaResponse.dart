class MediaList {
  int? success;
  List<MediaData>? data;
  List<Featured>? featured;
  String? msg;
  int? error;
  int? status;
  String? baseUrl;

  MediaList({this.success, this.data, this.featured, this.msg, this.error, this.status,this.baseUrl});

  MediaList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <MediaData>[];
      json['data'].forEach((v) {
        data!.add(MediaData.fromJson(v));
      });
    }
    if (json['featured'] != null) {
      featured = <Featured>[];
      json['featured'].forEach((v) {
        featured!.add(Featured.fromJson(v));
      });
    }
    msg = json['msg'];
    error = json['error'];
    status = json['status'];
    baseUrl = json['base_url_media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (featured != null) {
      data['featured'] = featured!.map((v) => v.toJson()).toList();
    }
    data['msg'] = msg;
    data['error'] = error;
    data['status'] = status;
    data['base_url_media'] = baseUrl;
    return data;
  }
}

class MediaData {
  String? mediaId;
  String? url;
  String? urlType;
  String? title;
  String? description;
  String? isActive;
  String? createdById;
  String? createdOn;
  String? updatedById;
  String? updatedOn;
  String? isDeleted;
  dynamic deletedById;
  dynamic deletedOn;
  String? partnerId;
  String? category;
  String? publishedOn;
  String? isHome;
  String? isFeatured;
  String? thumbnails;
  String? viewCount;
  dynamic domainId;
  dynamic domainKey;
  dynamic groupId;
  dynamic uuid;
  String? audioUrl;
  dynamic mediaType;

  MediaData(
      {this.mediaId,
      this.url,
      this.urlType,
      this.title,
      this.description,
      this.isActive,
      this.createdById,
      this.createdOn,
      this.updatedById,
      this.updatedOn,
      this.isDeleted,
      this.deletedById,
      this.deletedOn,
      this.partnerId,
      this.category,
      this.publishedOn,
      this.isHome,
      this.isFeatured,
      this.thumbnails,
      this.viewCount,
      this.domainId,
      this.domainKey,
      this.groupId,
      this.uuid,
      this.audioUrl,
      this.mediaType});

  MediaData.fromJson(Map<String, dynamic> json) {
    mediaId = json['media_id'];
    url = json['url'];
    urlType = json['url_type'];
    title = json['title'];
    description = json['description'];
    isActive = json['is_active'];
    createdById = json['created_by_id'];
    createdOn = json['created_on'];
    updatedById = json['updated_by_id'];
    updatedOn = json['updated_on'];
    isDeleted = json['is_deleted'];
    deletedById = json['deleted_by_id'];
    deletedOn = json['deleted_on'];
    partnerId = json['partner_id'];
    category = json['category'];
    publishedOn = json['published_on'];
    isHome = json['is_home'];
    isFeatured = json['is_featured'];
    thumbnails = json['thumbnails'];
    viewCount = json['view_count'];
    domainId = json['domain_id'];
    domainKey = json['domain_key'];
    groupId = json['group_id'];
    uuid = json['uuid'];
    audioUrl = json['audio_url'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['media_id'] = mediaId;
    data['url'] = url;
    data['url_type'] = urlType;
    data['title'] = title;
    data['description'] = description;
    data['is_active'] = isActive;
    data['created_by_id'] = createdById;
    data['created_on'] = createdOn;
    data['updated_by_id'] = updatedById;
    data['updated_on'] = updatedOn;
    data['is_deleted'] = isDeleted;
    data['deleted_by_id'] = deletedById;
    data['deleted_on'] = deletedOn;
    data['partner_id'] = partnerId;
    data['category'] = category;
    data['published_on'] = publishedOn;
    data['is_home'] = isHome;
    data['is_featured'] = isFeatured;
    data['thumbnails'] = thumbnails;
    data['view_count'] = viewCount;
    data['domain_id'] = domainId;
    data['domain_key'] = domainKey;
    data['group_id'] = groupId;
    data['uuid'] = uuid;
    data['audio_url'] = audioUrl;
    data['media_type'] = mediaType;
    return data;
  }
}

class Featured {
  String? mediaId;
  String? url;
  String? urlType;
  String? title;
  String? description;
  String? partnerId;
  String? category;
  String? publishedOn;
  String? thumbnails;
  String? viewCount;
  String? isHome;
  String? isFeatured;

  Featured({this.mediaId, this.url, this.urlType, this.title, this.description, this.partnerId, this.category, this.publishedOn, this.thumbnails, this.viewCount, this.isHome, this.isFeatured});

  Featured.fromJson(Map<String, dynamic> json) {
    mediaId = json['media_id'];
    url = json['url'];
    urlType = json['url_type'];
    title = json['title'];
    description = json['description'];
    partnerId = json['partner_id'];
    category = json['category'];
    publishedOn = json['published_on'];
    thumbnails = json['thumbnails'];
    viewCount = json['view_count'];
    isHome = json['is_home'];
    isFeatured = json['is_featured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['media_id'] = mediaId;
    data['url'] = url;
    data['url_type'] = urlType;
    data['title'] = title;
    data['description'] = description;
    data['partner_id'] = partnerId;
    data['category'] = category;
    data['published_on'] = publishedOn;
    data['thumbnails'] = thumbnails;
    data['view_count'] = viewCount;
    data['is_home'] = isHome;
    data['is_featured'] = isFeatured;
    return data;
  }
}
