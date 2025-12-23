
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:get/get_core/src/get_main.dart';

import '../utill/app_colors.dart';
import 'Dimensions.dart';
import 'ResponsiveView.dart';


void showDialogHelper(BuildContext context, Widget dialog, {bool isFlip = false, bool dismissible = true}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation1, animation2) => dialog,
    transitionDuration: const Duration(milliseconds: 700),
    transitionBuilder: (context, animation, secondaryAnimation, widget) {
      // 👇 Slide-from-bottom transition
      final offsetAnimation =
      Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: animation,
          child: widget,
        ),
      );
    },
    // transitionBuilder: (context, a1, a2, widget) {
    //   if(isFlip) {
    //     return Rotation3DTransition(
    //       alignment: Alignment.center,
    //       turns: Tween<double>(begin: math.pi, end: 2.0 * math.pi).animate(CurvedAnimation(parent: a1, curve: const Interval(0.0, 1.0, curve: Curves.linear))),
    //       child: FadeTransition(
    //         opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: a1, curve: const Interval(0.5, 1.0, curve: Curves.elasticOut))),
    //         child: widget,
    //       ),
    //     );
    //   }else {
    //     return Transform.scale(
    //       scale: a1.value,
    //       child: Opacity(
    //         opacity: a1.value,
    //         child: widget,
    //       ),
    //     );
    //   }
    // },
  );
}

class Rotation3DTransition extends AnimatedWidget {
  const Rotation3DTransition({
    Key? key,
    required Animation<double> turns,
    this.alignment = Alignment.center,
    this.child,
  })  : super(key: key, listenable: turns);

  Animation<double> get turns => listenable as Animation<double>;

  final Alignment alignment;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0006)
      ..rotateY(turnsValue);
    return Transform(
      transform: transform,
      alignment: const FractionalOffset(0.5, 0.5),
      child: child,
    );
  }
}

void openDialog(Widget child, {bool isDismissible = true, bool isDialog = false, bool willPop = true}) {
  ResponsiveView.isMobile()  ?
  showModalBottomSheet(
    backgroundColor: Colors.white,
    isDismissible: isDismissible,
    isScrollControlled: true,
    builder: (BuildContext context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child:  child,),
    context: Get.context!,
  ) :
  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent, // so rounded corners show nicely
    builder: (context) {
      final size = MediaQuery.of(context).size;
      final isMobile = ResponsiveView.isMobile();
print("dwdfdfefrefre");
      return WillPopScope(
        onWillPop: () async => willPop,
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            //height: isMobile ? size.height * 0.75 : size.height * 0.55,
            width: 450, // narrower on web/tablet
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // adjust for keyboard
            ),
            decoration: BoxDecoration(
              color: AppColors.whites,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.radiusSizeLarge),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: child,
          ),
        ),
      );
    },
  );
}