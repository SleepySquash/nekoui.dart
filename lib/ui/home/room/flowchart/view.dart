import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class FlowchartView extends StatelessWidget {
  const FlowchartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: FlowchartController(),
      builder: (FlowchartController c) {
        return Scaffold();
      },
    );
  }
}
