import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app.dart';
import 'src/blocs_provider.dart';
import 'src/config/local_notifications/local_notifications.dart';
import 'src/presentation/blocs/blocs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationsBloc.initializeFCM();
  await LocalNotifications.initializeLocalNotifications();
  runApp(
    MultiBlocProvider(
      providers: blocsProvider,
      child: const MainApp(),
    ),
  );
}
