import 'package:flutter/material.dart';
import 'package:mally/core/app_export.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.height,
    this.leadingWidth,
    this.leading,
    this.title,
    this.centerTitle,
    this.actions,
    this.titleColor,
    this.backgroundColor,
  }) : super(key: key);

  final double? height;
  final double? leadingWidth;
  final Widget? leading;
  final Widget? title;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Color? titleColor; // New property to specify text color
  final Color? backgroundColor; // New property to specify background color

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: height ?? 37.v,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? Colors.transparent,
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title != null
          ? DefaultTextStyle(
              style: TextStyle(
                color: titleColor ?? Theme.of(context).textTheme.titleLarge?.color,
              ),
              child: title!,
            )
          : null,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        mediaQueryData.size.width,
        height ?? 37.v,
      );
}