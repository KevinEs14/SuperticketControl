import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:st_common/st_ac.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authenticationRepository;

  LoginBloc({@required AuthRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield* _mapLoginSubmittedToState(event.authentication);
    }
  }

  Stream<LoginState> _mapLoginSubmittedToState(AuthenticationModel authentication) async* {
    yield LoginInProgress();
    try {
      await _authenticationRepository.logIn(authentication);
      yield LoginSuccess();
    } catch (error) {
      yield error is ErrorModel
          ? LoginFailure(error: error.getMessage())
          : LoginFailure(error: error.toString());
    }
  }
}
