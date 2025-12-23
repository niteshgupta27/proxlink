import '../../Otp/model/otpresponse.dart';

class SocialResponse {
  final bool status;
  final int registration;
  final int numberVerification;
  final String message;
  final UserData? data;
  String token;
  SocialResponse({
    required this.status,
    required this.registration,
    required this.numberVerification,
    required this.message,
    required this.token,
    this.data,
  });

  factory SocialResponse.fromJson(Map<String, dynamic> json) {
    return SocialResponse(
      status: json['status'],
      registration: json['Registration'],
      numberVerification: json['Number verification'],
      message: json['message'],
      data: (json.containsKey('data') && json['data'] != null && json['data'].containsKey('user') && json['data']['user'] != null)?UserData.fromJson(json['data']['user']):UserData.fromJson({}),
      token: (json.containsKey('data') && json['data'] != null && json['data'].containsKey('token') && json['data']['token'] != null)
          ? json['data']['token']
          : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'Registration': registration,
      'Number verification': numberVerification,
      'message': message,
      'data': data?.toJson(),
    };
  }
}


