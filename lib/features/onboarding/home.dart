import 'package:calories_tracking/features/onboarding/screen/login_page.dart';
import 'package:calories_tracking/features/onboarding/screen/register_user_screen.dart';
import 'package:flutter/material.dart';
import '../commonWidget/rectangle_custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: AppBar().preferredSize.height,),
                  _header(context),
                  _imageContainer(context),
                  Spacer(),
                  _bottomButton(context)
                ],
              ),
            ),
          ),
        ));
  }
}

Widget _header(BuildContext context) {
  return Column(
    children: [
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.80,
        height: 50,
        child: Text(
          "FitQuest",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Center(
        child: Text(
          "Why are you fat?",
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    ],
  );
}

Widget _imageContainer(BuildContext context) {
  return const Column(
    children: [
      SizedBox(
        height: 80,
      ),
      SizedBox(
          height: 250,
          child:
              Image(image: AssetImage("assets/FitQuest_Logo.png"))),
    ],
  );
}

Widget _bottomButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RectangleCustomButton(
          buttonText: "Log in",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserLogin()),
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
        // RectangleCustomButton(
        //   buttonText: "Register",
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => UserRegister()),
        //     );
        //   },
        //   icon: const Icon(
        //     Icons.arrow_forward,
        //     size: 16,
        //     color: Colors.white,
        //   ),
        // )
      ],
    ),
  );
}
