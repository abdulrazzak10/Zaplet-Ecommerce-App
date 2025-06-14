import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:zaplet/core/routes/app_routes.dart';
import 'package:zaplet/core/theme/app_theme.dart';
import 'package:zaplet/core/widgets/custom_button.dart';
import 'package:zaplet/core/widgets/custom_text_field.dart';
import 'package:zaplet/data/services/auth_service.dart';
import 'package:zaplet/presentation/providers/auth_provider.dart';
import 'package:zaplet/presentation/screens/auth/register_screen.dart';
import 'package:zaplet/data/services/supabase_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      
      // Test connection to Supabase first
      final isConnected = await SupabaseService.testConnection();
      if (!isConnected) {
        throw Exception('Unable to connect to the server. Please check your internet connection and try again.');
      }
      
      final response = await authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.user != null) {
        if (response.user!.emailConfirmedAt != null) {
          // Email is verified, show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login successful!'),
                backgroundColor: AppTheme.success,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
            
            // Navigate to base screen
            if (mounted) {
              context.go(AppRoutes.base);
            }
          }
        } else {
          // Email is not verified, show dialog
          if (mounted) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text(
                  'Email Not Verified',
                  style: AppTheme.headingStyle,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please verify your email address before logging in.',
                      style: AppTheme.bodyStyle,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'We\'ve sent a verification link to:',
                      style: AppTheme.bodyStyle.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _emailController.text.trim(),
                      style: AppTheme.bodyStyle.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      // Resend verification email
                      authService.resetPassword(_emailController.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Verification email resent to ${_emailController.text.trim()}',
                          ),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                    },
                    child: Text(
                      'Resend Verification Email',
                      style: AppTheme.bodyStyle.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'An error occurred. Please try again.';
        
        // Handle specific error cases
        if (e.toString().contains('Invalid login credentials')) {
          errorMessage = 'Incorrect email or password. Please try again.';
        } else if (e.toString().contains('Email not confirmed')) {
          errorMessage = 'Please verify your email before logging in.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // No visual AppBar
        systemOverlayStyle: SystemUiOverlayStyle.dark, // Use dark icons for light background
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  
                  // Header with logo
                  Center(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/zaplet_logo.svg',
                          height: 80.h,
                          width: 80.w,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Welcome Back!',
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 28.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Sign in to continue',
                          style: AppTheme.bodyStyle.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 28.h),
                  
                  // Email field
                  Text(
                    'Email',
                    style: AppTheme.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefix: Icon(
                      Icons.email_outlined,
                      color: AppTheme.textSecondary,
                      size: 20.sp,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Password field
                  Text(
                    'Password',
                    style: AppTheme.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    obscureText: _obscurePassword,
                    prefix: Icon(
                      Icons.lock_outline,
                      color: AppTheme.textSecondary,
                      size: 20.sp,
                    ),
                    suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppTheme.textSecondary,
                        size: 20.sp,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 25.h),
                  
                  // Login button
                  CustomButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    text: _isLoading ? 'Signing in...' : 'Sign In',
                    prefixIcon: _isLoading 
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.w,
                            ),
                          )
                        : null,
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Sign up text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.only(left: 8.w),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
                          style: AppTheme.bodyStyle.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 