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

import 'package:get/get.dart';

import '../model/credentials.dart';
import '/provider/hive/session.dart';
import '/router.dart';

/// Authentication service exposing [credentials] of the authenticated session.
class AuthService extends GetxService {
  AuthService(this._sessionProvider);

  /// Authorization status.
  ///
  /// Can be:
  /// - `status.isEmpty` meaning that `MyUser` is unauthorized;
  /// - `status.isLoading` meaning that authorization data is being fetched
  ///   from storage;
  /// - `status.isLoadingMore` meaning that `MyUser` is authorized according to
  ///   the storage, but network request to the server is still in-flight;
  /// - `status.isSuccess` meaning successful authorization.
  final Rx<RxStatus> status = Rx<RxStatus>(RxStatus.loading());

  /// [Credentials] of this [AuthService].
  final Rx<Credentials?> credentials = Rx(null);

  /// [SessionHiveProvider] storing the [Credentials].
  final SessionHiveProvider _sessionProvider;

  /// Initializes this service.
  ///
  /// Tries to load user data from the storage and navigates to the
  /// [Routes.auth] page if this operation fails. Otherwise, fetches user data
  /// from the server to be up-to-date with it.
  Future<String?> init() async {
    Credentials? creds = _sessionProvider.getCredentials();

    if (creds != null) {
      _authorized(creds);
      status.value = RxStatus.success();
      return null;
    }

    return _unauthorized();
  }

  /// Creates a new [Credentials].
  Future<void> register() async {
    status.value = RxStatus.loading();
    try {
      Credentials creds = Credentials();
      _authorized(creds);
      _sessionProvider.setCredentials(creds);
      status.value = RxStatus.success();
    } catch (e) {
      _unauthorized();
      rethrow;
    }
  }

  /// Creates a new [Credentials].
  Future<void> signIn() async {
    status.value = RxStatus.loading();
    try {
      Credentials creds = Credentials();
      _authorized(creds);
      _sessionProvider.setCredentials(creds);
      status.value = RxStatus.success();
    } catch (e) {
      _unauthorized();
      rethrow;
    }
  }

  /// Deletes the [Credentials].
  Future<String> logout() async {
    status.value = RxStatus.loading();
    return _unauthorized();
  }

  /// Sets authorized [status] to `isLoadingMore` (aka "partly authorized").
  void _authorized(Credentials creds) {
    credentials.value = creds;
    status.value = RxStatus.loadingMore();
  }

  /// Sets authorized [status] to `isEmpty` (aka "unauthorized").
  String _unauthorized() {
    _sessionProvider.clear();
    credentials.value = null;
    status.value = RxStatus.empty();
    return Routes.auth;
  }
}
