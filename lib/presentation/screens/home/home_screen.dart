import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaplet/core/theme/app_theme.dart';
import 'package:zaplet/presentation/providers/product_provider.dart';
import 'package:zaplet/presentation/screens/product/product_details_screen.dart';
import 'package:zaplet/presentation/screens/categories/categories_screen.dart';
import 'package:zaplet/presentation/widgets/product_card.dart';
import 'package:zaplet/presentation/widgets/product_card_shimmer.dart';
import 'package:zaplet/presentation/widgets/section_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);
    final isLoading = ref.watch(productLoadingProvider);

    // Get unique categories from products
    final categories = products
        .map((product) => product.category)
        .toSet()
        .toList()
      ..sort();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Zaplet',
              style: AppTheme.headingStyle.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: AppTheme.textPrimary),
                onPressed: () {
                  // TODO: Implement search
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary),
                onPressed: () {
                  // TODO: Implement notifications
                },
              ),
            ],
          ),

          // Categories Section
          // SliverToBoxAdapter(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          //         child: Text(
          //           'Categories',
          //           style: AppTheme.headingStyle.copyWith(
          //             fontSize: 20.sp,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 120.h, // slightly more height for padding + shadow
          //         child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           padding: EdgeInsets.symmetric(horizontal: 16.w),
          //           itemCount: categories.length,
          //           itemBuilder: (context, index) {
          //             final category = categories[index];
          //             return Padding(
          //               padding: EdgeInsets.only(right: 12.w),
          //               child: _CategoryCard(
          //                 category: category,
          //                 onTap: () {
          //                   Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (context) => CategoriesScreen(),
          //                     ),
          //                   );
          //                 },
          //               ),
          //             );
          //           },
          //         ),
          //       ),
          //       SizedBox(height: 16.h),
          //     ],
          //   ),
          // ),

          // Featured Products Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Products',
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 210.h,
                    child: isLoading
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: const ProductCardShimmer(),
                              );
                            },
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return Padding(
                                padding: EdgeInsets.only(right: 11.w),
                                child: SizedBox(
                                  width: 160.w,
                                  height: 175.h,
                                  child: ProductCard(
                                    product: product,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetailsScreen(
                                            product: product,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          // New Arrivals Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Arrivals',
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 210.h,
                    child: isLoading
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: const ProductCardShimmer(),
                              );
                            },
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[products.length - 1 - index];
                              return Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: SizedBox(
                                  width: 160.w,
                                  height: 245.h,
                                  child: ProductCard(
                                    product: product,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetailsScreen(
                                            product: product,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),


             SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '20% Sale',
                    style: AppTheme.headingStyle.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 210.h,
                    child: isLoading
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: const ProductCardShimmer(),
                              );
                            },
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: SizedBox(
                                  width: 160.w,
                                  height: 245.h,
                                  child: ProductCard(
                                    product: product,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetailsScreen(
                                            product: product,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category Icon
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(category),
                size: 24.sp,
                color: AppTheme.primary,
              ),
            ),
            SizedBox(height: 8.h),
            // Category Name
            Text(
              category,
              style: AppTheme.bodyStyle.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'smartphones':
        return Icons.phone_android;
      case 'audio':
        return Icons.headphones;
      case 'laptops':
        return Icons.laptop;
      case 'wearables':
        return Icons.watch;
      case 'accessories':
        return Icons.devices_other;
      default:
        return Icons.category;
    }
  }
} 