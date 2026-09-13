import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';
import '../../../services/stream_providers.dart';
import '../../../widgets/user_card.dart';
import '../../../widgets/horizontal_recent_calls.dart';
import '../../../core/theme/app_colors.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authServiceProvider).currentUser;
    if (currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // All streams come from cached Riverpod providers — no recreation on rebuild
    final userProfileAsync = ref.watch(
      userProfileStreamProvider(currentUser.uid),
    );
    final contactsAsync = ref.watch(contactsStreamProvider(currentUser.uid));
    final callHistoryAsync = ref.watch(
      callHistoryStreamProvider(currentUser.uid),
    );

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar & Welcome
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userProfileAsync.when(
                      data: (user) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Welcome,',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                                children: [
                                  if (user != null)
                                    TextSpan(
                                      text: ' ${user.name}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (user == null)
                            const CircleAvatar(
                              radius: 20,
                              child: Icon(Icons.person),
                            )
                          else
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primary,
                              backgroundImage:
                                  user.avatarUrl != null &&
                                      user.avatarUrl!.isNotEmpty
                                  ? NetworkImage(user.avatarUrl!)
                                  : null,
                              child:
                                  user.avatarUrl == null ||
                                      user.avatarUrl!.isEmpty
                                  ? Text(
                                      user.name.isNotEmpty
                                          ? user.name[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                        ],
                      ),
                      loading: () => Text(
                        'Welcome',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      error: (_, _) => Text(
                        'Welcome',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Who do you want to connect with today?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Horizontal Recent Calls
            SliverToBoxAdapter(
              child: callHistoryAsync.when(
                data: (calls) {
                  if (calls.isEmpty) return const SizedBox.shrink();
                  return HorizontalRecentCallsWidget(
                    calls: calls,
                    currentUserId: currentUser.uid,
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search contacts...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (value) =>
                      setState(() => _searchQuery = value.toLowerCase()),
                ),
              ),
            ),

            // Contacts List — sorted: active first, then offline
            contactsAsync.when(
              data: (allContacts) {
                final contacts = allContacts.where((user) {
                  if (_searchQuery.isEmpty) return true;
                  return user.name.toLowerCase().contains(_searchQuery) ||
                      user.email.toLowerCase().contains(_searchQuery);
                }).toList();

                if (contacts.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'No contacts available.'
                            : 'No contacts found.',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                final activeContacts = contacts
                    .where((u) => u.isOnline)
                    .toList();
                final offlineContacts = contacts
                    .where((u) => !u.isOnline)
                    .toList();

                return SliverPadding(
                  padding: const EdgeInsets.only(bottom: 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        int i = index;

                        // Active section header
                        if (activeContacts.isNotEmpty && i == 0) {
                          return _buildSectionHeader(
                            context,
                            'Active Now',
                            activeContacts.length,
                            Colors.green,
                          );
                        }
                        if (activeContacts.isNotEmpty) {
                          i -= 1; // account for header
                        }

                        // Active items
                        if (i < activeContacts.length) {
                          return UserCardWidget(user: activeContacts[i]);
                        }
                        i -= activeContacts.length;

                        // Others section header
                        if (offlineContacts.isNotEmpty && i == 0) {
                          return _buildSectionHeader(
                            context,
                            'Others',
                            offlineContacts.length,
                            Colors.grey,
                          );
                        }
                        if (offlineContacts.isNotEmpty) {
                          i -= 1; // account for header
                        }

                        // Offline items
                        return UserCardWidget(user: offlineContacts[i]);
                      },
                      childCount:
                          contacts.length +
                          (activeContacts.isNotEmpty ? 1 : 0) +
                          (offlineContacts.isNotEmpty ? 1 : 0),
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    int count,
    Color dotColor,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: dotColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: dotColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
