import 'package:flutter/material.dart';
import 'package:flutter_study/user_model/user_model.dart';

class DetailPage extends StatelessWidget {
  final UserModel user;
  const DetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Home Page')),
    body: SingleChildScrollView(
      padding: .all(25),
      child: Column(
        children: [
          Text('Name: ${user.name}'),
          Text('UserName: ${user.username}'),
          Text(user.email ?? 'Not provided (email)'),
          Text('Phone Number: ${user.phone}'),
        ],
      ),

    ),);
  }
}
