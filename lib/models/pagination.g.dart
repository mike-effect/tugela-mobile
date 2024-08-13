// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      total: (json['total'] as num?)?.toInt(),
      next: (json['next'] as num?)?.toInt(),
      previous: (json['previous'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('total', instance.total);
  writeNotNull('next', instance.next);
  writeNotNull('previous', instance.previous);
  return val;
}

QueryOptions _$QueryOptionsFromJson(Map<String, dynamic> json) => QueryOptions(
      ordering: json['ordering'] as String?,
      page: (json['page'] as num?)?.toInt(),
      search: json['search'] as String?,
      pageSize: (json['page_size'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QueryOptionsToJson(QueryOptions instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('search', instance.search);
  writeNotNull('ordering', instance.ordering);
  writeNotNull('page', instance.page);
  writeNotNull('page_size', instance.pageSize);
  return val;
}
