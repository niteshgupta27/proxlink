
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:proxlink/features/auth/Otp/view/Otpview.dart';
import 'package:proxlink/features/auth/signup/view/SignUpView.dart';
import 'package:proxlink/features/bottomNavigation/bindings/BottomNavigationBindings.dart';
import 'package:proxlink/features/event/bindings/AddeventBindings.dart';
import 'package:proxlink/features/event/view/AddeventView.dart';

import '../Utill/ErrorView.dart';
import '../Utill/app_required.dart';

import '../features/auth/Login/view/login_view.dart';
import '../features/bottomNavigation/views/bottom_navigation_view.dart';
import '../features/membersList/bindings/memberListBindings.dart';
import '../features/membersList/view/memberList.dart';
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
      name: _Paths.Addevent,
      page: () => AddeventView(),
      binding: AddeventBindings(),
    ),
  ];

}