import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:st_common/st_ac.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/event/list/events_bloc.dart';
import '../../values/values.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/common/failure_view.dart';
import '../../widgets/common/circle_progress.dart';
import 'event_item_row.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<void> _refreshCompleter;
  List<EventModel> _events;
  UserModel _user;
  
  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _user = BlocProvider.of<AuthenticationBloc>(context).state.user;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: SvgPicture.asset(
            Assets.svgLogoAbbr,
            fit: BoxFit.contain,
          ),
        ),
        titleSpacing: Dimens.small,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Strings.accessControl, style: TextStyle(fontSize: 19, letterSpacing: -0.4)),
            Text('${_user.firstName} ${_user.lastName}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: Strings.logout,
              icon: Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLogoutRequested());
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<EventsBloc>(context).add(EventsRefresh());
          return _refreshCompleter.future;
        },
        child: BlocConsumer<EventsBloc, EventsState>(
          listener: (context, state){
            if (state is EventsLoadedSuccess || state is EventsLoadedFailure) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, state) {
            if(state is EventsLoadedFailure){
              return FailureView(
                error: state.error,
                onPressed: () {
                  BlocProvider.of<EventsBloc>(context).add(EventsRefresh());
                },
              );
            }

            if (state is EventsLoadedSuccess) {
              _events = state.events;
            }

            if (state is EventsLoadInProgress && (_events == null || _events.isEmpty)) {
              return CircleProgress();
            }

            if(_events != null) {
              if(_events.isEmpty) {
                return EmptyView(
                  isSearch: false,
                  onPressed: (){
                    BlocProvider.of<EventsBloc>(context).add(EventsRefresh());
                  },
                );
              }

              return ListView.builder(
                // padding: const EdgeInsets.fromLTRB(Dimens.small, Dimens.small, Dimens.small, Dimens.xxLarge),
                itemCount: _events.length,
                itemBuilder: (context, index) => EventItemRow(
                  event: _events[index],
                  onTap: () async {
                    final _result = await Navigator.of(context).pushNamed(Routes.eventDetail, arguments: _events[index]);

                    if (_result != null && _result is bool){
                      BlocProvider.of<EventsBloc>(context).add(EventsLoadAll());
                    }
                  },
                ),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}