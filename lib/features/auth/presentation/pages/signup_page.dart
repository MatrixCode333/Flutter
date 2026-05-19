import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/common_button.dart';
import '../../../../core/widgets/common_textfield.dart';
import '../bloc/login_bloc.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Signup Success"),
                ),
              );

              Navigator.pop(context);
            }

            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
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

                  const SizedBox(height: 20),

                  CommonTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),

                  const SizedBox(height: 30),

                  state is LoginLoading
                      ? const CircularProgressIndicator()
                      : CommonButton(
                    text: "Signup",
                    onTap: () {
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Passwords do not match",
                            ),
                          ),
                        );

                        return;
                      }

                      // context.read<LoginBloc>().add(
                      //   SignupButtonPressed(
                      //     email: emailController.text.trim(),
                      //     password: passwordController.text.trim(),
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}