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

import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '/config.dart';
import '/domain/disposable_service.dart';
import '/domain/repository/flag.dart';
import '/util/message_popup.dart';
import '/util/platform_utils.dart';

enum Weather {
  clear,
  clouds,
  drizzle,
  fog,
  rain,
  snow,
  thunderstorm,
  unknown,
}

class EnvironmentService extends DisposableService {
  EnvironmentService(this._flagRepository);

  static const Duration refreshInterval = Duration(minutes: 4);

  final Rx<Weather> weather = Rx(Weather.clouds);
  late final RxDouble temperature;

  final AbstractFlagRepository _flagRepository;

  late final Position? _position;
  Timer? _timer;

  @override
  void onInit() {
    DateTime now = DateTime.now();

    switch (now.month) {
      case 1:
        temperature = RxDouble(-12);
        break;

      case 2:
        temperature = RxDouble(-20);
        break;

      case 3:
        temperature = RxDouble(-4);
        break;

      case 4:
        temperature = RxDouble(3);
        break;

      case 5:
        temperature = RxDouble(10);
        break;

      case 6:
        temperature = RxDouble(20);
        break;

      case 7:
        temperature = RxDouble(29);
        break;

      case 8:
        temperature = RxDouble(26);
        break;

      case 9:
        temperature = RxDouble(18);
        break;

      case 10:
        temperature = RxDouble(6);
        break;

      case 11:
        temperature = RxDouble(3);
        break;

      default:
        temperature = RxDouble(-13);
        break;
    }

    _initEnvironment();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> _initEnvironment() async {
    try {
      if (Config.openWeatherKey != '') {
        LocationPermission permission;

        if (_flagRepository.get(Flags.geolocationAsked) != true) {
          await MessagePopup.message('Геопозиция',
              description:
                  'NekoUI использует геопозицию исключительно для определения погоды и температуры рядышком!! Если не разрешить, то будет использован Санкт-Петербург, воть.');
          permission = await Geolocator.requestPermission();
          if (permission != LocationPermission.denied &&
              permission != LocationPermission.deniedForever &&
              permission != LocationPermission.unableToDetermine) {
            // TODO: Geolocator.getLastKnownPosition(), but no Web
            await Future.delayed(2.seconds);
          }

          _flagRepository.set(Flags.geolocationAsked, true);
        }

        try {
          // TODO: https://github.com/Baseflow/flutter-geolocator/issues/1015
          if (PlatformUtils.isAndroid) {
            _position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best,
            );
          } else {
            _position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.lowest,
            );
          }
        } catch (_) {
          _position = null;
        }

        _fetch();
        _timer = Timer.periodic(refreshInterval, (_) => _fetch());
      }
    } catch (_) {
      weather.value = Weather.unknown;
    }
  }

  void _fetch() async {
    try {
      if (Config.openWeatherKey != '') {
        String url =
            'https://api.openweathermap.org/data/2.5/weather?appid=${Config.openWeatherKey}&units=metric';
        if (_position == null) {
          url = '$url&q=Petersburg';
        } else {
          url = '$url&lat=${_position!.latitude}&lon=${_position!.longitude}';
        }

        http.Response response = await http.get(Uri.parse(url));
        Map<String, dynamic> result = json.decode(response.body);

        // int pressure = result['main']['pressure']; // hPa
        // int humidity = result['main']['humidity']; // %

        temperature.value = result['main']['feels_like'];

        int condition = result['weather'][0]['id'];
        if (condition < 300) {
          weather.value = Weather.thunderstorm;
        } else if (condition < 400) {
          weather.value = Weather.drizzle;
        } else if (condition < 600) {
          weather.value = Weather.rain;
        } else if (condition < 700) {
          weather.value = Weather.snow;
        } else if (condition < 800) {
          weather.value = Weather.fog;
        } else if (condition == 800) {
          weather.value = Weather.clear;
        } else if (condition <= 804) {
          weather.value = Weather.clouds;
        } else {
          weather.value = Weather.unknown;
        }
      }
    } catch (_) {
      weather.value = Weather.unknown;
    }
  }
}
