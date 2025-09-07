import 'package:flutter/material.dart';
import 'package:not/core/theme/app_theme.dart';
import 'package:not/presentation/features/calender/views/calendar_screen.dart';
import '../../tasks/views/tasks_screen.dart';
import '../../ayarlar/views/ayarlar_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TasksScreen(),
    CalendarScreen(),
    AyarlarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppTheme.cardColor,
        elevation: 8,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            activeIcon: Icon(Icons.check_circle, color: AppTheme.primaryColor),
            label: "Görevler",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            activeIcon: Icon(
              Icons.calendar_today,
              color: AppTheme.primaryColor,
            ),
            label: "Takvim",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.settings, color: AppTheme.primaryColor),
            label: "Ayarlar",
          ),
        ],
      ),
    );
  }
}
