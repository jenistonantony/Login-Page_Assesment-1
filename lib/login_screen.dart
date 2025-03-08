import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:login_page/homepage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isValidEmail = false;
  bool _isValidPassword = false;

  bool _validatePassword(String value) {
    return RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*])').hasMatch(value);
  }

  void _validateInputs() {
    setState(() {
      _isValidEmail = EmailValidator.validate(_emailController.text);
      _isValidPassword = _validatePassword(_passwordController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade100,
          title: Text(
            'Login',
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Email",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black)),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Email",
                    hintStyle: TextStyle(),
                    prefixIcon: Icon(Icons.email),
                    errorText:
                        _emailController.text.isNotEmpty && !_isValidEmail
                            ? "Enter a valid email"
                            : null,
                  ),
                  onChanged: (_) => _validateInputs(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Password",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black)),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Password",
                    prefixIcon: Icon(Icons.lock),
                    errorText:
                        _passwordController.text.isNotEmpty && !_isValidPassword
                            ? "Must have 1 number & 1 special char"
                            : null,
                  ),
                  onChanged: (_) => _validateInputs(),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: (_isValidEmail && _isValidPassword)
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Login Successful!')),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Homepage()));
                        }
                      : null,
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.deepPurple, fontSize: 20),
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
