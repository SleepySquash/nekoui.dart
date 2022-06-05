import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/widget/backdrop_button.dart';
import '../controller.dart';

class GroceryCheckoutView extends StatelessWidget {
  const GroceryCheckoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (GroceryController c) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Checkout'),
          ),
          body: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return c.cart.isEmpty
                      ? const Center(child: Text('Empty'))
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              ...c.cart
                                  .map(
                                    (e) => ListTile(
                                      leading: Image.asset(e.asset),
                                      title: Text(e.id),
                                      trailing: Text('${e.count}'),
                                    ),
                                  )
                                  .toList(),
                              const Divider(
                                indent: 20,
                                endIndent: 20,
                                thickness: 2,
                                height: 30,
                              ),
                              Text(
                                'Total amount is: ${c.cart.map((e) => e.count.value).fold(0, (int a, int b) => a + b)}',
                              ),
                            ],
                          ),
                        );
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Obx(() {
                  return BackdropBubble(
                    onTap: c.cart.isEmpty ? null : c.buy,
                    icon: Icons.payment,
                    text: 'Buy',
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
