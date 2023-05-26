import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/local_notifications/local_notifications.dart';
import 'presentation/blocs/blocs.dart';

var blocsProvider = [
  BlocProvider(
    create: (context) => NotificationsBloc(
        requestLocalNotificationPermissions:
            LocalNotifications.requestPermissionLocalNotifications,
        showLocalNotification: LocalNotifications.showLocalNotification),
  ),
];
