import 'package:flutter/material.dart';

import '../../../blocs/ticket/filter/ticket_filter_model.dart';
import '../../values/values.dart';
import '../../helpers/extensions/ticket_extension.dart';

class FilterButton extends StatelessWidget {
  final PopupMenuItemSelected<TicketSearchByEnum> onSelected;
  final TicketSearchByEnum activeFilter;
  final IconData icon;

  const FilterButton({
    Key key,
    @required this.onSelected,
    @required this.activeFilter,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TicketSearchByEnum>(
      key: Keys.ticketFilterButton,
      tooltip: 'Buscar por',
      icon: Icon(icon ?? Icons.filter_list),
      // child: Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 8.0),
      //   child: Text(title ?? 'Filtrar por', textAlign: TextAlign.center),
      // ),
      onSelected: onSelected,
      itemBuilder: (BuildContext context) =>
          TicketSearchByEnum.values.map((e) {
            return PopupMenuItem<TicketSearchByEnum>(
              value: e,
              child: Row(
                children: [
                  Icon(e.icon, color: activeFilter == e ? colorSecondary : Colors.grey, size: Dimens.normal,),
                  SizedBox(width: Dimens.small),
                  Text(
                    e.name,
                    style: activeFilter == e
                        ? TextStyle(color: colorSecondary)
                        : TextStyle(color: colorText),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}