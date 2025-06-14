import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaplet/core/theme/app_theme.dart';
import 'package:zaplet/core/utils/currency_formatter.dart';
import 'package:zaplet/presentation/providers/cart_provider.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.watch(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: AppTheme.headingStyle.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                // Order Summary
                _buildSection(
                  title: 'Order Summary',
                  child: Column(
                    children: [
                      ...cartItems.map((item) => _OrderItem(
                            name: item.product.name,
                            quantity: item.quantity,
                            price: item.product.price,
                          )),
                      Divider(height: 24.h),
                      _PriceRow(
                        label: 'Subtotal',
                        price: cartNotifier.totalPrice,
                      ),
                      SizedBox(height: 8.h),
                      _PriceRow(
                        label: 'Shipping',
                        price: 200, // Fixed shipping cost
                      ),
                      SizedBox(height: 8.h),
                      _PriceRow(
                        label: 'Tax',
                        price: cartNotifier.totalPrice * 0.15, // 15% tax
                      ),
                      Divider(height: 24.h),
                      _PriceRow(
                        label: 'Total',
                        price: cartNotifier.totalPrice + 200 + (cartNotifier.totalPrice * 0.15),
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Shipping Address
                _buildSection(
                  title: 'Shipping Address',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: AppTheme.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '123 Main Street, Apt 4B',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        'Karachi, Sindh 75600',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        'Pakistan',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '+92 300 1234567',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Payment Method
                _buildSection(
                  title: 'Payment Method',
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.credit_card,
                          color: AppTheme.primary,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Visa ending in 4242',
                              style: AppTheme.bodyStyle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Expires 12/25',
                              style: AppTheme.bodyStyle.copyWith(
                                color: AppTheme.textSecondary,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: AppTheme.textSecondary,
                        size: 24.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Place Order Button
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  // Show success dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      title: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Order Placed!',
                            style: AppTheme.headingStyle.copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Congratulations! Your order has been placed successfully.',
                            style: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Order Total: ${CurrencyFormatter.formatPrice(cartNotifier.totalPrice + 200 + (cartNotifier.totalPrice * 0.15))}',
                            style: AppTheme.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Clear cart
                            cartNotifier.clearCart();
                            // Close dialog
                            Navigator.pop(context);
                            // Navigate to home screen
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                          },
                          child: Text(
                            'OK',
                            style: AppTheme.bodyStyle.copyWith(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Place Order',
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.headingStyle.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String name;
  final int quantity;
  final double price;

  const _OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTheme.bodyStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Qty: $quantity',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.formatPrice(price * quantity),
            style: AppTheme.bodyStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double price;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.price,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.bodyStyle.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 16.sp : 14.sp,
          ),
        ),
        Text(
          CurrencyFormatter.formatPrice(price),
          style: AppTheme.bodyStyle.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 16.sp : 14.sp,
            color: isTotal ? AppTheme.primary : null,
          ),
        ),
      ],
    );
  }
} 