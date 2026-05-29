class ChatResponse {
  String? status;
  List<Message>? messages;

  ChatResponse({this.status, this.messages});

  ChatResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Message {
  int? messageId;
  int? chatId;
  int? senderId;
  String? message;
  String? messageType;
  String? createdAt;
  String? status;

  Message({
    this.messageId,
    this.chatId,
    this.senderId,
    this.message,
    this.messageType,
    this.createdAt,
    this.status,
  });

  Message.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
    chatId = json['chat_id'];
    senderId = json['sender_id'];
    message = json['message'];
    messageType = json['message_type'];
    createdAt = json['created_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message_id'] = messageId;
    data['chat_id'] = chatId;
    data['sender_id'] = senderId;
    data['message'] = message;
    data['message_type'] = messageType;
    data['created_at'] = createdAt;
    data['status'] = status;
    return data;
  }
}