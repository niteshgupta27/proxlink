import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:proxlink/features/auth/Otp/view/Otpview.dart';
import 'package:proxlink/features/auth/signup/view/SignUpView.dart';
import 'package:proxlink/features/bottomNavigation/bindings/BottomNavigationBindings.dart';
import 'package:proxlink/features/event/bindings/AddeventBindings.dart';
import 'package:proxlink/features/event/view/AddeventView.dart';
import 'package:proxlink/features/event/view/eventListView.dart';
import 'package:proxlink/features/job/bindings/JobBindings.dart';
import 'package:proxlink/features/job/search/bindings/search_job_bindings.dart';
import 'package:proxlink/features/job/search/view/search_job_view.dart';
import 'package:proxlink/features/job/view/jobView.dart';
import 'package:proxlink/features/network/bindings/networkBindings.dart';
import 'package:proxlink/features/network/view/QRScannerView.dart';
import 'package:proxlink/features/zone/bindings/my_zones_bindings.dart';
import 'package:proxlink/features/zone/bindings/zone_bindings.dart';
import 'package:proxlink/features/zone/view/create_zone_view.dart';
import 'package:proxlink/features/zone/view/my_zones_view.dart';
import 'package:proxlink/features/zone/view/zone_details_view.dart';

import '../Utill/ErrorView.dart';
import '../Utill/app_required.dart';

import '../features/auth/Login/view/login_view.dart';
import '../features/bottomNavigation/views/bottom_navigation_view.dart';
import '../features/job/post/bindings/post_job_bindings.dart';
import '../features/job/post/view/post_job_view.dart';
import '../features/membersList/bindings/memberListBindings.dart';
import '../features/membersList/view/memberList.dart';
import '../features/network/view/ShareQRView.dart';
import '../features/Chat/view/chat_detail_view.dart';
import '../features/Chat/controller/chat_detail_controller.dart';
import '../features/splash/view/SplashView.dart';



part 'package:proxlink/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [


    GetPage(
        name: _Paths.SPLASH,
        page: () => const SplashView(),
        binding: SplashBindings()
    ),
    GetPage(
        name: _Paths.LOGINSCREEN,
        page: () => const LoginView(),
        binding: AuthBindings()
    ),
    GetPage(
        name: _Paths.OTPSCREEN,
        page: () => const OtpView(),
        binding: AuthBindings()
    ),
    GetPage(
        name: _Paths.SignUpSCREEN,
        page: () => const SignUpView(),
        binding: AuthBindings()
    ),
    GetPage(
      name: _Paths.BOTTOM_NAVIGATION,
      page: () => BottomNavigationView(),
      binding: BottomNavigationBindings(),
    ),
    GetPage(
      name: _Paths.memebersList,
      page: () => MemberListview(),
      binding: MemberListBindings(),
    ),
    GetPage(
      name: _Paths.EventList,
      page: () => EventListview(),
      binding: AddeventBindings(),
    ),
    GetPage(
      name: _Paths.Addevent,
      page: () => AddeventView(),
      binding: AddeventBindings(),
    ),
    GetPage(
      name: _Paths.QRScanner,
      page: () => const QRScannerView(),
    ),
    GetPage(
      name: _Paths.Job,
      page: () => const JobView(),
      binding: JobBindings(),
    ),
    GetPage(
      name: _Paths.shearqr,
      page: () => ShareQRView(),
      binding: NetworkBindings(),
    ),
    GetPage(
      name: _Paths.post_job,
      page: () => PostJobView(),
      binding: PostJobBindings(),
    ),
    GetPage(
      name: _Paths.job_fitter,
      page: () => SearchJobView(),
      binding: SearchJobBindings(),
    ),
    GetPage(
      name: _Paths.CreateZone,
      page: () => const CreateZoneView(),
      binding: ZoneBindings(),
    ),
    GetPage(
      name: _Paths.ZoneDetails,
      page: () => const ZoneDetailsView(),
      binding: ZoneBindings(),
    ),
    GetPage(
      name: _Paths.MyZones,
      page: () => const MyZonesView(),
      binding: MyZonesBindings(),
    ),
    GetPage(
      name: _Paths.CHAT_DETAILS,
      page: () => const ChatDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ChatDetailController>(() => ChatDetailController());
      }),
    ),
  ];

}
