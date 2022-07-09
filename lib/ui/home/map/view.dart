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
import 'package:get/get.dart';

import '/router.dart';
import '/ui/widget/escape_popper.dart';
import 'controller.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EscapePopper(
      child: GetBuilder(
        init: MapController(),
        builder: (MapController c) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                Location(
                  'home',
                  icon: Icons.home,
                  onTap: router.home,
                ),
                Location(
                  'grocery',
                  icon: Icons.local_grocery_store,
                  onTap: router.grocery,
                ),
                const Location(
                  'restaurant',
                  icon: Icons.restaurant,
                  onTap: null,
                ),
                const Location(
                  'shopkeeper',
                  icon: Icons.shop,
                  onTap: null,
                ),
                const Location(
                  'job',
                  icon: Icons.shop,
                  onTap: null,
                ),
                Location(
                  'park',
                  icon: Icons.park,
                  onTap: router.park,
                ),
                const Location(
                  'neko_science',
                  icon: Icons.science_rounded,
                  onTap: null,
                ),
                const Location(
                  'church',
                  icon: Icons.church,
                  onTap: null,
                ),
                const Location(
                  'monastery',
                  icon: Icons.church_outlined,
                  onTap: null,
                ),
                const Location(
                  'school',
                  icon: Icons.school_outlined,
                  onTap: null,
                ),
                const Location(
                  'university',
                  icon: Icons.school,
                  onTap: null,
                ),
                const Location(
                  'hospital',
                  icon: Icons.local_hospital,
                  onTap: null,
                ),
                Location(
                  'guild',
                  icon: Icons.biotech,
                  onTap: router.guild,
                ),
              ]
                  .map(
                    (e) => ListTile(
                      leading: Icon(e.icon),
                      title: Text(e.id),
                      enabled: e.onTap != null,
                      onTap: () {
                        e.onTap?.call();
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                  .toList(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: Navigator.of(context).pop,
              child: const Icon(Icons.close),
            ),
          );
        },
      ),
    );
  }
}
