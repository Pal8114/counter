// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:counter/src/helper.dart';
import 'package:flutter/material.dart';

class BlogList extends StatelessWidget {
  final List<Map<dynamic, dynamic>> blogs;
  final ValueChanged<Map<dynamic, dynamic>>? onTap;

  const BlogList({
    required this.blogs,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
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
          onTap: onTap != null ? () => onTap!(blogs[index]) : null,
        ),
      );
}
