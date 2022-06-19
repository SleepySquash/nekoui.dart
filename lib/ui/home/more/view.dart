import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/router.dart';
import '/ui/widget/escape_popper.dart';
import 'controller.dart';

class MoreView extends StatelessWidget {
  const MoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EscapePopper(
      child: GetBuilder(
        init: MoreController(),
        builder: (MoreController c) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('More'),
            ),
            body: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Emails'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: router.settings,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: Navigator.of(context).pop,
              child: const Icon(Icons.close),
            ),
          );
        },
      ),
    );
  }
}
