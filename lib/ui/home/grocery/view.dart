import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class GroceryView extends StatelessWidget {
  const GroceryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: GroceryController(),
      builder: (GroceryController c) {
        return Scaffold();
      },
    );
  }
}
