class AppConstants {
  static const String appName = 'proxlink';
  static const double appVersion = 7.4;
  static const String fontFamily_ADLaM_Display = 'ADLaM Display';
  static const String fontFamily_Acre = 'Acre';

  static const String fontFamily_Inter = 'Inter';

  static const String baseUrl = 'https://dashboard.proxlink.com/api/';
  static const String ImaepathHost='https://dashboard.proxlink.com/';
  // static const String baseUrl = 'https://proxlink.encodeit.in/api/';
  // static const String ImaepathHost='https://proxlink.encodeit.in/';
  static const String configUri = '/api/v1/config';
  static const String payment_link=ImaepathHost+'payment/gateway';

  static const loginUserInformation = 'loginUserInformation_storage';
  static const loginUserInformationToken = 'loginUserInformation_token';
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
  static var register='auth/register';
  static var providergoogle='auth/signup/google';
  static var providerfacebook='auth/signup/facebook';
  static var providerapple='auth/signup/apple';
  static var productdashboard='product/dashboard';
  static var category_display='product/category_display/user';
  static var display_section_details = 'product/display_section_details';
  static var brandDetail='product/brand_details';
  static var product_details = 'product/product_details';
  static var category_detail='product/category_inside';
  static var category_assets='product/category_inside/assets';
  static var subcategory_detail='product/subcategory_inside';
  static var subcategory_assets='product/subcategory_inside/assets';
  static var Instantdelivery='product/selection/deliver/timeline';

  static var address_list = 'user/address/list';
  static var address_store='user/address/store';
  static var adress_update='user/address/update';
  static var address_delete='user/address/delete';
  static var get_profile='user/profile';
  static var profile_detail='user/profile';
  static var term_conditions='information/term-conditions';
  static var privacy_policy='information/privacy-policy';
  static var about_us='information/about-us';
  static var product_addfavorite='user/product/favorite';
  static var product_listfavorite='user/product/favorite/list';
  static var Service_listfavorite ='user/service/favorite/list';
  static var Service_addfavorite='user/service/favorite';

  static var referral='user/referral/info';
  static var search_detail='product/search';
  static var transaction='user/transaction';
  static var addtransaction='user/add/wallet/balance';

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
