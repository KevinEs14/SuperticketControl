T stringToEnum<T>(Iterable<T> values, String value) {
  if (values != null && value != null) {
//    value = '${T.toString()}.$value';
    return values.firstWhere((i) => i.toString().split(".").last == value,
          orElse: () => null);
  }
  return null;
}

String getValueFromEnum<T>(T enumValue){
  if (enumValue == null) {
    return null;
  }

  return enumValue.toString().split(".").last;
}