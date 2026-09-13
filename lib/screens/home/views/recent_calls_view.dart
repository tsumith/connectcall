import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';
import '../../../services/stream_providers.dart';
import '../../../models/call_model.dart';
import '../../../widgets/call_history_card.dart';

class RecentCallsView extends ConsumerWidget {
  const RecentCallsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authServiceProvider).currentUser;
    if (currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final callHistoryAsync = ref.watch(
      callHistoryStreamProvider(currentUser.uid),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recent Calls',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: callHistoryAsync.when(
        data: (calls) {
          if (calls.isEmpty) {
            return Center(
              child: Text(
                'No recent calls.',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 100, top: 16),
            itemCount: calls.length,
            itemBuilder: (context, index) {
              final call = calls[index];
              final isOutgoing = call.callerId == currentUser.uid;
              final otherUserId = isOutgoing ? call.calleeId : call.callerId;
              return _CallHistoryItem(
                call: call,
                otherUserId: otherUserId,
                isOutgoing: isOutgoing,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

/// Separate ConsumerWidget for each call history item.
/// Uses ref.watch on the cached userProfileStreamProvider, so Riverpod
/// deduplicates streams for the same userId across all items.
class _CallHistoryItem extends ConsumerWidget {
  final CallModel call;
  final String otherUserId;
  final bool isOutgoing;

  const _CallHistoryItem({
    required this.call,
    required this.otherUserId,
    required this.isOutgoing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileStreamProvider(otherUserId));

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return CallHistoryCardWidget(
          call: call,
          otherUser: user,
          isOutgoing: isOutgoing,
        );
      },
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
