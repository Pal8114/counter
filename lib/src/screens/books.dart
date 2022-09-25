// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:counter/src/helper.dart';
import 'package:counter/src/widgets/blog_list.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../routing.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({
    super.key,
  });

  @override
  State<BooksScreen> createState() {
    return _BooksScreenState();
  }
}

class _BooksScreenState extends State<BooksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<dynamic, dynamic>> _my = [];
  List<Map<dynamic, dynamic>> _all = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_handleTabIndexChanged);
    //posts();
  }

  Future<void> posts() async {
    var counterValue = await microBlog?.posts(0);
    if (this.mounted) {
      setState(() {
        _my = counterValue!;
      });
    }
  }

  Future<void> timeline() async {
    var counterValue = await microBlog?.timeline(0);
    if (this.mounted) {
      setState(() {
        _all = counterValue!;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newPath = _routeState.route.pathTemplate;
    if (newPath.startsWith('/books/popular')) {
      _tabController.index = 0;
      posts();
    } else if (newPath == '/books/all') {
      _tabController.index = 1;
      timeline();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndexChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('博客'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: '我的博客',
                icon: Icon(Icons.list),
              ),
              Tab(
                text: '关注的博客',
                icon: Icon(Icons.people),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            BlogList(
              blogs: _my,
              onTap: null,
            ),
            BlogList(
              blogs: _all,
              onTap: null,
            ),
          ],
        ),
      );

  RouteState get _routeState => RouteStateScope.of(context);

  void _handleBookTapped(Book book) {
    _routeState.go('/book/${book.id}');
  }

  void _handleTabIndexChanged() {
    switch (_tabController.index) {
      case 1:
        _routeState.go('/books/all');
        break;
      case 0:
      default:
        _routeState.go('/books/popular');
        break;
    }
  }
}
