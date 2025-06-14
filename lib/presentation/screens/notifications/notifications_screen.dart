import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaplet/core/theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _newArrivals = true;
  bool _priceDrops = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
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
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _buildSection(
            title: 'Notification Channels',
            children: [
              _buildSwitchTile(
                title: 'Push Notifications',
                subtitle: 'Receive notifications on your device',
                value: _pushEnabled,
                onChanged: (value) {
                  setState(() {
                    _pushEnabled = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                value: _emailEnabled,
                onChanged: (value) {
                  setState(() {
                    _emailEnabled = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildSection(
            title: 'Notification Types',
            children: [
              _buildSwitchTile(
                title: 'Order Updates',
                subtitle: 'Updates about your orders and deliveries',
                value: _orderUpdates,
                onChanged: (value) {
                  setState(() {
                    _orderUpdates = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Promotions & Offers',
                subtitle: 'Special deals and promotional offers',
                value: _promotions,
                onChanged: (value) {
                  setState(() {
                    _promotions = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'New Arrivals',
                subtitle: 'Updates about new products',
                value: _newArrivals,
                onChanged: (value) {
                  setState(() {
                    _newArrivals = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Price Drops',
                subtitle: 'Alerts when items in your wishlist go on sale',
                value: _priceDrops,
                onChanged: (value) {
                  setState(() {
                    _priceDrops = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildSection(
            title: 'Quiet Hours',
            children: [
              _buildTimeTile(
                title: 'Start Time',
                time: '10:00 PM',
                onTap: () {
                  // TODO: Show time picker
                },
              ),
              _buildTimeTile(
                title: 'End Time',
                time: '7:00 AM',
                onTap: () {
                  // TODO: Show time picker
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 12.h),
          child: Text(
            title,
            style: AppTheme.bodyStyle.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ),
        Container(
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
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.textSecondary.withOpacity(0.1),
          ),
        ),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: AppTheme.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.bodyStyle.copyWith(
            color: AppTheme.textSecondary,
            fontSize: 14.sp,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primary,
      ),
    );
  }

  Widget _buildTimeTile({
    required String title,
    required String time,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.textSecondary.withOpacity(0.1),
          ),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: AppTheme.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        trailing: Text(
          time,
          style: AppTheme.bodyStyle.copyWith(
            color: AppTheme.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
} 