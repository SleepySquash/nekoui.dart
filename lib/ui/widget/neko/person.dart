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

import '/domain/service/neko.dart';

class NekoPerson extends StatefulWidget {
  const NekoPerson(this._nekoService, {Key? key}) : super(key: key);

  final NekoService _nekoService;

  @override
  State<NekoPerson> createState() => _NekoPersonState();
}

class _NekoPersonState extends State<NekoPerson> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        Image.asset(
          'assets/images/neko/person.png',
          filterQuality: FilterQuality.high,
          isAntiAlias: true,
          fit: BoxFit.fitHeight,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print('mur');
              },
              child: const MouseRegion(
                opaque: false,
                cursor: SystemMouseCursors.grab,
                hitTestBehavior: HitTestBehavior.translucent,
                child: SizedBox(
                  width: 140,
                  height: 100,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
