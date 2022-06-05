import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class WardrobeView extends StatelessWidget {
  const WardrobeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: WardrobeController(),
      builder: (WardrobeController c) {
        return Scaffold();
      },
    );
  }
}
