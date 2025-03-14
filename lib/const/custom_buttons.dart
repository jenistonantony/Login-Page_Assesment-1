import 'package:flutter/material.dart';

const TextStyle heading =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);

const TextStyle subheading =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);

const double buttonHeight = 50.0;
const double buttonWidth = 150.0;
const double buttonBorderRadius = 8.0;

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.grey.shade300,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(buttonBorderRadius),
  ),
  elevation: 5, 
);
