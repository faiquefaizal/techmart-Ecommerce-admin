import 'package:flutter/material.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/features/authentication/presentation/widget/screens/login_page.dart';
import 'package:techmart_admin/home_screen.dart';

void validateLogin(BuildContext context, String username, String password) {
  if (username == 'admin' && password == 'admin') {
    custemSnakbar(context, "Login successful. Welcome, Admin!", Colors.green);
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  } else {
    custemSnakbar(context, "Invalid username or password", Colors.red);
    return;
  }
}
