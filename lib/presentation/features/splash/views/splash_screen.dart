import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:not/presentation/features/auth/providers/auth_provider.dart';
import 'package:not/core/theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animasyonu
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        // Kullanıcı oturumu varsa → dashboard
        // Yoksa → login
        Future.microtask(() {
          if (!mounted) return;
          if (user != null) {
            context.go('/dashboard');
          } else {
            context.go('/login');
          }
        });

        return _buildSplashView(theme);
      },
      loading: () => _buildSplashView(theme),
      error: (_, __) => _buildSplashView(theme),
    );
  }

  Widget _buildSplashView(ThemeData theme) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: const Icon(Icons.book, color: Colors.white, size: 100),
            ),
            const SizedBox(height: 20),
            Text(
              "ToDo App",
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
