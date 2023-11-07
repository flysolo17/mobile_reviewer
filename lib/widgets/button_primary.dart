import 'package:flutter/material.dart';
import 'package:mobile_reviewer/styles/pallete.dart';

class OutlinedButtonPrimary extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const OutlinedButtonPrimary(
      {required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: PrimaryColor), // Border color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Text(
            title,
            style: const TextStyle(
              color: PrimaryColor, // Text color matching the border color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
