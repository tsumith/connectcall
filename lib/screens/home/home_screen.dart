import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';
import '../../../services/calling_service.dart';
import '../../../services/stream_providers.dart';
import 'views/dashboard_view.dart';
import 'views/recent_calls_view.dart';
import 'views/contacts_view.dart';
import 'views/profile_view.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  static const List<Widget> _views = [
    DashboardView(),
    ContactsView(),
    RecentCallsView(),
    ProfileView(),
  ];

  bool _zegoInitialized = false;

  void _initZego(String userId, String userName) {
    if (_zegoInitialized) return;
    ref.read(callingServiceProvider).initCloud(userId, userName);
    _zegoInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authServiceProvider).currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Watch the user profile via cached StreamProvider — no stream recreation
    final userProfileAsync = ref.watch(userProfileStreamProvider(currentUser.uid));

    // Initialize Zego when profile data is available — runs only when data changes
    userProfileAsync.whenData((user) {
      if (user != null && !_zegoInitialized) {
        // Schedule after build to avoid setState-during-build issues
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _initZego(user.uid, user.name);
        });
      }
    });

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _views),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
