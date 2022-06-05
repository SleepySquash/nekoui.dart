import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MapController extends GetxController {}

class Location {
  const Location(this.id, {this.icon, this.onTap});

  final String id;
  final IconData? icon;
  final void Function()? onTap;
}
