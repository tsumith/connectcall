import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/call_model.dart';
import '../models/call_status.dart';
import '../models/call_type.dart';
import '../services/stream_providers.dart';
import '../core/theme/app_colors.dart';

class HorizontalRecentCallsWidget extends StatelessWidget {
  final List<CallModel> calls;
  final String currentUserId;

  const HorizontalRecentCallsWidget({
    super.key,
    required this.calls,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    if (calls.isEmpty) return const SizedBox.shrink();

    // Group calls by user
    final Map<String, List<CallModel>> groupedCalls = {};
    for (var call in calls) {
      final isOutgoing = call.callerId == currentUserId;
      final otherUserId = isOutgoing ? call.calleeId : call.callerId;
      if (!groupedCalls.containsKey(otherUserId)) {
        groupedCalls[otherUserId] = [];
      }
      groupedCalls[otherUserId]!.add(call);
    }

    // Sort users by their most recent call
    final sortedUserIds = groupedCalls.keys.toList()
      ..sort(
        (a, b) => groupedCalls[b]!.first.startedAt.compareTo(
          groupedCalls[a]!.first.startedAt,
        ),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Recent Calls',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: sortedUserIds.length > 5 ? 5 : sortedUserIds.length,
            itemBuilder: (context, index) {
              final otherUserId = sortedUserIds[index];
              final userCalls = groupedCalls[otherUserId]!;
              final latestCall = userCalls.first;
              final callCount = userCalls.length;

              final isOutgoing = latestCall.callerId == currentUserId;
              final isMissed =
                  (latestCall.status == CallStatus.missed ||
                      latestCall.status == CallStatus.rejected) &&
                  !isOutgoing;

              return _RecentCallItem(
                call: latestCall,
                callCount: callCount,
                otherUserId: otherUserId,
                isMissed: isMissed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentCallItem extends ConsumerWidget {
  final CallModel call;
  final int callCount;
  final String otherUserId;
  final bool isMissed;

  const _RecentCallItem({
    required this.call,
    required this.callCount,
    required this.otherUserId,
    required this.isMissed,
  });

  String _formatCallTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final aDate = DateTime(time.year, time.month, time.day);

    if (aDate == today) {
      return DateFormat.jm().format(time);
    } else if (aDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MM/dd/yyyy').format(time);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileStreamProvider(otherUserId));

    final user = userAsync.whenData((u) => u);
    final displayName =
        user.value?.name ?? (userAsync.isLoading ? '...' : 'Unknown');
    final avatarUrl = user.value?.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isMissed
                      ? AppColors.error.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.1),
                  image: hasAvatar
                      ? DecorationImage(
                          image: NetworkImage(avatarUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: !hasAvatar
                    ? Center(
                        child: Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isMissed
                                ? AppColors.error
                                : AppColors.primary,
                          ),
                        ),
                      )
                    : null,
              ),
              if (callCount > 1)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).cardColor,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      '$callCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            displayName,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                call.type == CallType.video
                    ? Icons.videocam_rounded
                    : Icons.phone_rounded,
                size: 14,
                color: call.type == CallType.video
                    ? Colors.teal
                    : Colors.blueAccent,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  _formatCallTime(call.startedAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
