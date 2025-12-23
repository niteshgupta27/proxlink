import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Utill/Dimensions.dart';
import '../../Utill/app_colors.dart';
import '../../Utill/styles.dart';

class CcPrimaryButton extends StatelessWidget {

  final String? buttonText;
  final VoidCallback? onPressed;
  final double margin;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final double? elevation;
  final IconData? icon;
  final TextStyle? textStyle;
  final bool isLoading;

  const CcPrimaryButton({
    Key? key, required this.buttonText,
    required this.onPressed,
    this.margin = 0,
    this.textColor,
    this.borderRadius = 5,
    this.backgroundColor,
    this.width,
    this.height,
    this.elevation = 4,
    this.icon,
    this.textStyle,
    this.isLoading = false,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(margin),
      child: SizedBox(
        height: height != null ? height : 40,
        width: kIsWeb ? 350 :Dimensions.webScreenWidth,
        child: Material(
          elevation: elevation!,
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor ?? Theme.of(context).primaryColor,
          child: TextButton(
            onPressed: isLoading ? null : onPressed as void Function()?,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: backgroundColor ?? (onPressed == null ? Theme.of(context).hintColor.withOpacity(0.6) : Theme.of(context).primaryColor),
              minimumSize: Size(kIsWeb ? 150 :Dimensions.webScreenWidth,  height ?? 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
              side: borderColor != null ? BorderSide(color: borderColor!, width: 1) : null,
            ),
            child: isLoading
                ? Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 15, width: 15,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              // Text(getTranslated('loading', context), style: poppinsMedium.copyWith(color: Colors.white)),
              Text("Loading",
               style: Styles.inriaSansBold.copyWith(
                 color: AppColors.whites
               ),
                // style: Theme.of(context).textTheme.titleLarge!.copyWith(
                //   color: AppColors.whites
                // ),
              ),
            ]))
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [

              icon != null
                  ? Padding(
                padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                child: Icon(icon, color: textColor ?? Theme.of(context).cardColor),
              ) : const SizedBox(),

              Text(buttonText ?? '', textAlign: TextAlign.center,
                  style: textStyle ?? Styles.inriaSansBold.copyWith(
                fontSize: Dimensions.fontSizeMedium,
                fontWeight: FontWeight.bold,
                color: textColor ?? Theme.of(context).cardColor,
                )
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

