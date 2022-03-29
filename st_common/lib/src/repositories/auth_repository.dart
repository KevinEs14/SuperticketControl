import 'dart:async';

import 'package:meta/meta.dart';

import '../client/auth_client.dart';
import '../models/authentication_model.dart';
import '../models/authentication_status.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthClient authClient;
  final _controller = StreamController<AuthenticationStatus>();

  UserModel _userCache;

  AuthRepository({@required this.authClient});

  Stream<AuthenticationStatus> get status => _controller.stream;

  Future<String> logIn(AuthenticationModel authentication) async {
    final result = await authClient.toLogin(authentication);
    if (result != null && result is String) {
      _controller.add(AuthenticationStatusAuthenticated(token: result));
    }
    return result;
  }

  // -- ACCOUNT --
  Future<UserModel> fetchAccount() async {
    try {
      final _result = await authClient.fetchAccount();
      _userCache = _result;
      return _userCache;
    } catch (e) {
      throw e;
    }
  }

  // Role getRole() {
  //   return _accountCache.role.role;
  // }

  UserModel get user => _userCache;

  void logOut() {
    _controller.add(AuthenticationStatusUnauthenticated());
  }

  void dispose() => _controller.close();
}
