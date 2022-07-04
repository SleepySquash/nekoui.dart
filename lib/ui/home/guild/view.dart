import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nekoui/router.dart';

import '/ui/widget/escape_popper.dart';
import 'controller.dart';

class GuildView extends StatelessWidget {
  const GuildView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EscapePopper(
      child: GetBuilder(
        init: GuildController(Get.find()),
        builder: (GuildController c) {
          return Scaffold(
            body: Row(
              children: [
                Flexible(
                  child: Image.asset(
                    'assets/character/demon.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: const [
                      Text('Commission Guild'),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: router.map,
              child: const Icon(Icons.map),
            ),
          );
        },
      ),
    );
  }
}
