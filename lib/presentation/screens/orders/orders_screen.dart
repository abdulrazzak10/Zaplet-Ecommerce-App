import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaplet/core/theme/app_theme.dart';
import 'package:zaplet/core/utils/currency_formatter.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: AppTheme.headingStyle.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 3, // Sample orders
        itemBuilder: (context, index) {
          return _OrderCard(
            orderNumber: '#ORD-${1000 + index}',
            date: 'March ${15 - index}, 2024',
            status: index == 0 ? 'Delivered' : index == 1 ? 'Processing' : 'Cancelled',
            total: 2800.0 + (index * 500.0),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderNumber;
  final String date;
  final String status;
  final double total;

  const _OrderCard({
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
        children: [
          // Order Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderNumber,
                      style: AppTheme.bodyStyle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      date,
                      style: AppTheme.bodyStyle.copyWith(
                        color: AppTheme.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                _StatusChip(status: status),
              ],
            ),
          ),

          // Order Items Preview
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12.r),
              ),
            ),
            child: Column(
              children: [
                // Sample order items
                _OrderItem(
                  name: 'Wireless Earbuds',
                  quantity: 1,
                  price: 2800.0,
                ),
                if (status != 'Cancelled') ...[
                  SizedBox(height: 8.h),
                  _OrderItem(
                    name: 'Phone Case',
                    quantity: 2,
                    price: 500.0,
                  ),
                ],
                Divider(height: 24.h),
                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: AppTheme.bodyStyle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.formatPrice(total),
                      style: AppTheme.bodyStyle.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'delivered':
        color = Colors.green;
        break;
      case 'processing':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: AppTheme.bodyStyle.copyWith(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
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
    return Row(
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
    );
  }
} 