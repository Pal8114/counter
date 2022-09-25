// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:agent_dart/agent_dart.dart';
import 'package:counter/src/helper.dart';
import 'package:counter/src/microblog.dart';
import 'package:flutter/material.dart';

class FollowList extends StatefulWidget {
  final List<Principal> authors;
  final ValueChanged<Principal>? onTap;

  const FollowList({
    required this.authors,
    this.onTap,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _FollowList();
}

class _FollowList extends State<FollowList>
    with SingleTickerProviderStateMixin {
  Map<String, String> names = Map();

  Future<void> getName(Principal principal) async {
    var name = await microBlog?.otherName(principal.toString());
    names[principal.toString()] = name!;
    if (this.mounted) {
      setState(() {});
    }
  }

  // Future<void> getName(Principal principal) async {
  //   MicroBlog mb = MicroBlog(canisterId: principal.toString(), url: url);
  //   await mb.setAgent(newIdentity: null);
  //   var name = await mb.getName();
  //   names[principal.toString()] = name;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) => ListView.builder(
      itemCount: widget.authors.length,
      itemBuilder: (context, index) {
        if (!names.containsKey(widget.authors[index].toString())) {
          names[widget.authors[index].toString()] = "loading...";
          getName(widget.authors[index]);
        }
        return ListTile(
          title: Text(
            names[widget.authors[index].toString()]!,
          ),
          subtitle: Text(
            widget.authors[index].toString(),
          ),
          onTap: widget.onTap != null
              ? () => widget.onTap!(widget.authors[index])
              : null,
        );
      });
}
