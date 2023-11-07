import 'package:flutter/material.dart';
import 'package:mobile_reviewer/models/user_type.dart'; // Import the UserType enum from your desired location

class Users {
  final String id;
  String name;
  final String photo;
  final String email;
  final UserType userType;

  Users({
    required this.id,
    required this.name,
    required this.photo,
    required this.email,
    required this.userType,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] as String,
      name: json['name'] as String,
      photo: json['photo'] as String,
      email: json['email'] as String,
      userType: UserType.values
          .firstWhere((e) => e.toString() == 'UserType.${json['userType']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'email': email,
      'userType': userType.toString().split('.').last,
    };
  }
}
