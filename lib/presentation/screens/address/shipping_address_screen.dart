import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaplet/core/theme/app_theme.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final List<Map<String, String>> _addresses = [
    {
      'name': 'Home',
      'address': 'House #123, Block 6, PECHS',
      'city': 'Karachi',
      'province': 'Sindh',
      'postalCode': '75400',
      'phone': '+92 300 1234567',
    },
    {
      'name': 'Office',
      'address': 'Suite 45, 5th Floor, The Centaurus',
      'city': 'Islamabad',
      'province': 'Islamabad Capital Territory',
      'postalCode': '44000',
      'phone': '+92 300 7654321',
    },
    {
      'name': 'Summer House',
      'address': 'Plot #78, Phase 5, DHA',
      'city': 'Lahore',
      'province': 'Punjab',
      'postalCode': '54000',
      'phone': '+92 300 9876543',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shipping Addresses',
          style: AppTheme.headingStyle.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Address List
          Expanded(
            child: _addresses.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: _addresses.length,
                    itemBuilder: (context, index) {
                      final address = _addresses[index];
                      return _buildAddressCard(address);
                    },
                  ),
          ),
          // Add New Address Button
          Padding(
            padding: EdgeInsets.all(16.w),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to add new address screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: const Text('Add New Address'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 64.sp,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Addresses Found',
            style: AppTheme.headingStyle.copyWith(
              color: AppTheme.textPrimary,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your first shipping address',
            style: AppTheme.bodyStyle.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Map<String, String> address) {
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
          // Address Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppTheme.primary,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  address['name']!,
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: AppTheme.textSecondary,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    // TODO: Navigate to edit address screen
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    // TODO: Show delete confirmation dialog
                  },
                ),
              ],
            ),
          ),
          // Address Details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address['address']!,
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${address['city']!}, ${address['province']!}',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Postal Code: ${address['postalCode']!}',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Phone: ${address['phone']!}',
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 