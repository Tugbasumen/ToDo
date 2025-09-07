import 'package:go_router/go_router.dart';
import 'package:not/presentation/features/auth/views/login_screen.dart';
import 'package:not/presentation/features/auth/views/register_screen.dart';
import 'package:not/presentation/features/calender/views/calendar_screen.dart';
import 'package:not/presentation/features/dashboard/views/dashboard_screen.dart';
import 'package:not/presentation/features/ayarlar/views/ayarlar_screen.dart';
import 'package:not/presentation/features/splash/views/splash_screen.dart';
import 'package:not/presentation/features/tasks/views/tasks_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/tasks',
      name: 'tasks',
      builder: (context, state) => const TasksScreen(),
    ),
    GoRoute(
      path: '/calendar',
      name: 'calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const AyarlarScreen(),
    ),
  ],
);
