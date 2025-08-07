import 'package:flutter/material.dart';

import 'package:techmart_admin/features/authentication/presentation/widget/login_side.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Expanded(child: Container(color: Colors.black87)),
          loginSide(
            emailController: emailController,
            passwordController: passwordController,
          ),
        ],
      ),
    );
  }
}
