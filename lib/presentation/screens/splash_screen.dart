import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:zaplet/core/routes/app_routes.dart';
import 'package:zaplet/core/theme/app_theme.dart';
import 'package:zaplet/data/services/auth_service.dart';
import 'package:zaplet/presentation/providers/auth_provider.dart';
import 'package:zaplet/presentation/providers/onboarding_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 2));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final onboardingComplete = ref.read(onboardingProvider);

      if (!onboardingComplete) {
        context.go(AppRoutes.onboarding);
        return;
      }

      final authService = ref.read(authServiceProvider);
      final user = authService.currentUser;

      if (user != null) {
        final isAdmin = await authService.isAdmin();
        if (isAdmin) {
          context.go(AppRoutes.base); // Admin goes to base screen
        } else {
          context.go(AppRoutes.login); // Regular user to login screen
        }
      } else {
        context.go(AppRoutes.login); // No user, go to login
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar icons to dark
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SVG Logo
            SvgPicture.asset(
              'assets/images/zaplet_splash_svg.svg',
              width: 380.w,
              fit: BoxFit.contain,
              placeholderBuilder: (BuildContext context) => SizedBox(
                width: 350.w,
                height: 200.h,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 48.h),
            // Loading indicator
            SizedBox(
              width: 40.w,
              height: 40.h,
              child: CircularProgressIndicator(
                color: AppTheme.primary,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
