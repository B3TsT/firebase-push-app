part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class NotificationStatusChange extends NotificationsEvent {
  const NotificationStatusChange(this.status);
  final AuthorizationStatus status;
}

class NotificactionReceived extends NotificationsEvent {
  const NotificactionReceived(this.pushMessage);
  final PushMessage pushMessage;
}
