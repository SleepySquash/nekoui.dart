import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/router.dart';
import '/util/message_popup.dart';
import 'controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SettingsController(Get.find()),
      builder: (SettingsController c) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Logout'),
                onTap: () async {
                  if (await MessagePopup.alert('Are you sure?') == true) {
                    c.reset();
                    router.auth();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
