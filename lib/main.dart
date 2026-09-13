import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'widgets/call_overlay.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: ConnectCallApp()));
}

class ConnectCallApp extends ConsumerStatefulWidget {
  const ConnectCallApp({super.key});

  @override
  ConsumerState<ConnectCallApp> createState() => _ConnectCallAppState();
}

class _ConnectCallAppState extends ConsumerState<ConnectCallApp>
    with WidgetsBindingObserver {
  StreamSubscription? _authSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Set user as online when the app is launched and auth is ready
    _authSubscription = ref.read(authServiceProvider).authStateChanges.listen((user) {
      if (user != null) {
        ref.read(userServiceProvider).updateOnlineStatus(user.uid, true);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final currentUser = ref.read(authServiceProvider).currentUser;
    if (currentUser != null) {
      final isOnline = state == AppLifecycleState.resumed;
      ref
          .read(userServiceProvider)
          .updateOnlineStatus(currentUser.uid, isOnline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'ConnectCall',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      builder: (BuildContext context, Widget? child) {
        return CallOverlayWidget(child: child!);
      },
    );
  }
}
