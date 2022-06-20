import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class IntroductionView extends StatelessWidget {
  const IntroductionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: IntroductionController(Get.find()),
      builder: (IntroductionController c) {
        return const Scaffold();
      },
    );
  }
}
