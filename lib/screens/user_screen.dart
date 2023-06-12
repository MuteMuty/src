import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  static const _pageSize = 20;

  String _searchTerm = '';

  final PagingController<int, User> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildProductsView(),
      backgroundColor: Colors.grey[900],
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    final queryParameters = {
      'q': _searchTerm,
      'limit': _pageSize.toString(),
      'skip': pageKey.toString(),
    };

    try {
      int err = 0;
      List<User> users = [];
      Uri uri = Uri.https('dummyjson.com', '/users', queryParameters);
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

  Widget buildProductsView() => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: _updateSearchTerm,
                ),
              ),
            ),
            PagedSliverList<int, User>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<User>(
                itemBuilder: (context, item, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(item.image),
                  ),
                  title: Text(item.firstName),
                  subtitle: Text(item.email),
                ),
              ),
            ),
          ],
        ),
      );

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
