import 'package:flutter/material.dart';
import 'package:login_page/const/custom_buttons.dart';
import 'package:provider/provider.dart';
import 'package:login_page/provider/theme_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Home Page", style: heading),
        actions: [
          IconButton(
            icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Text(" 👋 Welcome to the Home Page!", style: subheading),
      ),
    );
  }
}
