import 'package:flutter/material.dart';
import '../models/user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  _fetchUsers() async {
    final Uri uri = Uri.https('dummyjson.com', '/users');
    final response = await http.get(uri);
    var users = json.decode(response.body)['users'] as List;
    setState(() {
      _users = users.map((user) => User.fromJson(user)).toList();
      _filteredUsers = _users;
    });
  }

  void _filterUsers(String value) {
    setState(() {
      _filteredUsers = _users
          .where((user) =>
              user.firstName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_users.toString());
    debugPrint(_filteredUsers[0].toString());
    User user = _filteredUsers[0];
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InfoCard(title: 'First Name', data: user.firstName),
              InfoCard(title: 'Last Name', data: user.lastName),
              InfoCard(title: 'Maiden Name', data: user.maidenName),
              InfoCard(title: 'Age', data: user.age.toString()),
              InfoCard(title: 'Gender', data: user.gender),
              InfoCard(title: 'Email', data: user.email),
              InfoCard(title: 'Phone', data: user.phone),
              InfoCard(title: 'Username', data: user.username),
              InfoCard(title: 'Password', data: user.password),
              InfoCard(title: 'Birth Date', data: user.birthDate.toString()),
              InfoCard(title: 'Blood Group', data: user.bloodGroup),
              InfoCard(title: 'Height', data: user.height.toString()),
              InfoCard(title: 'Weight', data: user.weight.toString()),
              InfoCard(title: 'Eye Color', data: user.eyeColor),
              InfoCard(title: 'Hair Color', data: user.hair.color),
              InfoCard(title: 'Hair Type', data: user.hair.type),
              InfoCard(title: 'Domain', data: user.domain),
              InfoCard(title: 'IP Address', data: user.ip),
              InfoCard(title: 'Address', data: user.address.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String data;

  InfoCard({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 5),
          Text(
            data,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
