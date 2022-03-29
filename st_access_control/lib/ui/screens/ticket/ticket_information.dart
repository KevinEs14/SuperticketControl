import 'package:flutter/material.dart';
import 'package:st_common/st_ac.dart';

import '../../values/values.dart';
import 'ticket_vertical_border.dart';
import '../../helpers/extensions/ticket_extension.dart';

class TicketInformation extends StatelessWidget {
  final TicketModel ticket;

  const TicketInformation({Key key, @required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _accessTotal = ticket.access?.accessQuantity ?? 0;
    final _accessed = ticket.access?.accesses?.length ?? 0;

    List<Widget> _childTop = [
      Padding(
        padding: const EdgeInsets.only(bottom: Dimens.small),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Text(
              ticket.code ?? '-',
              style: Styles.titleDetailSmallTextSecondary,
              textAlign: TextAlign.end,
            ),
            SizedBox(width: Dimens.xSmall),
            ticket.access.state.toEnum?.icon ?? SizedBox.shrink(),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: Dimens.normal),
        child: Text(ticket.ticketBook?.name ?? '-', style: Styles.textDetailLarge),
      ),
      Padding(
        padding: const EdgeInsets.only(left: Dimens.normal, bottom: Dimens.normal,),
        child: Text(ticket.ticketBook?.type?.name ?? '-', style: Styles.subtitleToList),
      ),
    ];

    if (ticket.access?.note != null && ticket.access.note.isNotEmpty) {
      _childTop.add(Container(
        padding: const EdgeInsets.all(Dimens.small),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, Dimens.normal),
        color: Colors.amber[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nota', style: Styles.titleToForm),
            Text('${ticket.access.note ?? '-'}', style: Styles.titleDetailSmallText),
          ],
        ),
      ));
    }

    _childTop.add(_row(
      Strings.accessCode,
      ticket.access?.accessCode,
      Strings.accessStatus,
      ticket.access?.state?.value,
    ));

    _childTop.add(_row(
      Strings.quantity,
      '${_accessTotal ?? '-'}',
      Strings.currentAccesses,
      '${_accessTotal - _accessed ?? '-'}',
    ));

    if (ticket.access?.accesses != null && ticket.access.accesses.isNotEmpty) {
      _childTop.add(Text('Accesos registrados' ?? '-', style: Styles.titleDetailSmallTextSecondary));
      for (AccessModel access in ticket.access.accesses) {
        _childTop.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(stringToFormatDateTime(access.date, DateTimeFormatEnum.ABBR_MONTH_DAY_YEAR, true, '-') ?? '-', style: Styles.titleDetailSmallText),
            Expanded(child: Text('${access.attendedBy?.firstName ?? '-'} ${access.attendedBy?.lastName ?? ''}', style: Styles.trailingToList, textAlign: TextAlign.end,)),
          ],
        ));
      }
      _childTop.add(SizedBox(height: Dimens.small));
    }

    _childTop.addAll([
      Padding(
        padding: const EdgeInsets.only(bottom: Dimens.small),
        child: Divider(),
      ),
      // _row(
      //   Strings.ticketCode,
      //   ticket.code,
      //   Strings.ticketStatus,
      //   ticket.status?.name,
      // ),
      Padding(
        padding: EdgeInsets.only(bottom: Dimens.normal),
        child: _info(Strings.ticketStatus, ticket.status?.name),
      ),
      _row(
          Strings.sector,
          ticket.sector?.name,
          Strings.seat,
          ticket.seat?.alias,
          Dimens.xSmall
      ),
    ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(Dimens.xLarge, Dimens.normal, Dimens.xLarge, 0),
          padding: EdgeInsets.fromLTRB(Dimens.large, Dimens.large, Dimens.large, Dimens.medium),
          decoration: new ShapeDecoration(
            color: ticket.access.state.toEnum?.colorCard,
            shape: TicketTopVerticalBorder(
              radius: Dimens.little,
            ),
            // side: new BorderSide(color: Colors.white)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _childTop,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(Dimens.xLarge, 0, Dimens.xLarge, Dimens.normal),
          padding: EdgeInsets.fromLTRB(Dimens.little, 0, Dimens.little, Dimens.normal),
          decoration: new ShapeDecoration(
            color: ticket.access.state.toEnum?.colorCard,
            shape: TicketBottomVerticalBorder(
              radius: Dimens.little,
            ),
            // side: new BorderSide(color: Colors.white)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Divider(height: 1,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: List.generate(40, (_) {
                    return SizedBox(
                      width: 4,
                      height: 0.5,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.grey),
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(Dimens.normal, Dimens.medium, Dimens.normal, Dimens.normal),
                child: _info(Strings.fullName, ticket.access?.owner?.firstName),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(Dimens.normal, 0, Dimens.normal, Dimens.normal),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: _info(Strings.documentNumber, ticket.access?.owner?.documentNumber)),
                    Expanded(flex: 1, child: _info(Strings.email, ticket.access?.owner?.email)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _info(String title, String text){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? '-', style: Styles.titleDetailSmallTextSecondary),
        Text(text ?? '-', style: Styles.titleToList.copyWith(fontSize: 15)),
      ],
    );
  }

  Padding _row(String title1, String text1, String title2, String text2, [double bottomPadding = Dimens.normal]){
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        children: [
          Expanded(flex: 1, child: _info(title1, text1)),
          Expanded(flex: 1, child: _info(title2, text2)),
        ],
      ),
    );
  }
}
