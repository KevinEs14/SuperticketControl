import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:st_common/st_ac.dart';

import '../../values/values.dart';

class EventItemRow extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventItemRow({Key key, @required this.event, @required this.onTap}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final DateTime _startDateTime = stringToDateTime(event.eventStartDate);
    final DateTime _endDateTime = stringToDateTime(event.eventEndDate);
    final Duration _duration = _endDateTime?.difference(_startDateTime);

    final String _startDate = _startDateTime?.toStringFormat(DateTimeFormatEnum.ABBR_MONTH_DAY);
    final String _endDate = _endDateTime?.toStringFormat(DateTimeFormatEnum.ABBR_MONTH_DAY);
    String _date;

    if (_startDate != null && _endDate != null) {
      if (_startDate == _endDate) {
        _date =
            '$_startDate, ${_startDateTime.hourFormat} - ${_endDateTime.hourFormat}';
      } else {
        _date =
            '${_startDateTime.toStringFormat(DateTimeFormatEnum.ABBR_MONTH_DAY, true) ?? '-'} - ${_endDateTime.toStringFormat(DateTimeFormatEnum.ABBR_MONTH_DAY, true) ?? '-'}';
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimens.medium, Dimens.little, Dimens.medium, Dimens.little),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Row(
          children: [
            Card(
              elevation: 10,
              shadowColor: colorSecondaryVariant,
              margin: const EdgeInsets.only(right: Dimens.normal),
              child: ExtendedImage.network(
                event.imageHomeUrl,
                width: Dimens.large*2,
                height: Dimens.large*3,
                fit: BoxFit.cover,
                cache: true,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: Dimens.xSmall),
                    child: Text(event.name ?? '-', style: Styles.titleToList),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: Dimens.xSmall, bottom: Dimens.little),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(StAccessControl.clock, size: 11, color: colorTextSecondary),
                        SizedBox(width: Dimens.small),
                        Text(_duration?.inDaysString ?? '-', style: Styles.subtitleToList),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: Dimens.xSmall, bottom: Dimens.xSmall),
                    child: Row(
                      children: [
                        Icon(StAccessControl.calendar_day, size: 11, color: colorTextSecondary),
                        SizedBox(width: 6),
                        Text('${_date ?? '-'}', style: Styles.trailingToList),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: Dimens.xSmall, bottom: Dimens.xSmall),
                    child: Row(
                      children: [
                        Icon(StAccessControl.door_open, size: 11, color: colorTextSecondary),
                        SizedBox(width: 6),
                        Text(stringToFormatDateTime(event.doorOpeningDate, DateTimeFormatEnum.ABBR_MONTH_DAY, true) ?? '-', style: Styles.trailingToList),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
