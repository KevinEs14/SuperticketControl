import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:st_common/st_ac.dart';

part 'access_form_event.dart';
part 'access_form_state.dart';

class AccessFormBloc extends Bloc<AccessFormEvent, AccessFormState> {

  AccessFormBloc({
    @required TicketAccessModel ticketAccess,
  }) : super(AccessFormState.initial(ticketAccess));

  @override
  Stream<AccessFormState> mapEventToState(AccessFormEvent event) async* {
    if(event is AccessFormUpdateData){
      yield* _mapUpdateData(event.typeData, event.value);
    }else if(event is AccessFormValidate){
      yield* _validate();
    } else if (event is AccessFormValidateLock){
      yield* _validateLock();
    } else if (event is AccessFormValidateUnlock){
      yield* _validateUnlock();
    }
  }

  Stream<AccessFormState> _mapUpdateData(AccessFormData typeData, dynamic value) async* {
  var _ticketAccess = state.ticketAccess;
    switch (typeData) {
      case AccessFormData.STATUS:
        yield state.copyWith(status: value);
        return;
      case AccessFormData.QUANTITY:
        yield state.copyWith(quantity: value);
        return;
      case AccessFormData.NOTE:
      _ticketAccess = _ticketAccess.copyWith(note: value);
        break;
    }

    yield state.copyWith(ticketAccess: _ticketAccess);
  }

  Stream<AccessFormState> _validate() async* {
    List<String> _errors = [];

    if (state.isValidQuantity  != null) {
      _errors.add('- ${state.isValidQuantity}');
    }

    if (_errors.isEmpty) {
      yield state.copyWith(status: MyFormStatus.FORM_SUCCESS, accessAction: AccessAction.REGISTER_ACCESS);
    }else {
      yield state.copyWith(status: MyFormStatus.FORM_FAILURE, accessAction: AccessAction.REGISTER_ACCESS);
    }
  }

  Stream<AccessFormState> _validateLock() async* {
    List<String> _errors = [];

    if (state.isValidNote != null) {
      _errors.add('- ${state.isValidNote}');
    }

    if (_errors.isEmpty) {
      yield state.copyWith(status: MyFormStatus.FORM_SUCCESS, accessAction: AccessAction.LOCK);
    } else {
      yield state.copyWith(status: MyFormStatus.FORM_FAILURE, accessAction: AccessAction.LOCK);
    }
  }

  Stream<AccessFormState> _validateUnlock() async* {
    List<String> _errors = [];

    if (state.isValidNote != null) {
      _errors.add('- ${state.isValidNote}');
    }

    if (_errors.isEmpty) {
      yield state.copyWith(status: MyFormStatus.FORM_SUCCESS, accessAction: AccessAction.UNLOCK);
    } else {
      yield state.copyWith(status: MyFormStatus.FORM_FAILURE, accessAction: AccessAction.UNLOCK);
    }
  }
}
