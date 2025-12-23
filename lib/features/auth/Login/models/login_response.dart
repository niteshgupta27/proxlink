class LoginResponse {
 // bool? success;
  String? message;
  int? Numberverification;
  dynamic? data;
  int? Registration;

  LoginResponse({
  //  this.success,
    this.message,
    this.Numberverification,
    this.data,
    this.Registration,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
       // success: json["success"],
        message: json["message"],
    Numberverification: json["Number verification"],
        data: json["data"],
    Registration: json["Registration"],
      );

  Map<String, dynamic> toJson() => {
       // "success": success,
        "message": message,
        "Numberverification": Numberverification,
        "data": data,
        "Registration": Registration,
      };
}
