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
  static const job_fitter = _Paths.job_fitter;
  static const CreateZone = _Paths.CreateZone;
  static const ZoneDetails = _Paths.ZoneDetails;
  static const MyZones = _Paths.MyZones;
  static const CHAT_DETAILS = _Paths.CHAT_DETAILS;

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
 static const job_fitter = '/job_fitter';
 static const CreateZone = '/create_zone';
 static const ZoneDetails = '/zone_details';
 static const MyZones = '/my_zones';
 static const CHAT_DETAILS = '/chat_details';
}
