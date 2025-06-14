import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:zaplet/core/routes/app_routes.dart';
import 'package:zaplet/core/theme/app_theme.dart';
import 'package:zaplet/data/models/onboarding_item.dart';
import 'package:zaplet/presentation/providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _completeOnboarding() {
    ref.read(onboardingProvider.notifier).completeOnboarding().then((_) {
      if (mounted) {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Skip button
            // Positioned(
            //   top: 16.h,
            //   right: 16.w,
            //   child: TextButton(
            //     onPressed: _completeOnboarding,
            //     child: Text(
            //       'Skip',
            //       style: AppTheme.bodyStyle.copyWith(
            //         color: AppTheme.primary,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ),
            // ),
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: onboardingItems.length,
                    itemBuilder: (context, index) {
                      return OnboardingPage(
                        item: onboardingItems[index],
                        index: index,
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Page indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingItems.length, 
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            height: 10.h,
                            width: _currentPage == index ? 30.w : 10.w,
                            decoration: BoxDecoration(
                              color: _currentPage == index 
                                  ? AppTheme.primary 
                                  : AppTheme.border,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      // Navigation buttons
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: _currentPage == onboardingItems.length - 1
                            ? ElevatedButton(
                                onPressed: _completeOnboarding,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 56.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                child: Text(
                                  'Get Started',
                                  style: AppTheme.buttonStyle,
                                ),
                              )
                            : Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _pageController.animateToPage(
                                        onboardingItems.length - 1,
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: Text(
                                      'Skip',
                                      style: AppTheme.bodyStyle.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      _pageController.nextPage(
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: EdgeInsets.all(16.w),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 24.sp,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;
  final int index;

  const OnboardingPage({
    super.key,
    required this.item,
    required this.index,
  });

  String get _imagePath {
    switch (index) {
      case 0:
        return 'assets/images/onboarding/onboarding1.svg';
      case 1:
        return 'assets/images/onboarding/onboarding2.svg';
      case 2:
        return 'assets/images/onboarding/onboarding3.svg';
      default:
        return 'assets/images/onboarding/onboarding1.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SVG image
          SvgPicture.asset(
            _imagePath,
            height: 280.h,
            width: 280.w,
            placeholderBuilder: (BuildContext context) => Container(
              width: 280.w,
              height: 280.h,
              color: AppTheme.backgroundSecondary,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primary,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            item.title,
            style: AppTheme.headingStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Text(
            item.description,
            style: AppTheme.bodyStyle.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 