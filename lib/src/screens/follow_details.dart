// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:counter/src/helper.dart';
import 'package:counter/src/microblog.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class FollowDetailsScreen extends StatefulWidget {
  final Author author;

  const FollowDetailsScreen({
    super.key,
    required this.author,
  });

  @override
  State<StatefulWidget> createState() => _FollowDetailsScreenState();
}

class _FollowDetailsScreenState extends State<FollowDetailsScreen>
    with SingleTickerProviderStateMixin {
  var title = "loading";
  List<Map<dynamic, dynamic>> blogs = [];

  @override
  void initState() {
    super.initState();
    getName();
    getPosts();
  }

  Future<void> getName() async {
    var name = await microBlog?.otherName(widget.author.name);
    if (this.mounted) {
      setState(() {
        title = name!;
      });
    }
  }

  Future<void> getPosts() async {
    var posts = await microBlog?.otherposts(widget.author.name, 0);
    if (this.mounted) {
      setState(() {
        blogs = posts!;
      });
    }
  }

  Future<void> unfollow() async {
    await microBlog?.unfollow(widget.author.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          TextButton(
            onPressed: unfollow,
            child: const Text(
              '取消关注',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            blogs[index]["text"],
          ),
          subtitle: Text(blogs[index]["author"] +
              "\n" +
              simplyFormat(
                  time: DateTime.fromMillisecondsSinceEpoch(
                      getTime(blogs[index]["time"].toString()),
                      isUtc: false))),
        ),
      ),
    );
  }
}
