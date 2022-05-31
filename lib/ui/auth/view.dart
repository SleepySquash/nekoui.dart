import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('NekoUI'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: c.register,
                        child: const Text('Play'),
                      ),
                    ],
                  ),
                ),
              ));
      },
    );
  }
}
