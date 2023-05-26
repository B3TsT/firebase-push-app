import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/src/domain/domain.dart';
import 'package:push_app/src/presentation/blocs/notifications_bloc/notifications_bloc.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.pushMessageId});
  final String pushMessageId;

  @override
  Widget build(BuildContext context) {
    final PushMessage? message =
        context.read<NotificationsBloc>().getMessageById(pushMessageId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles Push'),
      ),
      body: (message != null)
          ? _DetailsView(message: message)
          : const Center(
              child: Text('Notificacion no exite'),
            ),
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView({required this.message});
  final PushMessage message;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          if (message.imageUrl != null) Image.network(message.imageUrl!),
          const SizedBox(height: 30),
          Text(message.title, style: textStyle.titleMedium),
          Text(message.body),
          const Divider(),
          Text(message.data.toString()),
        ],
      ),
    );
  }
}
