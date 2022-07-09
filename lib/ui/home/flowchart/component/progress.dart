// Copyright © 2022 NIKITA ISAENKO, <https://github.com/SleepySquash>
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License v3.0 as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License v3.0 for
// more details.
//
// You should have received a copy of the GNU Affero General Public License v3.0
// along with this program. If not, see
// <https://www.gnu.org/licenses/agpl-3.0.html>.

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
