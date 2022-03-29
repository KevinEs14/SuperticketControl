import 'package:flutter/material.dart';
import 'package:st_common/st_ac.dart';

import '../../values/values.dart';
import '../../helpers/extensions/ticket_extension.dart';
import '../../helpers/hex_color.dart';

class TicketOwnerItemRow extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;

  static const _borderRadius = BorderRadius.only(
    topLeft: Radius.circular(Dimens.normal),
    bottomLeft: Radius.circular(Dimens.normal),
  );

  const TicketOwnerItemRow({Key key, @required this.ticket, @required this.onTap}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final _accessQty = ticket.access?.accessQuantity ?? 0;
    final _accessCurrent = ticket.access?.accesses?.length ?? 0;

    final _colorCard = ticket.access?.state?.toEnum?.colorCard ?? Colors.blueGrey[100];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, Dimens.small, Dimens.normal, Dimens.small),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              clipBehavior: Clip.antiAlias,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimens.normal),
                  bottomRight: Radius.circular(Dimens.normal),
                ),
              ),
              child: Container(
                width: Dimens.medium,
                color: _accessQty > _accessCurrent ? _colorCard : Colors.transparent,
                padding: const EdgeInsets.all(Dimens.normal),
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Row(
                //           children: [
                //             Text('${ticket.ticketBook?.name ?? '-'}', style: Styles.titleToList),
                //             ticket.access.state.toEnum?.icon ?? SizedBox.shrink(),
                //           ],
                //         ),
                //         SizedBox(height: Dimens.xSmall),
                //         Text(ticket.ticketBook?.type?.name ?? '-', style: Styles.titleDetailSmallTextSecondary, textAlign: TextAlign.end,),
                //       ],
                //     ),
                //     Row(
                //       children: [
                //         Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(Strings.sector, style: Styles.titleDetailSmallTextSecondary),
                //             Text(ticket.sector?.name ?? '-', style: Styles.textDetailSmall),
                //           ],
                //         ),
                //         SizedBox(width: Dimens.little),
                //         Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(Strings.seat, style: Styles.titleDetailSmallTextSecondary),
                //             Text(ticket.seat?.alias ?? '-', style: Styles.textDetailSmall),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${ticket.access?.owner?.firstName ?? '-'}', style: Styles.titleToList),
                              SizedBox(height: Dimens.xSmall),
                              Text('${_accessQty - _accessCurrent ?? '0'} ${_accessQty - _accessCurrent == 1 ? Strings.currentAccess : Strings.currentAccesses}', style: Styles.titleDetailSmallTextSecondary),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(Strings.documentNumber, style: Styles.titleDetailSmallTextSecondary),
                                Text(ticket.access?.owner?.documentNumber ?? '-', style: Styles.textDetailSmall),
                              ],
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: Dimens.normal),
                                child: Column(
                                  children: [
                                    Text(Strings.email, style: Styles.titleDetailSmallTextSecondary),
                                    Text(ticket.access?.owner?.email ?? '-', style: Styles.textDetailSmall),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Material(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimens.small),
                  bottomRight: Radius.circular(Dimens.small),
                ),
              ),
              child: Container(
                width: Dimens.small,
                color: HexColor(ticket.ticketBook?.color ?? _colorCard),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
