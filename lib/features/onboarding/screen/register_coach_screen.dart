import 'package:calories_tracking/features/commonWidget/customInput.dart';
import 'package:calories_tracking/features/commonWidget/rectangle_custom_button.dart';
import 'package:calories_tracking/features/onboarding/screen/login_page.dart';
import 'package:calories_tracking/features/onboarding/screen/register_user_screen.dart';
import 'package:calories_tracking/helper/route_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/onboarding/bloc/register_bloc.dart';
import 'package:calories_tracking/service/auth_service.dart';

class CoachRegister extends StatelessWidget {
  const CoachRegister({Key? key}) : super(key: key);

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
    _locationController.dispose();
    _userController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.status == FormStatus.success) {
            RouteHelper().backToPrevious(context);
          }
    }, builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: AppBar().preferredSize.height,),
              const Text(
                'Coach Registration',
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
              CustomInput(
                  inputName: "Location", controller: _locationController),
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
              state.fileStatus == FormStatus.pending ? Uploading(state.selectedFile!.name) : Browse(),
              SizedBox(
                height: 10,
              ),
              RectangleCustomButton(
                buttonText: "Register",
                onPressed: () {
                  if (_passwordController.text ==
                      _confirmPasswordController.text && _userController != null && _emailController != null && _locationController != null ) {
                    BlocProvider.of<RegisterBloc>(context)
                        .add(LocationChanged(_locationController.text));
                    BlocProvider.of<RegisterBloc>(context)
                        .add(userNameChanged(_userController.text));
                    BlocProvider.of<RegisterBloc>(context)
                        .add(PasswordChanged(_passwordController.text));
                    BlocProvider.of<RegisterBloc>(context)
                        .add(EmailChanged(_emailController.text));
                    BlocProvider.of<RegisterBloc>(context)
                        .add(RoleChanged(UserType.coach));
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
                    'Already Have an Account? ',
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
                    'Want to Register as a User? ',
                    style: TextStyle(color: AppTheme.secondaryTextColor),
                  ),
                  GestureDetector(
                    onTap: () =>
                        RouteHelper().redirectTo(context, UserRegister()),
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
      );
    });
  }

  Widget Browse() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          context.read<RegisterBloc>().add(FileSelected(result.files.first));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Center(
              child: Icon(Icons.file_copy_rounded),
            ),
            SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                text: 'Drag & drop files or ',
                style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                children: const <TextSpan>[
                  TextSpan(
                      text: 'Browse',
                      style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          decoration: TextDecoration.underline)),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Supported formats : JPEG,PNG,PDF',
              style:
                  TextStyle(color: AppTheme.secondaryTextColor, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget Uploading(String name) {
    return TextField(
      controller: TextEditingController(text: name),
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'File Name',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(8.0), // 可选的圆角边框
        ),
        suffixIcon: Padding(
            padding: const EdgeInsets.all(11.0),
            // Reduced padding from 11.0 to 5.0
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                onTap: () {
                  context.read<RegisterBloc>().add(FileRemove());
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            )),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
