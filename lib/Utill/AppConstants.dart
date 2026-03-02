class AppConstants {
  static const String appName = 'proxlink';
  static const double appVersion = 7.4;
  static const String fontFamily_ADLaM_Display = 'ADLaM Display';
  static const String fontFamily_Acre = 'Acre';

  static const String fontFamily_Inter = 'Inter';

  static const String baseUrl = 'https://customersquare.com/lalaat/api/';
  static const String ImaepathHost='https://dashboard.proxlink.com/';
  // static const String baseUrl = 'https://proxlink.encodeit.in/api/';
  // static const String ImaepathHost='https://proxlink.encodeit.in/';
  static const String configUri = '/api/v1/config';
  static const String payment_link=ImaepathHost+'payment/gateway';

  static const loginUserInformation = 'loginUserInformation_storage';
  static const loginUserInformationToken = 'loginUserInformation_token';
  static const loginUserId = 'login_user_id';
  static const productHeaderColor = "productHeaderColor";
  static const ServiceHeaderColor = "ServiceHeaderColor";
  static const AmcHeaderColor = "amcHeaderColor";
  static const SplashTime="SplashTime";
  static const SplashPath="SplashPath";
  static const loginTime="loginTime";
  static const loginimgPath="loginimgPath";

  static const Referalcontent = "Referalcontent";
  static const  cartList = 'cart_list';
  static const  AddressList = 'address_list';
  static const  ServicecartList = 'servicecart_list';
  static const  PlanecartList = 'planecart_list';


  static var phonenoExp = '^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}';
  static var emailExp = "^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$";

//Api END POINTS
  static var login='auth';
  static var resendOtp='auth/resendOtp/';
  static var otpsubmit='auth/otpsubmit';
  static var register='profile/create_profile.php';
  static var social_login='auth/social_login.php';
  static var location_update = 'location/update.php';
  static var users_map = 'discover/users_map.php';
  static var jobs_map = 'jobs/map.php';
  static var jobs_post = 'jobs/post.php';
  static var networks_join = 'networks/join.php';
  static var networks_create='networks/create.php';
  static var event_List='networks/list.php';
  static var member_List = 'networks/members.php';




  static var selectedProductInfo="user/product/selected/info";
  static var paymentinfo= "order/product/checkout";
  static var placeOrder= "order/product/place-order";
  static var orderHistory="order/product/order/history";
  static var serviceHistory="order/service/order/history";

  static var service_paymentinfo= "order/service/checkout";
  static var Service_placeOrder= "order/service/place-order";

  static var product_orderdetail= "order/product/order/";
  static var service_orderdetail= "order/service/order/";
  static var product_review= "order/product/review";
  static var Service_review= "order/service/review";
  static var Service_section= "service/display/details/";
  static var coupon="user/coupon";
  static var AmcDashboard="amc/dashboard?platform=";
  static var AmccheckoutPlane="order/amc/checkout";
  static var Amc_placeOrder= "order/amc/place-order";
  static var Amc_ServiceBook= "order/amc/book";
  static var Amc_search="amc/search";
  static var delete_account='user/user-delete-account';
  static var updateToken= "user/update-fcm";





  /// TODO SERVICE
  static var serviceDashboard = 'service/dashboard?platform=PLATFORM';
  static var serviceCategory = 'service/category/ItemId';
  static var serviceSubCategory = 'service/sub-category/details/SubCatId';
static var serviceSearch='service/search';
  /// TODO NOTIFICATION
  static var userNotification = 'user/notification';
  static var splash_baner = 'banner/splash/user';
  static var bulk_enquiry = 'user/bulk/enquiry';
  static var banerlogin="banner/auth/user/login";


}
