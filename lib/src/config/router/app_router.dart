import 'package:go_router/go_router.dart';
import 'package:push_app/src/presentation/screens/details_screen.dart';

import '../../presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      // routes: [
      // ],
    ),
    GoRoute(
      path: '/push-details/:messageId',
      builder: (context, state) => DetailsScreen(
        pushMessageId: state.pathParameters['messageId'] ?? '',
      ),
    ),
  ],
);
