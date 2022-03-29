import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_common/st_ac.dart';

import '../../../blocs/access/form/access_form_bloc.dart';
import '../../../blocs/access/crud/access_crud_bloc.dart';
import '../../../blocs/event/crud/event_crud_bloc.dart';
import '../../helpers/hex_color.dart';
import '../../values/values.dart';
import 'ticket_access.dart';
import 'ticket_information.dart';

class TicketScreen extends StatelessWidget {
  final TicketModel ticket;
  final EventCrudBloc eventCrudBloc;

  const TicketScreen({Key key, @required this.ticket, @required this.eventCrudBloc,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _bgColor = HexColor(ticket?.ticketBook?.color) ?? colorSecondary;

    final _accessTotal = ticket.access?.accessQuantity ?? 0;
    final _accessed = ticket.access?.accesses?.length ?? 0;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: colorOnPrimary, //change your color here
        ),
        title: Text("Ticket", style: TextStyle(color: colorOnPrimary)),
        elevation: 0,
        backgroundColor: _bgColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: TicketInformation(ticket: ticket),
            ),
          ),
          _accessTotal - _accessed > 0
              ? MultiBlocProvider(
                  providers: [
                    BlocProvider<AccessCrudBloc>(
                      create: (context) => AccessCrudBloc(
                        accessControlRepository: RepositoryProvider.of<AccessControlRepository>(context),
                        eventCrudBloc: eventCrudBloc,
                      ),
                    ),
                    BlocProvider<AccessFormBloc>(
                      create: (context) => AccessFormBloc(ticketAccess: ticket.access.copyWith(note: '')),
                    ),
                  ],
            child: TicketAccess(
                    accessesAvailable: _accessTotal - _accessed,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
