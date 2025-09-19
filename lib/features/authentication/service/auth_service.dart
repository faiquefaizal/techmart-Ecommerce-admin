import 'package:flutter/material.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/features/authentication/presentation/widget/screens/login_page.dart';
import 'package:techmart_admin/home_screen.dart';
import 'package:web/web.dart' as web;

class AuthService {
  static const String _key = 'isLoggedIn';

  static void setLoginStatus(bool isLoggedIn) {
    web.window.localStorage.setItem(_key, isLoggedIn.toString());
  }

  static bool isLoggedIn() {
    final value = web.window.localStorage.getItem(_key);
    return value == 'true';
  }

  static void validateLogin(
    BuildContext context,
    String username,
    String password,
  ) {
    if (username == 'admin' && password == 'admin') {
      AuthService.setLoginStatus(true);
      custemSnakbar(context, "Login successful. Welcome, Admin!", Colors.green);
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      custemSnakbar(context, "Invalid username or password", Colors.red);
      return;
    }
  }

  static void logout() {
    web.window.localStorage.removeItem(_key);
  }
}
