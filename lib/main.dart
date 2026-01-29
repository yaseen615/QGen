import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'utils/app_theme.dart';
import 'widgets/sidebar_nav.dart';
import 'screens/home_screen.dart';
import 'screens/create_question_screen.dart';
import 'screens/question_bank_screen.dart';
import 'screens/generate_paper_screen.dart';
import 'screens/subjects_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  final storage = StorageService();
  await storage.init();

  runApp(
    ChangeNotifierProvider.value(
      value: storage,
      child: const QuestionPaperApp(),
    ),
  );
}

class QuestionPaperApp extends StatelessWidget {
  const QuestionPaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QGen - NEET/JEE Question Bank',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppShell(),
    );
  }
}

/// Main app shell with sidebar navigation
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  bool _sidebarExpanded = true;

  final List<Widget> _screens = const [
    HomeScreen(),
    CreateQuestionScreen(),
    QuestionBankScreen(),
    GeneratePaperScreen(),
    SubjectsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          SidebarNav(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            isExpanded: _sidebarExpanded,
            onToggleExpand: () {
              setState(() => _sidebarExpanded = !_sidebarExpanded);
            },
          ),

          // Main content area
          Expanded(
            child: Container(
              color: AppColors.background,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _screens[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
