import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:st_common/st_ac.dart';

import '../../src/local/prefs_sec.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final ApiClient apiClient;
  final AuthRepository _authRepository;
  
  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  AuthenticationBloc({
    @required AuthRepository authenticationRepository,
    @required this.apiClient,
    AuthenticationState state: const AuthenticationState.unauthenticated(),
  })  : assert(authenticationRepository != null),
        _authRepository = authenticationRepository,
        super(state) {
    _authenticationStatusSubscription = _authRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event.status);
    } else if (event is AuthenticationLogoutRequested) {
      _authRepository.logOut();
    }
  }
  
  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(AuthenticationStatus event) async {
    if (event is AuthenticationStatusUnauthenticated) {
      await prefsSec.clear();
      return const AuthenticationState.unauthenticated();
    } else if (event is AuthenticationStatusAuthenticated) {
      final _token = event.token;
      apiClient.updateToken(_token);
     return await _tryGetUser(_token);
    } else {
      return const AuthenticationState.unauthenticated();
    }
  }

  Future<AuthenticationState> _tryGetUser(String token) async {
    try {
      final user = await _authRepository.fetchAccount();
      await prefsSec.addUser(user);
      await prefsSec.addUserToken(token);
      return user != null
          ? AuthenticationState.authenticated(user)
          : const AuthenticationState.unauthenticated();
    } catch (e) {
      print(e);
      return const AuthenticationState.unauthenticated();
    }
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription?.cancel();
    _authRepository.dispose();
    return super.close();
  }
}
