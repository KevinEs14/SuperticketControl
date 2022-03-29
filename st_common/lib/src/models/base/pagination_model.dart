import 'package:meta/meta.dart';

class PaginationModel<T>{
  final int page;
  final int totalElements;
  final int limitToCreate;
  final List<T> list;

  PaginationModel({@required this.page, @required this.totalElements, @required this.limitToCreate, @required this.list});

  static PaginationModel<T> createNew<T>(List<T> list, Map<String, dynamic> json) {
    if (json == null || json.isEmpty) return null;

    return PaginationModel<T>(
      page: json['page'],
      totalElements: json['x-total-count'] != null ? int.tryParse(json['x-total-count']) : null,
      limitToCreate: json['x-total-limit'] != null ? int.tryParse(json['x-total-limit']) : null,
      list: list,
    );
  }

}