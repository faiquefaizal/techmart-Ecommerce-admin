import 'package:flutter/material.dart';
import 'package:techmart_admin/features/authentication/service/auth_service.dart';
import 'package:techmart_admin/features/authentication/presentation/widget/custem_input.dart';
import 'package:techmart_admin/features/authentication/presentation/widget/login_button.dart';

class loginSide extends StatelessWidget {
  const loginSide({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Admin Login',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              CustomInput(
                controller: emailController,
                hintText: 'Enter your email',
                icon: Icons.email,
                obscure: false,
              ),
              const SizedBox(height: 15),
              CustomInput(
                controller: passwordController,
                hintText: 'Enter your password',
                icon: Icons.lock,
                obscure: true,
              ),
              const SizedBox(height: 20),
              LoginButton(
                onPressed: () {
                  validateLogin(
                    context,
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
