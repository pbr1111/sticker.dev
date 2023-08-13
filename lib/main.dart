import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screens/stickers_screen.dart';

void main() {
  runApp(const NavigationBarApp());
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Sticker.dev",
        themeMode: ThemeMode.dark,
        theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.green[700]),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.green[700],
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
        ],
        home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTabIndex = 0;

  static const List<Widget> _widgetOptions = [
    const StickersScreen(),
    const StickersScreen(),
    const StickersScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        selectedIndex: _selectedTabIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.explore),
            label: AppLocalizations.of(context)!.explore,
          ),
          NavigationDestination(
            icon: Icon(Icons.add),
            label: AppLocalizations.of(context)!.add,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border),
            label: AppLocalizations.of(context)!.saved,
          ),
        ],
      ),
      body: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => _widgetOptions.elementAt(_selectedTabIndex))),
    );
  }
}
