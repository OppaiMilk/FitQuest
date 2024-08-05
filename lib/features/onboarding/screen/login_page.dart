import 'package:calories_tracking/features/admin_main/screens/admin_main_screen.dart';
import 'package:calories_tracking/features/commonWidget/customInput.dart';
import 'package:calories_tracking/features/commonWidget/rectangle_custom_button.dart';
import 'package:calories_tracking/features/onboarding/bloc/login_bloc.dart';
import 'package:calories_tracking/features/onboarding/screen/register_user_screen.dart';
import 'package:calories_tracking/helper/route_helper.dart';
import 'package:calories_tracking/helper/screen_height_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/service/auth_service.dart';
import 'package:calories_tracking/features/user_main/screens/user_main_screen.dart';

import '../../coach_main/screens/coach_main_screen.dart';

class UserLogin extends StatelessWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      body: BlocProvider(
        create: (_) => LoginBloc(AuthRepo()),
        child: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          // Navigate to the user main screen upon successful login
          if (state.role == UserType.user) {
            RouteHelper().redirectReplaceTo(
                context,
                UserMainScreen(user: state.user!)
            );
          } else if (state.role == UserType.coach && state.user?.status == "approved") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CoachMainScreen(coach: state.user!,)),
            );
          } else {
            RouteHelper().redirectReplaceTo(
                context,
                AdminMainScreen(admin: state.user!)
            );
          }
        } else if (state.status == FormStatus.error) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMsg ?? 'Login failed')),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenHeightHelper(context).getScreenHeight() / 4,
                ),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Please login to use our application',
                  style: TextStyle(color: AppTheme.secondaryTextColor),
                ),
                const SizedBox(height: 30),
                CustomInput(
                    inputName: "Email Address", controller: _emailController),
                const SizedBox(height: 10),
                CustomInput(
                  inputName: "Password",
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                RectangleCustomButton(
                  buttonText: "Login",
                  onPressed: () {
                    context
                        .read<LoginBloc>()
                        .add(PasswordChanged(_passwordController.text));
                    context
                        .read<LoginBloc>()
                        .add(EmailChanged(_emailController.text));
                    context.read<LoginBloc>().add(FormSubmit());
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Remember Me",
                      style: TextStyle(fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: AppTheme.secondaryTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Haven\'t yet become User? ',
                      style: TextStyle(color: AppTheme.secondaryTextColor),
                    ),
                    GestureDetector(
                      onTap: () =>
                          RouteHelper().redirectTo(context, UserRegister()),
                      child: const Text(
                        'Register Instead',
                        style: TextStyle(
                            color: AppTheme.secondaryTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
