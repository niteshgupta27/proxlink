
import 'otpresponse.dart';

class SocialResponse {
  final String status;
  final String? message;
  final int? userId;
  final String? apiKey;
  final bool? isNewUser;
  final UserData? data;
  String? token;

  SocialResponse({
    required this.status,
    this.message,
    this.userId,
    this.apiKey,
    this.isNewUser,
    this.token,
    this.data,
  });

  factory SocialResponse.fromJson(Map<String, dynamic> json) {
    return SocialResponse(
      status: json['status']?.toString() ?? "",
      message: json['message']?.toString(),
      userId: json['user_id'],
      apiKey: json['api_key'],
      isNewUser: json['is_new_user'],
      token: json['api_key'] ?? (json.containsKey('data') && json['data'] != null && json['data'].containsKey('token') ? json['data']['token'] : ""),
      data: (json.containsKey('data') && json['data'] != null && json['data'].containsKey('user') && json['data']['user'] != null)
          ? UserData.fromJson(json['data']['user'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'user_id': userId,
      'api_key': apiKey,
      'is_new_user': isNewUser,
      'data': data?.toJson(),
    };
  }
}
