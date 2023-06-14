import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserTile extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final User user;
  UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.image),
      ),
      title: Text('${user.firstName} ${user.lastName}, ${user.age}'),
      subtitle: Text(user.email),
      onTap: () async {
        final SharedPreferences prefs = await _prefs;
        prefs.setInt('user', user.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Switched to user: ${user.firstName}',
              textAlign: TextAlign.center,
            ),
            width: 150,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        );
        Navigator.of(context).pop();
      },
    );
  }
}
