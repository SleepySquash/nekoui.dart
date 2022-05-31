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
