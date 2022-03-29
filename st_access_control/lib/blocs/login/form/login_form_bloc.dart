import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:st_common/st_ac.dart';

part 'login_form_event.dart';
part 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {

  LoginFormBloc({
    AuthenticationModel authentication : const AuthenticationModel.newModel(),
  }) : super(LoginFormState.initial(authentication));

  @override
  Stream<LoginFormState> mapEventToState(LoginFormEvent event) async* {
    if(event is LoginFormLoadLists) {
      yield* _mapLoadAllLists();
    } else if(event is LoginFormUpdateData){
      yield* _mapUpdateData(event.typeData, event.value);
    }else if(event is LoginFormValidate){
      yield* _validate();
    }
  }

  Stream<LoginFormState> _mapLoadAllLists() async* {
    try {
      // final result = await repo.fetchAllList();
      // yield state.copyWith(list: result);
    } catch (e) {
      yield state.copyWith(status: MyFormStatus.FORM_LOAD_INITIAL_FAILED);
    }
  }

  Stream<LoginFormState> _mapUpdateData(LoginFormData typeData, dynamic value) async* {
  var _authentication = state.authentication;
    switch (typeData) {
      case LoginFormData.STATUS:
        yield state.copyWith(status: value);
        return;
      case LoginFormData.SHOW_PASSWORD:
        yield state.copyWith(showPassword: value);
        return;
      case LoginFormData.USERNAME:
        _authentication = _authentication.copyWith(username: value);
        break;
      case LoginFormData.PASSWORD:
        _authentication = _authentication.copyWith(password: value);
        break;
    }

    yield state.copyWith(authentication: _authentication);
  }

  Stream<LoginFormState> _validate() async* {
    List<String> _errors = [];

    if (state.isValidUsername != null) {
      _errors.add('- ${state.isValidUsername}');
    }

    if (state.isValidPassword != null) {
      _errors.add('- ${state.isValidPassword}');
    }

    if (_errors.isEmpty) {
      yield state.copyWith(status: MyFormStatus.FORM_SUCCESS);
    }else {
      yield state.copyWith(status: MyFormStatus.FORM_FAILURE);
    }
  }
}
