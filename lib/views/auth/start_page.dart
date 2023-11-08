import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_reviewer/styles/pallete.dart';

import '../../widgets/button_1.dart';
import '../../widgets/button_primary.dart';

class StarterPage extends StatelessWidget {
  const StarterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: SecondaryBG,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: SecondaryBG,
          image: DecorationImage(
            image: AssetImage('assets/images/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 120,
              height: 120,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Login or Sign Up",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Login or create an account to take Reviewer and quiz, take part in challenge, and more.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ButtonPrimary(
                    title: "Login",
                    onTap: () => context.push("/login"),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  OutlinedButtonPrimary(
                    title: "Sign up",
                    onTap: () => context.push("/signup"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
