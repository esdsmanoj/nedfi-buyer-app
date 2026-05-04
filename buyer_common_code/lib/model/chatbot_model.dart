class ChatBotModel {
  int? success;
  int? error;
  int? status;
  ChatBotData? data;
  String? chat;
  String? message;

  ChatBotModel({this.success, this.error, this.status, this.data, this.chat, this.message});

  ChatBotModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    status = json['status'];
    data = json['data'] != null ? ChatBotData.fromJson(json['data']) : null;
    chat = json['chat'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['chat'] = chat;
    data['message'] = message;
    return data;
  }
}

class ChatBotData {
  ChatBotResponse? chatBotResponse;
  List<ChatBotReplay>? chatBotReplay;
  String? chatBotError;

  ChatBotData({this.chatBotResponse, this.chatBotReplay, this.chatBotError});

  ChatBotData.fromJson(Map<String, dynamic> json) {
    chatBotResponse = json['chat_bot_response'] != null ? ChatBotResponse.fromJson(json['chat_bot_response']) : null;
    if (json['chat_bot_replay'] != null) {
      chatBotReplay = <ChatBotReplay>[];
      json['chat_bot_replay'].forEach((v) {
        chatBotReplay!.add(ChatBotReplay.fromJson(v));
      });
    }
    chatBotError = json['chat_bot_error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (chatBotResponse != null) {
      data['chat_bot_response'] = chatBotResponse!.toJson();
    }
    if (chatBotReplay != null) {
      data['chat_bot_replay'] = chatBotReplay!.map((v) => v.toJson()).toList();
    }
    data['chat_bot_error'] = chatBotError;
    return data;
  }
}

class ChatBotResponse {
  String? s1;
  String? s2;
  String? s3;

  ChatBotResponse({this.s1, this.s2, this.s3});

  ChatBotResponse.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1'] = s1;
    data['2'] = s2;
    data['3'] = s3;
    return data;
  }
}

class ChatBotReplay {
  String? id;
  String? cbTitle;
  String? cbKeywords;
  String? cbResponsedata;

  ChatBotReplay({this.id, this.cbTitle, this.cbKeywords, this.cbResponsedata});

  ChatBotReplay.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cbTitle = json['cb_title'];
    cbKeywords = json['cb_keywords'];
    cbResponsedata = json['cb_responsedata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cb_title'] = cbTitle;
    data['cb_keywords'] = cbKeywords;
    data['cb_responsedata'] = cbResponsedata;
    return data;
  }
}
