import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/notifications/notifications_cubit.dart';
import '../../models/notification.dart' as notify;
import '../../widgets/notification_widget.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationsCubit notificationsCubit = context.watch<NotificationsCubit>();
    final List<notify.Notification> notifications = notificationsCubit.getAllNotifications();

    return notifications.isEmpty
        ? const Center(
            child: Text("You are all caught up 😃"),
          )
        : ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            itemBuilder: (context, index) {
              return NotificationWidget(notification: notifications[index]);
            },
            separatorBuilder: (context, index) => SizedBox(height: 20.h),
            itemCount: notifications.length,
          );
  }
}
