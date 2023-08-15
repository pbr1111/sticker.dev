import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sticker_dev/screens/sticker_create_screen.dart';
import 'package:sticker_dev/screens/stickers_saved_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_localizations.dart';
import 'screens/stickers_screen.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://tvjryoppfhnjypxllulc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR2anJ5b3BwZmhuanlweGxsdWxjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIwNzkwNTMsImV4cCI6MjAwNzY1NTA1M30.mAqUaxcMG-Z94c1M622ja2nquUQj1G681IEOu8y0rGE',
  );
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
            colorSchemeSeed: Colors.green),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.green,
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
    const StickerCreateScreen(),
    const StickersSavedScreen(),
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
            selectedIcon: Icon(Icons.explore),
            icon: Icon(Icons.explore_outlined),
            label: AppLocalizations.of(context)!.explore,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add_circle),
            icon: Icon(Icons.add_circle_outline),
            label: AppLocalizations.of(context)!.create,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_outline),
            label: AppLocalizations.of(context)!.saved,
          )
        ],
      ),
      body: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => _widgetOptions.elementAt(_selectedTabIndex))),
    );
  }
}
