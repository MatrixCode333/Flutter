import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../bloc/login_bloc.dart';

import './widgets/auth_form_widget.dart';
import './widgets/auth_header_widget.dart';
import './widgets/auth_tab_toggle_widget.dart';
import './widgets/demo_credentials_widget.dart';
import './widgets/social_auth_widget.dart';

class SignUpLoginScreen extends StatefulWidget {
  const SignUpLoginScreen({super.key});

  @override
  State<SignUpLoginScreen> createState() => _SignUpLoginScreenState();
}

class _SignUpLoginScreenState extends State<SignUpLoginScreen>
    with TickerProviderStateMixin {

  bool _isLogin = true;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();

    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _toggleMode(bool isLogin) {
    if (_isLogin == isLogin) return;

    setState(() {
      _isLogin = isLogin;
      _formKey.currentState?.reset();
    });
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_isLogin) {
      context.read<LoginBloc>().add(
        LoginButtonPressed(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    } else {
      context.read<LoginBloc>().add(
        SignupButtonPressed(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  void _autofillCredentials(String email, String password) {
    _emailController.text = email;
    _passwordController.text = password;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {

          if (state is LoginSuccess) {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isLogin
                      ? "Login Success"
                      : "Signup Success",
                ),
              ),
            );
            print("asdasdasdfasfd");
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.homeScreen,
                  (route) => false,
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

          final isLoading = state is LoginLoading;

          return SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 0 : 24,
                      vertical: 24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 480 : double.infinity,
                        ),
                        child: isTablet
                            ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(20),
                                blurRadius: 32,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(40),
                          child: _buildContent(isLoading),
                        )
                            : _buildContent(isLoading),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeaderWidget(),

          const SizedBox(height: 32),

          AuthTabToggleWidget(
            isLogin: _isLogin,
            onToggle: _toggleMode,
          ),

          const SizedBox(height: 28),

          AuthFormWidget(
            isLogin: _isLogin,
            emailController: _emailController,
            passwordController: _passwordController,
            nameController: _nameController,
            confirmPasswordController: _confirmPasswordController,
            isLoading: false,
            onSubmit: _handleSubmit,
          ),

          const SizedBox(height: 24),

          const SocialAuthWidget(),

          const SizedBox(height: 24),

          DemoCredentialsWidget(
            onAutofill: _autofillCredentials,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}