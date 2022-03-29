import 'package:flutter/material.dart';
import 'package:st_common/st_ac.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../blocs/authentication/authentication_bloc.dart';
import '../../values/values.dart';
import '../../../blocs/ticket/filter/ticket_filter_model.dart';
import '../../../blocs/event/scanner/event_tickets_bloc.dart';
import '../../../blocs/event/crud/event_crud_bloc.dart';
import '../../widgets/common/failure_view.dart';
import '../../widgets/common/circle_progress.dart';
import '../../widgets/common/snack_bars.dart';
import 'image_header.dart';
import '../../helpers/hex_color.dart';
import '../../widgets/my_alert_dialog.dart';
// import '../../widgets/fab_speed_dial.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;

  // final List<SpeedDialModel> buttonsFab = [
  //   SpeedDialModel(icon: StAccessControl.ticket, route: Routes.searchTicket),
  //   SpeedDialModel(icon: StAccessControl.id_card, route: Routes.searchTicket),
  //   SpeedDialModel(icon: StAccessControl.ic_barcode_scan, route: Routes.searchTicket),
  // ];

  EventDetailScreen({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // UserModel _user = BlocProvider.of<AuthenticationBloc>(context).state.user;

    if(BlocProvider.of<EventCrudBloc>(context).state is! EventCrudInitial){
      BlocProvider.of<EventCrudBloc>(context).add(EventCrudInitialize());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        toolbarHeight: 48,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Dimens.xLarge, Dimens.normal, Dimens.medium, Dimens.medium),
              child: Text(event.name ?? '-', style: Styles.t31w7TS),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: Dimens.normal),
              child: ImageHeader(image: event.imageDetailUrl, info: _infoEvent()),
            ),
            BlocBuilder<EventCrudBloc, EventCrudState>(
              builder: (context, state) {
                if(state is EventCrudInitial) {
                  BlocProvider.of<EventCrudBloc>(context).add(EventCrudReadTotalTickets(eventId: event.id));
                  return CircleProgress();
                }

                if (state is EventCrudFailure) {
                  return FailureView(
                    error: state.error,
                    onPressed: (){
                      BlocProvider.of<EventCrudBloc>(context).add(EventCrudReadTotalTickets(eventId: event.id));
                    },
                  );
                }

                if (state is EventCrudSuccess) {
                  List<Widget> _children = [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          Dimens.medium, 0, Dimens.medium, 0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: _infoTickets(
                                  title: 'Total Tickets',
                                  description: '${state.totalTickets ?? '-'}',
                                  color: colorSecondary)),
                          Expanded(
                              flex: 1,
                              child: _infoTickets(
                                  title: 'Total Tickets leídos',
                                  description: '${state.totalTicketsRead ?? '-'}',
                                  color: colorSuccess)),
                        ],
                      ),
                    ),
                    Divider(indent: Dimens.xxLarge,
                        endIndent: Dimens.xxLarge,
                        thickness: 0.5,
                        height: Dimens.xLarge),
                  ];

                  if (state.ticketsAccesses != null && state.ticketsAccesses.isNotEmpty) {
                    state.ticketsAccesses.forEach((element) {
                      _children.add(Padding(
                        padding: const EdgeInsets.fromLTRB(Dimens.xLarge, 0, 72, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(StAccessControl.ticket, size: 20, color: HexColor(element?.ticketBook?.color ?? colorSecondary)),
                            SizedBox(width: Dimens.small),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${element.ticketBook?.name ?? '-'}', style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5
                                  )),
                                  Text('${element.ticketBook.accessQuantity ?? '0'} acceso por ticket', style: Styles.trailingToList,),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child:RichText(
                                          text: TextSpan(
                                            style: Styles.trailingToList,
                                            children: <TextSpan>[
                                              TextSpan(text: 'Tickets: '),
                                              TextSpan(
                                                text: '${element.ticketBook.quantity ?? '-'}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: colorText,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: RichText(
                                          text: TextSpan(
                                            style: Styles.trailingToList,
                                            children: <TextSpan>[
                                              TextSpan(text: 'Leídos: '),
                                              TextSpan(
                                                text: '${element.totalAccessesRead ?? '-'}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: colorText,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                      _children.add(SizedBox(height: Dimens.medium));
                    });
                  }

                  return Column(
                    children: _children,
                  );
                }

                return CircleProgress();
              },
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: BlocConsumer<EventTicketsBloc, EventTicketsState>(
        listener: (context, state){
          if (state is EventTicketsLoadInProgress) {}

          if (state is EventTicketsLoadedFailure) {
            showErrorSnackBar(text: state.error, context: context);
          }

          if (state is EventTicketsLoadedSuccess) {
            final List<TicketModel> _tickets = state.tickets;
            if (_tickets != null && _tickets.isNotEmpty) {
              if(_tickets.length == 1){
                Navigator.of(context).pushNamed(Routes.ticket, arguments: _tickets[0]);
              } else {
                Navigator.pushNamed(context, Routes.tickets, arguments: TicketFilterModel.searchByTicket(event.id,state.accessCode));
              }
            } else {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) => MyAlertDialog(
                  iconData: StAccessControl.ticket_broken,//Icons.search_off,
                  bgColorIcon: colorError,
                  colorIcon: colorOnError,
                  title: 'Código de acceso incorrecto',
                  description: 'El ticket con código de acceso ${state.accessCode} no existe o es incorrecto.',
                ),
              );
            }
          }
        },
        builder: (context, state) {
          if(state is EventTicketsLoadInProgress){
            return CircleProgress(center: false);
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: Strings.searchByUser,
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  fillColor: colorButtonLight,
                  constraints: BoxConstraints.tightFor(
                    width: 56.0,
                    height: 56.0,
                  ),
                  child: Icon(StAccessControl.id_card),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.tickets,
                        arguments: TicketFilterModel.searchByOwner(event.id));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimens.small),
                child: Tooltip(
                  message: Strings.searchByCode,
                  child: RawMaterialButton(
                    shape: CircleBorder(),
                    fillColor: colorButtonLight,
                    constraints: BoxConstraints.tightFor(
                      width: 56.0,
                      height: 56.0,
                    ),
                    child: Icon(StAccessControl.ticket),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.tickets,
                          arguments:
                          TicketFilterModel.searchByTicket(event.id));
                    },
                  ),
                ),
              ),
              FloatingActionButton(
                tooltip: Strings.scanner,
                child: Icon(StAccessControl.ic_barcode_scan),
                onPressed: () => _scanner(context),
              ),
            ],
          );
        },
      ),
      // floatingActionButton: FabSpeedDial(
      //   list: buttonsFab,
      // ),
    );
  }

  _scanner(BuildContext context) async {
    /*String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#2F88CE",
      "Salir",
      true,
      ScanMode.DEFAULT,
    );

    if (barcodeScanRes != null && barcodeScanRes != '-1') {
      BlocProvider.of<EventTicketsBloc>(context).add(EventCrudSearchTicket(eventId: event.id, accessCode: barcodeScanRes));
    }*/
    Navigator.of(context).pushNamed(Routes.scanner, arguments: event.id);
  }

  Column _infoEvent(){
    List<Widget> _child = [];

    if (event.venue != null && event.venue.name != null) {
      // _child.add(Text(Strings.doorOpeningDate, style: Styles.titleDetailSmallTextSecondary));
      _child.add(Text('${event.venue.name ?? ''}', style:  Styles.titleDetailSmallPrimary));
      _child.add(Text('${event.venue.city?.value ?? ''}, ${event.venue.country ?? ''}', style: Styles.trailingToList));
      _child.add(SizedBox(height: Dimens.little));
    }

    _child.addAll([
      Text(Strings.startDate, style: Styles.titleDetailSmallTextSecondary),
      Text(stringToFormatDateTime(event.eventStartDate, DateTimeFormatEnum.ABBR_MONTH_DAY, true) ?? '-', style: Styles.textDetailSmall),
      SizedBox(height: Dimens.little),
      Text(Strings.endDate, style: Styles.titleDetailSmallTextSecondary),
      Text(stringToFormatDateTime(event.eventEndDate, DateTimeFormatEnum.ABBR_MONTH_DAY, true) ?? '-', style: Styles.textDetailSmall),
      SizedBox(height: Dimens.little),
      Text(Strings.doorOpeningDate, style: Styles.titleDetailSmallTextSecondary),
      Text(stringToFormatDateTime(event.doorOpeningDate, DateTimeFormatEnum.ABBR_MONTH_DAY, true) ?? '-', style: Styles.textDetailSmall),
    ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _child,
    );
  }

  Column _infoTickets({
    @required String title,
    @required String description,
    @required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title ?? '-', style: Styles.titleDetailSmallText),
        SizedBox(height: Dimens.small),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(StAccessControl.ticket, size: 20, color: color),
            SizedBox(width: Dimens.xSmall),
            Text(description ?? '-', style: Styles.textDetailLarge),
          ],
        ),
      ],
    );
  }
}
