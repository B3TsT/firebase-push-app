import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../firebase_options.dart';
import '../../../config/local_notifications/local_notifications.dart';
import '../../../domain/domain.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  int pushNumberId = 0;
  final Future<void> Function()? requestLocalNotificationPermissions;
  final void Function({
    required int id,
    String? title,
    String? body,
    String? data,
  })? showLocalNotification;
  NotificationsBloc({
    required this.requestLocalNotificationPermissions,
    required this.showLocalNotification,
  }) : super(const NotificationsState()) {
    on<NotificationStatusChange>(_notificationStatusChange);
    on<NotificactionReceived>(_onPushMessageReceived);
    //* Verificar estado de las notificaciones
    _initialStatusCheck();
    //* Listener para notificaciones en Foreground
    _onForefroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationStatusChange(
      NotificationStatusChange event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  void _onPushMessageReceived(
      NotificactionReceived event, Emitter<NotificationsState> emit) {
    emit(state
        .copyWith(notifications: [event.pushMessage, ...state.notifications]));
    _getFCMToken();
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChange(settings.authorizationStatus));
  }

  void _getFCMToken() async {
    // final settings = await messaging.getNotificationSettings();
    // settings.authorizationStatus
    if (state.status != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    print(token);
  }

  void handleRemoteMessage(RemoteMessage message) {
    //* Recibe la notificacion
    if (message.notification == null) return;
    final messageId = replaceMessageId(message);
    final notification = PushMessage(
      messageId: messageId,
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl,
    );
    if (showLocalNotification != null) {
      showLocalNotification!(
        id: ++pushNumberId,
        body: notification.body,
        data: notification.messageId,
        title: notification.title,
      );
    }
    add(NotificactionReceived(notification));
  }

  String replaceMessageId(RemoteMessage message) {
    return message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '';
  }

  void _onForefroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    //* Solicitar permiso a las local notifications
    if (requestLocalNotificationPermissions != null) {
      await requestLocalNotificationPermissions!();
      // await LocalNotifications.requestPermissionLocalNotifications();
    }
    add(NotificationStatusChange(settings.authorizationStatus));
  }

  PushMessage? getMessageById(String pushMessageId) {
    final exist = state.notifications
        .any((element) => element.messageId == pushMessageId);
    if (!exist) return null;

    return state.notifications
        .firstWhere((element) => element.messageId == pushMessageId);
  }
}
