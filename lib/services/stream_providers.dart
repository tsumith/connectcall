import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/call_model.dart';
import 'user_service.dart';
import 'calling_service.dart';

/// Cached stream provider for a single user's profile.
/// Using `.family` ensures one stream per unique userId,
/// and `.autoDispose` cleans up when no widget watches it.
final userProfileStreamProvider =
    StreamProvider.autoDispose.family<UserModel?, String>((ref, uid) {
  final userService = ref.watch(userServiceProvider);
  return userService.getUserProfile(uid);
});

/// Cached stream provider for contacts list (all users except current).
final contactsStreamProvider =
    StreamProvider.autoDispose.family<List<UserModel>, String>((ref, currentUserId) {
  final userService = ref.watch(userServiceProvider);
  return userService.getContacts(currentUserId);
});

/// Cached stream provider for call history.
final callHistoryStreamProvider =
    StreamProvider.autoDispose.family<List<CallModel>, String>((ref, userId) {
  final callingService = ref.watch(callingServiceProvider);
  return callingService.getCallHistory(userId);
});
