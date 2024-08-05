import 'package:calories_tracking/features/commonWidget/customInput.dart';
import 'package:calories_tracking/features/commonWidget/rectangle_custom_button.dart';
import 'package:calories_tracking/features/onboarding/screen/login_page.dart';
import 'package:calories_tracking/features/onboarding/screen/register_coach_screen.dart';
import 'package:calories_tracking/helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/onboarding/bloc/register_bloc.dart';
import 'package:calories_tracking/service/auth_service.dart';

class UserRegister extends StatelessWidget {
  const UserRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      body: BlocProvider(
        create: (_) => RegisterBloc(AuthRepo()),
        child: const RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          // 跳转到登录页面或其他页面
          RouteHelper().backToPrevious(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppBar().preferredSize.height,
              ),
              const Text(
                'Registration',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Please fill in your details',
                style: TextStyle(color: AppTheme.secondaryTextColor),
              ),
              const SizedBox(height: 30),
              CustomInput(inputName: "Username", controller: _userController),
              const SizedBox(height: 10),
              CustomInput(
                  inputName: "Email Address", controller: _emailController),
              const SizedBox(height: 10),
              CustomInput(inputName: "Location", controller: _locationController),
              const SizedBox(height: 10),
              CustomInput(
                inputName: "Password",
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              CustomInput(
                inputName: "Confirm Password",
                controller: _confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              RectangleCustomButton(
                buttonText: "Register",
                onPressed: () {
                  if (_passwordController.text ==
                      _confirmPasswordController.text) {
                    BlocProvider.of<RegisterBloc>(context)
                        .add(LocationChanged(_locationController.text));
                    BlocProvider.of<RegisterBloc>(context)
                        .add(userNameChanged(_userController.text));
                    BlocProvider.of<RegisterBloc>(context)
                        .add(PasswordChanged(_passwordController.text));
                    BlocProvider.of<RegisterBloc>(context)
                        .add(EmailChanged(_emailController.text));
                    BlocProvider.of<RegisterBloc>(context).add(RoleChanged(UserType.user));
                    BlocProvider.of<RegisterBloc>(context).add(FormSubmit());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already Have an Account?',
                    style: TextStyle(color: AppTheme.secondaryTextColor),
                  ),
                  GestureDetector(
                    onTap: () =>
                        RouteHelper().redirectTo(context, UserLogin()),
                    child: const Text(
                      'Sign In Instead',
                      style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Want to Register as a Coach? ',
                    style: TextStyle(color: AppTheme.secondaryTextColor),
                  ),
                  GestureDetector(
                    onTap: () =>
                        RouteHelper().redirectTo(context, CoachRegister()),
                    child: const Text(
                      'Click Here',
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
      ),
    );
  }
}
