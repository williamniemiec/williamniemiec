import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogo;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showLogo = false,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: showLogo
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: const Icon(
                    Icons.push_pin,
                    color: AppTheme.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppTheme.fontSizeXLarge,
                    fontWeight: AppTheme.fontWeightBold,
                    color: AppTheme.textPrimary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ],
            )
          : Text(
              title,
              style: const TextStyle(
                fontSize: AppTheme.fontSizeLarge,
                fontWeight: AppTheme.fontWeightSemiBold,
                color: AppTheme.textPrimary,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppTheme.white,
      foregroundColor: foregroundColor ?? AppTheme.textPrimary,
      elevation: elevation ?? AppTheme.elevationSmall,
      shadowColor: AppTheme.shadowColor,
      leading: leading,
      actions: actions,
      systemOverlayStyle: Theme.of(context).brightness == Brightness.light
          ? const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            )
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppTheme.appBarHeight);
}
