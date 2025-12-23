class OtpResponse {
  bool status;
  String message;
  UserData data;
  String token;
  int? Registration;

  OtpResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.token,
    this.Registration
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      status: json['status'],
      message: json['message'],
      data: json.containsKey('data') && json['data'] != null && json["data"] is Map<String, dynamic> && json['data'].containsKey('user') && json['data']['user'] != null?UserData.fromJson(json['data']['user']):UserData.fromJson({}),
      token: json.containsKey('data') && json['data'] != null &&json["data"] is Map<String, dynamic>  && json['data'].containsKey('token') && json['data']['token'] != null
          ? json['data']['token']
          : "",
      Registration: json.containsKey('Registration') && json['Registration'] != null?json['Registration']:0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
      'token':token,
      'Registration':Registration
    };
  }
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? number;
  String? otp;
  String? image;
  String? otpExpiredAt;
  String? emailVerifiedAt;
  int? walletBalance;
  String? temporaryToken;
  String? referralCode;
  String? referredBy;
  String? providerId;
  String? providerName;
  int? isBlock;
  int? registration;
  int? numberVerify;
  String? createdAt;
  String? updatedAt;
//String? token;
  UserData({
     this.id,
    this.name,
    this.email,
     this.number,
     this.otp,
    this.image,
     this.otpExpiredAt,
    this.emailVerifiedAt,
    // this.walletBalance,
    this.temporaryToken,
    this.referralCode,
    this.referredBy,
    this.providerId,
    this.providerName,
     this.isBlock,
     this.registration,
     this.numberVerify,
     this.createdAt,
     this.updatedAt,

  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json.containsKey('id') &&json['id']!= null?json['id']:0,
      name: json.containsKey('name') &&json['name'] != null?json['name']:"",
      email: json.containsKey('email') &&json['email'] != null?json['email']:"",
      number:json.containsKey('number') &&json['number'] != null? json['number']:"",
      otp: json.containsKey('otp') &&json['otp'] != null?json['otp']:"",
      image: json.containsKey('image') &&json['image'] != null?json['image']:"",
      otpExpiredAt:json.containsKey('otp_expired_at') && json['otp_expired_at'] != null?json['otp_expired_at']:"",
      emailVerifiedAt:json.containsKey('email_verified_at') &&json['email_verified_at'] != null? json['email_verified_at']:"",
     // walletBalance: json.containsKey('wallet_balance') &&json['wallet_balance'] != null?int.parse(json['wallet_balance']):0,
      temporaryToken:json.containsKey('temporary_token') &&json['temporary_token'] != null? json['temporary_token']:"",
      referralCode: json.containsKey('referral_code') &&json['referral_code'] != null?json['referral_code']:"",
      referredBy: json.containsKey('referred_by') &&json['referred_by'] != null?json['referred_by']:"",
      providerId: json.containsKey('provider_id') &&json['provider_id'] != null?json['provider_id']:"",
      providerName:json.containsKey('provider_name') && json['provider_name'] != null?json['provider_name']:"",
      isBlock: json.containsKey('is_block') &&json['is_block'] != null?json['is_block']:0,
      registration:json.containsKey('registration') &&json['registration'] != null? json['registration']:1,
      numberVerify:json.containsKey('number_verify') && json['number_verify'] != null?json['number_verify']:0,
      createdAt: json.containsKey('created_at') &&json['created_at'] != null?json['created_at']:"",
      updatedAt:json.containsKey('updated_at') &&json['updated_at'] != null? json['updated_at']:"",

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'number': number,
      'otp': otp,
      'image': image,
      'otp_expired_at': otpExpiredAt,
      'email_verified_at': emailVerifiedAt,
      'wallet_balance': walletBalance,
      'temporary_token': temporaryToken,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'provider_id': providerId,
      'provider_name': providerName,
      'is_block': isBlock,
      'registration': registration,
      'number_verify': numberVerify,
      'created_at': createdAt,
      'updated_at': updatedAt,
      //'token':token
    };
  }
}