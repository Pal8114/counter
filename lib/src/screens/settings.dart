// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:counter/src/helper.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _textFieldController = TextEditingController();
  String self = 'loading';
  String? codeDialog;
  String? valueText;

  Future<void> getName() async {
    var name = await microBlog?.getName();
    if (this.mounted) {
      setState(() {
        self = name!;
      });
    }
  }

  Future<void> post(String content) async {
    if (content.length > 0) {
      await microBlog?.post(content);
    }
  }

  Future<void> follow(String id) async {
    if (id.length > 0) {
      await microBlog?.follow(id);
    }
  }

  // Future<void> getName() async {
  //   var name = await microBlog?.getName();
  //   setState(() {
  //     self = name!;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    child: Column(
                      children: [
                        ...[
                          Text(
                            self,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              BookstoreAuthScope.of(context).signOut();
                            },
                            child: const Text('Sign out'),
                          ),
                        ].map((w) => Padding(
                            padding: const EdgeInsets.all(8), child: w)),
                        TextButton(
                          onPressed: () =>
                              _displayTextInputDialog(context, "写点什么", 0x01),
                          child: const Text('写点什么'),
                        ),
                        TextButton(
                          onPressed: () => _displayTextInputDialog(
                              context, "请输入同学的canisterId", 0x02),
                          child: const Text('关注同学'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Future<void> _displayTextInputDialog(
      BuildContext context, String title, int opt) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    Navigator.pop(context);
                    if (opt == 0x01) {
                      post(codeDialog!);
                    } else if (opt == 0x02) {
                      follow(codeDialog!);
                    }
                  });
                },
              ),
            ],
          );
        });
  }
}
