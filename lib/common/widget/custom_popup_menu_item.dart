import 'package:flutter/material.dart';
import '../../Utill/app_colors.dart';
import '../../Utill/AppConstants.dart';

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  final IconData? icon;
  final String label;
  final Color? iconColor;
  final Color? textColor;

  CustomPopupMenuItem({
    super.key,
    super.value,
    super.onTap,
    super.enabled = true,
    super.height = kMinInteractiveDimension,
    super.padding,
    super.mouseCursor,
    this.icon,
    required this.label,
    this.iconColor,
    this.textColor,
  }) : super(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: iconColor ?? AppColors.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
              ],
              Text(
                label,
                style: TextStyle(
                  color: textColor ?? AppColors.black,
                  fontFamily: AppConstants.fontFamily_Acre,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
}

class CustomPopupMenu extends StatelessWidget {
  const CustomPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        if (value == 'profile') {
          // TODO: Navigate to Profile
        } else if (value == 'setting') {
          // TODO: Navigate to Settings
        } else if (value == 'notification') {
          // TODO: Navigate to Notifications
        }
      },
      itemBuilder: (context) => [
        CustomPopupMenuItem(
          value: 'profile',
          icon: Icons.person_outline,
          label: 'Profile',
        ),
        CustomPopupMenuItem(
          value: 'setting',
          icon: Icons.settings_outlined,
          label: 'Setting',
        ),
        CustomPopupMenuItem(
          value: 'notification',
          icon: Icons.notifications_none,
          label: 'Notification',
        ),
      ],
    );
  }
}
