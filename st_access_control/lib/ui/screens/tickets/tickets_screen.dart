import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_common/st_ac.dart';

import '../../../blocs/ticket/filter/ticket_filter_model.dart';
import '../../../blocs/ticket/filter/tickets_filter_bloc.dart';
import '../../../blocs/ticket/list/tickets_bloc.dart';
import '../../widgets/common/search_bar.dart';
import '../../widgets/common/failure_view.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/common/circle_progress.dart';
import '../../values/values.dart';
import '../../helpers/extensions/ticket_extension.dart';
import 'filter_button.dart';
import 'ticket_item_row.dart';
import 'ticket_owner_item_row.dart';

class TicketsScreen extends StatefulWidget {
  final TicketFilterModel filter;

  const TicketsScreen({Key key, @required this.filter}) : super(key: key);
  
  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  Completer<void> _refreshCompleter;

  TicketsFilterBloc _filterBloc;
  List<TicketModel> _tickets;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _filterBloc = BlocProvider.of<TicketsFilterBloc>(context);
    _filterBloc.add(TicketsFilter(filter: widget.filter));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorButtonLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorButtonLight,
        title: Text(Strings.tickets ?? '-'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.xSmall),
            child: BlocBuilder<TicketsFilterBloc, TicketsFilterState>(
              buildWhen: (previous, current) => previous.filter?.searchBy != current.filter?.searchBy,
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: SearchBar(
                        icon: Icons.search,
                        textSearch: state.filter?.searchBy?.name,
                        searchInit: widget.filter.search,
                        searchType: SearchType.ON_COMPLETE,
                        updateSearchQuery: (String newQuery) {
                          if (newQuery != _filterBloc.state.filter.search) {
                            _filterBloc.add(TicketsFilterSearch(search: newQuery));
                          }
                        },
                      ),
                    ),
                    FilterButton(
                      activeFilter: state.filter.searchBy,
                      icon: state.filter?.searchBy?.icon,
                      onSelected: (TicketSearchByEnum filter) {
                        if (_filterBloc.state.filter.searchBy != filter) {
                          _filterBloc.add(TicketsFilter(filter: _filterBloc.state.filter.copyWith(searchBy: filter)));
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                BlocProvider.of<TicketsBloc>(context).add(
                    TicketsRefresh(_filterBloc.state.filter));
                return _refreshCompleter.future;
              },
              child: BlocConsumer<TicketsBloc, TicketsState>(
                listener: (context,state){

                  if (state is TicketsLoadedSuccess) {
                    if(state.tickets != null && state.tickets.isNotEmpty &&state.tickets.length==1){
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.of(context).pushNamed(Routes.ticket, arguments: state.tickets[0]);
                    }
                  }
                },
                builder: (context, state) {
                  
                  if (state is TicketsLoadInProgress && (_tickets == null || _tickets.isEmpty)) {
                    return CircleProgress();
                  }
                  
                  if (state is TicketsLoadedFailure) {
                    return FailureView(
                      error: state.error,
                      onPressed: (){
                        BlocProvider.of<TicketsBloc>(context).add(TicketsStartedLoad(_filterBloc.state.filter));
                      },
                    );
                  }

                  if (state is TicketsLoadedSuccess) {
                    _refreshCompleter?.complete();
                    _refreshCompleter = Completer();
                    _tickets = state.tickets;

                    if (_tickets == null){
                      return EmptyView(
                        icon: Icons.search_off,
                        title: 'Sin búsqueda',
                        message: 'Ingrese una palabra de búsqueda para visualizar los tickets',
                      );
                    }

                    if (_tickets.isEmpty) {
                      final _isSearch = _filterBloc.state.filter.search != null && _filterBloc.state.filter.search.isNotEmpty;
                      return EmptyView(
                        isSearch: _isSearch,
                        onPressed: _isSearch ? null : (){
                          BlocProvider.of<TicketsBloc>(context).add(TicketsStartedLoad(_filterBloc.state.filter));
                        },
                      );
                    } 
                  }

                  if (_tickets != null && _tickets.isNotEmpty && _tickets.length>1) {
                    return ListView.builder(
                      key: Keys.ticketsList,
                      padding: const EdgeInsets.only(bottom: Dimens.large),
                      itemCount: _tickets.length,
                      itemBuilder: (context, index) {
                        switch (_filterBloc.state.filter.searchBy) {
                          case TicketSearchByEnum.ACCESS_CODE:
                            return TicketItemRow(
                              ticket: _tickets[index],
                              onTap: (){
                                FocusScope.of(context).requestFocus(FocusNode());
                                Navigator.of(context).pushNamed(Routes.ticket, arguments: _tickets[index]);
                              },
                            );
                          case TicketSearchByEnum.TICKET_OWNER:
                            return TicketOwnerItemRow(
                              ticket: _tickets[index],
                              onTap: (){
                                FocusScope.of(context).requestFocus(FocusNode());
                                Navigator.of(context).pushNamed(Routes.ticket, arguments: _tickets[index]);
                              },
                            );
                        }
                        
                        return SizedBox.shrink();
                      },
                    );
                  }
                  // else if(_tickets.length==1){
                  //   FocusScope.of(context).requestFocus(FocusNode());
                  //   Navigator.of(context).pushNamed(Routes.ticket, arguments: _tickets[0]);
                  // }
                  else
                    return SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
