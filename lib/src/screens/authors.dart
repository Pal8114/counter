// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:agent_dart/agent_dart.dart';
import 'package:counter/src/helper.dart';
import 'package:counter/src/widgets/follow_list.dart';
import 'package:flutter/material.dart';

import '../data/library.dart';
import '../routing.dart';
import '../widgets/author_list.dart';

class AuthorsScreen extends StatefulWidget {
  final String title = '关注';

  const AuthorsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen>
    with SingleTickerProviderStateMixin {
  List<Principal> _follows = [];

  @override
  void initState() {
    super.initState();
    follows();
  }

  Future<void> follows() async {
    var counterValue = await microBlog?.follows();
    if (this.mounted) {
      setState(() {
        _follows = counterValue!;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FollowList(
          authors: _follows,
          onTap: (author) {
            RouteStateScope.of(context).go('/author/${author.toString()}');
          },
        ),
      );
}
