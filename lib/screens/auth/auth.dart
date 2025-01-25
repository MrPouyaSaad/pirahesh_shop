// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/auth_repository.dart';
import '../../data/repo/cart_repository.dart';
import '../../theme.dart';
import '../widgets/button_loading_widget.dart';
import 'bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextStyle textFieldStyle =
      const TextStyle(color: Color.fromARGB(255, 234, 237, 247));
  final TextEditingController usernameController =
      TextEditingController(text: '09143660476');
  final TextEditingController passwordController =
      TextEditingController(text: '12345678');
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const onBackground = Color.fromARGB(255, 234, 237, 247);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Theme(
        data: themeData.copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: (onBackground),
              foregroundColor: (themeData.colorScheme.secondary),
            ),
          ),
          colorScheme: themeData.colorScheme.copyWith(onSurface: onBackground),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: const TextStyle(color: onBackground),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: onBackground, width: 1)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: onBackground, width: 1)),
          ),
        ),
        child: Scaffold(
          backgroundColor: themeData.colorScheme.secondary,
          body: BlocProvider<AuthBloc>(
            create: (context) {
              final authBloc = AuthBloc(
                  authRepository: authRepository,
                  cartRepository: cartRepository);
              authBloc.stream.forEach((state) {
                if (state is AuthSuccess) {
                  Navigator.of(context).pop();
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.exception.message,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.redAccent.shade700,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              });
              authBloc.add(AuthStarted());
              return authBloc;
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 48, right: 48),
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) {
                  return current is AuthLoading ||
                      current is AuthInitial ||
                      current is AuthError;
                },
                builder: (context, state) {
                  final authBloc = BlocProvider.of<AuthBloc>(context);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/nike_logo.png',
                        color: Colors.white,
                        width: 120,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        state.isLogin ? 'Welcome Back' : 'Welcome to Nike',
                        style: const TextStyle(
                            color: onBackground,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        state.isLogin
                            ? 'Login your account'
                            : 'Create your account',
                        style:
                            const TextStyle(color: onBackground, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextField(
                        controller: usernameController,
                        style: textFieldStyle,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          label: Text('Phone Number '),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      _PasswordTextField(
                        onBackground: onBackground,
                        passwordController: passwordController,
                        textFieldStyle: textFieldStyle,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          authBloc.add(
                            AuthButtonClicked(
                              username: usernameController.text,
                              password: passwordController.text,
                            ),
                          );
                        },
                        child: state is AuthLoading
                            ? const ButtonLoadingWidget()
                            : Text(
                                state.isLogin ? 'Login' : 'Sign Up',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          authBloc.add(AuthModeChangeButtonClicked());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.isLogin
                                  ? 'Don\'t have an account?'
                                  : 'Already have an account?',
                              style: TextStyle(
                                  color: onBackground.withOpacity(0.7)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              state.isLogin ? 'Sign Up' : 'Login',
                              style: TextStyle(
                                color: themeData.colorScheme.primary,
                                decoration: TextDecoration.underline,
                                decorationColor: themeData.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    required this.onBackground,
    required this.passwordController,
    required this.textFieldStyle,
  }) : super();

  final Color onBackground;
  final TextEditingController passwordController;
  final TextStyle textFieldStyle;
  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.passwordController,
      style: widget.textFieldStyle,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obsecureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obsecureText = !obsecureText;
              });
            },
            icon: Icon(
              obsecureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: widget.onBackground.withOpacity(0.6),
            )),
        label: const Text('Password '),
      ),
    );
  }
}
