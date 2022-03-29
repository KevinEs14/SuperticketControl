import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_common/st_ac.dart';

import 'app.dart';
import 'src/client/cert.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'src/local/prefs_sec.dart';
import 'ui/values/routes.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    if (SHOW_DETAIL_LOGS || SHOW_MIN_LOGS) {
      printWrapped('🡢 $event');
    }
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (SHOW_DETAIL_LOGS || SHOW_MIN_LOGS) {
      printWrapped('⚫ ${transition.nextState}');
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stacktrace) {
    if (SHOW_DETAIL_LOGS || SHOW_MIN_LOGS) {
      print(error);
    }
    super.onError(cubit, error, stacktrace);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  final _apiClient = ApiClient.instance;
  _apiClient.addSelfSignedCertificate(certificate);

  //
  //  Api provider
  //
  final _authClient = AuthClient(apiClient: _apiClient);
  final _eventClient = EventClient(apiClient: _apiClient);
  final _ticketClient = TicketClient(apiClient: _apiClient);
  final _accessControlClient = AccessControlClient(apiClient: _apiClient);

  //
  //  Repositories
  //
  final _authRepository = AuthRepository(authClient: _authClient);
  final _eventRepository = EventACRepository(eventClient: _eventClient);
  final _ticketRepository = TicketRepository(ticketClient: _ticketClient);
  final _accessControlRepository = AccessControlRepository(accessControlClient: _accessControlClient);


  final _token = await prefsSec.userToken();
  final _user = await prefsSec.user();

  String _initialPage;
  if (_token != null && _user != null) {
    _apiClient.updateToken(_token);
    _initialPage = Routes.home;
  } else {
    _initialPage = Routes.login;
  }

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthRepository>(create: (context) => _authRepository),
      RepositoryProvider<EventACRepository>(create: (context) => _eventRepository),
      RepositoryProvider<TicketRepository>(create: (context) => _ticketRepository),
      RepositoryProvider<AccessControlRepository>(create: (context) => _accessControlRepository),
    ],
    child: BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(
          apiClient: _apiClient,
          authenticationRepository: _authRepository,
          state: _token == null
              ? AuthenticationState.unauthenticated()
              : AuthenticationState.authenticated(_user)
        );
      },
      child: App(initialPage: _initialPage),
    ),
  ));
}
