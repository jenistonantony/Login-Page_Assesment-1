import 'package:flutter/material.dart';
import 'package:login_page/provider/language_provider.dart';
import 'package:login_page/screens/app_localizations.dart';
import 'package:login_page/screens/home_page.dart';

import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isValidEmail = false;
  bool _isValidPassword = false;

  bool _validatePassword(String value) {
    return RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*]).{6,}$').hasMatch(value);
  }

  void _validateInputs() {
    setState(() {
      _isValidEmail = EmailValidator.validate(_emailController.text);
      _isValidPassword = _validatePassword(_passwordController.text);
    });
  }

  void _login() {
    if (_isValidEmail && _isValidPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.translate('login_success')),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid email or password!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.translate(
              'login',
            ),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.language,
              color: Colors.black,
            ),
            onSelected: (String value) {
              if (value == 'English') {
                languageProvider.setLocale(Locale('en', 'US'));
              } else if (value == 'Tamil') {
                languageProvider.setLocale(Locale('ta', 'IN'));
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'English', child: Text('English')),
              PopupMenuItem(value: 'Tamil', child: Text('தமிழ்')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.translate('email'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 211, 200, 240),
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!
                          .translate('enter_email'),
                      errorText:
                          _emailController.text.isNotEmpty && !_isValidEmail
                              ? "Enter a valid email"
                              : null,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => _validateInputs(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.translate('password'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 211, 200, 240),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!
                          .translate('enter_password'),
                      errorText: _passwordController.text.isNotEmpty &&
                              !_isValidPassword
                          ? "Must have at least 6 chars, 1 number & 1 special char"
                          : null,
                    ),
                    onChanged: (_) => _validateInputs(),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    AppLocalizations.of(context)!.translate('login'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
