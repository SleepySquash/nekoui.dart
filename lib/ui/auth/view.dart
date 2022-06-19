import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nekoui/util/message_popup.dart';

import 'controller.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AuthController(Get.find()),
      builder: (AuthController c) {
        return Obx(() => c.authStatus.value.isLoading
            ? const Scaffold(body: CircularProgressIndicator())
            : Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Spacer(),
                      const Text('NekoUI'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: c.register,
                        child: const Text(
                          'Play',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (await MessagePopup.alert('Are you sure?') ==
                              true) {
                            c.clean();
                          }
                        },
                        child: const Text(
                          'Clear cache',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ));
      },
    );
  }
}
