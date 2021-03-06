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

import '/theme.dart';
import 'conditional_backdrop.dart';

class BackdropIconButton extends StatelessWidget {
  const BackdropIconButton({
    Key? key,
    this.onTap,
    this.icon,
    this.color,
    this.text,
  }) : super(key: key);

  final VoidCallback? onTap;
  final IconData? icon;
  final Color? color;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return text != null
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              boxShadow: const [
                CustomBoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 8,
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: ConditionalBackdropFilter(
              borderRadius: BorderRadius.circular(60),
              child: Material(
                color: color ?? const Color(0x66000000),
                child: InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          text!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          icon,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                CustomBoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 8,
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: ConditionalBackdropFilter(
              borderRadius: BorderRadius.circular(60),
              child: FloatingActionButton(
                onPressed: onTap,
                elevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                backgroundColor: color ?? const Color(0x66000000),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          );
  }
}

class BackdropBubble extends StatelessWidget {
  const BackdropBubble({
    Key? key,
    this.icon,
    this.color,
    required this.text,
    this.onTap,
  }) : super(key: key);

  final Icon? icon;
  final Color? color;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          CustomBoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: ConditionalBackdropFilter(
        borderRadius: BorderRadius.circular(40),
        child: Material(
          borderRadius: BorderRadius.circular(40),
          color: const Color(0xA0FFFFFF),
          elevation: 0,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(40),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 18,
                        color: onTap == null
                            ? Colors.grey
                            : const Color(0xFF3971FF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
