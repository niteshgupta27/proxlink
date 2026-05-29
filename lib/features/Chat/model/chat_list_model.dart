class ChatListResponse {
  String? status;
  List<ChatData>? chats;

  ChatListResponse({this.status, this.chats});

  ChatListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['chats'] != null) {
      chats = <ChatData>[];
      json['chats'].forEach((v) {
        chats!.add(ChatData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.chats != null) {
      data['chats'] = this.chats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatData {
  int? chatId;
  String? chatType;
  String? displayName;
  String? lastMessage;
  String? messageType;
  String? lastMessageTime;
  int? unreadCount;
  ChatUser? user;

  ChatData({
    this.chatId,
    this.chatType,
    this.displayName,
    this.lastMessage,
    this.messageType,
    this.lastMessageTime,
    this.unreadCount,
    this.user,
  });

  ChatData.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    chatType = json['chat_type'];
    displayName = json['display_name'];
    lastMessage = json['last_message'];
    messageType = json['message_type'];
    lastMessageTime = json['last_message_time'];
    unreadCount = json['unread_count'];
    user = json['user'] != null ? ChatUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    data['chat_type'] = chatType;
    data['display_name'] = displayName;
    data['last_message'] = lastMessage;
    data['message_type'] = messageType;
    data['last_message_time'] = lastMessageTime;
    data['unread_count'] = unreadCount;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }

  // Helper getters to maintain compatibility if needed
  int? get otherUserId => user?.userId;
  String? get otherUserName => user?.name ?? displayName;
  String? get otherUserImage => null; // JSON didn't provide image field
}

class ChatUser {
  int? userId;
  String? name;
  String? age;
  String? gender;
  String? profession;
  String? company;

  ChatUser({
    this.userId,
    this.name,
    this.age,
    this.gender,
    this.profession,
    this.company,
  });

  ChatUser.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    age = json['age'];
    gender = json['gender'];
    profession = json['profession'];
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['age'] = age;
    data['gender'] = gender;
    data['profession'] = profession;
    data['company'] = company;
    return data;
  }
}
