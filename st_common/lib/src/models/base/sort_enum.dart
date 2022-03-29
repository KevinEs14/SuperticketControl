
enum Sort{NAME, NRO, LAST_UPDATE}
extension SortExtension on Sort{
  String get name{
    switch(this){
      case Sort.NAME:
        return "Nombre";
      case Sort.NRO:
        return "Código";
      case Sort.LAST_UPDATE:
        return "Fecha de modificación";
      default:
        return null;
        break;
    }
  }
  String get varName{
    switch(this){
      case Sort.NAME:
        return 'name';
      case Sort.NRO:
        return "code";
      case Sort.LAST_UPDATE:
        return 'lastModifiedDate';
      default:
        return null;
    }
  }
}

enum SortType{ASC, DESC}
extension SortTypeExtension on SortType{
  String get name{
    switch(this){
      case SortType.ASC:
        return "Ascendente";
      case SortType.DESC:
        return "Descendente";
      default:
        return null;
    }
  }
  String get varName{
    switch(this){
      case SortType.ASC:
        return 'asc';
      case SortType.DESC:
        return 'desc';
      default:
        return null;
    }
  }
}