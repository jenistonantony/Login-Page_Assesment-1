import 'package:flutter/material.dart';
import 'package:login_page/core/widget/responsive_builder.dart';
import 'package:login_page/screens/study_image_pagination.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:login_page/provider/language_provider.dart';
import 'package:login_page/screens/app_localizations.dart';
import 'package:login_page/screens/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  bool _validatePassword(String value) {
    return RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*]).{6,}$').hasMatch(value);
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)?.translate('invalid_login') ??
                    "Invalid login!"),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              AppLocalizations.of(context)?.translate('login_success') ??
                  "Login Successful!")),
    );

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: _buildAppBar(languageProvider),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth > 800
              ? _buildWebView()
              : _buildMobileView();
        },
      ),
    );
  }

  AppBar _buildAppBar(LanguageProvider languageProvider) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      title: Center(
        child: Text(AppLocalizations.of(context)?.translate('login') ?? "Login",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.language, color: Colors.white),
          onSelected: (String value) {
            languageProvider.setLocale(value == 'English'
                ? const Locale('en', 'US')
                : const Locale('ta', 'IN'));
          },
          itemBuilder: (BuildContext context) => const [
            PopupMenuItem(value: 'English', child: Text('English')),
            PopupMenuItem(value: 'Tamil', child: Text('தமிழ்')),
          ],
        ),
      ],
    );
  }

  Widget _buildWebView() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: _buildLoginForm(),
          ),
        ),
        SizedBox(
          width: 400,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0), // Starts from right
                  end: Offset.zero, // Ends at original position
                ).animate(animation),
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(1),
                  child: child,
                ),
              );
            },
            child: ExpandedOrNot(
                child:
                    const StudyImagePagination()), // Keep it constant, for page animations
          ),
        ),
      ],
    );
  }

  Widget _buildMobileView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildLoginForm(),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2)
        ],
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextLabel('email'),
            _buildTextField(
                _emailController, 'enter_email', false, Icons.email),
            const SizedBox(height: 16),
            _buildTextLabel('password'),
            _buildTextField(
                _passwordController, 'enter_password', true, Icons.lock),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextLabel(String key) {
    return Text(
      AppLocalizations.of(context)?.translate(key) ?? key,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintKey,
      bool isPassword, IconData icon) {
    return TextFormField(
      autofocus: false,
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        hintText: AppLocalizations.of(context)?.translate(hintKey) ?? hintKey,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.deepPurple),
                onPressed: _togglePasswordVisibility,
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
      keyboardType:
          isPassword ? TextInputType.text : TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Field cannot be empty";
        }
        if (!isPassword && !EmailValidator.validate(value)) {
          return "Invalid email address";
        }
        if (isPassword && !_validatePassword(value)) {
          return "Password must contain at least 6 characters, a number & a symbol";
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          elevation: 5,
        ),
        child: Text(AppLocalizations.of(context)?.translate('login') ?? "Login",
            style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
