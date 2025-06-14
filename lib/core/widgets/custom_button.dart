import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaplet/core/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final BorderSide? borderSide;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.prefixIcon,
    this.suffixIcon,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primary,
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          padding: padding ?? EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            side: borderSide ?? BorderSide.none,
          ),
          disabledBackgroundColor: backgroundColor?.withOpacity(0.6) ?? AppTheme.primary.withOpacity(0.6),
          disabledForegroundColor: textColor?.withOpacity(0.6) ?? Colors.white.withOpacity(0.6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              SizedBox(width: 12.w),
            ],
            Text(
              text,
              style: AppTheme.buttonStyle.copyWith(
                color: textColor ?? Colors.white,
              ),
            ),
            if (suffixIcon != null) ...[
              SizedBox(width: 12.w),
              suffixIcon!,
            ],
          ],
        ),
      ),
    );
  }
} 