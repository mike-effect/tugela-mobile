import 'package:json_annotation/json_annotation.dart';
import 'package:tugela/models/base_model.dart';

part 'pagination.g.dart';

@JsonSerializable()
class Pagination extends BaseModel {
  final int? total;
  final int? next;
  final int? previous;

  const Pagination({
    this.total,
    this.next,
    this.previous,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);

  @override
  List<Object?> get props => [total, next, previous];
}

@JsonSerializable()
class QueryOptions {
  final String? search, ordering;
  final int? page, pageSize;

  QueryOptions({
    this.ordering,
    this.page,
    this.search,
    this.pageSize,
  });

  factory QueryOptions.fromJson(Map<String, dynamic> json) =>
      _$QueryOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$QueryOptionsToJson(this);
}
