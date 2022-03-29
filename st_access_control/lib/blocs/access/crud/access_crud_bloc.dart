import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:st_common/st_ac.dart';
import '../../event/crud/event_crud_bloc.dart';

part 'access_crud_event.dart';
part 'access_crud_state.dart';

class AccessCrudBloc extends Bloc<AccessCrudEvent, AccessCrudState> {
  final AccessControlRepository accessControlRepository;
  final EventCrudBloc eventCrudBloc;

  AccessCrudBloc({@required this.accessControlRepository, @required this.eventCrudBloc}) : super(AccessCrudInitial());

  @override
  Stream<AccessCrudState> mapEventToState(AccessCrudEvent event) async* {
    if (event is AccessCrudRegister) {
      yield* _mapRegisterAccess(event.ticketAccessId, event.qty, event.note);
    } else if (event is AccessCrudLock) {
      yield* _mapLockAccess(event.ticketAccessId, event.note);
    } else if (event is AccessCrudUnlock) {
      yield* _mapUnlockAccess(event.ticketAccessId, event.note);
    }
  }

  Stream<AccessCrudState> _mapRegisterAccess(String ticketAccessId, int qty, String note) async* {
    yield AccessCrudInProgress();
    try {
      final result = await accessControlRepository.registerAccess(ticketAccessId, qty, note);
      eventCrudBloc.add(EventCrudRefresh());
      yield AccessCrudSuccess(access: result, on: CrudOn.CREATE);
    } catch (e) {
      yield e is ErrorModel
          ? AccessCrudFailure(error: e.getMessage(), on: CrudOn.CREATE)
          : AccessCrudFailure(error: e.toString(), on: CrudOn.CREATE);
    }
  }

  Stream<AccessCrudState> _mapLockAccess(String ticketAccessId, String note) async* {
    yield AccessCrudInProgress();
    try {
      final result = await accessControlRepository.lockAccess(ticketAccessId, note);
      yield AccessCrudSuccess(access: result, on: CrudOn.READ);
      eventCrudBloc.add(EventCrudRefresh());
    } catch (e) {
      yield e is ErrorModel
          ? AccessCrudFailure(error: e.getMessage(), on: CrudOn.READ)
          : AccessCrudFailure(error: e.toString(), on: CrudOn.READ);
    }
  }

  Stream<AccessCrudState> _mapUnlockAccess(String ticketAccessId, String note) async* {
    yield AccessCrudInProgress();
    try {
      final result = await accessControlRepository.unlockAccess(ticketAccessId, note);
      yield AccessCrudSuccess(access: result, on: CrudOn.UPDATE);
      eventCrudBloc.add(EventCrudRefresh());
    } catch (e) {
      yield e is ErrorModel
          ? AccessCrudFailure(error: e.getMessage(), on: CrudOn.UPDATE)
          : AccessCrudFailure(error: e.toString(), on: CrudOn.UPDATE);
    }
  }
}
