import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaplet/core/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final bool isOutlined;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.isOutlined = false,
    this.borderRadius = 12,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width,
        height: height ?? 48.h,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isOutlined
              ? Colors.transparent
              : (backgroundColor ?? AppTheme.primary),
          borderRadius: BorderRadius.circular(borderRadius.r),
          border: isOutlined
              ? Border.all(
                  color: backgroundColor ?? AppTheme.primary,
                  width: 1.5,
                )
              : null,
          boxShadow: isOutlined
              ? null
              : [
                  BoxShadow(
                    color: (backgroundColor ?? AppTheme.primary).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOutlined
                          ? (backgroundColor ?? AppTheme.primary)
                          : (textColor ?? Colors.white),
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 20.sp,
                        color: isOutlined
                            ? (backgroundColor ?? AppTheme.primary)
                            : (textColor ?? Colors.white),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      text,
                      style: AppTheme.bodyStyle.copyWith(
                        fontSize: fontSize ?? 16.sp,
                        fontWeight: fontWeight ?? FontWeight.w600,
                        color: isOutlined
                            ? (backgroundColor ?? AppTheme.primary)
                            : (textColor ?? Colors.white),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
} 