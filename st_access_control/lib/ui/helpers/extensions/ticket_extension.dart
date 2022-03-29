import 'package:flutter/material.dart';
import 'package:st_common/st_ac.dart';

import '../../../blocs/ticket/filter/ticket_filter_model.dart';
import '../../values/values.dart';

extension TicketSearchByExtension on TicketSearchByEnum{
  String get name{
    switch(this){
      case TicketSearchByEnum.ACCESS_CODE:
        return Strings.searchByCode;
      case TicketSearchByEnum.TICKET_OWNER:
        return Strings.searchByUser;
      default:
        return null;
    }
  }

  IconData get icon{
    switch(this){
      case TicketSearchByEnum.ACCESS_CODE:
        return StAccessControl.ticket;
      case TicketSearchByEnum.TICKET_OWNER:
        return StAccessControl.id_card;
      default:
        return null;
    }
  }
}

extension TicketAccessStateExtension on TicketAccessStateEnum{
  Color get colorCard{
    switch(this){
      case TicketAccessStateEnum.ENABLED:
        return Colors.white;
      case TicketAccessStateEnum.LOCKED:
        return Colors.red[50];
      default:
        return null;
    }
  }
  Icon get icon{
    switch(this){
      case TicketAccessStateEnum.ENABLED:
        return Icon(Icons.verified_user, color: Colors.lightGreen, size: Dimens.normal);
      case TicketAccessStateEnum.LOCKED:
        return Icon(Icons.lock , color: Colors.red, size: Dimens.normal);
      default:
        return null;
    }
  }
}

extension TicketStatusExtension on TicketStatusEnum{
  Icon get icon{
    switch(this){
      case TicketStatusEnum.AVAILABLE:
        return Icon(Icons.help_center_outlined, color: Colors.amber, size: Dimens.normal);
      case TicketStatusEnum.RESERVATION:
        return Icon(Icons.lock_clock, color: Colors.amber, size: Dimens.normal);
      case TicketStatusEnum.AWARD:
        return Icon(Icons.verified_user, color: Colors.lightGreen, size: Dimens.normal);
      case TicketStatusEnum.LOCKED:
        return Icon(Icons.block , color: Colors.red, size: Dimens.normal);
      case TicketStatusEnum.CANCELLED:
        return Icon(Icons.cancel_presentation, color: Colors.red, size: Dimens.normal);
      default:
        return null;
    }
  }
}