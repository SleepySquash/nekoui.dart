import 'package:flutter/material.dart';

import '../controller.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab(this.c, {Key? key}) : super(key: key);

  final FlowchartController c;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: Center(
              child: Card(
                child: Column(
                  children: const [
                    Text('Progress'),
                    Text('Conditions:'),
                    Text('- 1'),
                    Text('- 2'),
                    Text('- 3'),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircleAvatar(),
              CircleAvatar(),
              CircleAvatar(),
              CircleAvatar(),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
