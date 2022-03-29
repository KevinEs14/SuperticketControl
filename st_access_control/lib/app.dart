import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:st_common/st_ac.dart';

import 'blocs/blocs.dart';
import 'ui/screens/scanner/scanner_screen.dart';
import 'ui/screens/screens.dart';
import 'ui/values/values.dart';

final ThemeData _theme = buildTheme();

class App extends StatefulWidget {
  final String initialPage;

  const App({Key key, @required this.initialPage}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  EventCrudBloc _eventDetailBloc;

  @override
  void initState() {
    super.initState();
    _eventDetailBloc = EventCrudBloc(ticketRepository: RepositoryProvider.of<TicketRepository>(context));
  }

  @override
  void dispose() {
    _eventDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      theme: _theme,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es'),
      ],
      navigatorKey: _navigatorKey,
      initialRoute: widget.initialPage,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatusEnum.unauthenticated:
                _navigator.pushNamedAndRemoveUntil<void>(Routes.login, (route) => false);
                break;
              case AuthenticationStatusEnum.authenticated:
                _navigator.pushNamedAndRemoveUntil<void>(Routes.home, (route) => false);
                break;
              default:
                _navigator.pushNamedAndRemoveUntil<void>(Routes.login, (route) => false);
                break;
            }
          },
          child: child,
        );
      },
      routes: {
        Routes.login: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<LoginFormBloc>(
                  create: (context) => LoginFormBloc(),
                ),
                BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(
                    authenticationRepository: RepositoryProvider.of<AuthRepository>(context),
                  ),
                ),
              ],
              child: LoginScreen(),
            ),
        Routes.home: (context) => BlocProvider<EventsBloc>(
          create: (context) => EventsBloc(eventACRepository: RepositoryProvider.of<EventACRepository>(context))..add(EventsLoadAll()),
          child: HomeScreen(),
        ),
        Routes.eventDetail: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<EventCrudBloc>.value(value: _eventDetailBloc),
            BlocProvider<EventTicketsBloc>(
              create: (context) => EventTicketsBloc(ticketRepository: RepositoryProvider.of<TicketRepository>(context)),
            ),
          ],
          child: EventDetailScreen(event: ModalRoute.of(context).settings.arguments),
        ),
        Routes.tickets: (context) => BlocProvider<TicketsBloc>(
          create: (context) => TicketsBloc(ticketRepository: RepositoryProvider.of<TicketRepository>(context)),
          child: BlocProvider<TicketsFilterBloc>(
            create: (context) => TicketsFilterBloc(ticketsBloc: BlocProvider.of<TicketsBloc>(context)),
            child: TicketsScreen(filter: ModalRoute.of(context).settings.arguments),
          ),
        ),
        Routes.ticket: (context) => TicketScreen(ticket:  ModalRoute.of(context).settings.arguments, eventCrudBloc: _eventDetailBloc),
        Routes.scanner: (context) => BlocProvider(
          create: (context)=>EventTicketsBloc(ticketRepository: RepositoryProvider.of<TicketRepository>(context),accessControlRepository:RepositoryProvider.of<AccessControlRepository>(context)),
          child: ScannerScreen(eventId:  ModalRoute.of(context).settings.arguments, ),
        ),
      },
    );
  }
}
