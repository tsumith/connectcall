import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/call_model.dart';
import '../models/call_status.dart';
import '../models/call_type.dart';
import '../models/user_model.dart';
import '../core/theme/app_colors.dart';

class CallHistoryCardWidget extends StatelessWidget {
  final CallModel call;
  final UserModel otherUser;
  final bool isOutgoing;

  const CallHistoryCardWidget({
    super.key,
    required this.call,
    required this.otherUser,
    required this.isOutgoing,
  });

  String _formatCallTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final aDate = DateTime(time.year, time.month, time.day);
    final timeStr = DateFormat.jm().format(time);

    if (aDate == today) {
      return timeStr;
    } else if (aDate == yesterday) {
      return 'Yesterday, $timeStr';
    } else {
      return '${DateFormat('MM/dd/yyyy').format(time)}, $timeStr';
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData callIcon;
    Color iconColor;

    final isMissed =
        (call.status == CallStatus.missed ||
            call.status == CallStatus.rejected) &&
        !isOutgoing;

    if (isMissed) {
      callIcon = Icons.call_missed_rounded;
      iconColor = AppColors.error;
    } else if (isOutgoing) {
      callIcon = Icons.call_made_rounded;
      iconColor = AppColors.textSecondary;
    } else {
      callIcon = Icons.call_received_rounded;
      iconColor = AppColors.success;
    }

    final displayName = otherUser.name.isNotEmpty
        ? otherUser.name
        : 'Unknown User';

    final durationStr = call.durationSeconds > 0
        ? ' • ${call.durationSeconds ~/ 60}:${(call.durationSeconds % 60).toString().padLeft(2, '0')} min'
        : '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isMissed
                  ? AppColors.error.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              image:
                  otherUser.avatarUrl != null && otherUser.avatarUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(otherUser.avatarUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: otherUser.avatarUrl == null || otherUser.avatarUrl!.isEmpty
                ? Center(
                    child: Text(
                      displayName[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isMissed ? AppColors.error : AppColors.primary,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isMissed
                        ? AppColors.error
                        : null, // null inherits theme color
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(callIcon, size: 16, color: iconColor),
                    const SizedBox(width: 6),
                    Text(
                      '${call.type == CallType.video ? 'Video' : 'Audio'} • ${_formatCallTime(call.startedAt)}$durationStr',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Call Type Icon on Right
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              call.type == CallType.video
                  ? Icons.videocam_rounded
                  : Icons.phone_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
