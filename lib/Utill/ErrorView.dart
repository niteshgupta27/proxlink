import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_required.dart';

class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(child: Text(message, style: TextStyle(fontSize: 18))),
    );
  }
}