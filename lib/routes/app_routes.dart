part of 'app_pages.dart';


abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const HOMESCREEN = _Paths.HOMESCREEN;
  static const LOGINSCREEN = _Paths.LOGINSCREEN;

  static const BOTTOM_NAVIGATION = _Paths.BOTTOM_NAVIGATION;
  static const memebersList = _Paths.memebersList;
  static const Addevent = _Paths.Addevent;
  static const ServiceDashboard = _Paths.ServiceDashboard;
  static const AmcDashboard = _Paths.AmcDashboard;

  static const ServiceCategory = _Paths.ServiceCategory;
  static const ServiceSubCategory = _Paths.ServiceSubCategory;
  static const CategoryProducts = _Paths.CategoryProducts;
  static const SubCategoryProducts = _Paths.SubCategoryProducts;
  static const Checkout = _Paths.Checkout;
  static const Profile = _Paths.Profile;
  static const Address = _Paths.Address;
  static const Wallet = _Paths.Wallet;
  static const OTPSCREEN = _Paths.OTPSCREEN;
  static const SignUpSCREEN = _Paths.SignUpSCREEN;

  // TODO ORDERS
  static const ORDERS_SCREEN = _Paths.ORDERS_SCREEN;
  static const ORDERS_DETAILS_SCREEN = _Paths.ORDERS_DETAILS_SCREEN;
  static const FAVORITE_SCREEN = _Paths.FAVORITE_SCREEN;
  static const REFER_AND_EARN_SCREEN = _Paths.REFER_AND_EARN_SCREEN;
  static const CardSection_SCREEN = _Paths.CardSection_SCREEN;
  static const BoxSection_SCREEN = _Paths.BoxSection_SCREEN;
  static const BrandDetail= _Paths.BrandDetail;
  static const Information= _Paths.Information;

  static const AddressConfirm= _Paths.AddressConfirm;
  static const AddressDetail= _Paths.AddressDetail;
  static const ProfileDetail= _Paths.ProfileDetail;
  static const Searchproduct= _Paths.Searchproduct;

static const ServiceCheckout= _Paths.ServiceCheckout;
  static const NotificationScreen= _Paths.NotificationScreen;
  static const ServiceSearch=_Paths.ServiceSearch;
  static const ServiceORDERS_DETAILS_SCREEN=_Paths.ServiceORDERS_DETAILS_SCREEN;
  static const Serviceboxsection=_Paths.Serviceboxsection;
  static const AmcPlaneCheckOut=_Paths.AmcPlaneCheckOut;
  static const AmcServiceCheckOut=_Paths.AmcServiceCheckOut;
static const Amcsearch=_Paths.Amcsearch;
static const Bulk=_Paths.Bulk;
}

abstract class _Paths {
  _Paths._();

  static const SPLASH = "/splash";
  static const HOMESCREEN = "/home";
  static const LOGINSCREEN = "/login";
  static const BOTTOM_NAVIGATION = '/Home';
  static const memebersList = '/memebersList';
  static const Addevent = '/addevent';
  static const ServiceDashboard = '/serviceDashboard';
  static const ServiceCategory = '/ServiceCategory';
  static const ServiceSubCategory = '/ServiceSubCategoryView';
  static const CategoryProducts = '/categoryProducts';
  static const SubCategoryProducts = '/subcategoryProducts';
  static const Checkout = '/Checkout';
  static const Profile = '/profile';
  static const Address = '/address';
  static const Wallet = '/wallet';
  static const OTPSCREEN = "/otp";
  static const SignUpSCREEN = "/signup";
  static const ORDERS_SCREEN = "/orders";
  static const ORDERS_DETAILS_SCREEN = "/orderDetails";
  static const FAVORITE_SCREEN = "/favorite";
  static const REFER_AND_EARN_SCREEN = "/referAndEarn";
  static const CardSection_SCREEN = "/CardSectionSCREEN";
  static const BoxSection_SCREEN = "/boxSectionSCREEN";
  static const BrandDetail = "/brandDetail";
  static const Information = "/information";
  static const AddressDetail = "/addressDetail";
  static const AddressConfirm = "/addressConfirm";
  static const ProfileDetail = "/profileDetail";
  static const Searchproduct = "/Searchproduct";
  static const ServiceCheckout="/serviceCheckout";
  static const ServiceSearch="/servicesearch";
  static const ServiceORDERS_DETAILS_SCREEN = "/serviceorderDetails";
  static const Serviceboxsection = "/service_box_section";

  static const NotificationScreen = "/notification";
  static const AmcDashboard = "/amcDashboard";
  static const AmcPlaneCheckOut = "/planecheckout";
  static const AmcServiceCheckOut = "/servicecheckout";
  static const Amcsearch = "/amcsearch";
  static const Bulk = "/bulk";

}