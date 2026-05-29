import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_base_client.dart';
import '../model/chat_list_model.dart';
import '../model/message_model.dart';

class ChatService {
  Future<dynamic> getOrCreateChat({required int otherUserId, required int userId, required String apiKey}) async {
    try {
      final body = {
        "user_id": userId,
        "api_key": apiKey,
        "payload": {
          "type": "PRIVATE",
          "other_user_id": otherUserId
        }
      };
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.get_or_create_chat,
        body: body,
      );
      return response;
    } catch (exception) {
      rethrow;
    }
  }

  Future<ChatListResponse> getChatList({required int userId, required String apiKey}) async {
    try {
      final body = {
        "user_id": userId,
        "api_key": apiKey,
      };
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.chat_list,
        body: body,
      );
      return ChatListResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      rethrow;
    }
  }

  Future<ChatResponse> getMessages({required int chat_id, required int last_id, required int userId, required String apiKey}) async {
    try {
      final body = {
        "user_id": userId,
        "api_key": apiKey,
        "payload": {
          "chat_id": chat_id,
          "last_id": last_id
        }
      };
      print(body);
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.chat_get_messages,
        body: body,
      );
      return  ChatResponse.fromJson(response as Map<String, dynamic>);
    } catch (exception) {
      rethrow;
    }
  }

  Future<dynamic> sendMessage({required int chat_id, required String message, required String type, required int userId, required String apiKey}) async {
    try {
      final body = {
        "user_id": userId,
        "api_key": apiKey,
        "payload": {
          "chat_id": chat_id,
          "message": message,
          "type": type
        }
      };
      final response = await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.chat_send,
        body: body,
      );
      return response;
    } catch (exception) {
      rethrow;
    }
  }

  Future<dynamic> markRead({required int chat_id, required int last_message_id, required int userId, required String apiKey}) async {
    try {
      final body = {
        "user_id": userId,
        "api_key": apiKey,
        "payload": {
          "chat_id": chat_id,
          "last_message_id": last_message_id
        }
      };
      return await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.chat_mark_read,
        body: body,
      );
    } catch (exception) {
      rethrow;
    }
  }

  Future<dynamic> markDelivered({required int chat_id, required int last_message_id, required int userId, required String apiKey}) async {
    try {
      final body = {
        "user_id": userId,
        "api_key": apiKey,
        "payload": {
          "chat_id": chat_id,
          "last_message_id": last_message_id
        }
      };
      return await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.chat_mark_delivered,
        body: body,
      );
    } catch (exception) {
      rethrow;
    }
  }

  Future<dynamic> setUserOnlineStatus({required int userId, required String apiKey, required bool isOnline}) async {
    try {
      final body = {
        "user_id": userId,
        "api_key": apiKey,
        "payload": {
          "is_online": isOnline ? 1 : 0
        }
      };
      return await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.user_online_status,
        body: body,
      );
    } catch (exception) {
      rethrow;
    }
  }

  Future<dynamic> sendTypingStatus({required int userId, required String apiKey, required int chatId, required bool isTyping}) async {
    try {
      final body = {
        "user_id": userId,
        "api_key": apiKey,
        "payload": {
          "chat_id": chatId,
          "is_typing": isTyping ? 1 : 0
        }
      };
      return await BaseClient.sharedClient.postRequest(
        endPoint: AppConstants.chat_typing,
        body: body,
      );
    } catch (exception) {
      rethrow;
    }
  }

  Future<dynamic> getOnlineStatus({required int userId}) async {
    try {
      final uri = "${AppConstants.baseUrl}${AppConstants.user_online_status}?user_id=$userId";
      final response = await BaseClient.sharedClient.get(uri);
      return response.body;
    } catch (exception) {
      rethrow;
    }
  }
}
