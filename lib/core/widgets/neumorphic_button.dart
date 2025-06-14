import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color? color;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const NeumorphicButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.padding,
  }) : super(key: key);

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.color ?? Theme.of(context).colorScheme.surface;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 0),
                    blurRadius: 1,
                    spreadRadius: 0.1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                    spreadRadius: 0.5,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: 0.1,
                  ),
                ],
        ),
        child: Center(child: widget.child),
      ),
    );
  }
} 