import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../widgets/search_field.dart';
import '../widgets/user_tile.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const _pageSize = 10;
  User? _user;

  String _searchTerm = '';

  final PagingController<int, User> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height -
            (_user != null
                ? 200
                : 60 + 56), // 200 = bottom sheet height, 56 = app bar height
        child: buildProductsView(),
      ),
      backgroundColor: Colors.grey[900],
      bottomSheet: Container(
        height: _user != null ? 200 : 60,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _user != null
              ? Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(_user!.image),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${_user!.firstName} ${_user!.maidenName} ${_user!.lastName}, ${_user!.age}'),
                            Text(_user!.gender),
                            Text(_user!.email),
                            Text(_user!.phone),
                            Text(
                                '${_user!.birthDate.day}.${_user!.birthDate.month}.${_user!.birthDate.year}'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: const Text('Sign out'),
                      onPressed: () async {
                        final SharedPreferences prefs = await _prefs;
                        prefs.remove('user');
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              : const Text(
                  'No user Logged in',
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }

  Widget buildProductsView() => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchField(
                onChanged: _updateSearchTerm,
              ),
            ),
            PagedSliverList<int, User>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<User>(
                itemBuilder: (context, item, index) =>
                    (_searchTerm.isNotEmpty || _user == null)
                        ? UserTile(
                            user: item,
                          )
                        : const SizedBox(),
              ),
            ),
          ],
        ),
      );

  Future<void> _fetchPage(int pageKey) async {
    final queryParameters = {
      'q': _searchTerm,
      'limit': _pageSize.toString(),
      'skip': pageKey.toString(),
    };

    try {
      int err = 0;
      List<User> users = [];
      Uri uri = Uri.https('dummyjson.com', '/users/search', queryParameters);
      final response = await http.get(uri);
      final decodedUsers = json.decode(response.body)['users'] as List;

      for (int i = 0; i < decodedUsers.length; i++) {
        try {
          users.add(User.fromJson(decodedUsers[i]));
        } catch (e) {
          err++;
          debugPrint(e.toString());
        }
      }

      final isLastPage = users.length < (_pageSize - err);
      if (isLastPage) {
        _pagingController.appendLastPage(users);
      } else {
        final nextPageKey = pageKey + users.length + err;
        _pagingController.appendPage(users, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void getCurrentUser() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getInt('user') == null) {
      return null;
    }
    final int? currentUser = prefs.getInt('user');

    Uri uri = Uri.https('dummyjson.com', '/users/$currentUser');
    final response = await http.get(uri);
    final decodedUser = json.decode(response.body);
    debugPrint(decodedUser.toString());
    setState(() {
      _user = User.fromJson(decodedUser);
    });
  }

  void _updateSearchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
