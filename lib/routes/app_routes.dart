part of 'app_pages.dart';


abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const HOMESCREEN = _Paths.HOMESCREEN;
  static const LOGINSCREEN = _Paths.LOGINSCREEN;

  static const BOTTOM_NAVIGATION = _Paths.BOTTOM_NAVIGATION;
  static const memebersList = _Paths.memebersList;
  static const Addevent = _Paths.Addevent;

  static const OTPSCREEN = _Paths.OTPSCREEN;
  static const SignUpSCREEN = _Paths.SignUpSCREEN;
  static const Job = _Paths.Job;

  // TODO ORDERS

static const EventList=_Paths.EventList;
static const QRScanner = _Paths.QRScanner;
  static const shearqr = _Paths.shearqr;
  static const post_job = _Paths.post_job;
  static const job_filtter = _Paths.job_filtter;

}

abstract class _Paths {
  _Paths._();

  static const SPLASH = "/splash";
  static const HOMESCREEN = "/home";
  static const LOGINSCREEN = "/login";
  static const BOTTOM_NAVIGATION = '/Home';
  static const memebersList = '/memebersList';
  static const Addevent = '/addevent';
  static const Job = '/job';

  static const OTPSCREEN = "/otp";
  static const SignUpSCREEN = "/signup";
  static const EventList = "/eventlist";

  static const QRScanner = "/qr_scanner";
 static const shearqr = '/shearqr';
 static const post_job = '/post_job';
 static const job_filtter = '/job_filtter';
// static const CategoryProducts = '/categoryProducts';
// static const SubCategoryProducts = '/subcategoryProducts';
// static const Checkout = '/Checkout';
// static const Profile = '/profile';
// static const Address = '/address';
// static const Wallet = '/wallet';
}
