import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zaplet/core/theme/app_theme.dart';
import 'package:zaplet/data/services/supabase_service.dart';
import 'package:zaplet/core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar icons to dark
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  // Initialize Supabase
  await SupabaseService.initialize();

  // Allow Google Fonts runtime fetching
  GoogleFonts.config.allowRuntimeFetching = true;

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Zaplet',
          theme: ThemeData(
            primaryColor: AppTheme.primary,
            scaffoldBackgroundColor: AppTheme.background,
            appBarTheme: AppBarTheme(
              backgroundColor: AppTheme.background,
              elevation: 0,
              iconTheme: IconThemeData(
                color: AppTheme.text,
                size: 24.sp,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          routerConfig: AppRoutes.router,
        );
      },
    );
  }
}
