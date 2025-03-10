import 'package:flutter/material.dart';
import 'package:login_page/screens/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:login_page/provider/language_provider.dart';
import 'package:login_page/provider/theme_provider.dart'; // Import ThemeProvider
import 'package:login_page/screens/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                ThemeProvider()), // Ensure ThemeProvider is included
      ],
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Multi-Language App',
            theme:
                themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            locale: languageProvider.locale,
            supportedLocales: [
              Locale('en', 'US'),
              Locale('ta', 'IN'),
            ],
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: LoginScreen(),
          );
        },
      ),
    );
  }
}
