part of 'notifications_cubit.dart';

sealed class NotificationsState extends Equatable {
  final List<OrderNotificaiton> orderRequestNotifications;
  final List<OrderNotificaiton> orderUpdatesNotifications;
  final List<MessageNotification> messageNotifications;

  const NotificationsState({
    required this.messageNotifications,
    required this.orderRequestNotifications,
    required this.orderUpdatesNotifications,
  });

  @override
  List<Object> get props => [
        orderRequestNotifications,
        orderUpdatesNotifications,
        messageNotifications,
      ];
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial({
    required super.messageNotifications,
    required super.orderRequestNotifications,
    required super.orderUpdatesNotifications,
  });
}

final class NotificationsUpdate extends NotificationsState {
  const NotificationsUpdate({
    required super.messageNotifications,
    required super.orderRequestNotifications,
    required super.orderUpdatesNotifications,
  });
}
