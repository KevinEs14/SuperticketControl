import 'package:flutter/material.dart';
import 'package:st_common/st_ac.dart';

import '../../values/values.dart';
import '../../helpers/hex_color.dart';
import '../../helpers/extensions/ticket_extension.dart';

class TicketItemRow extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;

  static const _borderRadius = BorderRadius.only(
    topRight: Radius.circular(Dimens.normal),
    bottomRight: Radius.circular(Dimens.normal),
  );

  const TicketItemRow({
    Key key,
    @required this.ticket,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _accessQty = ticket.access?.accessQuantity ?? 0;
    final _accessCurrent = ticket.access?.accesses?.length ?? 0;

    final _colorCard = ticket.access?.state?.toEnum?.colorCard ?? Colors.blueGrey[100];

    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimens.normal, Dimens.small, 0, Dimens.small),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.small),
                  bottomLeft: Radius.circular(Dimens.small),
                ),
              ),
              child: Container(
                width: Dimens.small,
                color: HexColor(ticket.ticketBook?.color ?? _colorCard),
              ),
            ),
            Expanded(
              child: Material(
                color: _colorCard,
                shape: BeveledRectangleBorder(
                  borderRadius: _borderRadius,
                ),
                child: InkWell(
                  onTap: onTap,
                  customBorder: BeveledRectangleBorder(
                    borderRadius: _borderRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.normal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(Dimens.little, Dimens.xSmall, Dimens.little, Dimens.normal),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${ticket.ticketBook?.name ?? '-'}', style: Styles.titleToList),
                                    SizedBox(height: Dimens.xSmall),
                                    Text('${_accessQty - _accessCurrent ?? '0'} ${_accessQty - _accessCurrent == 1 ? Strings.currentAccess : Strings.currentAccesses}', style: Styles.titleDetailSmallTextSecondary),
                                  ],
                                ),
                              ),
                              Text(ticket.ticketBook?.type?.name ?? '-', style: Styles.titleDetailSmallTextSecondary, textAlign: TextAlign.end,),
                              ticket.access.state.toEnum?.icon ?? SizedBox.shrink(),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(Strings.sector, style: Styles.titleDetailSmallTextSecondary),
                                Text(ticket.sector?.name ?? '-', style: Styles.textDetailSmall),
                              ],
                            ),
                            Column(
                              children: [
                                Text(Strings.seat, style: Styles.titleDetailSmallTextSecondary),
                                Text(ticket.seat?.alias ?? '-', style: Styles.textDetailSmall),
                              ],
                            ),
                            Column(
                              children: [
                                Text(Strings.accessCode, style: Styles.titleDetailSmallTextSecondary),
                                Text(ticket.access?.accessCode ?? '-', style: Styles.textDetailSmall),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.normal),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                direction: Axis.vertical,
                children: List.generate(10, (_) {
                  return SizedBox(
                    width: 1,
                    height: 3,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: _colorCard),
                    ),
                  );
                }),
              ),
            ),
            Material(
              clipBehavior: Clip.antiAlias,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.normal),
                  bottomLeft: Radius.circular(Dimens.normal),
                ),
              ),
              child: Container(
                width: Dimens.medium,
                color: _accessQty > _accessCurrent ? _colorCard : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
