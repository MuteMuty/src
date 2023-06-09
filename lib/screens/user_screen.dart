import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserScreeen extends StatefulWidget {
  const UserScreeen({super.key});

  @override
  State<UserScreeen> createState() => _UserScreeenState();
}

class _UserScreeenState extends State<UserScreeen> {
  List<User> _users = [];

  @override
  void initState() async {
    super.initState();
    _users = await fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    // return ListView with the users
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_users[index].firstName),
          subtitle: Text(_users[index].email),
        );
      },
    );
  }

  Future<List<User>> fetchUsers() async {
    try {
      List<User> users = [];
      Uri uri = Uri.https('dummyjson.com', '/users/5');
      final response = await http.get(uri);
      final decodedUsers = json.decode(response.body)['users'] as List;

      decodedUsers.forEach((user) {
        users.add(User.fromJson(user));
      });

      return users;
    } catch (error) {
      throw error;
    }
  }
}
