// login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projrct/features/auth/presentation/pages/signup_page.dart';

import '../../presentation/bloc/login_bloc.dart';
import '../../../../core/widgets/common_button.dart';
import '../../../../core/widgets/common_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Login Success"),
                ),
              );
            }

            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),

              );
              print(state.message);

            }
          },
          builder: (context, state) {
            return Column(
              children: [
                CommonTextField(
                  controller: emailController,
                  hintText: "Email",
                ),

                const SizedBox(height: 20),

                CommonTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                const SizedBox(height: 30),

                state is LoginLoading
                    ? const CircularProgressIndicator()
                    : CommonButton(
                  text: "Login",
                  onTap: () {
                    context.read<LoginBloc>().add(
                      LoginButtonPressed(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      ),
                    );
                  },
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SignupPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Signup",
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}