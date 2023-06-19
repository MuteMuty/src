import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'my_snack_bar.dart';

class UserTile extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final User user;
  UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(user.image),
      ),
      title: Text('${user.firstName} ${user.lastName}, ${user.age}'),
      subtitle: Text(user.email),
      onTap: () async {
        final SharedPreferences prefs = await _prefs;
        prefs.setInt('user', user.id);

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          mySnackBar(context, 'Switched to user: ${user.firstName}'),
        );
        Navigator.of(context).pop();
      },
    );
  }
}
