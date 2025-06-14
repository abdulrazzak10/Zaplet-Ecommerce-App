import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zaplet/core/theme/app_theme.dart';
import 'package:zaplet/core/widgets/custom_button.dart';
import 'package:zaplet/core/widgets/custom_text_field.dart';
import 'package:zaplet/data/services/auth_service.dart';
import 'package:zaplet/data/services/supabase_service.dart';
import 'package:zaplet/presentation/providers/auth_provider.dart';
import 'package:zaplet/presentation/screens/auth/login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      
      // Test connection to Supabase first
      final isConnected = await SupabaseService.testConnection();
      if (!isConnected) {
        throw Exception('Unable to connect to the server. Please check your internet connection and try again.');
      }
      
      await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
      );

      if (mounted) {
        // Show verification dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(
              'Account Created!',
              style: AppTheme.headingStyle,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please verify your email address to continue.',
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Text(
                  'Go to Login',
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
    } catch (e) {
      if (mounted) {
        String errorMessage = 'An error occurred. Please try again.';
        
        // Handle specific error cases
        if (e.toString().contains('already registered')) {
          errorMessage = 'This email is already registered. Please login instead.';
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
        toolbarHeight: 40.h,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/zaplet_logo.svg',
                          height: 60.h,
                          width: 60.w,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Create Account',
                          style: AppTheme.headingStyle.copyWith(
                            fontSize: 24.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Sign up to get started',
                          style: AppTheme.bodyStyle.copyWith(
                            color: AppTheme.textSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Form fields in a more compact layout
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Full Name field
                      Text(
                        'Full Name',
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Enter your full name',
                        prefix: Icon(
                          Icons.person_outline,
                          color: AppTheme.textSecondary,
                          size: 18.sp,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 15.h),
                      
                      // Email field
                      Text(
                        'Email',
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        prefix: Icon(
                          Icons.email_outlined,
                          color: AppTheme.textSecondary,
                          size: 18.sp,
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
                      
                      SizedBox(height: 15.h),
                      
                      // Password field
                      Text(
                        'Password',
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Create a password',
                        obscureText: _obscurePassword,
                        prefix: Icon(
                          Icons.lock_outline,
                          color: AppTheme.textSecondary,
                          size: 18.sp,
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
                            size: 18.sp,
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
                      
                      SizedBox(height: 15.h),
                      
                      // Confirm Password field
                      Text(
                        'Confirm Password',
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Re-enter your password',
                        obscureText: _obscureConfirmPassword,
                        prefix: Icon(
                          Icons.lock_outline,
                          color: AppTheme.textSecondary,
                          size: 18.sp,
                        ),
                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                          child: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppTheme.textSecondary,
                            size: 18.sp,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 25.h),
                  
                  // Register button
                  CustomButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    text: _isLoading ? 'Creating Account...' : 'Create Account',
                    height: 50.h,
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
                  
                  SizedBox(height: 15.h),
                  
                  // Sign in text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.only(left: 4.w),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign In',
                          style: AppTheme.bodyStyle.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 